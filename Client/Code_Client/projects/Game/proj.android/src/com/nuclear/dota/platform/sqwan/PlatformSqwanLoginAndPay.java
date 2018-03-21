package com.nuclear.dota.platform.sqwan;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.cyouwanwan.sdk.GameLib;
import com.cyouwanwan.sdk.callback.LoginCallback;
import com.cyouwanwan.sdk.callback.LogoutCallback;
import com.cyouwanwan.sdk.callback.PayCallback;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.FeedBackDialog;
import com.nuclear.dota.LastLoginHelp;
import com.nuclear.dota.Config;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;

public class PlatformSqwanLoginAndPay implements IPlatformLoginAndPay {

	
private static final String TAG = PlatformSqwanLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	private int 						auto_recalllogin_count = 0;
	private boolean isLogined = false;
	private static String Tag = PlatformSqwanLoginAndPay.class.getSimpleName();
	private final int LOGINSUCCESED = 901;
	private final int LOGINFAILED = 902;
	private final int LOGININVALID = 903;
	private final int LOGININETERR = 904;
	private final int LOGINCANCEL = 905;
	private Thread loginThread;
	private String userToken = "";
	private String userName = "";
	
	private Handler mLoginHandler = new Handler(){
		public void dispatchMessage(Message msg) {
			switch (msg.what) {
			case LOGINSUCCESED:
				Toast.makeText(game_ctx, "登录成功", Toast.LENGTH_SHORT).show();
				break;
			case LOGINFAILED:
				Toast.makeText(game_ctx, "登录失败", Toast.LENGTH_SHORT).show();
				break;
			case LOGININVALID:
				Toast.makeText(game_ctx, "登录失败", Toast.LENGTH_SHORT).show();
				break;
			case LOGINCANCEL:
				Toast.makeText(game_ctx, "登录取消", Toast.LENGTH_SHORT).show();
				break;
			case LOGININETERR:
				Toast.makeText(game_ctx, "网络请求失败，请重新登录", Toast.LENGTH_SHORT).show();
				break;
			}
		};
	};
	
	private static PlatformSqwanLoginAndPay sInstance = null;
	public static PlatformSqwanLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformSqwanLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformSqwanLoginAndPay() {
		
	}
	@Override
	public void onLoginGame() {
			// TODO Auto-generated method stub
			
		}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		
		 /**
		   * 初始化SDK，设置游戏在字符无平台上注册时得到的id和私密串 需要在app启动时进行设定，并且只能调用一次，多次调用将会 引发异常。
		   * @param context 应用的上下文Context对象，不可使用getApplicationContext()获取
		   * @param gameId 游戏在平台上分配的唯一标识
		   * @param gameSecret 游戏平台给游戏分配的一个私密字符串， 只有游戏开发商和平台知道，用于通信加密校验
		   * @param vendorName 开发商名称,最好是英文字母,否则会因为编码问题产生乱码
		   * @param distributionChannel 渠道名称 
		   * @throws IllegalStateException 多次调用会抛出此异常
		   */

		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Sqwan;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_Sqwan;
		this.game_info = game_info;
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		
		gameId = String.valueOf(game_info.app_id);
		gameSecret = game_info.app_secret;
		vendor = "com4loves";
		
		GameLib.initialize(gameId,gameSecret,vendor,"4");
		
		
		
		//
		mCallback1.notifyInitPlatformSDKComplete();
		//
		
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		// TODO Auto-generated method stub

