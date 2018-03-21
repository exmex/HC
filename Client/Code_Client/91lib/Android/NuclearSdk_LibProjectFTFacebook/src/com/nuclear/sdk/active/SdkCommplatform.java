package com.nuclear.sdk.active;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.accounts.Account;
import android.app.Activity;
import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.drawable.GradientDrawable.Orientation;
import android.os.Bundle;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.Session;
import com.facebook.Session.StatusCallback;
import com.facebook.SessionState;
import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.GooglePlayServicesClient.ConnectionCallbacks;
import com.google.android.gms.common.GooglePlayServicesClient.OnConnectionFailedListener;
import com.google.android.gms.common.GooglePlayServicesUtil;
import com.google.android.gms.plus.PlusClient;
import com.google.android.gms.plus.PlusClient.OnPeopleLoadedListener;
import com.google.android.gms.plus.model.people.Person;
import com.google.android.gms.plus.model.people.Person.Name;
import com.google.android.gms.plus.model.people.PersonBuffer;
import com.nuclear.sdk.android.CallbackListener;
import com.nuclear.sdk.android.SdkError;
import com.nuclear.sdk.android.api.BindCallback;
import com.nuclear.sdk.android.api.SdkApi;
import com.nuclear.sdk.android.api.SdkException;
import com.nuclear.sdk.android.config.SdkConfig;
import com.nuclear.sdk.android.config.SdkErrorCode;
import com.nuclear.sdk.android.entry.SdkAppInfo;
import com.nuclear.sdk.android.entry.SdkUser;
import com.nuclear.sdk.android.token.Token;
import com.nuclear.sdk.android.utils.JsonUtil;
import com.nuclear.sdk.android.utils.Utils;
import com.nuclear.sdk.net.AsyncUserRunner;
import com.nuclear.sdk.net.RequestListener;
import com.nuclear.sdk.R;

public class SdkCommplatform {
	public static final int PROTRIT = 0;
	public static final int LANDSCAPE = 1;
	public List<Activity> activityList = new ArrayList<Activity>();
	protected static final String Tag = SdkCommplatform.class.getSimpleName();
	private static SdkCommplatform commplatform;
	private SdkAppInfo mAppInfo;
	private boolean isLogined = false;
	protected static CallbackListener mUserCallback;
	protected static String OnSuccesBackJsonStr = "";
	protected static SdkUser OnSuccessLoginUser;

	protected static String OnSuccesTryJsonStr = "";
	protected static SdkUser OnSuccessTryLoginUser;

	protected SaveUserHelp savehelp;// 保存用户的工具类
	protected static ArrayList<SdkUser> fromNetUserNames = new ArrayList<SdkUser>();
	private boolean haveTry = false;// 是否有试玩帐号
	private boolean haveOk = false;// 是否有正式帐号
	public static String channelName = "1000";
	private boolean initOk = false;

	private static final int REQUEST_CODE_RESOLVE_ERR = 9000;
    private OnInitCompleteListener mOnInitCallbackListener;
	private final String mFbGetUrl = "https://graph.facebook.com/me?access_token=";

	public SdkAppInfo getAppInfo() {
		return mAppInfo;
	}

	public static SdkCommplatform getInstance() {
		if (commplatform == null) {
			commplatform = new SdkCommplatform();

		}
		return commplatform;
	}

	int initTime = 0;

	public void Init(final Activity activity, SdkAppInfo sdkAppInfo,
			final OnInitCompleteListener OnInitCallbackListener) {
		if(OnInitCallbackListener==null){
		   Log.i(Tag, "init failed,OnInitCallbackListener is null");
		   return;
		}
		this.mOnInitCallbackListener=OnInitCallbackListener;
		if ((sdkAppInfo == null) || (sdkAppInfo.appId < 0)
				|| (sdkAppInfo.appSecret == null)
				|| (sdkAppInfo.appKey == null) || (activity == null)) {
			initOk = false;
			mOnInitCallbackListener.onFailed(SdkErrorCode.NUCLEAR_INIT_ERROR,
					activity.getString(R.string.initfailinner));
			return;
		}
		mAppInfo = sdkAppInfo;
		mAppInfo.setCtx(activity);
		savehelp = new SaveUserHelp(activity);

		JsonUtil.appinfo = mAppInfo.getAppId();
		SdkPay.appkey = mAppInfo.getAppKey();
		SdkPay.appsecret = mAppInfo.getAppSecret();

		ApplicationInfo appInfo = null;
		try {
			appInfo = activity.getPackageManager().getApplicationInfo(
					activity.getPackageName(), PackageManager.GET_META_DATA);
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}

		int channelId = appInfo.metaData.getInt("nuclear_channel");

		channelName = String.valueOf(channelId);

		SdkPay.channelId = String.valueOf(channelId);

		initTime = 0;
		AsyncUserRunner.requestInit(activity,
				String.valueOf(mAppInfo.getAppId()), mAppInfo.getAppKey(),
				channelName, new RequestListener() {

					@Override
					public void onIOException(IOException e) {
						initOk = false;
						initTime++;
						if (initTime < 4) {
							if (initTime == 2) {
								SdkConfig.urlroot = SdkConfig.urlroot_back;
							}

							AsyncUserRunner.requestInit(activity,
									String.valueOf(mAppInfo.getAppId()),
									mAppInfo.getAppKey(), channelName, this);

						}
//						activity.runOnUiThread(new Runnable() {
//
//							@Override
//							public void run() {
//								Toast.makeText(
//										activity,
//										activity.getString(R.string.initfailtryagain),
//										Toast.LENGTH_SHORT).show();
//								if (initTime < 4)
//									return;
//								mOnInitCallbackListener
//										.onFailed(
//												SdkErrorCode.NUCLEAR_INIT_ERROR,
//												activity.getString(R.string.initfailinner));
//							}
//						});
					}

					@Override
					public void onError(SdkException e) {
						initOk = false;
						initTime++;
						if (initTime < 3) {
							if (initTime == 2) {
								SdkConfig.urlroot = SdkConfig.urlroot_back;
							}
							AsyncUserRunner.requestInit(activity,
									String.valueOf(mAppInfo.getAppId()),
									mAppInfo.getAppKey(), channelName, this);
						}
						activity.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								Toast.makeText(
										activity,
										activity.getString(R.string.initfailtryagain),
										Toast.LENGTH_SHORT).show();
								if (initTime < 4)
									return;
								mOnInitCallbackListener
										.onFailed(
												SdkErrorCode.NUCLEAR_INIT_SUCCESS,
												activity.getString(R.string.initfailinner));
							}
						});
					}

