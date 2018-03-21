package com.youai.sdk.active;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.PendingIntent;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.util.Log;
import android.widget.Toast;

import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.YouaiError;
import com.youai.sdk.android.api.BindCallback;
import com.youai.sdk.android.api.YouaiApi;
import com.youai.sdk.android.api.YouaiException;
import com.youai.sdk.android.config.YouaiConfig;
import com.youai.sdk.android.config.YouaiErrorCode;
import com.youai.sdk.android.entry.YouaiAppInfo;
import com.youai.sdk.android.entry.YouaiUser;
import com.youai.sdk.android.utils.JsonUtil;
import com.youai.sdk.android.utils.Utils;
import com.youai.sdk.net.AsyncUserRunner;
import com.youai.sdk.net.RequestListener;

public class YouaiCommplatform {
	
	protected static final String Tag = YouaiCommplatform.class.getSimpleName();
	private static YouaiCommplatform commplatform;
	private YouaiAppInfo mAppInfo; 
	private boolean isLogined = false;
	protected static CallbackListener mUserCallback;
	protected static String OnSuccesBackJsonStr = "";
	protected static YouaiUser OnSuccessLoginUser;
	
	protected static String OnSuccesTryJsonStr = ""; 
	protected static YouaiUser OnSuccessTryLoginUser;
	

	protected SaveUserHelp savehelp ;//保存用户的工具类
	protected static ArrayList<YouaiUser> fromNetUserNames = new ArrayList<YouaiUser>();
	private boolean haveTry = false;//是否有试玩帐号
	private boolean haveOk = false;//是否有正式帐号
	public static String channelName = "1000";
	private boolean initOk = false;
	public YouaiAppInfo  getAppInfo() {
		return mAppInfo;
	}
	
	public static YouaiCommplatform getInstance() {
		if (commplatform == null) {
			commplatform = new YouaiCommplatform();

		}
		return commplatform;
	}

	int  initTime = 0;
	 