		this.mCallback1 = callback1;
		
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		// TODO Auto-generated method stub
		this.mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		// TODO Auto-generated method stub
		this.mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		// TODO Auto-generated method stub
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		mGameActivity = null;
		mCallback1 = null;
		mCallback2 = null;
		mCallback3 = null;
		//
		this.game_ctx = null;
		this.game_info = null;
		this.login_info = null;
		this.version_info = null;
		this.pay_info = null;

	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	private MyLoginCallback LoginResultBack;
	@Override
	public void callLogin() {
		
		LoginResultBack = new MyLoginCallback(){

			@Override
			public void onSuccess(String pBackJson) {
			LoginInfo login_info = new LoginInfo();	
			isLogined = false;
			
			JSONObject jsonOBJ = null;
			try {
				jsonOBJ = new JSONObject(pBackJson);
				login_info =  new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
				notifyLoginResult(login_info);
			} catch (JSONException e) {
				mLoginHandler.sendEmptyMessage(LOGININETERR);
				return;
			}
			String uid = jsonOBJ.optString("usergameid");
			
			
			String code = jsonOBJ.optString("errcode");
			if(null!=code&&!code.equals("")){
				 if(code.equals("1000")){
					 mLoginHandler.sendEmptyMessage(LOGINFAILED);
					 GameLib.getInstance(game_ctx).logout(new LogoutCallback() {
							
							@Override
							public void onLogoutSuccess() {
								callLogin();
							}
						});
				 }else if(code.equals("1001")){
					 mLoginHandler.sendEmptyMessage(LOGINFAILED);
					 login_info =  new LoginInfo();
					 login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;	
					 notifyLoginResult(login_info);
				 }else if(code.equals("1002")){
					 
					 GameLib.getInstance(game_ctx).logout(new LogoutCallback() {
						
						@Override
						public void onLogoutSuccess() {
							callLogin();
						}
					});
				 }
				
			}
			if(null==uid||uid.equals("")){
				login_info =  new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;	
				notifyLoginResult(login_info);
			}else{
				login_info.account_uid_str =  uid ;
				isLogined = true;
				login_info.account_nick_name = "帐号切换";
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				notifyLoginResult(login_info);
			}
			mCallback3.showWaitingViewImp(false, -1, "已经登录过");
		 
			}

			@Override
			public void onFailed(String pErr) {
				Log.i(Tag, "onSuccess" + pErr);
			}
			 
		 };
		 
		if(isLogined){
			return;
		}
		
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		 
		if(GameLib.getInstance(game_ctx).isLogined){
			PlatformSqwanLoginAndPay.this.userToken = GameLib.getInstance(game_ctx).token;
       	 if(null!=loginThread){
   			 Log.i("status:", "status:"+loginThread.getState());
   			 if(loginThread.isInterrupted()){
   				  
   			 }else if(Thread.State.TERMINATED==loginThread.getState()){
   				 loginThread = new Thread(loginRun);
   				 loginThread.start();
   			 }
   		 }else{
   			 loginThread = new Thread(loginRun);
   			 loginThread.start();
   		 }
		}
		
		GameLib.getInstance(game_ctx).login(new LoginCallback() {

		        @Override
		        public void onLoginSuccess(String tokenStr) {
		        	
					PlatformSqwanLoginAndPay.this.userToken = tokenStr;
		        	 if(null!=loginThread){
		    			 Log.i("status:", "status:"+loginThread.getState());
		    			 if(loginThread.isInterrupted()){
		    				  
		    			 }else if(Thread.State.TERMINATED==loginThread.getState()){
		    				 loginThread = new Thread(loginRun);
		    				 loginThread.start();
		    			 }
		    		 }else{
		    		 loginThread = new Thread(loginRun);
		    		 loginThread.start();
		    		 }
		        	 
		        }

		        @Override
		        public void onError() {
		        	mLoginHandler.sendEmptyMessage(LOGINFAILED);
		        	mCallback3.showWaitingViewImp(false, -1, "登录失败");
		        }

		        @Override
		        public void onCancel() {
		        	mLoginHandler.sendEmptyMessage(LOGINCANCEL);
		        	mCallback3.showWaitingViewImp(false, -1, "取消登录");
		        }
 
		      });
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {

			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Sqwan+login_info.account_uid_str;
			
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		return login_info;
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub
		 GameLib.getInstance(game_ctx).logout(new LogoutCallback() {

		        @Override
		        public void onLogoutSuccess() {
		           isLogined = false;
		        }

		      });
		 
		
	}

	@Override
	public void callCheckVersionUpate() {
		

	}

	@Override
	public void notifyVersionUpateInfo(VersionInfo version_info) {
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			mLoginHandler.sendEmptyMessage(LOGINSUCCESED);
			mCallback2.notifyVersionCheckResult(version_info);
		}
	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		// TODO Auto-generated method stub
		pay_info.order_serial = generateNewOrderSerial();
		
		
		
		
		/**
		 * productId :道具ID
		 * productName:道具名称
		 * priceText : 道具价格(单价),此价格为厂商和平台约定的价格,如果错误,会支付失败,此DEMO 写的是1改为别的值可能发生错误
		 * quantityText : 购买道具数量
		 * orderId :订单ID ,注意,必须全局唯一,不能相同
		 */
		
		String extraInfo =  pay_info.description + "-" + pay_info.product_id+"-"+this.login_info.account_uid_str;
		pay_info.price = (int)pay_info.price*100;
		GameLib.getInstance(game_ctx).pay(pay_info.product_id,pay_info.product_name,(int)pay_info.price,1,extraInfo,new PayCallback() {

		    @Override
		    public void onPayError() {
		    	
		    }
		    @Override
		    public void onPayCancel() {
		    	
		    }
		    
		  });
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		if (!Cocos2dxHelper.nativeHasEnterMainFrame()&&isLogined)
		{
			 GameLib.getInstance(game_ctx).logout(new LogoutCallback() {

			        @Override
			        public void onLogoutSuccess() {
			           isLogined = false;
			           callLogin();
			        }

			      });
			
		}else if(!Cocos2dxHelper.nativeHasEnterMainFrame()&&!isLogined){
			callLogin();
		}

	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {
		// TODO Auto-generated method stub
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			String _url = Config.UrlFeedBack + "?puid="+LastLoginHelp.mPuid+"&gameId="+LastLoginHelp.mGameid
					 	+"&serverId="+LastLoginHelp.mServerID+"&playerId="+LastLoginHelp.mPlayerId+"&playerName="
					 	+LastLoginHelp.mPlayerName+"&vipLvl="+LastLoginHelp.mVipLvl+"&platformId="+LastLoginHelp.mPlatform;
			FeedBackDialog.getInstance(game_ctx, _url).show();
		}
	}