					@Override
					public void onComplete(String response) {
						JSONObject backjson = null;
						try {
							backjson = new JSONObject(response);
							final String code = backjson.getString("error");
							final String errormsg = backjson
									.getString("errorMessage");
							if (code.equals("200")) {
								SdkConfig.timestamp = backjson
										.getLong("timestamp");
								SdkConfig.UrlFeedBack += "?gameId="
										+ mAppInfo.getAppKey() + "&platformId="
										+ SdkConfig.PlatformStr;
								initOk = true;
								activity.runOnUiThread(new Runnable() {
									@Override
									public void run() {
										mOnInitCallbackListener
												.onComplete(SdkErrorCode.NUCLEAR_INIT_SUCCESS);
									}
								});
							} else {
								initOk = false;
								activity.runOnUiThread(new Runnable() {
									@Override
									public void run() {
										mOnInitCallbackListener.onFailed(
												Integer.valueOf(code), errormsg);
									}
								});

							}
						} catch (JSONException e) {
							e.printStackTrace();
						}

					}
				});
	}

	public void nuclearCreate() {

	}

	public void nuclearPause() {

	}

	private ArrayList<SdkUser> tryUserList = new ArrayList<SdkUser>();
	private ArrayList<SdkUser> okUserList = new ArrayList<SdkUser>();
	public ArrayList<SdkUser> allUserList;

	/**
	 * 填充本地的user 检查本地存储的用户信息
	 */
	public void checkLocalUserInfo() {
		// 检查本地存储的用户信息
		allUserList = savehelp.doDbSelectAll();

		if (allUserList.size() == 0) {
			// 本地没有账号记录。先联网查询账号并存储到本地。
			if (!checkNetForUserInfo()) {
				doUserLogin(false);
			} else {
				doUserLogin(true);
			}

		} else {
			doUserLogin(true);
		}
		// if(tryUserList.size()==0&okUserList.size()==0){
		// doByUser(0);
		//
		// }else if(tryUserList.size()==0&okUserList.size()!=0){
		// UserDialog.nuclearUsers = allUserList;
		// doByUser(1);
		// }else if(tryUserList.size()!=0&okUserList.size()==0){
		// UserDialog.nuclearUsers = allUserList;
		// doByUser(2);
		// }else if(tryUserList.size()!=0&okUserList.size()!=0){
		// UserDialog.nuclearUsers = allUserList;
		// doByUser(3);
		//
		// }

	}

	private void doUserLogin(boolean hasUserInfo) {
		if (!hasUserInfo) {
			// 用户第一次登录
			mAppInfo.getCtx().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Intent intent = new Intent(mAppInfo.getCtx(),
							SdkPreLogin.class);
					intent.putExtra("oritention", mAppInfo.getOrientation());
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					mAppInfo.getCtx().startActivity(intent);
				}
			});
		} else {
			okUserList.clear();
			for (SdkUser itemUser : allUserList) {

				// 0 是正式用户，1是第三方登录用户,2是试玩用户
				if (itemUser.getUserType().equals("0")) {

					// 0表示不是本地登出账号，应该自动登录。
					okUserList.add(itemUser);
				}
			}
			UserDialog.nuclearUsers = okUserList;
			for (SdkUser itemUser : okUserList) {
				// 0表示不是本地登出账号，应该自动登录。
				if ("0".equals(itemUser.getIsLocalLogout())) {
					autoLoginOkUser(itemUser, allUserList);
					return;
				}
			}

			if (mAppInfo.getCtx()
					.getSharedPreferences("config", Context.MODE_PRIVATE)
					.getBoolean("autologin", false)) {
				// 这里是试玩的自动登录。
				mAppInfo.getCtx().runOnUiThread(new Runnable() {
					@Override
					public void run() {
						Intent intent = new Intent(mAppInfo.getCtx(),
								SdkRegistBindPre.class);
						intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						intent.putExtra("oritention", mAppInfo.getOrientation());
						mAppInfo.getCtx().startActivity(intent);
					}
				});
				return;

			}

			mAppInfo.getCtx().runOnUiThread(new Runnable() {
				@Override
				public void run() {
					Intent intent = new Intent(mAppInfo.getCtx(),
							SdkPreLogin.class);
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					intent.putExtra("oritention", mAppInfo.getOrientation());
					mAppInfo.getCtx().startActivity(intent);
				}
			});
		}
	}

	private boolean checkNetForUserInfo() {
		JSONObject message = new JSONObject();
		JSONObject data = new JSONObject();
		try {
			message.put("data", data);
			message.put("header", Utils.makeHead(mAppInfo.getCtx()));
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		SdkApi.getUserList(message.toString(), new RequestListener() {
			ArrayList<SdkUser> getFromUsers = new ArrayList<SdkUser>();
			ArrayList<SdkUser> okUsers = new ArrayList<SdkUser>();

			@Override
			public void onIOException(IOException e) {
				Log.e(Tag, e.toString());
			}

			@Override
			public void onError(SdkException e) {
				Log.e(Tag, e.toString());
			}

			@Override
			public void onComplete(String response) {
				JSONObject jsonServer;
				Log.e(Tag, "返回names：" + response);
				try {
					jsonServer = new JSONObject(response);
					String error = jsonServer.getString("error");
					// String errorMsg =
					// jsonServer.getString("errorMessage");
					if (error.equals("200")) {
						JSONArray players = jsonServer.getJSONObject("data")
								.getJSONArray("users");
						if (players == null || players.length() <= 0)
							return;

						mUserCallback.isOldDeviceUser();

						Log.e("users", "" + players.length());
						for (int i = 0; i < players.length(); i++) {
							SdkUser _tempUser = new SdkUser();
							_tempUser.setUidStr(players.getJSONObject(i)
									.getString("nuclearId"));
							_tempUser.setUserType(""
									+ players.getJSONObject(i).getInt(
											"userType"));
							_tempUser.setUsername(players.getJSONObject(i)
									.getString("name"));
							getFromUsers.add(i, _tempUser);
							if (_tempUser.getUserType().equals("2")) {
								// 试玩账号

								JSONObject jsonback = new JSONObject();
								JSONObject jsonObj = new JSONObject();
								jsonObj.put("nuclearId", _tempUser.getUidStr());
								jsonback.put("data", jsonObj);
								jsonback.put("username",
										_tempUser.getUsername());

								OnSuccesBackJsonStr = jsonback.toString();
								OnSuccessLoginUser = _tempUser;
								OnSuccesTryJsonStr = OnSuccesBackJsonStr;
								OnSuccessTryLoginUser = OnSuccessLoginUser;

								haveTry = true;
								savehelp.doDbInsert(_tempUser);
							} else if (_tempUser.getUserType().equals("1")) {
								// 第三方登录账号
								haveOk = true;
								savehelp.doDbInsert(_tempUser);
							} else {
								// 正式账号
								okUsers.add(_tempUser);
								haveOk = true;
								savehelp.doDbInsert(_tempUser);
							}
						}
						fromNetUserNames = getFromUsers;

						// 登录下拉框只保存正式用户。
						UserDialog.nuclearUsers = okUsers;

						allUserList = fromNetUserNames;

					}

				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});
		return allUserList.size() > 0;

	}

	/** 访问网络获取机器登录的user */
	public void doByUser(int which) {
		if (which == 0) {// 本地没有试玩帐号也没有正式帐号
			askServerByDevice();

		}

		else if (which == 1) {// 本地没有试玩帐号有正式帐号

			mUserCallback.isOldDeviceUser();

			mHasAutoLoginOkUser = false;
			SdkUser tempUser = null;

			for (SdkUser itemUser : okUserList) {
				if ("0".equals(itemUser.getIsLocalLogout())) {

					mHasAutoLoginOkUser = true;
					tempUser = itemUser;
					break;
				}
			}

			final SdkUser _tempAutoLoginUser = tempUser;

			if (true) {
				OnSuccesBackJsonStr = null;
				OnSuccessLoginUser = null;
				OnSuccessTryLoginUser = null;
				OnSuccesTryJsonStr = null;

				JSONObject trymessage = new JSONObject();
				JSONObject trydata = new JSONObject();
				try {
					trydata.put("nuclearId", "");
					trydata.put("channel", channelName);
					trymessage.put("data", trydata);
					trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}

				SdkApi.CreateOrLoginTry(trymessage.toString(),
						new RequestListener() {

							@Override
							public void onIOException(IOException e) {
								Log.e(Tag, e.toString());
								if (mHasAutoLoginOkUser) {
									Log.e(Tag, ":::  bHasAutoLoginOkUser");
									autoLoginOkUser(_tempAutoLoginUser,
											allUserList);// 自动登录本地保存的帐号
								} else {
									popuLoginView(okUserList.get(0));// 弹出登录框，填充
																		// text，填充列表
								}
							}

							@Override
							public void onError(SdkException e) {
								Log.e(Tag, e.toString());
								if (mHasAutoLoginOkUser) {
									Log.e(Tag, ":::  bHasAutoLoginOkUser");
									autoLoginOkUser(_tempAutoLoginUser,
											allUserList);// 自动登录本地保存的帐号
								} else {
									popuLoginView(okUserList.get(0));// 弹出登录框，填充
																		// text，填充列表
								}
							}

							@Override
							public void onComplete(String response) {
								JSONObject jsonServer;
								Log.e(Tag, "TRY onComplete" + response);
								try {
									jsonServer = new JSONObject(response);
									String error = jsonServer
											.getString("error");
									if (error.equals("200")) {
										String nucleard = jsonServer
												.getJSONObject("data")
												.getString("nuclearId");
										int isCreate = jsonServer
												.getJSONObject("data").getInt(
														"isCreate");
										if (isCreate == 1) {
											mUserCallback.onTryRegister();
										}
										String nuclearName = jsonServer
												.getJSONObject("data")
												.getString("nuclearName");
										int userType = jsonServer
												.getJSONObject("data").getInt(
														"userType");
										SdkUser _tempUser = new SdkUser();
										_tempUser.setUidStr(nucleard);
										_tempUser.setUserType("" + userType);
										_tempUser.setUsername(nuclearName);
										fromNetUserNames.add(_tempUser);
										JSONObject jsonback = new JSONObject();
										JSONObject jsonObj = new JSONObject();
										jsonObj.put("nuclearId", nucleard);
										jsonback.put("data", jsonObj);
										jsonback.put("username", nuclearName);
										OnSuccesBackJsonStr = jsonback
												.toString();
										OnSuccessLoginUser = _tempUser;
										OnSuccessTryLoginUser = OnSuccessLoginUser;
										OnSuccesTryJsonStr = OnSuccesBackJsonStr;

										savehelp.doDbUpdateOrInsert(_tempUser);

										Log.e(Tag, "创建试玩帐号" + response);

										if (mHasAutoLoginOkUser) {
											Log.e(Tag,
													":::  bHasAutoLoginOkUser");
											autoLoginOkUser(_tempAutoLoginUser,
													allUserList);// 自动登录本地保存的帐号
										} else {
											popuLoginView(okUserList.get(0));// 弹出登录框，填充
																				// text，填充列表
										}

									}
								} catch (Exception e) {
									Log.e(Tag, e.toString());
								}

							}
						});
			}

		}

		else if (which == 2) {// 本地有试玩帐号，没有正式帐号
			// 校验下 用试玩帐号登录
			for (SdkUser pUser : allUserList) {
				if ("2".equals(pUser.getUserType())) {
					tryUserList.add(pUser);
				}
			}
			askServerTryCheckorLogin(tryUserList.get(0));

			mUserCallback.isOldDeviceUser();
		}

		else if (which == 3) {// 本地有试玩帐号，也有正式帐号
			// 按最后使用，来判定，使用tryuser autologin 还是使用ok user，login by 是否注销 显示列表 包含随机

			mUserCallback.isOldDeviceUser();

			UserDialog.nuclearUsers = allUserList;

			mHasAutoLoginOkUser = false;
			SdkUser tempUser = null;

			for (SdkUser itemUser : okUserList) {
				if ("0".equals(itemUser.getIsLocalLogout())) {

					mHasAutoLoginOkUser = true;
					tempUser = itemUser;
					break;
				}
			}

			final SdkUser _tempAutoLoginUser = tempUser;
			if (true) {
				OnSuccesBackJsonStr = null;
				OnSuccessLoginUser = null;
				OnSuccesTryJsonStr = null;
				OnSuccessTryLoginUser = null;

				JSONObject trymessage = new JSONObject();
				JSONObject trydata = new JSONObject();
				final SdkUser _tryUser = tryUserList.get(0);
				try {
					trydata.put("nuclearId", _tryUser.getUidStr());
					trydata.put("channel", channelName);
					trymessage.put("data", trydata);
					trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}

				SdkApi.CreateOrLoginTry(trymessage.toString(),
						new RequestListener() {

							@Override
							public void onIOException(IOException e) {
								Log.e(Tag, e.toString());
								if (mHasAutoLoginOkUser) {
									autoLoginOkUser(_tempAutoLoginUser,
											allUserList);// 自动登录本地保存的帐号
								} else if (!isLogined) {
									isLogined = false;
									popuLoginView(okUserList.get(0));// 弹出登录框，填充
																		// text，填充列表
								}
							}

							@Override
							public void onError(SdkException e) {
								Log.e(Tag, e.toString());

								if (mHasAutoLoginOkUser) {
									autoLoginOkUser(_tempAutoLoginUser,
											allUserList);// 自动登录本地保存的帐号
								} else {
									isLogined = false;
									popuLoginView(okUserList.get(0));// 弹出登录框，填充
																		// text，填充列表
								}
							}

							@Override
							public void onComplete(String response) {
								JSONObject jsonServer;
								try {
									jsonServer = new JSONObject(response);
									String error = jsonServer
											.getString("error");
									if (error.equals("200")) {
										String nucleard = jsonServer
												.getJSONObject("data")
												.getString("nuclearId");
										int isCreate = jsonServer
												.getJSONObject("data").getInt(
														"isCreate");
										String nuclearName = jsonServer
												.getJSONObject("data")
												.getString("nuclearName");
										int userType = jsonServer
												.getJSONObject("data").getInt(
														"userType");
										SdkUser _tempTryUser = new SdkUser();
										_tempTryUser.setUidStr(nucleard);
										_tempTryUser.setUserType("" + userType);
										_tempTryUser.setUsername(nuclearName);
										if (isCreate != 1) {
											fromNetUserNames.add(_tempTryUser);
											mUserCallback.onTryRegister();
										}
										JSONObject jsonback = new JSONObject();
										JSONObject jsonObj = new JSONObject();
										jsonObj.put("nuclearId", nucleard);
										jsonback.put("data", jsonObj);
										jsonback.put("username", nuclearName);

										OnSuccesBackJsonStr = jsonback
												.toString();
										OnSuccessLoginUser = _tempTryUser;
										OnSuccesTryJsonStr = OnSuccesBackJsonStr;
										OnSuccessTryLoginUser = OnSuccessLoginUser;

										if (isCreate == 0) {

											if (_tryUser.getUidStr().equals(
													nucleard)) {
												savehelp.doDbUpdate(_tempTryUser);
											} else {
												savehelp.doDbInsert(_tempTryUser);
												savehelp.doDbDelete(_tryUser);
											}
										} else {
											savehelp.doDbInsert(_tempAutoLoginUser);
											savehelp.doDbDelete(_tryUser);
										}

										if (mHasAutoLoginOkUser) {
											autoLoginOkUser(_tempAutoLoginUser,
													allUserList);// 自动登录本地保存的帐号
										} else {
											isLogined = false;
											popuLoginView(okUserList.get(0));// 弹出登录框，填充
																				// text，填充列表
										}

									} else {
										if (mHasAutoLoginOkUser) {
											autoLoginOkUser(_tempAutoLoginUser,
													allUserList);// 自动登录本地保存的帐号
										} else {
											funcDoAfterLogin();
										}

									}
								} catch (Exception e) {
									Log.e(Tag, e.toString());
								}

							}
						});
			}

		}

	}

	boolean mHasAutoLoginOkUser = false;

	private void afterAutoLogin() {
		mAppInfo.getCtx().runOnUiThread(new Runnable() {

			@Override
			public void run() {
				if (isLogined) {
					mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
					return;
				} else if (!isLogined) {
					if (OnSuccesBackJsonStr != null) {
						isLogined = true;
						mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
					} else {
						popuLoginView(okUserList.get(0));
					}
				}
			}
		});

	}

	// private boolean insertOrUpdate = false; //false:insert true:Update
	// 访问网络获取到的user 网络登录的是按照时间排序的，自动填充第一个
	private void askServerByDevice() {
		/*
		 * 第一次玩本地没有 网络返回一个初始化的 tryuser
		 */
		final SdkError _Error = new SdkError();
		JSONObject trymessage = new JSONObject();
		JSONObject trydata = new JSONObject();
		try {
			trydata.put("nuclearId", "");
			trydata.put("channel", channelName);
			trymessage.put("data", trydata);
			trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
		} catch (JSONException e1) {
			e1.printStackTrace();
		}

		SdkApi.CreateOrLoginTry(trymessage.toString(), new RequestListener() {

			@Override
			public void onIOException(IOException e) {
				Log.e(Tag, "IOExecption");
				isLogined = false;
				// funcDoAfterLogin();
				_Error.setmErrorCode(SdkErrorCode.NUCLEAR_NET_ERR);
				_Error.setmErrorMessage(e.toString());
			}

			@Override
			public void onError(SdkException e) {
				Log.e(Tag, "onError");
				isLogined = false;
				// funcDoAfterLogin();
				_Error.setmErrorCode(SdkErrorCode.NUCLEAR_NET_ERR);
				_Error.setmErrorMessage(e.toString());
			}

			@Override
			public void onComplete(String response) {
				Log.e(Tag, "onComplete 222");
				JSONObject jsonServer;
				try {
					jsonServer = new JSONObject(response);
					String error = jsonServer.getString("error");
					if (error.equals("200")) {
						String nucleard = jsonServer.getJSONObject("data")
								.getString("nuclearId");
						int isCreate = jsonServer.getJSONObject("data").getInt(
								"isCreate");
						String nuclearName = jsonServer.getJSONObject("data")
								.getString("nuclearName");
						int userType = jsonServer.getJSONObject("data").getInt(
								"userType");
						SdkUser _tempUser = new SdkUser();
						_tempUser.setUidStr(nucleard);
						_tempUser.setUserType("" + userType);
						_tempUser.setUsername(nuclearName);
						if (isCreate != 0) {
							mUserCallback.onTryRegister();
						}
						JSONObject jsonback = new JSONObject();
						JSONObject jsonObj = new JSONObject();
						jsonObj.put("nuclearId", nucleard);
						jsonback.put("data", jsonObj);
						jsonback.put("username", nuclearName);

						OnSuccesBackJsonStr = jsonback.toString();
						OnSuccessLoginUser = _tempUser;
						OnSuccesTryJsonStr = OnSuccesBackJsonStr;
						OnSuccessTryLoginUser = OnSuccessLoginUser;

						savehelp.doDbUpdateOrInsert(_tempUser);

						if (isCreate == 1 & !haveOk) {// 没有登录过不弹出登录框
							isLogined = true;
							mAppInfo.getCtx().runOnUiThread(new Runnable() {

								@Override
								public void run() {
									mUserCallback
											.onLoginSuccess(OnSuccesBackJsonStr);
								}
							});
						} else if (isCreate == 0 & !haveOk) {
							isLogined = true;
							mAppInfo.getCtx().runOnUiThread(new Runnable() {

								@Override
								public void run() {
									mUserCallback
											.onLoginSuccess(OnSuccesBackJsonStr);
								}
							});
						} else {
							funcDoAfterLogin();
						}

					} else {
						funcDoAfterLogin();
					}
				} catch (Exception e) {
					Log.e(Tag, e.toString());
					_Error.setmErrorCode(SdkErrorCode.NUCLEAR_NET_ERR);
					_Error.setmErrorMessage(e.toString());
				}

			}
		});

		extracted(_Error);

	}

	private void funcDoAfterLogin() {
		if (!isLogined & !haveOk) { // 获取到了tryUser 没有OkUser
			Log.e(Tag, "!haveOk");
			if (null != OnSuccesBackJsonStr && !isLogined) {
				isLogined = true;
				savehelp.doDbUpdateOrInsert(OnSuccessLoginUser);
				mAppInfo.getCtx().runOnUiThread(new Runnable() {

					@Override
					public void run() {
						mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
					}
				});
			} else if (fromNetUserNames.size() != 0) {// 对异常的处理 就弹出登录框
				allUserList = fromNetUserNames;
				popuLoginView(fromNetUserNames.get(0));
			} else {
				popuLoginView(null);
			}

		} else if (haveOk) {// 获取到了tryUser 有 OkUser
			Log.e(Tag, "haveOk");
			allUserList = fromNetUserNames;
			popuLoginView(fromNetUserNames.get(0));

		} else if (haveTry) {
			askServerTryCheckorLogin(OnSuccessTryLoginUser);
		}
	}

	// 校验成功与否，成功登录，校验失败 则返回新的tryuser继续登录
	private void askServerTryCheckorLogin(SdkUser pTryUser) {

		// insertOrUpdate = true;
		OnSuccesBackJsonStr = null;
		OnSuccessLoginUser = null;
		OnSuccesTryJsonStr = null;
		OnSuccessTryLoginUser = null;

		JSONObject trymessage = new JSONObject();
		JSONObject trydata = new JSONObject();
		try {
			trydata.put("nuclearId", pTryUser.getUidStr());
			trydata.put("channel", channelName);
			trymessage.put("data", trydata);
			trymessage.put("header", Utils.makeHead(mAppInfo.getCtx()));
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		final SdkUser _nuclearUser = pTryUser;
		final SdkError _Error = new SdkError();

		SdkApi.CreateOrLoginTry(trymessage.toString(), new RequestListener() {

			@Override
			public void onIOException(IOException e) {
				Log.e(Tag, e.toString());
				_Error.setmErrorCode(SdkErrorCode.NUCLEAR_NET_ERR);
				_Error.setmErrorMessage(e.toString());
				extracted(_Error);
			}

			@Override
			public void onError(SdkException e) {
				Log.e(Tag, e.toString());
			}

			@Override
			public void onComplete(String response) {
				JSONObject jsonServer;
				try {
					jsonServer = new JSONObject(response);
					String error = jsonServer.getString("error");
					if (error.equals("200")) {
						String nucleard = jsonServer.getJSONObject("data")
								.getString("nuclearId");
						int isCreate = jsonServer.getJSONObject("data").getInt(
								"isCreate");

						String nuclearName = jsonServer.getJSONObject("data")
								.getString("nuclearName");
						int userType = jsonServer.getJSONObject("data").getInt(
								"userType");
						SdkUser _tempUser = new SdkUser();
						_tempUser.setUidStr(nucleard);
						_tempUser.setUserType("" + userType);
						_tempUser.setUsername(nuclearName);

						if (isCreate != 0) {
							fromNetUserNames.add(_tempUser);
							mUserCallback.onTryRegister();
						}

						JSONObject jsonback = new JSONObject();
						JSONObject jsonObj = new JSONObject();
						jsonObj.put("nuclearId", nucleard);
						jsonback.put("data", jsonObj);
						jsonback.put("username", nuclearName);

						OnSuccesBackJsonStr = jsonback.toString();
						OnSuccessLoginUser = _tempUser;
						OnSuccesTryJsonStr = OnSuccesBackJsonStr;
						OnSuccessTryLoginUser = OnSuccessLoginUser;

						if (isCreate == 0) {
                         
							if (_nuclearUser.getUidStr().equals(nucleard)) {
								savehelp.doDbUpdate(_tempUser);
							} else {
								savehelp.doDbInsert(_tempUser);
								savehelp.doDbDelete(_nuclearUser);
							}
						} else {
							savehelp.doDbInsert(_tempUser);
							savehelp.doDbDelete(_nuclearUser);
						}
						
					}
					extracted(_Error);
				} catch (Exception e) {
					Log.e(Tag, e.toString());
				}

			}
		});

		

	}

	private void extracted(final SdkError _Error) {
		if (OnSuccesBackJsonStr != null) {
			isLogined = true;
			mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
			mAppInfo.getCtx()
					.getSharedPreferences("config", Context.MODE_PRIVATE)
					.edit().putBoolean("autologin", true).commit();
		} else {
			isLogined = false;
			mUserCallback.onLoginError(_Error);
		}
	}

	private void autoLoginOkUser(SdkUser pOkUser, List<SdkUser> pOkList) {
		JSONObject message = new JSONObject();
		JSONObject data = new JSONObject();
		try {
			data.put("nuclearName", pOkUser.getUsername());
			data.put("password", pOkUser.getPassword());
			message.put("data", data);
			message.put("header", Utils.makeHead(mAppInfo.getCtx()));
		} catch (JSONException e1) {
			e1.printStackTrace();
		}

		// DB UPDATE
		savehelp.doDbUpdate(pOkUser);

		final SdkUser _oKUser = pOkUser;
		final String _password = pOkUser.getPassword();
		final String _nuclearName = pOkUser.getUsername();
		SdkApi.Login(message.toString(), new RequestListener() {

			@Override
			public void onComplete(String response) {
				Log.e(Tag, "in autoLoginOkUser");
				JSONObject jsonback = null;
				String error = null;
				String nuclearId = null;
				try {
					jsonback = new JSONObject(response);
					error = jsonback.getString("error");

					if (error.equals("200")) {
						nuclearId = jsonback.getJSONObject("data").getString(
								"nuclearId");
						jsonback.put("username", _nuclearName);
						_oKUser.setIsLocalLogout("0");

						OnSuccesBackJsonStr = jsonback.toString();
						OnSuccessLoginUser = _oKUser;
						isLogined = true;
						// dB UPDATE
						savehelp.doDbUpdate(_oKUser);
						SdkCommplatform.getInstance().setLoginUser(_oKUser);

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
			public void onError(SdkException e) {
				isLogined = false;
				afterAutoLogin();
			}
		});

	}

	private void popuTryView() {

		mAppInfo.getCtx().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Intent intent = new Intent(mAppInfo.getCtx(), SdkLogin.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.putExtra("KEY_POSITION", 3);
				mAppInfo.getCtx().startActivity(intent);
			}
		});

	}

	private void popuLoginView(SdkUser pTheUser) {
		SdkLogin.mRecentnuclearUser = pTheUser;
		mAppInfo.getCtx().runOnUiThread(new Runnable() {
			@Override
			public void run() {
				Intent intent = new Intent(mAppInfo.getCtx(), SdkPreLogin.class);
				intent.putExtra("oritention", mAppInfo.getOrientation());
				mAppInfo.getCtx().startActivity(intent);
			}
		});

	}

	private void popuRecentUser(SdkUser pRecentUser) {
		if ("2".equals(pRecentUser.getUserType())) {
			askServerTryCheckorLogin(pRecentUser);// 校验下并登录

		} else {
			popuLoginView(pRecentUser);
			// 弹出登录框 填充 pRecentUser
		}

	}

	protected void LoginTry() {

		if (null != OnSuccesBackJsonStr) {
			savehelp.doDbUpdateOrInsert(OnSuccessLoginUser);
			mUserCallback.onLoginSuccess(OnSuccesBackJsonStr);
			isLogined = true;
		} else if (null != OnSuccesTryJsonStr) {

			savehelp.doDbUpdateOrInsert(OnSuccessTryLoginUser);
			mUserCallback.onLoginSuccess(OnSuccesTryJsonStr);
			setLoginUser(OnSuccessTryLoginUser);

			isLogined = true;
		} else {
			mUserCallback.onLoginError(new SdkError(mAppInfo.getCtx()
					.getString(R.string.netwarning)));
			isLogined = false;
		}

	}

	protected void innerLoginTry() {
		if (null != OnSuccesTryJsonStr) {

			savehelp.doDbUpdateOrInsert(OnSuccessTryLoginUser);
			mUserCallback.onLoginSuccess(OnSuccesTryJsonStr);
			setLoginUser(OnSuccessTryLoginUser);

			isLogined = true;
		}
	}

	public void nuclearExit() {

	}

	public void destory() {

	}

	public byte[] getToken() {
		return null;
	}

	public String getLoginUin() {
		if (OnSuccessLoginUser != null) {
			return OnSuccessLoginUser.getUidStr();
		} else if (null != OnSuccessTryLoginUser) {
			return OnSuccessTryLoginUser.getUidStr();
		} else {
			return null;
		}
	}

	public String getSessionId() {
		return null;
	}

	public String getLoginNickName() {
		if (OnSuccessLoginUser != null) {
			return OnSuccessLoginUser.getUsername();
		} else if (null != OnSuccessTryLoginUser) {
			return OnSuccessTryLoginUser.getUsername();
		} else {
			return null;
		}
	}

	public void nuclearCheckPaySuccess() {

	}

	public void nuclearLogin(Context pContext, CallbackListener callbacklisten) {
		/*
		 * Intent intent = new Intent(pContext, nuclearLogin.class);
		 * intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		 * intent.putExtra("KEY_POSITION", 1);
		 */
		if (!initOk)
			return;
		SdkLogin.listener = callbacklisten;
		mUserCallback = callbacklisten;
		checkLocalUserInfo();
	}

	public void u2QuickRegist(Context pContext, CallbackListener callbacklisten) {
		if (!initOk)
			return;
		Intent intent = new Intent(pContext, SdkLogin.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("KEY_POSITION", 2);
		SdkLogin.listener = callbacklisten;
		pContext.startActivity(intent);

	}

	public boolean isLogined() {

		return isLogined;
	}

	private void onClickLogoutFB() {
		try {
			Session session = Session.getActiveSession();
			if (!session.isClosed()) {
				session.closeAndClearTokenInformation();
			}
		} catch (Exception e) {
			Log.e(Tag, e.toString());
		}

	}

	public void nuclearLogout(Context pContext) {
		isLogined = false;
		onClickLogoutFB();

		if (mAppInfo.getCtx() == null)
			return;

		if (SdkControlCenter.mCallBack.onLoginOutAfter()) {

			SharedPreferences cofigSharePre = mAppInfo.getCtx()
					.getSharedPreferences("config", 0);
			Editor editor = cofigSharePre.edit();
			editor.putBoolean("autologin", false);
			editor.commit();
			OnSuccessLoginUser.setIsLocalLogout("1");
			savehelp.doDbUpdate(OnSuccessLoginUser);
			OnSuccessLoginUser = null;
			OnSuccesBackJsonStr = null;
			SdkLogin.autoLogin = false;
			SdkCommplatform.this.isLogined = false;
			nuclearLogin(pContext, mUserCallback);
		} else {

			popuAlert();

		}

	}

	public void nuclearLogoutPopu(Context pContext) {
		isLogined = false;
		if (mAppInfo.getCtx() == null)
			return;

		if (SdkControlCenter.mCallBack.onLoginOutAfter()) {

			SharedPreferences cofigSharePre = mAppInfo.getCtx()
					.getSharedPreferences("config", 0);
			Editor editor = cofigSharePre.edit();
			editor.putBoolean("autologin", false);
			editor.commit();
			OnSuccessLoginUser.setIsLocalLogout("1");
			savehelp.doDbUpdate(OnSuccessLoginUser);
			OnSuccessLoginUser = null;
			OnSuccesBackJsonStr = null;
			SdkLogin.autoLogin = false;
			SdkCommplatform.this.isLogined = false;
			onClickLogoutFB();
			popuLoginView(OnSuccessLoginUser);
		} else {
			popuAlert();
		}

	}

	private void popuAlert() {
		new AlertDialog.Builder(mAppInfo.getCtx())
				.setTitle(R.string.warning)
				.setMessage(R.string.logouneedre)
				.setPositiveButton(R.string.ensure,
						new Dialog.OnClickListener() {

							@Override
							public void onClick(DialogInterface arg0, int arg1) {

								SharedPreferences cofigSharePre = mAppInfo
										.getCtx().getSharedPreferences(
												"config", 0);
								Editor editor = cofigSharePre.edit();
								editor.putBoolean("autologin", false);
								editor.commit();
								OnSuccessLoginUser.setIsLocalLogout("1");
								savehelp.doDbUpdate(OnSuccessLoginUser);
								OnSuccessLoginUser = null;
								SdkLogin.autoLogin = false;
								SdkCommplatform.this.isLogined = false;
								Toast.makeText(mAppInfo.getCtx(),
										R.string.logoutsuccess,
										Toast.LENGTH_SHORT).show();

								AlarmManager alm = (AlarmManager) mAppInfo
										.getCtx().getSystemService(
												Context.ALARM_SERVICE);
								alm.set(AlarmManager.RTC, System
										.currentTimeMillis() + 1000,
										PendingIntent.getActivity(mAppInfo
												.getCtx(), 0, new Intent(
												mAppInfo.getCtx(), mAppInfo
														.getCtx().getClass()),
												0));
								android.os.Process
										.killProcess(android.os.Process.myPid());

							}
						})
				.setNegativeButton(R.string.cancel,
						new Dialog.OnClickListener() {

							@Override
							public void onClick(DialogInterface arg0, int arg1) {

							}
						}).show();
	}

	public boolean isAutoLogin(Context ctx) {
		return false;
	}

	public void setNotAutologin() {
		SharedPreferences cofigSharePre = mAppInfo.getCtx()
				.getSharedPreferences("config", 0);
		Editor editor = cofigSharePre.edit();
		editor.putBoolean("autologin", false);
		editor.commit();

	}

	public int nuclearEnterAppCenter() {

		return 0;
	}

	public int nuclearEnterUserSetting() {

		return 0;
	}

	public int nuclearEnterAppBBS(Context pContext) {
		WebindexDialog webindexdialog = new WebindexDialog(mAppInfo.getCtx(),
				"http://mxhzw.com/index.php");
		webindexdialog.show();
		return 0;
	}

	private int nuclearEnterUserSpace(Context pContext,
			CallbackListener pCallbacklisten) {
		if (!initOk)
			return 0;
		Intent intent = new Intent(pContext, SdkLogin.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("KEY_POSITION", 3);
		SdkLogin.listener = pCallbacklisten;
		pContext.startActivity(intent);

		return 0;
	}

	public int nuclearEnterRecharge(Context pContext, SdkPayParams payinfo,
			CallbackListener pCallbacklisten) {
		if (!initOk)
			return 0;
		Intent intent = new Intent(pContext, SdkPay.class);
		intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		intent.putExtra("Center_POSITION", 1);
		SdkPay.setPayCallback(pCallbacklisten);
		payinfo.setUid(SdkCommplatform.getInstance().getLoginUin());
		SdkPay.setPayInfo(payinfo);
		pContext.startActivity(intent);

		return 0;
	}

	public SdkUser getLoginUser() {
		if (null != OnSuccessLoginUser) {
			return OnSuccessLoginUser;
		} else if (null != OnSuccessTryLoginUser) {
			return OnSuccessTryLoginUser;
		} else {
			return null;
		}

	}

	public SdkUser getTryLoginUser() {
		tryUserList.clear();
		for (SdkUser itemUser : allUserList) {

			// 0 是正式用户，1是第三方登录用户,2是试玩用户
			if (itemUser.getUserType().equals("2")) {

				// 0表示不是本地登出账号，应该自动登录。
				tryUserList.add(itemUser);
			}
		}
		return tryUserList.get(0);

	}

	protected void setLoginUser(SdkUser pLoginUser) {
		OnSuccessLoginUser = pLoginUser;
		if (OnSuccessLoginUser.getUidStr() == null
				&& OnSuccessLoginUser.getUidStr().equals("")) {
			SdkCommplatform.this.isLogined = false;
			return;
		} else {
			SdkCommplatform.this.isLogined = true;
		}

		/*
		 * SharedPreferences cofigSharePre =
		 * mAppInfo.getCtx().getSharedPreferences("config", 0); Editor editor =
		 * cofigSharePre.edit(); editor.putBoolean("autologin", false);
		 * editor.commit();
		 */

		try {
			savehelp.doDbUpdateOrInsert(pLoginUser);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

	}

	protected void setRegisterLoginUser(SdkUser pLoginUser) {
		OnSuccessLoginUser = pLoginUser;
		if (OnSuccessLoginUser.getUidStr() != null
				&& !OnSuccessLoginUser.getUidStr().equals("")) {
			SdkCommplatform.this.isLogined = true;
		}

		try {
			/*
			 * pLoginUser.setPassword(DES.encryptDES("com4love",pLoginUser.
			 * getPassword()));
			 * pLoginUser.setUidStr(DES.encryptDES("com4love",pLoginUser
			 * .getUidStr()));
			 */
			pLoginUser.setPassword(pLoginUser.getPassword());
			pLoginUser.setUidStr(pLoginUser.getUidStr());
			savehelp.doDbInsert(pLoginUser);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

	}

	protected void setThirdLoginUser(SdkUser pLoginUser) {
		OnSuccessLoginUser = pLoginUser;
		if (OnSuccessLoginUser.getUidStr() != null
				&& !OnSuccessLoginUser.getUidStr().equals("")) {
			SdkCommplatform.this.isLogined = true;
		}

		try {
			// pLoginUser.setUidStr(DES.encryptDES("com4love",pLoginUser.getUidStr()));
			savehelp.doDbUpdateOrInsert(pLoginUser);
		} catch (Exception e1) {
			e1.printStackTrace();
		}

	}

	public void nuclearSetScreenOrientation(int oreientation) {

	}

	public void nuclearSwitchAccount() {

	}

	public void nuclearEnterSetting() {

	}

	public void EnterAccountManage(Context pContext,
			CallbackListener pCallbacklisten) {

		if (!initOk)
			return;

		String userType = "";
		if (null != OnSuccessLoginUser) {
			userType = OnSuccessLoginUser.getUserType();

			if (userType.equals("2")) {
				// Intent intent = new Intent(pContext, nuclearLogin.class);
				// intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				// intent.putExtra("KEY_POSITION", 1);
				// nuclearLogin.showRegister = false;
				// pContext.startActivity(intent);
				Intent intent = new Intent(mAppInfo.getCtx(),
						SdkControlCenter.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				SdkControlCenter.mCallBack = pCallbacklisten;
				SdkControlCenter.setFromContext(pContext);
				mAppInfo.getCtx().startActivity(intent);

			} else {
				Intent intent = new Intent(pContext, SdkControlCenter.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				SdkLogin.showRegister = true;
				intent.putExtra("KEY_POSITION", 1);
				SdkControlCenter.mCallBack = pCallbacklisten;
				SdkControlCenter.setFromContext(pContext);
				pContext.startActivity(intent);
			}
		}

		// if (!initOk)
		// return;
		// SdkControlCenter.mCallBack = pCallbacklisten;
		// SdkControlCenter.setFromContext(pContext);
		// // SdkCommplatform.getInstance().nuclearLogoutPopu(pContext);
		// String userType = "";
		// if (null != OnSuccessLoginUser) {
		// userType = OnSuccessLoginUser.getUserType();
		// Log.e("userType", "userType+" + userType);
		// if (userType.equals("2")) {
		// Intent intent = new Intent(mAppInfo.getCtx(), SdkLogin.class);
		// intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		// intent.putExtra("KEY_POSITION", 1);
		// SdkLogin.showRegister = false;
		// mAppInfo.getCtx().startActivity(intent);
		// } else {
		// Intent intent = new Intent(mAppInfo.getCtx(),
		// SdkControlCenter.class);
		// intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		// SdkLogin.showRegister = true;
		// intent.putExtra("KEY_POSITION", 1);
		// SdkControlCenter.mCallBack = SdkLogin.listener;
		// SdkControlCenter.setFromContext(mAppInfo.getCtx());
		// mAppInfo.getCtx().startActivity(intent);
		// }
		// }
	}

	protected void innerFbEnterAccoutManager() {

		String userType = "";
		if (null != OnSuccessLoginUser) {
			userType = OnSuccessLoginUser.getUserType();
			Log.e("userType", "userType+" + userType);
			if (userType.equals("2")) {
				Intent intent = new Intent(mAppInfo.getCtx(), SdkLogin.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.putExtra("KEY_POSITION", 1);
				SdkLogin.showRegister = false;
				mAppInfo.getCtx().startActivity(intent);
			} else {
				Intent intent = new Intent(mAppInfo.getCtx(),
						SdkControlCenter.class);
				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				SdkLogin.showRegister = true;
				intent.putExtra("KEY_POSITION", 1);
				SdkControlCenter.mCallBack = SdkLogin.listener;
				SdkControlCenter.setFromContext(mAppInfo.getCtx());
				mAppInfo.getCtx().startActivity(intent);
			}
		}
	}

	public void nuclearEnterAppUserCenter(Context pContext,
			CallbackListener pCallbacklisten) {
		if (!initOk)
			return;
		SdkCommplatform.getInstance().nuclearLogoutPopu(pContext);
		// String userType = "";
		// if (null != OnSuccessLoginUser) {
		// userType = OnSuccessLoginUser.getUserType();
		// Log.e("userType", "userType+" + userType);
		// if (userType.equals("2")) {
		// Intent intent = new Intent(pContext, nuclearLogin.class);
		// intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		// intent.putExtra("KEY_POSITION", 2);
		// nuclearLogin.showRegister = false;
		// pContext.startActivity(intent);
		//
		// } else {
		// Intent intent = new Intent(pContext, nuclearControlCenter.class);
		// intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		// nuclearLogin.showRegister = true;
		// intent.putExtra("KEY_POSITION", 1);
		// nuclearControlCenter.mCallBack = pCallbacklisten;
		// nuclearControlCenter.setFromContext(pContext);
		// pContext.startActivity(intent);
		// }
		// }
	}

	interface LoginCallback {
		public void onSuccess();

		public void onFailed();
	}

	public void facebookLogin(String uid, String nickName, String token,
			Activity pAcitivity) throws JSONException {
		Token tokenfb = new Token();
		tokenfb.setUid(uid);
		tokenfb.setAccessToken(token);

		JSONObject message = new JSONObject();
		JSONObject data = new JSONObject();
		data.put("thirdId", tokenfb.getUid());
		data.put("nickName", nickName);
		data.put("platform", SdkConfig.THIRD_PLATFORM.FACKBOOK.ordinal());
		data.put("channel", SdkCommplatform.channelName);
		message.put("data", data);
		message.put("header", Utils.makeHead(pAcitivity));
		thirdLogin_fb_gg(message.toString(), pAcitivity);

	}

	public void thirdLogin_fb_gg(String message, final Activity pActivity) {

		SdkApi.thirdLogin(message, new RequestListener() {

			@Override
			public void onIOException(IOException e) {

				pActivity.runOnUiThread(new Runnable() {

					@Override
					public void run() {
						Toast.makeText(pActivity, R.string.loginfail,
								Toast.LENGTH_SHORT).show();
					}
				});

			}

			@Override
			public void onError(SdkException e) {
				pActivity.runOnUiThread(new Runnable() {
					@Override
					public void run() {
						Toast.makeText(pActivity, R.string.loginfail,
								Toast.LENGTH_SHORT).show();
					}
				});
			}

			@Override
			public void onComplete(String response) {
				JSONObject jsonback = null;
				String error = null;
				String nuclearId = null;
				String username = null;
				String password = null;
				try {
					jsonback = new JSONObject(response);
					error = jsonback.getString("error");
					if (error.equals(SdkConfig.statuCode)) {
						SdkUser nuclearuser = new SdkUser();
						nuclearId = jsonback.getJSONObject("data").getString(
								"nuclearId");
						username = jsonback.getJSONObject("data").getString(
								"nuclearName");
						password = jsonback.getJSONObject("data").getString(
								"password");
						nuclearuser.setUserType("1");

						nuclearuser.setIsLocalLogout("0");
						nuclearuser.setUsername(username);
						jsonback.put("username", username);
						nuclearuser.setUidStr(nuclearId);
						final String backjsontosdk = jsonback.toString();

						if (!password.equals("") && password != null) {
							nuclearuser.setPassword(password);
							nuclearuser.setIsFirstThird("1");
							SdkCommplatform.getInstance().setThirdLoginUser(
									nuclearuser);
							SdkCommplatform.getInstance().setLoginUser(
									nuclearuser);
							SdkControlCenter.thirdLoginFirst = true;
						} else {
							SdkControlCenter.thirdLoginFirst = false;

							SdkCommplatform.getInstance().setLoginUser(
									nuclearuser);
							SdkCommplatform.getInstance().setThirdLoginUser(
									nuclearuser);
						}
						pActivity.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								LayoutInflater inflater = LayoutInflater
										.from(pActivity);
								View view = inflater
										.inflate(
												R.layout.ya_toast,
												(ViewGroup) pActivity
														.findViewById(R.id.toast_layout_root));
								TextView textView = (TextView) view
										.findViewById(R.id.welcome);
								textView.setText(SdkCommplatform.getInstance()
										.getLoginNickName()
										+ ","
										+ pActivity.getString(R.string.welcome)
										+ " ！");
								Toast toast = new Toast(pActivity);
								toast.setDuration(Toast.LENGTH_LONG);
								toast.setView(view);
								toast.setGravity(Gravity.TOP, Gravity.CENTER,
										50);
								toast.show();
								SdkCommplatform.getInstance().OnSuccesBackJsonStr = backjsontosdk;
								SdkLogin.listener.onLoginSuccess(backjsontosdk);
								SdkCommplatform.getInstance().finish();
							}
						});
					} else {
						final String errorMessage = jsonback
								.getString("errorMessage");

						pActivity.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								SdkLogin.listener.onLoginError(new SdkError(
										errorMessage));
								Toast.makeText(
										pActivity,
										pActivity.getString(R.string.loginfail)
												+ ":" + errorMessage,
										Toast.LENGTH_SHORT).show();
							}
						});

					}

				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});
	}

	public void setNuclearBind(BindCallback pBindCallback) {
		mBindCallback = pBindCallback;
	}

	private BindCallback mBindCallback;
	private PlusClient mPlusClient;
	private ConnectionResult mConnectionResult;
	private ProgressDialog mConnectionProgressDialog;
	private Account[] mAccounts;

	protected void notifyBind(boolean pResult) {
		if (!initOk)
			return;

		if (pResult) {
			if (mBindCallback != null) {
				mBindCallback.onBindSuccess();
				new AlertDialog.Builder(mAppInfo.getCtx())
						.setTitle(R.string.warning)
						.setMessage(R.string.bindsuccess)
						.setPositiveButton(R.string.ensure, null).show();
			}
		}
	}

	public void finish() {
		for (Activity activity : activityList) {
			activity.finish();
		}
	}

	public void addActivity(Activity activity) {
		activityList.add(activity);
	}

	public void googleLogin(final Activity activity) {
		int available = GooglePlayServicesUtil
				.isGooglePlayServicesAvailable(activity);
		if (available != ConnectionResult.SUCCESS) {
			activity.showDialog(1);
			return;
		}
		if (mConnectionResult == null) {
			mPlusClient.connect();
			mConnectionProgressDialog.show();
		} else {
			try {
				mConnectionResult.startResolutionForResult(activity,
						REQUEST_CODE_RESOLVE_ERR);
			} catch (SendIntentException e) {
				// 重新尝试连接。
				mConnectionResult = null;
				mPlusClient.connect();
			}
		}
	}

	public void facebookLogin(final Activity game_ctx) {
		Bundle savedInstanceState = game_ctx.getIntent().getExtras();
		Session session = Session.getActiveSession();
		// session.close();session = Session.getActiveSession();
		StatusCallback statusCallback = new StatusCallback() {
			@Override
			public void call(final Session session, SessionState state,
					Exception exception) {

				if (session.isOpened()) {
					final String getUidUrl = mFbGetUrl
							+ session.getAccessToken();
					new Thread(new Runnable() {

						@Override
						public void run() {
							HttpClient client = HttpClientHelper
									.getHttpClient();
							HttpGet geter = new HttpGet(getUidUrl);
							String result = "";
							HttpResponse httpResponse = null;
							try {
								httpResponse = client.execute(geter);
								int statusCode = httpResponse.getStatusLine()
										.getStatusCode();

								if (statusCode == 200) {
									result = EntityUtils.toString(httpResponse
											.getEntity());
									JSONObject jsonResult = new JSONObject(
											result);
									String uid = jsonResult.optString("id");
									String name = jsonResult.optString("name");
									Log.e("name", name);
									SdkCommplatform.getInstance()
											.facebookLogin(uid, name,
													session.getAccessToken(),
													game_ctx);
									SdkCommplatform.getInstance().finish();
								} else {

									game_ctx.runOnUiThread(new Runnable() {

										@Override
										public void run() {
											Toast.makeText(game_ctx,
													R.string.loginfail,
													Toast.LENGTH_SHORT).show();
										}
									});

								}
							} catch (Exception e) {
								e.printStackTrace();
							}

						}
					}).start();

				} else {
				}

			}
		};
		if (session == null) {
			if (savedInstanceState != null) {
				session = Session.restoreSession(game_ctx, null,
						statusCallback, savedInstanceState);
			}
			if (session == null) {
				session = new Session(game_ctx);
			}
			Session.setActiveSession(session);
			if (session.getState().equals(SessionState.CREATED_TOKEN_LOADED)) {
				session.openForRead(new Session.OpenRequest(game_ctx)
						.setCallback(statusCallback));
			}
		}

		session = Session.getActiveSession();
		if (!session.isOpened()) {
			if (!session.isOpened() && !session.isClosed()) {
				session.openForRead(new Session.OpenRequest(game_ctx)
						.setCallback(statusCallback));
				Log.i("session ", session.getState().name());
			} else {
				Session.openActiveSession(game_ctx, true, statusCallback);
				Log.i("session ", session.getState().name());
			}

		} else {
			Session.openActiveSession(game_ctx, true, statusCallback);
		}

	}

	private static final int REQUEST_CODE_SIGN_IN = 1;
	private static final int REQUEST_CODE_GET_GOOGLE_PLAY_SERVICES = 2;

	public void onActivityResult(Activity activity, int requestCode,
			int resultCode, Intent data) {
		Session session = Session.getActiveSession();
		if (session != null) {
			session.onActivityResult(activity, requestCode, resultCode, data);
		}
		// if (requestCode == REQUEST_CODE_SIGN_IN
		// || requestCode == REQUEST_CODE_GET_GOOGLE_PLAY_SERVICES) {
		// if (resultCode == Activity.RESULT_OK && !mPlusClient.isConnected()
		// && !mPlusClient.isConnecting()) {
		// mPlusClient.connect();
		// }
		// }

		if (requestCode == REQUEST_CODE_RESOLVE_ERR
				&& resultCode == Activity.RESULT_OK) {
			mConnectionResult = null;
			mPlusClient.connect();
		}

	}

	public void callOnCreate(final Activity activity) {
		mPlusClient = new PlusClient.Builder(activity,
				new ConnectionCallbacks() {

					@Override
					public void onDisconnected() {

					}

					@Override
					public void onConnected(Bundle arg0) {
						mConnectionProgressDialog.dismiss();
						String accountName = mPlusClient.getAccountName();

						Person currentPerson = mPlusClient.getCurrentPerson();
						String id = currentPerson.getId();
						String name = currentPerson.getDisplayName();

						googleLogin(id, name, activity);
						// mPlusClient.loadPeople(new OnPeopleLoadedListener() {
						//
						// @Override
						// public void onPeopleLoaded(ConnectionResult status,
						// PersonBuffer person,
						// String arg2) {
						// System.out.println(person);
						//
						// }
						// }, "me");
					}

				}, new OnConnectionFailedListener() {

					@Override
					public void onConnectionFailed(ConnectionResult result) {
						mConnectionProgressDialog.dismiss();
						if (result.hasResolution()) {
							try {
								result.startResolutionForResult(activity,
										REQUEST_CODE_RESOLVE_ERR);
							} catch (SendIntentException e) {
								mPlusClient.connect();
							}
						}
						// 在用户点击时保存结果并解决连接故障。
						mConnectionResult = result;

					}
				}).setActions("http://schemas.google.com/AddActivity",
				"http://schemas.google.com/BuyActivity").build();

		mConnectionProgressDialog = new ProgressDialog(activity);
		mConnectionProgressDialog.setMessage("Signing in...");
	}

	public void callOnStart() {
		mPlusClient.connect();
	}

	public void callOnStop() {
		mPlusClient.disconnect();
	}

	public CallbackListener getMUserCallback() {
		return mUserCallback;
	}

	public void doTryUserLogin() {

	}

	private void googleLogin(String uId, String name, Activity activity) {

		JSONObject message = new JSONObject();
		JSONObject data = new JSONObject();
		try {
			data.put("thirdId", uId);
			data.put("nickName", name);
			data.put("platform", SdkConfig.THIRD_PLATFORM.GOOGLE.ordinal());
			data.put("channel", SdkCommplatform.channelName);
			message.put("data", data);
			message.put("header", Utils.makeHead(activity));
			thirdLogin_fb_gg(message.toString(), activity);
		} catch (Exception e) {
		}

	}
}
