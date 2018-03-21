
/*
 * utf-8 encoding
 * */

package com.nuclear.dota.platform.mi;

import java.util.UUID;
import javax.crypto.Mac;
import javax.crypto.SecretKey;
import javax.crypto.spec.SecretKeySpec;
import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.net.Uri;
import android.content.Intent;
import android.widget.Toast;

import java.io.IOException;
import java.io.UnsupportedEncodingException;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import com.xiaomi.gamecenter.sdk.MiCommplatform;
import com.xiaomi.gamecenter.sdk.MiErrorCode;
import com.xiaomi.gamecenter.sdk.MiSdkAction;
import com.xiaomi.gamecenter.sdk.OnLoginProcessListener;
import com.xiaomi.gamecenter.sdk.OnPayProcessListener;
import com.xiaomi.gamecenter.sdk.entry.MiAccountInfo;
import com.xiaomi.gamecenter.sdk.entry.MiAppInfo;
import com.xiaomi.gamecenter.sdk.entry.ScreenOrientation;
import com.xiaomi.gamecenter.sdk.entry.MiBuyInfo;

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



public class PlatformXiaoMiLoginAndPay implements IPlatformLoginAndPay {
	
	private static final String TAG = PlatformXiaoMiLoginAndPay.class.getSimpleName();
	
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
	private boolean						is_logined = false;
	private String						APPID;
	private static MiAccountInfo _currMiAccountInfo;
	