	@Override
	public void callPlatformSupportThirdShare(ShareInfo share_info) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void callPlatformGameBBS() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onGamePause() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onGameExit() {
		// TODO Auto-generated method stub
		GameLib.exit();
	}

	@Override
	public void callToolBar(boolean visible) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean isTryUser() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void callBindTryToOkUser() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
		
	}
	
	
	private Runnable loginRun = new Runnable() {
		
		

		@Override
		public void run() {
			/** 下面这些参数需要自己配置，此示例里写死*/
			
			apiName = "verifyUser";
			

			initRequest(gameId,gameSecret,vendor,apiName,userToken);
			String url = BASE_URL+apiName;//请求地址+接口名
			String backStr = "";
			try {
				backStr = sendPostRequest(url,params);
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			if(backStr.equals("")){
				LoginResultBack.onFailed("error");
			}else{
				LoginResultBack.onSuccess(backStr);
			}
		}
	};
	
	interface MyLoginCallback {
		public void onSuccess(String strUid);
		public void onFailed(String strUid);
	}
	
	
	
	
	
	/** 接口地址*/
	private static String BASE_URL = "http://gop.37wanwan.com/api/";
	/** 接口名字*/
	private static String apiName;
	/** 游戏在平台上分配的唯一标识*/
	private static String gameId;
	/** 游戏平台给游戏分配的一个私密字符串,只有游戏开发商和平台知道，用于通信加密校验 */
	private static String gameSecret;
	/** 开发商的名称*/
	private static String vendor;
	/** 时间戳 */
	private static String date;
	/** SDK版本*/
	private static String version = "1.0"; 
	/** 请求的集合*/
	private static HashMap<String, String> params = new HashMap<String, String>();
	
	

	/**
	 * 请求网络
	 * @param path url路径
	 * @param apiName 接口名字
	 * @param paramsMap 参数集合
	 * @return json字符串
	 * @throws Exception
	 */
	public static String sendPostRequest(String path,HashMap<String, String> paramsMap) throws Exception {
		URL url = new URL(path);
		HttpURLConnection conn = (HttpURLConnection) url.openConnection();
		conn.setRequestMethod("POST");
		conn.setConnectTimeout(5 * 1000);
		conn.setReadTimeout(9 * 1000);
		conn.setDoOutput(true);
		conn.setRequestProperty("Connection","Keep-Alive");
		conn.setRequestProperty("Content-Type","application/x-www-form-urlencoded; charset=UTF-8");
		// 设置请求头
		conn.setRequestProperty("Accept","application/json; version=" + version);
		/** 计算时间戳 */
		date = getDate();
		conn.setRequestProperty("Date",date);
		/** 设置请求头的参数不需要encode*/
		String headerParam = sortParams(paramsMap);
		conn.setRequestProperty("Authentication",getAuthentication(gameId,gameSecret,vendor,date,apiName,headerParam));
		/** 设置请求体参数需要encode */
		String bodyParam = sortEncoderParams(paramsMap);
		byte[] entitydata = bodyParam.getBytes();
		conn.setRequestProperty("Content-Length",String.valueOf(entitydata.length)); // 传递数据的长据
		conn.connect();
		OutputStream outStream = conn.getOutputStream();
		outStream.write(entitydata);
		outStream.flush();
		outStream.close();
		System.out.println("ResponseCode=" +conn.getResponseCode());
		if(conn.getResponseCode() != 200){
			System.out.println("connent failed !");
			conn.disconnect();
			return null;
		}else{
			String result = inputStream2String(conn.getInputStream());
			System.out.println("connent success !");
			System.out.println("result = " + result);
			conn.disconnect();
			return result;
		}
	}
	
	/**
	 * 初始化,填入你需要初始化的参数
	 * 
	 * @param id 游戏在平台上分配的唯一标识
	 * @param secret 游戏平台给游戏分配的一个私密字符串
	 * @param vendorName 开发商的名称
	 * @param api 接口名字
	 */
	private static void initRequest(String id, String secret, String vendorName, String api,String token) {
		gameId = id;
		gameSecret = secret;
		vendor = vendorName;
		apiName = api;
		/** 这里键值对 是根据你请求的参数来设置的,因为verifyUser 就一个参数"token" 所以就只写一个.*/
		params.put("token",token);
	}
	
	
    
    /**
     * 从输入流中读取数据
     * @param inStream
     * @return
     * @throws Exception
     */
    public static byte[] readInputStream(InputStream inStream) throws Exception{
        ByteArrayOutputStream outStream = new ByteArrayOutputStream();
        byte[] buffer = new byte[1024];
        int len = 0;
        while( (len = inStream.read(buffer)) !=-1 ){
            outStream.write(buffer, 0, len);
        }
        byte[] data = outStream.toByteArray();//网页的二进制数据
        outStream.close();
        inStream.close();
        return data;
    }
    
    
    /** 将输入流转变为字符串 */
	public static String inputStream2String(InputStream in) throws IOException {
		StringBuffer out = new StringBuffer();
		byte[] b = new byte[4096];
		for (int n; (n = in.read(b)) != -1;){
			out.append(new String(b,0,n));
		}
		String str = out.toString();
		return str;
	}
	/**
	 * 对参数进行排序
	 * @param params
	 * @return
	 */
	public static String sortParams(HashMap<String, String> params) {
		List<String> keys = new ArrayList<String>(params.keySet());
		Collections.sort(keys);
		String prestr = "";
		for (String key : keys){
			String value = params.get(key);
			prestr = prestr + key + "=" + value + "&";
		}
		prestr = prestr.substring(0,prestr.length() - 1);
		return prestr;
	}
	/**
	 * 对参数进行排序+encode
	 * @param params
	 * @return
	 * @throws UnsupportedEncodingException
	 */
	public static String sortEncoderParams(HashMap<String, String> params) throws UnsupportedEncodingException {
		List<String> keys = new ArrayList<String>(params.keySet());
		Collections.sort(keys);
		String prestr = "";
		for (String key : keys){
			String value = params.get(key);
			prestr = prestr + key + "=" + URLEncoder.encode(value,"utf-8") + "&";
		}
		prestr = prestr.substring(0,prestr.length() - 1);
		return prestr;
	}
	/**
	 * 生成时间戳
	 * @return
	 */
	public static String getDate() {
		SimpleDateFormat dfs = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss ",Locale.US);
		return dfs.format(new Date()).toString() + "GMT";
	}
	/**
	 * 计算授权号
	 * @param gameId
	 * @param gameSecret
	 * @param vendor
	 * @param date
	 * @param apiName
	 * @param params
	 * @return
	 */
	private static String getAuthentication(String gameId, String gameSecret, String vendor, String date, String apiName, String params) {
		String sign = getSign(date,apiName,params,gameSecret);
		String authentication = vendor + " " + gameId + ":" + sign;
		return authentication;
	}
	/**
	 * 计算签名
	 * @param date
	 * @param apiName
	 * @param params
	 * @param gameSecret
	 * @return
	 */
	private static String getSign(String date, String apiName, String params, String gameSecret) {
		String str = date + ":" + apiName + ":" + params + ":" + gameSecret;
		return md5(str);
	}
	/**
	 * MD5编码
	 * @param data
	 * @return
	 */
	public static String md5(String data) {
		try{
			MessageDigest md = MessageDigest.getInstance("md5");
			md.update(data.getBytes());
			byte[] digest = md.digest();
			StringBuilder sb = new StringBuilder();
			for (byte b : digest){
				sb.append(String.format("%02x",b & 0xFF));
			}
			return sb.toString();
		}catch(Exception e){
			return "";
		}
	}
	
	
}