	public void Init(final Activity activity, YouaiAppInfo youaiAppInfo,
			final OnInitCompleteListener mOnInitCallbackListener) {
		if ((youaiAppInfo == null) || (youaiAppInfo.appId<0)|| (youaiAppInfo.appSecret == null)
				|| (youaiAppInfo.appKey == null) || (activity == null)){
			initOk = false;
			mOnInitCallbackListener.onFailed(YouaiErrorCode.YOUAI_INIT_ERROR, "初始化失败");
			return;
		}
		mAppInfo = youaiAppInfo;
		mAppInfo.setCtx(activity);
		savehelp = new SaveUserHelp(activity);
		
		JsonUtil.appinfo = mAppInfo.getAppId();
		YouaiPay.appkey = mAppInfo.getAppKey();
		YouaiPay.appsecret = mAppInfo.getAppSecret();
		ApplicationInfo appInfo = null;
		try {
			appInfo = activity.getPackageManager().getApplicationInfo(activity.getPackageName(),PackageManager.GET_META_DATA);
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		
		int channelId=appInfo.metaData.getInt("youai_channel");
		
		channelName = String.valueOf(channelId);
		
		YouaiPay.channelId = String.valueOf(channelId);
		
		
		initTime = 0;
		AsyncUserRunner.requestInit(activity,String.valueOf(mAppInfo.getAppId()),mAppInfo.getAppKey(),channelName, new RequestListener() {
			
			@Override
			public void onIOException(IOException e) {
				initOk = false;
				initTime++;
				if(initTime<4){
					if(initTime==2){
						YouaiConfig.urlroot = YouaiConfig.urlroot_back;
					}
					
					AsyncUserRunner.requestInit(activity,String.valueOf(mAppInfo.getAppId()),mAppInfo.getAppKey(),channelName,this);
					 
				}
				activity.runOnUiThread(new Runnable() {
					
					@Override
					public void run() {
						Toast.makeText(activity, "初始化失败，重新初始化中...", Toast.LENGTH_SHORT).show();
						if(initTime<4)return;
						mOnInitCallbackListener.onFailed(YouaiErrorCode.YOUAI_INIT_ERROR,"初始化失败");
					}
				});
			}
			@Override
			public void onError(YouaiException e) {
				initOk = false;
				initTime++;
				if(initTime<3){
					if(initTime==2){
						YouaiConfig.urlroot = YouaiConfig.urlroot_back;
					}
					AsyncUserRunner.requestInit(activity,String.valueOf(mAppInfo.getAppId()),mAppInfo.getAppKey(),channelName,this);
				}
				activity.runOnUiThread(new Runnable() {
					@Override
					public void run() {
						Toast.makeText(activity, "初始化失败，重新初始化中...", Toast.LENGTH_SHORT).show();
						if(initTime<4)return;
						mOnInitCallbackListener.onFailed(YouaiErrorCode.YOUAI_INIT_SUCCESS, "初始化失败");
					}
				});
			}
			
			@Override
			public void onComplete(String response) {
				JSONObject backjson = null;
				try {
					backjson = new JSONObject(response);
					final String code = backjson.getString("error");
					final String errormsg = backjson.getString("errorMessage");
					if(code.equals("200")){
						YouaiConfig.timestamp = backjson.getLong("timestamp");
						 YouaiConfig.UrlFeedBack += "?gameId="+mAppInfo.getAppKey() + "&platformId="+YouaiConfig.PlatformStr;
						initOk = true;
						activity.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								mOnInitCallbackListener.onComplete(YouaiErrorCode.YOUAI_INIT_SUCCESS);
							}
						});
					}else{
						initOk = false;
						activity.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								mOnInitCallbackListener.onFailed(Integer.valueOf(code), errormsg);
							}
						});
						
					}
				} catch (JSONException e) {
					e.printStackTrace();
				}
			
			}
		});
	}

	

	public void youaiCreate(){
		
	}

	public void youaiPause() {

	}
	private ArrayList<YouaiUser> tryUserList;
	private ArrayList<YouaiUser> okUserList ;
	private ArrayList<YouaiUser> allUserList;
	

	 
	/**
	 * 填充本地的user
	 * 检查本地存储的用户信息*/
	private void checkLocalUserInfo(){
		//检查本地存储的用户信息
		
		allUserList = null;
		tryUserList = null;
		okUserList = null;
		
		allUserList = savehelp.doDbSelectAll();
		//1 read
		//2 check, only one try user
		//3 check, only one ok user is Local unlogout
		tryUserList = new ArrayList<YouaiUser>();
		okUserList = new ArrayList<YouaiUser>();
		for (YouaiUser pUser :allUserList ) {
			if("2".equals(pUser.getUserType())){
				tryUserList.add(pUser);
			}else {
				okUserList.add(pUser);
			}
		}
		
		if(tryUserList.size()==0&okUserList.size()==0){
			doByUser(0);
			
		}else if(tryUserList.size()==0&okUserList.size()!=0){
			UserDialog.youaiUsers = allUserList;
			doByUser(1);
		}else if(tryUserList.size()!=0&okUserList.size()==0){
			UserDialog.youaiUsers = allUserList;
			doByUser(2);
		}else if(tryUserList.size()!=0&okUserList.size()!=0){
			UserDialog.youaiUsers = allUserList;
			doByUser(3);
			
		}
		
	}

	
	/**访问网络获取机器登录的user*/
	private void doByUser(int which){
		if(which==0){//本地没有试玩帐号也没有正式帐号
			askServerByDevice();
			
		}
		
		else if(which == 1){//本地没有试玩帐号有正式帐号
			
			mHasAutoLoginOkUser = false;
			YouaiUser tempUser = null;
			
			for (YouaiUser itemUser : okUserList) {
				if("0".equals(itemUser.getIsLocalLogout())){
					
					mHasAutoLoginOkUser = true;
					tempUser = itemUser;
					break;
				}
			}
			
			final YouaiUser _tempAutoLoginUser = tempUser;
			
			if(true)
			{
				OnSuccesBackJsonStr = null;
				OnSuccessLoginUser = null;
				OnSuccessTryLoginUser = null;
				OnSuccesTryJsonStr = null;
				
				JSONObject trymessage = new JSONObject();
				JSONObject trydata = new JSONObject();
				try {
					trydata.put("youaiId", "");
					trydata.put("channel", channelName);
					trymessage.put("data", trydata);
					trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				
				YouaiApi.CreateOrLoginTry(trymessage.toString(), new RequestListener() {
					
					@Override
					public void onIOException(IOException e) {
						Log.e(Tag, e.toString());
						if (mHasAutoLoginOkUser)
						{
							Log.e(Tag, ":::  bHasAutoLoginOkUser");
							autoLoginOkUser(_tempAutoLoginUser,allUserList);//自动登录本地保存的帐号
						}
						else
						{
							popuLoginView(okUserList.get(0));//弹出登录框，填充 text，填充列表
						}
					}
					
					@Override
					public void onError(YouaiException e) {
						Log.e(Tag, e.toString());
						if (mHasAutoLoginOkUser)
						{
							Log.e(Tag, ":::  bHasAutoLoginOkUser");
							autoLoginOkUser(_tempAutoLoginUser,allUserList);//自动登录本地保存的帐号
						}
						else
						{
								popuLoginView(okUserList.get(0));//弹出登录框，填充 text，填充列表
						}
					}
					
					@Override
					public void onComplete(String response) {
						JSONObject jsonServer;
						Log.e(Tag, "TRY onComplete"+response);
						try {
							jsonServer = new JSONObject(response);
							String error = jsonServer.getString("error");
							if (error.equals("200")) {
								String youaid = jsonServer.getJSONObject("data").getString("youaiId");
								int isCreate = jsonServer.getJSONObject("data").getInt("isCreate");
								String youaiName = jsonServer.getJSONObject("data").getString("youaiName");
								int userType = jsonServer.getJSONObject("data").getInt("userType");
								YouaiUser _tempUser = new YouaiUser();
								_tempUser.setUidStr(youaid);
								_tempUser.setUserType(""+userType);
								_tempUser.setUsername(youaiName);
								fromNetUserNames.add(_tempUser);
								JSONObject jsonback = new JSONObject();
								JSONObject jsonObj = new JSONObject();
								jsonObj.put("youaiId", youaid);
								jsonback.put("data", jsonObj);
								jsonback.put("username", youaiName);
								OnSuccesBackJsonStr = jsonback.toString();
								OnSuccessLoginUser = _tempUser;
								OnSuccessTryLoginUser = OnSuccessLoginUser;
								OnSuccesTryJsonStr = OnSuccesBackJsonStr;
								
								savehelp.doDbUpdateOrInsert(_tempUser);

								Log.e(Tag, "创建试玩帐号"+response);
								
								if (mHasAutoLoginOkUser)
								{
									Log.e(Tag, ":::  bHasAutoLoginOkUser");
									autoLoginOkUser(_tempAutoLoginUser,allUserList);//自动登录本地保存的帐号
								}
								else
								{
									popuLoginView(okUserList.get(0));//弹出登录框，填充 text，填充列表
								}
								
							}
						}catch(Exception e){
							Log.e(Tag, e.toString());
						}
						
					}
				});
			}
			
			
		}
		
		else if(which == 2){//本地有试玩帐号，没有正式帐号
			//校验下  用试玩帐号登录
			askServerTryCheckorLogin(tryUserList.get(0));
			
		}
		
		else if(which == 3){//本地有试玩帐号，也有正式帐号
			//按最后使用，来判定，使用tryuser autologin 还是使用ok user，login by 是否注销  显示列表 包含随机
			
			
			UserDialog.youaiUsers = allUserList;
			
			mHasAutoLoginOkUser = false;
			YouaiUser tempUser = null;
			
			for (YouaiUser itemUser : okUserList) {
				if("0".equals(itemUser.getIsLocalLogout())){
					
					mHasAutoLoginOkUser = true;
					tempUser = itemUser;
					break;
				}
			}
			
			final YouaiUser _tempAutoLoginUser = tempUser;
			if(true)
			{
				OnSuccesBackJsonStr = null;
				OnSuccessLoginUser = null;
				OnSuccesTryJsonStr = null;
				OnSuccessTryLoginUser = null;
				
				JSONObject trymessage = new JSONObject();
				JSONObject trydata = new JSONObject();
				final YouaiUser _tryUser = tryUserList.get(0);
				try {
					trydata.put("youaiId", _tryUser.getUidStr());
					trydata.put("channel", channelName);
					trymessage.put("data", trydata);
					trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				
				YouaiApi.CreateOrLoginTry(trymessage.toString(), new RequestListener() {
					
					@Override
					public void onIOException(IOException e) {
						Log.e(Tag, e.toString());
						if (mHasAutoLoginOkUser)
						{
							autoLoginOkUser(_tempAutoLoginUser,allUserList);//自动登录本地保存的帐号
						}
						else if(!isLogined)
						{
							isLogined = false;
							popuLoginView(okUserList.get(0));//弹出登录框，填充 text，填充列表
						}
					}
					
					@Override
					public void onError(YouaiException e) {
						Log.e(Tag, e.toString());
						
						if (mHasAutoLoginOkUser)
						{
							autoLoginOkUser(_tempAutoLoginUser,allUserList);//自动登录本地保存的帐号
						}
						else
						{
							isLogined = false;
							popuLoginView(okUserList.get(0));//弹出登录框，填充 text，填充列表
						}
					}
					
					@Override
					public void onComplete(String response) {
						JSONObject jsonServer;
						try {
							jsonServer = new JSONObject(response);
							String error = jsonServer.getString("error");
							if (error.equals("200")) {
								String youaid = jsonServer.getJSONObject("data").getString("youaiId");
								int isCreate = jsonServer.getJSONObject("data").getInt("isCreate");
								String youaiName = jsonServer.getJSONObject("data").getString("youaiName");
								int userType = jsonServer.getJSONObject("data").getInt("userType");
								YouaiUser _tempTryUser = new YouaiUser();
								_tempTryUser.setUidStr(youaid);
								_tempTryUser.setUserType(""+userType);
								_tempTryUser.setUsername(youaiName);
								if(isCreate!=1){
								fromNetUserNames.add(_tempTryUser);
								}
								JSONObject jsonback = new JSONObject();
								JSONObject jsonObj = new JSONObject();
								jsonObj.put("youaiId", youaid);
								jsonback.put("data", jsonObj);
								jsonback.put("username", youaiName);
								
								OnSuccesBackJsonStr = jsonback.toString();
								OnSuccessLoginUser = _tempTryUser;
								OnSuccesTryJsonStr = OnSuccesBackJsonStr;
								OnSuccessTryLoginUser = OnSuccessLoginUser;
								
								if(isCreate==0){
									
									if (_tryUser.getUidStr().equals(youaid))
									{
										savehelp.doDbUpdate(_tempTryUser);
									}
									else
									{
										savehelp.doDbInsert(_tempTryUser);
										savehelp.doDbDelete(_tryUser);
									}
								}else{
									savehelp.doDbInsert(_tempAutoLoginUser);
									savehelp.doDbDelete(_tryUser);
								}
								
								if (mHasAutoLoginOkUser)
								{
									autoLoginOkUser(_tempAutoLoginUser,allUserList);//自动登录本地保存的帐号
								}
								else
								{
									isLogined = false;
									popuLoginView(okUserList.get(0));//弹出登录框，填充 text，填充列表
								}
								
								
							}else{
								if (mHasAutoLoginOkUser)
								{
									autoLoginOkUser(_tempAutoLoginUser,allUserList);//自动登录本地保存的帐号
								}else{
									funcDoAfterLogin();
								}
								
								
							}
						}catch(Exception e){
							Log.e(Tag, e.toString());
						}
						
					}
				});
			}
			
			
		}		
		
	}
	
	
	boolean mHasAutoLoginOkUser = false;
	
	private void afterAutoLogin(){
		mAppInfo.getCtx().runOnUiThread(new Runnable() {
			
			@Override
			public void run() {
				if(isLogined){
					mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
					return;
				}else if (!isLogined)
				{
					if (OnSuccesBackJsonStr != null)
					{
						isLogined = true;
						mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
					}else{
						popuLoginView(okUserList.get(0));
					}
				}
			}
		});
		
	}
	
	//private boolean insertOrUpdate = false; //false:insert true:Update
	//访问网络获取到的user 网络登录的是按照时间排序的，自动填充第一个
	private void askServerByDevice(){
		/*
		访问网络获取设备登录过的user   填充tryuser 	填充okUserList
		//第一次玩本地没有  网络返回一个初始化的 tryuser
		*/
		haveOk = false;
		haveTry = false;
		OnSuccesBackJsonStr = null;
		OnSuccessLoginUser = null;
		OnSuccesTryJsonStr = null;
		OnSuccessTryLoginUser = null;
		
			JSONObject message = new JSONObject();
			JSONObject data = new JSONObject();
			try {
				message.put("data", data);
				message.put("header", Utils.makeHead(mAppInfo.getCtx()));
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			
			 YouaiApi.getUserList(message.toString(), new RequestListener() {
			 ArrayList<YouaiUser> getFromUsers = new ArrayList<YouaiUser>();
				@Override
				public void onIOException(IOException e) {
					Log.e(Tag,  e.toString());
				}
				
				@Override
				public void onError(YouaiException e) {
					Log.e(Tag,	e.toString());
				}
				
				@Override
				public void onComplete(String response) {
					JSONObject jsonServer;
					Log.e(Tag, "返回names："+response);
					try {
						jsonServer = new JSONObject(response);
						String error = jsonServer.getString("error");
						// String errorMsg = jsonServer.getString("errorMessage");
						if (error.equals("200")) {
							JSONArray players = jsonServer.getJSONObject("data").getJSONArray("users");
							if(players==null||players.length()<=0)
								return;
							Log.e("users", ""+players.length());
							for (int i = 0; i <players.length(); i++) {
								YouaiUser _tempUser = new YouaiUser();
								_tempUser.setUidStr(players.getJSONObject(i).getString("youaiId"));
								_tempUser.setUserType(""+players.getJSONObject(i).getInt("userType"));
								_tempUser.setUsername(players.getJSONObject(i).getString("name"));
								getFromUsers.add(i,_tempUser);
								
								if(_tempUser.getUserType().equals("2")){
									JSONObject jsonback = new JSONObject();
									JSONObject jsonObj = new JSONObject();
									jsonObj.put("youaiId", _tempUser.getUidStr());
									jsonback.put("data", jsonObj);
									jsonback.put("username", _tempUser.getUsername());
									
									OnSuccesBackJsonStr = jsonback.toString();
									OnSuccessLoginUser = _tempUser;
									OnSuccesTryJsonStr = OnSuccesBackJsonStr;
									OnSuccessTryLoginUser = OnSuccessLoginUser;
									
									haveTry = true;
									savehelp.doDbInsert(_tempUser);
								}else{
									haveOk = true;
									savehelp.doDbInsert(_tempUser);
								}
							}
							fromNetUserNames = getFromUsers;
							UserDialog.youaiUsers = fromNetUserNames;

						}
					
					} catch (JSONException e) {
						e.printStackTrace();
					}
				}
			});
			 
			 
			JSONObject trymessage = new JSONObject();
			JSONObject trydata = new JSONObject();
			try {
				trydata.put("youaiId", "");
				trydata.put("channel", channelName);
				trymessage.put("data", trydata);
				trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
			} catch (JSONException e1) {
				e1.printStackTrace();
			}
			
			YouaiApi.CreateOrLoginTry(trymessage.toString(), new RequestListener() {
				
				@Override
				public void onIOException(IOException e) {
					Log.e(Tag, "IOExecption");
					isLogined = false;
					funcDoAfterLogin();
				}
				
				@Override
				public void onError(YouaiException e) {
					Log.e(Tag, "onError");
					isLogined = false;
					funcDoAfterLogin();
				}
				
				@Override
				public void onComplete(String response) {
					Log.e(Tag,"onComplete 222");
					JSONObject jsonServer;
					try {
						jsonServer = new JSONObject(response);
						String error = jsonServer.getString("error");
						if (error.equals("200")) {
							String youaid = jsonServer.getJSONObject("data").getString("youaiId");
							int isCreate = jsonServer.getJSONObject("data").getInt("isCreate");
							String youaiName = jsonServer.getJSONObject("data").getString("youaiName");
							int userType = jsonServer.getJSONObject("data").getInt("userType");
							YouaiUser _tempUser = new YouaiUser();
							_tempUser.setUidStr(youaid);
							_tempUser.setUserType(""+userType);
							_tempUser.setUsername(youaiName);
							if(isCreate!=0){
							fromNetUserNames.add(_tempUser);
							}
							JSONObject jsonback = new JSONObject();
							JSONObject jsonObj = new JSONObject();
							jsonObj.put("youaiId", youaid);
							jsonback.put("data", jsonObj);
							jsonback.put("username", youaiName);
							
							OnSuccesBackJsonStr = jsonback.toString();
							OnSuccessLoginUser = _tempUser;
							OnSuccesTryJsonStr = OnSuccesBackJsonStr;
							OnSuccessTryLoginUser = OnSuccessLoginUser;
							
							savehelp.doDbUpdateOrInsert(_tempUser);
							
							UserDialog.youaiUsers = fromNetUserNames;
							
							if(isCreate==1&!haveOk){//没有登录过不弹出登录框
								isLogined = true;
								mAppInfo.getCtx().runOnUiThread(new Runnable() {
									
									@Override
									public void run() {
										mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);										
									}
								});
							}else if(isCreate==0&!haveOk){
								isLogined = true;
								mAppInfo.getCtx().runOnUiThread(new Runnable() {
									
									@Override
									public void run() {
										mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);										
									}
								});
							}else{
								funcDoAfterLogin();
							}
							
						}else{
							funcDoAfterLogin();
						}
					}catch(Exception e){
						Log.e(Tag, e.toString());
					}
					
				}
			});
	
			 
	}
	
	
	private void funcDoAfterLogin(){
		if(!isLogined&!haveOk){ //获取到了tryUser 没有OkUser
			Log.e(Tag,"!haveOk");
			if(null!=OnSuccesBackJsonStr&&!isLogined){
				isLogined = true;
				savehelp.doDbUpdateOrInsert(OnSuccessLoginUser);
				mAppInfo.getCtx().runOnUiThread(new Runnable() {
					
					@Override
					public void run() {
						mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);										
					}
				});
			}else if(fromNetUserNames.size()!=0){//对异常的处理 就弹出登录框
				allUserList = fromNetUserNames;
				popuLoginView(fromNetUserNames.get(0));
			}else{
				popuLoginView(null);
			}
			
		}else if(haveOk) {//获取到了tryUser 有 OkUser
			Log.e(Tag,"haveOk");
				allUserList = fromNetUserNames;
				popuLoginView(fromNetUserNames.get(0));
				
		}else if(haveTry){
			askServerTryCheckorLogin(OnSuccessTryLoginUser);
		}
	}
	
	
	
	
	//校验成功与否，成功登录，校验失败 则返回新的tryuser继续登录
	private void askServerTryCheckorLogin(YouaiUser pTryUser){
		 
		//insertOrUpdate = true;
		OnSuccesBackJsonStr = null;
		OnSuccessLoginUser = null;
		OnSuccesTryJsonStr = null;
		OnSuccessTryLoginUser = null;
		
		JSONObject trymessage = new JSONObject();
		JSONObject trydata = new JSONObject();
		try {
			trydata.put("youaiId", pTryUser.getUidStr());
			trydata.put("channel", channelName);
			trymessage.put("data", trydata);
			trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		final YouaiUser _YouaiUser = pTryUser;
		final YouaiError _Error = new YouaiError();
		
		
		YouaiApi.CreateOrLoginTry(trymessage.toString(), new RequestListener() {
			
			@Override
			public void onIOException(IOException e) {
				Log.e(Tag, e.toString());
				_Error.setmErrorCode(YouaiErrorCode.YOUAI_NET_ERR);
				_Error.setmErrorMessage(e.toString());
			}
			
			@Override
			public void onError(YouaiException e) {
				Log.e(Tag, e.toString());
			}
			
			@Override
			public void onComplete(String response) {
				JSONObject jsonServer;
				try {
					jsonServer = new JSONObject(response);
					String error = jsonServer.getString("error");
					if (error.equals("200")) {
						String youaid = jsonServer.getJSONObject("data").getString("youaiId");
						int isCreate = jsonServer.getJSONObject("data").getInt("isCreate");
						
						String youaiName = jsonServer.getJSONObject("data").getString("youaiName");
						int userType = jsonServer.getJSONObject("data").getInt("userType");
						YouaiUser _tempUser = new YouaiUser();
						_tempUser.setUidStr(youaid);
						_tempUser.setUserType(""+userType);
						_tempUser.setUsername(youaiName);
						
						if(isCreate!=0){
							fromNetUserNames.add(_tempUser);
						}
					 
						
						JSONObject jsonback = new JSONObject();
						JSONObject jsonObj = new JSONObject();
						jsonObj.put("youaiId", youaid);
						jsonback.put("data", jsonObj);
						jsonback.put("username", youaiName);
						
						OnSuccesBackJsonStr = jsonback.toString();
						OnSuccessLoginUser = _tempUser;
						OnSuccesTryJsonStr = OnSuccesBackJsonStr;
						OnSuccessTryLoginUser = OnSuccessLoginUser;
						
						
						if(isCreate==0){
							
							if (_YouaiUser.getUidStr().equals(youaid))
							{
								savehelp.doDbUpdate(_tempUser);
							}
							else
							{
								savehelp.doDbInsert(_tempUser);
								savehelp.doDbDelete(_YouaiUser);
							}
						}else{
							savehelp.doDbInsert(_tempUser);
							savehelp.doDbDelete(_YouaiUser);
						}
					}
				}catch(Exception e){
					Log.e(Tag, e.toString());
				}
				
			}
		});
		
		if (OnSuccesBackJsonStr != null&!isLogined)
		{
			isLogined = true;
			mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
		}
		else
		{
			mUserCallback.onLoginError(_Error);
		}
		
		
	}
	
	private void autoLoginOkUser(YouaiUser pOkUser,List<YouaiUser> pOkList){
		JSONObject message = new JSONObject();
		JSONObject data = new JSONObject(); 
		try {
			data.put("youaiName", pOkUser.getUsername()); 
			data.put("password", pOkUser.getPassword()); 
			message.put("data", data);
			message.put("header", Utils.makeHead(mAppInfo.getCtx()));
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		
		//DB UPDATE
		savehelp.doDbUpdate(pOkUser);
		
		final YouaiUser _oKUser = pOkUser;
		final String _password = pOkUser.getPassword();
		final String _youaiName = pOkUser.getUsername();
		YouaiApi.Login(message.toString(), new RequestListener(){

			@Override
			public void onComplete(String response) {
				Log.e(Tag, "in autoLoginOkUser");
				JSONObject jsonback = null;
				String error = null;
				String youaiId = null;
				try {
						jsonback  = new JSONObject(response);
						error = jsonback.getString("error");
					
					if(error.equals("200")){
						youaiId = jsonback.getJSONObject("data").getString("youaiId");
						jsonback.put("username", _youaiName);
						_oKUser.setIsLocalLogout("0");
						
						OnSuccesBackJsonStr = jsonback.toString();
						OnSuccessLoginUser = _oKUser;
						isLogined = true;
						//	dB UPDATE
						savehelp.doDbUpdate(_oKUser);
						YouaiCommplatform.getInstance().setLoginUser(_oKUser);
						
					}
					afterAutoLogin();
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}

			@Override
			public void onIOException(IOException e) {
				isLogined = false;
				afterAutoLogin();
			}

			@Override
			public void onError(YouaiException e) {
				isLogined = false;
				afterAutoLogin();
			}});
		
		
		
		
	}
	
	private  void popuLoginView(YouaiUser pTheUser){
		YouaiLogin.mRecentYouaiUser = pTheUser;
		mAppInfo.getCtx().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Intent intent = new Intent(mAppInfo.getCtx(), YouaiLogin.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.putExtra("KEY_POSITION", 1);
				mAppInfo.getCtx().startActivity(intent);				
			}
		});
		
	}
	 
	private void popuRecentUser(YouaiUser pRecentUser){
		if("2".equals(pRecentUser.getUserType())){
			askServerTryCheckorLogin(pRecentUser);//校验下并登录
			
		}else {
			popuLoginView(pRecentUser);
			//弹出登录框 填充  pRecentUser
		}
		
	}
	
	protected void LoginTry(){
		if(null!=OnSuccesBackJsonStr){
		savehelp.doDbUpdateOrInsert(OnSuccessLoginUser);
		mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
		isLogined = true;
		}else if(null!=OnSuccesTryJsonStr){
			savehelp.doDbUpdateOrInsert(OnSuccessTryLoginUser);
			mUserCallback.onLoginSuccess(OnSuccesTryJsonStr);
			setLoginUser(OnSuccessTryLoginUser);
			isLogined = true;
		}else{
			mUserCallback.onLoginError(new YouaiError("网络异常"));
			isLogined = false;
		}
		
	}
	
	public void youaiExit() {

	}

	public void destory() {

	}

	public byte[] getToken() {
		return null;
	}

	public String getLoginUin() {
		if(OnSuccessLoginUser!=null){
			return OnSuccessLoginUser.getUidStr();
		}else if(null!=OnSuccessTryLoginUser){
			return OnSuccessTryLoginUser.getUidStr();
		}else {
			return null;
		}
	}

	public String getSessionId() {
		return null;
	}

	public String getLoginNickName() {
		 if(OnSuccessLoginUser!=null){
				return OnSuccessLoginUser.getUsername();
		}else if(null!=OnSuccessTryLoginUser){
			return OnSuccessTryLoginUser.getUsername();
		}else {
			return null;
		}
	}

	
	
	public void youaiCheckPaySuccess() {

	}

	public void youaiLogin(Context pContext,CallbackListener callbacklisten) {
		/*Intent intent = new Intent(pContext, YouaiLogin.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("KEY_POSITION", 1);*/
		if(!initOk)return;
		YouaiLogin.listener = callbacklisten;
		mUserCallback = callbacklisten;
		checkLocalUserInfo();
	}
	
	
	
	public void u2QuickRegist(Context pContext, CallbackListener callbacklisten) {
		if (!initOk)
			return;
		Intent intent = new Intent(pContext, YouaiLogin.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("KEY_POSITION", 2);
		YouaiLogin.listener = callbacklisten;
		pContext.startActivity(intent);

	}

	public boolean isLogined() {

		return isLogined;
	}

	public void youaiLogout(Context pContext) {
		isLogined = false;
		if (mAppInfo.getCtx() == null)
			return;

		if(YouaiControlCenter.mCallBack.onLoginOutAfter()){
			
			SharedPreferences cofigSharePre = mAppInfo.getCtx().getSharedPreferences("config", 0);
			Editor editor = cofigSharePre.edit();
			editor.putBoolean("autologin", false);
			editor.commit();
			OnSuccessLoginUser.setIsLocalLogout("1");
			savehelp.doDbUpdate(OnSuccessLoginUser);
			OnSuccessLoginUser = null;
			OnSuccesBackJsonStr = null;
			YouaiLogin.autoLogin = false;
			YouaiCommplatform.this.isLogined = false;
			youaiLogin(pContext, mUserCallback);
		}else{
			
			popuAlert();
			
		}
		
	}
	
	public void youaiLogoutPopu(Context pContext) {
		isLogined = false;
		if (mAppInfo.getCtx() == null)
			return;

		if(YouaiControlCenter.mCallBack.onLoginOutAfter()){
			
			SharedPreferences cofigSharePre = mAppInfo.getCtx().getSharedPreferences("config", 0);
			Editor editor = cofigSharePre.edit();
			editor.putBoolean("autologin", false);
			editor.commit();
			OnSuccessLoginUser.setIsLocalLogout("1");
			savehelp.doDbUpdate(OnSuccessLoginUser);
			OnSuccessLoginUser = null;
			OnSuccesBackJsonStr = null;
			YouaiLogin.autoLogin = false;
			YouaiCommplatform.this.isLogined = false;
			popuLoginView(OnSuccessLoginUser);
		}else{
			popuAlert();
		}
		
	}
	
	private void popuAlert(){
		 new AlertDialog.Builder(mAppInfo.getCtx())
			.setTitle("提示")
			.setMessage("游戏内部注销需要重新启动游戏\n")
			.setPositiveButton("确定", new Dialog.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface arg0, int arg1) {
					
					SharedPreferences cofigSharePre = mAppInfo.getCtx().getSharedPreferences("config", 0);
					Editor editor = cofigSharePre.edit();
					editor.putBoolean("autologin", false);
					editor.commit();
					OnSuccessLoginUser.setIsLocalLogout("1");
					savehelp.doDbUpdate(OnSuccessLoginUser); 
					OnSuccessLoginUser = null;
					YouaiLogin.autoLogin = false;
					YouaiCommplatform.this.isLogined = false;
					Toast.makeText(mAppInfo.getCtx(), "注销成功", Toast.LENGTH_SHORT).show();
					
					AlarmManager alm = (AlarmManager) mAppInfo.getCtx()
							.getSystemService(Context.ALARM_SERVICE);
					alm.set(AlarmManager.RTC, System.currentTimeMillis() + 1000,
							PendingIntent.getActivity(mAppInfo.getCtx(), 0, new Intent(mAppInfo.getCtx(),
									mAppInfo.getCtx().getClass()), 0));
					android.os.Process.killProcess(android.os.Process.myPid());
					
				}
			}).setNegativeButton("取消", new Dialog.OnClickListener() {
				
				@Override
				public void onClick(DialogInterface arg0, int arg1) {
					
				}
			}).show();
	}

	public boolean isAutoLogin(Context ctx) {
		return false;
	}
	public void setNotAutologin(){
		SharedPreferences cofigSharePre = mAppInfo.getCtx().getSharedPreferences("config", 0);
		Editor editor = cofigSharePre.edit();
		editor.putBoolean("autologin", false);
		editor.commit();
		
	}

	public int youaiEnterAppCenter() {

		return 0;
	}

	public int youaiEnterUserSetting() {

		return 0;
	}

	public int youaiEnterAppBBS(Context pContext) {
		WebindexDialog webindexdialog = new WebindexDialog(mAppInfo.getCtx(), "http://mxhzw.com/index.php");
		webindexdialog.show();
		return 0;
	}

	private int youaiEnterUserSpace(Context pContext,CallbackListener pCallbacklisten) {
		if(!initOk)return 0;
		Intent intent = new Intent(pContext, YouaiLogin.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("KEY_POSITION", 3);
		YouaiLogin.listener = pCallbacklisten;
		pContext.startActivity(intent);
		
		return 0;
	}

	public int youaiEnterRecharge(Context pContext,YouaiPayParams payinfo,CallbackListener pCallbacklisten) {
		if(!initOk)return 0;
		Intent intent = new Intent(pContext, YouaiPay.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("Center_POSITION", 1);
		YouaiPay.setPayCallback(pCallbacklisten);
		payinfo.setUid(YouaiCommplatform.getInstance().getLoginUin());
		YouaiPay.setPayInfo(payinfo);
		pContext.startActivity(intent);
		
		return 0;
	}
	 
	public YouaiUser getLoginUser() {
		if(null!=OnSuccessLoginUser){
			return OnSuccessLoginUser;
		}else if(null!=OnSuccessTryLoginUser){
			return OnSuccessTryLoginUser;
		}else {
			return null;
		}

	}

	
	protected void setLoginUser(YouaiUser pLoginUser) {
		OnSuccessLoginUser = pLoginUser;
		if(OnSuccessLoginUser.getUidStr()==null&&OnSuccessLoginUser.getUidStr().equals("")){
			  YouaiCommplatform.this.isLogined = false;
			  return;
		}else{
			YouaiCommplatform.this.isLogined = true;
		}
		
		SharedPreferences cofigSharePre = mAppInfo.getCtx().getSharedPreferences("config", 0);
		Editor editor = cofigSharePre.edit();
		editor.putBoolean("autologin", false);
		editor.commit();
		
	    try {
	    	//pLoginUser.setPassword(DES.encryptDES("com4love",pLoginUser.getPassword()));
	    	//pLoginUser.setUidStr(DES.encryptDES("com4love",pLoginUser.getUidStr()));
	    	pLoginUser.setPassword(pLoginUser.getPassword());
	    	pLoginUser.setUidStr(pLoginUser.getUidStr());
	    	savehelp.doDbUpdateOrInsert(pLoginUser);
	    } catch (Exception e1) {
			e1.printStackTrace();
		}
	    
	    
	}
	
	protected void setRegisterLoginUser(YouaiUser pLoginUser) {
		OnSuccessLoginUser = pLoginUser;
		if(OnSuccessLoginUser.getUidStr()!=null&&!OnSuccessLoginUser.getUidStr().equals("")){
			  YouaiCommplatform.this.isLogined = true;
		}
		
		SharedPreferences cofigSharePre = mAppInfo.getCtx().getSharedPreferences("config", 0);
		Editor editor = cofigSharePre.edit();
		editor.putBoolean("autologin", false);
		editor.commit();
		
	    try {
	    	/*pLoginUser.setPassword(DES.encryptDES("com4love",pLoginUser.getPassword()));
	    	pLoginUser.setUidStr(DES.encryptDES("com4love",pLoginUser.getUidStr()));*/
	    	pLoginUser.setPassword(pLoginUser.getPassword());
	    	pLoginUser.setUidStr(pLoginUser.getUidStr());
	    	   savehelp.doDbInsert(pLoginUser);
	    } catch (Exception e1) {
			e1.printStackTrace();
		}
	    
	 
	}
	

	
	protected void setThirdLoginUser(YouaiUser pLoginUser) {
		OnSuccessLoginUser = pLoginUser;
		if(OnSuccessLoginUser.getUidStr()!=null&&!OnSuccessLoginUser.getUidStr().equals("")){
			  YouaiCommplatform.this.isLogined = true;
		}
		 
	    try {
	    //	pLoginUser.setUidStr(DES.encryptDES("com4love",pLoginUser.getUidStr()));
	    	savehelp.doDbUpdateOrInsert(pLoginUser);
	    } catch (Exception e1) {
			e1.printStackTrace();
		}
	    
	    
	}
	
	public void youaiSetScreenOrientation(int oreientation) {

	}

	public void youaiSwitchAccount() {

	}

	public void youaiEnterSetting() {

	}

	public void EnterAccountManage(Context pContext,CallbackListener pCallbacklisten) {
		if(!initOk)return;
		
		String userType = "";
		 if (null != OnSuccessLoginUser) {
				userType = OnSuccessLoginUser.getUserType();
				Log.e("userType","userType+"+userType);
				if (userType.equals("2")) {
					Intent intent = new Intent(pContext, YouaiLogin.class);
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					intent.putExtra("KEY_POSITION", 1);
					YouaiLogin.showRegister = false;
					pContext.startActivity(intent);
				} else {
					Intent intent = new Intent(pContext, YouaiControlCenter.class);
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					YouaiLogin.showRegister = true;
					intent.putExtra("KEY_POSITION", 1);
					YouaiControlCenter.mCallBack = pCallbacklisten;
					YouaiControlCenter.setFromContext(pContext);
					pContext.startActivity(intent);
				}
		} 
		
	}

	public void youaiEnterAppUserCenter(Context pContext,CallbackListener pCallbacklisten) {
		if(!initOk)return;
		
		String userType = "";
		 if (null != OnSuccessLoginUser) {
				userType = OnSuccessLoginUser.getUserType();
				Log.e("userType","userType+"+userType);
				if (userType.equals("2")) {
					Intent intent = new Intent(pContext, YouaiLogin.class);
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					intent.putExtra("KEY_POSITION", 2);
					YouaiLogin.showRegister = false;
					pContext.startActivity(intent);
					
				} else {
					Intent intent = new Intent(pContext, YouaiControlCenter.class);
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					YouaiLogin.showRegister = true;
					intent.putExtra("KEY_POSITION", 1);
					YouaiControlCenter.mCallBack = pCallbacklisten;
					YouaiControlCenter.setFromContext(pContext);
					pContext.startActivity(intent);
				}
		}
	}

	
	
	interface LoginCallback {
		public void onSuccess();

		public void onFailed();
	}
	


	public void setYouaiBind(BindCallback pBindCallback){
		mBindCallback = pBindCallback;
	}
	
	private BindCallback mBindCallback; 
	
	protected void notifyBind(boolean pResult) {
		if(!initOk)return;
		
		if (pResult) {
			mBindCallback.onBindSuccess();
			new AlertDialog.Builder(mAppInfo.getCtx()).setTitle("提示")
					.setMessage("注册绑定成功").setPositiveButton("确定", null).show();
		}
	}

}