	private static PlatformXiaoMiLoginAndPay sInstance = null;
	public static PlatformXiaoMiLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformXiaoMiLoginAndPay();
			_currMiAccountInfo = null;
		}
		return sInstance;
	}
	
	private PlatformXiaoMiLoginAndPay() {
		
	}
	
	public int getPlatformLogoLayoutId()
	{
		return -1;
	}

	@Override
	public void onLoginGame() {
		
	}
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		APPID = game_info.app_id_str;
		/**SDK初始化*/
		MiAppInfo appInfo = new MiAppInfo();
		appInfo.setAppId(APPID);
		appInfo.setAppKey(game_info.app_key);
		appInfo.setOrientation( ScreenOrientation.vertical ); //横竖屏
		MiCommplatform.Init(game_ctx, appInfo);

		mCallback1.notifyInitPlatformSDKComplete();
	}

	@Override
	public void unInit() {
		
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

		//
		PlatformXiaoMiLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		
		return this.game_info;
	}

	private OnLoginProcessListener loginListener = new OnLoginProcessListener()
	{
		@Override
		public void finishLoginProcess(int code, MiAccountInfo arg1) {
			// TODO Auto-generated method stub
	
			mCallback3.showWaitingViewImp(true, -1, "正在登录");
			String tip = "";
			switch( code )
			{
			case MiErrorCode.MI_XIAOMI_GAMECENTER_SUCCESS:
				tip = "登录成功，点击进入游戏";
				_currMiAccountInfo=arg1;
				// 登陆成功
				//获取用户的登陆后的UID（即用户唯一标识）
				//获取用户的登陆的Session（请参考4.2.3.3 流程校验Session 有效性）
				//请开发者完成将uid 和session 提交给开发者自己服务器进行session 验证
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = arg1.getSessionId();
				login_info.account_uid_str = String.valueOf(arg1.getUid());
				login_info.account_uid = arg1.getUid();
				login_info.account_nick_name = arg1.getNikename();
				
				String signText = "appId=" + game_info.app_id + "&session=" + login_info.login_session + 
						"&uid=" + login_info.account_uid;
				HmacSHA1Encryption hmacSHA1Encryption = new HmacSHA1Encryption();
				final String UID_URL = "http://mis.migc.xiaomi.com/api/biz/service/verifySession.do";//验证sid
				String getURL = "";
				try{
					getURL = UID_URL + "?appId" + game_info.app_id_str + "&session" + login_info.login_session + 
							"&uid" + login_info.account_uid + "&signature" + 
							hmacSHA1Encryption.HmacSHA1Encrypt(signText, "r5FcFBXYztN8mBbO4+F8rg=");
				} catch (Exception e){
					
				}
				HttpClient client = new DefaultHttpClient();
				HttpGet get = new HttpGet(getURL);

	            try {
					HttpResponse httpResponse = client.execute(get);
					if(httpResponse.getStatusLine().getStatusCode() == 200)
					{ 
		            	String resultStr = EntityUtils.toString(httpResponse.getEntity());
		            	JSONObject jsonResult = new JSONObject(resultStr);
		            	PlatformXiaoMiLoginAndPay.getInstance().notifyLoginResult(login_info);	
		            } else {
		            	tip = "验证失败";
		            }	
				} catch (UnsupportedEncodingException e) {
					tip = "验证失败";
				} catch (ClientProtocolException e) {
					tip = "验证失败";
				} catch (IOException e) {
					tip = "验证失败";
				} catch (JSONException e) {
					tip = "验证失败";
				}   
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_LOGIN_FAIL:
				tip = "小米登录失败，错误代码：" + code;
				tip = tip + "，正在重试，请稍后";
				if (PlatformXiaoMiLoginAndPay.getInstance().auto_recalllogin_count < 5) {
					PlatformXiaoMiLoginAndPay.getInstance().auto_recalllogin_count++;
					
					try {
						Thread.sleep(2000);//非主线程(各个SDK不一)
					} catch (InterruptedException e) {
						//
						e.printStackTrace();
					}
						PlatformXiaoMiLoginAndPay.getInstance().callLogin();
				}
				else {
					tip = "小米登录失败，请检查手机网络，并重新启动游戏";
					
				}
				_currMiAccountInfo=null;
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_CANCEL:
				// 取消登录
				tip = "取消登录";
				
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_ACTION_EXECUTED:
				//登录操作正在进行中
				tip = "登录操作正在进行中";
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_LOGINOUT_SUCCESS:
				//注销成功
				tip = "注销成功";
				_currMiAccountInfo=null;
				break;
			case MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_LOGINOUT_FAIL:
				//注销失败
				tip = "注销失败";
				break;
			default:
				// 登录失败
				tip = "登录失败";
				_currMiAccountInfo=null;
				break;
			}
			
			mGameActivity.showToastMsg(tip);
			mCallback3.showWaitingViewImp(false, -1, "");
		}
	};

	@Override
	public void callLogin() {
		
		Log.d(TAG, "MiCommplatform.getInstance().miLogin");
		
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		MiCommplatform.getInstance().miLogin( this.game_ctx, loginListener);
		mCallback3.showWaitingViewImp(false, -1, "正在登录");
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			is_logined = true;
			
			login_result.account_uid_str = PlatformAndGameInfo.enPlatformShort_XiaoMi + login_result.account_uid_str;
			
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		
		if (login_info != null) {
			if(_currMiAccountInfo!=null)
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			else
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}
		
		return login_info;
	}

	@Override
	public void callLogout() {

		is_logined = false;
		
		MiCommplatform.getInstance().miLogout(loginListener);
	}

	@Override
	public void callCheckVersionUpate() {
		
		
	}

	@Override
	public void notifyVersionUpateInfo(VersionInfo version_info) {
		
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			
			mCallback2.notifyVersionCheckResult(version_info);
		}
		
	}

	private OnPayProcessListener payListener = new OnPayProcessListener()
	{
		@Override
		public void finishPayProcess(int arg0) {
			if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_SUCCESS )// 成功
			{
				mGameActivity.showToastMsg("购买成功");
			}
			else if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_CANCEL 
					|| arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_PAY_CANCEL )// 取消
			{
				mGameActivity.showToastMsg("取消购买");
			}
			else if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_PAY_FAILURE )// 失败
			{
				mGameActivity.showToastMsg("购买失败");
			}
			else if ( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_ACTION_EXECUTED )
			{
				mGameActivity.showToastMsg("正在购买，不要重复操作");
			}
			else if( arg0 == MiErrorCode.MI_XIAOMI_GAMECENTER_ERROR_LOGIN_FAIL )
			{
				mGameActivity.showToastMsg("您还没有登陆，请先登录");
			}
			PlatformXiaoMiLoginAndPay.getInstance().pay_info.result = arg0;
			PlatformXiaoMiLoginAndPay.getInstance()
				.notifyPayRechargeRequestResult(PlatformXiaoMiLoginAndPay.getInstance().pay_info);
		}
	};
	
	@Override
	public int callPayRecharge(PayInfo pay_info) {
		this.pay_info = null;
		this.pay_info = pay_info;
		
		MiBuyInfo miBuyInfo = new MiBuyInfo();
		miBuyInfo.setCpOrderId(pay_info.order_serial);
		miBuyInfo.setCpUserInfo(pay_info.description + "-" + pay_info.product_id);
		miBuyInfo.setAmount((int)(pay_info.price));	
		
		try
		{
			MiCommplatform.getInstance().miUniPay(game_ctx, miBuyInfo, payListener);
		}
		catch ( Exception e )
		{
			e.printStackTrace();
		}
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		
		mCallback3.notifyPayRechargeResult(pay_info);
		//
	}
	
	@Override
	public void callAccountManage() {
		
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			mGameActivity.showToastMsg("暂未开通,敬请期待!");
			return;
		}
		if (is_logined)
		//callLogout();
		callLogin();
	}

	@Override
	public String generateNewOrderSerial() {
		
		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {
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
		
		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}
		
	}
	
	@Override
	public void callPlatformGameBBS() {
		/*Intent intent = new Intent();        
		intent.setAction("android.intent.action.VIEW");    
		Uri content_url = Uri.parse("http://igame.xiaomi.com/forum.php?mod=forumdisplay&fid=73");
		intent.setData(content_url);  
		game_ctx.startActivity(intent);*/
		
		//需判断入口是否可用 
		final  boolean canOpen = MiCommplatform.getInstance().canOpenEntrancePage(); 
		if(canOpen) 
		{   //入口可用，打开界面 
		    Intent intent = new Intent(); 
		    intent.setAction( MiSdkAction.SDK_ACTION_ENTRANCE ); 
		    game_ctx.startActivity( intent ); 
		} 
		else
		{ 	
			Intent intent = new Intent();        
			intent.setAction("android.intent.action.VIEW");    
			Uri content_url = Uri.parse("http://igame.xiaomi.com/forum.php?mod=forumdisplay&fid=73");
			intent.setData(content_url);  
			game_ctx.startActivity(intent);
		}
		          
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1)
	{
		
		mCallback1 = callback1;
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2)
	{
		
		mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3)
	{
		
		mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate()
	{

		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public void onGameExit()
	{
		callLogout();
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
	public boolean isTryUser() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void callToolBar(boolean visible) {
		// TODO Auto-generated method stub
		
	}

	
	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
		
	}
	@Override
	public void callBindTryToOkUser() {
		// TODO Auto-generated method stub
		
	}

	public class HmacSHA1Encryption {
		private static final String MAC_NAME = "HmacSHA1";
		private static final String ENCODING = "UTF-8";
		/**
		 * 使用 HMAC-SHA1 签名方法对对encryptText进行签名
		 * @param encryptText 被签名的字符串
		 * @param encryptKey 密钥
		 * @return 返回被加密后的字符串
		 * @throws Exception
		 */
		public String HmacSHA1Encrypt( String encryptText, String encryptKey ) throws Exception{
			byte[] data = encryptKey.getBytes( ENCODING );
			// 根据给定的字节数组构造一个密钥,第二参数指定一个密钥算法的名称
			SecretKey secretKey = new SecretKeySpec( data, MAC_NAME );
				// 生成一个指定 Mac 算法 的 Mac 对象
			Mac mac = Mac.getInstance( MAC_NAME );
			// 用给定密钥初始化 Mac 对象
			mac.init( secretKey );
			byte[] text = encryptText.getBytes( ENCODING );
			// 完成 Mac 操作
			byte[] digest = mac.doFinal( text );
			StringBuilder sBuilder = bytesToHexString( digest );
			return sBuilder.toString();
		}


		/**
		 * 转换成Hex
		 * 
		 * @param bytesArray
		 */
		public StringBuilder bytesToHexString( byte[] bytesArray ){
			if ( bytesArray == null ){
				return null;
			}
			StringBuilder sBuilder = new StringBuilder();
			for ( byte b : bytesArray ){
				String hv = String.format("%02x", b);
				sBuilder.append( hv );
			}
			return sBuilder;
		}

		/**
		 * 使用 HMAC-SHA1 签名方法对对encryptText进行签名
		 * 
		 * @param encryptData 被签名的字符串
		 * @param encryptKey 密钥
		 * @return 返回被加密后的字符串
		 * @throws Exception
		 */
		public String hmacSHA1Encrypt( byte[] encryptData, String encryptKey ) throws Exception{
			byte[] data = encryptKey.getBytes( ENCODING );
				// 根据给定的字节数组构造一个密钥,第二参数指定一个密钥算法的名称
			SecretKey secretKey = new SecretKeySpec( data, MAC_NAME );
				// 生成一个指定 Mac 算法 的 Mac 对象
			Mac mac = Mac.getInstance( MAC_NAME );
				// 用给定密钥初始化 Mac 对象
			mac.init( secretKey );
				// 完成 Mac 操作
			byte[] digest = mac.doFinal( encryptData );
			StringBuilder sBuilder = bytesToHexString( digest );
			return sBuilder.toString();
		}
	}

}
