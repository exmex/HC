package com.nuclear.dota.platform.punchbox;

import java.util.UUID;

import joy.JoyCallback;
import joy.JoyGL;
import joy.JoyInterface;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.CountDownTimer;
import android.util.Log;
import android.widget.Toast;

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
import com.qsds.ggg.dfgdfg.fvfvf.R;
public class PlatformChuKongLoginAndPay implements IPlatformLoginAndPay {

	public static final String TAG = PlatformChuKongLoginAndPay.class.getSimpleName();
	
	private IGameActivity                         mGameActivity;
	private IPlatformSDKStateCallback             mCallback1;
	private IGameUpdateStateCallback              mCallback2;
	private IGameAppStateCallback                 mCallback3;
	
	private Activity                              game_ctx = null;
	private GameInfo                              game_info = null;
	private LoginInfo                             login_info = null;
	private VersionInfo                           version_info = null;
	private PayInfo                               pay_info = null;
	private boolean                               isLogin = false;
	
	private JoyGL								  joyGL = null;

	private MyCount myCount;
	
	private static PlatformChuKongLoginAndPay   sInstance = null;
	public static PlatformChuKongLoginAndPay getInstance()
	{
		if(sInstance == null)
		{
			sInstance = new PlatformChuKongLoginAndPay();
		}
		return sInstance;
	}
	
	@Override
	public void onLoginGame() {
		
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		this.mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_ChuKong;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_ChuKong;
		
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
	}
	
	/*
	 * 最早调用
	 * */
	protected void initChuKong(JoyGL gl)
	{
		joyGL = gl;
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		// TODO Auto-generated method stub
		mCallback1 = callback1;
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		// TODO Auto-generated method stub
		mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		// TODO Auto-generated method stub
		mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		// TODO Auto-generated method stub
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return 0;//R.layout.logo_chukong;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		JoyInterface.onDestroy();
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}
	
	class LoginCallback implements JoyCallback {

		public void onCallback(String jsonStr) {
			Log.e(TAG, "login callback...");
			Log.e(TAG, "jsonStr:" + jsonStr);
			JSONObject jsonObject;
			try {
				jsonObject = new JSONObject(jsonStr);
				if(jsonObject!=null)
				{
					if(jsonObject.optInt("state")==1){
						JSONObject data = jsonObject.optJSONObject("data");
						if(data!=null)
						{
							final LoginInfo login_info = new LoginInfo();
							login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
							login_info.login_session = data.optString("tkn");
							login_info.account_uid_str = data.optString("coco");
							login_info.account_nick_name = data.optString("un");
							TokenInfoTask.GETTOKEN = game_info.app_secret;
							TokenInfoTask.doRequest(game_ctx, login_info.login_session, PlatformChuKongLoginAndPay.this.game_info.app_id_str, 
									PlatformChuKongLoginAndPay.this.game_info.app_key,	new TokenInfoListener() {
								
								@Override
								public void onGotError(String error) {
											// TODO Auto-generated method stub
									final LoginInfo login_info = new LoginInfo();
									login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
									PlatformChuKongLoginAndPay.this.isLogin = false; 
								
									game_ctx.runOnUiThread(new Runnable() {
										@Override
										public void run() {
											Toast.makeText(game_ctx, "验证失败,请重新登录", Toast.LENGTH_SHORT).show();
											PlatformChuKongLoginAndPay.getInstance().notifyLoginResult(login_info);
										}
									});
										}
								
								@Override
								public void onGotTokenInfo(String tokenInfo) {
									if(tokenInfo==null)
									{	
										game_ctx.runOnUiThread(new Runnable() {
											@Override
											public void run() {
												 		Toast.makeText(game_ctx, "验证失败,请重新登录", Toast.LENGTH_SHORT).show();
														login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
														PlatformChuKongLoginAndPay.this.isLogin = false;
														PlatformChuKongLoginAndPay.getInstance().notifyLoginResult(login_info);
														return;
											}
											});
										
									}else{
									
									JSONObject jsonObject = null;
									try {
										jsonObject = new JSONObject(tokenInfo);
									} catch (JSONException e) {
										e.printStackTrace();
									}
										if(jsonObject.optString("access_token") != null&&login_info.account_uid_str.equals(jsonObject.optString("coco"))){
											login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
											PlatformChuKongLoginAndPay.this.isLogin = true; 
										
											game_ctx.runOnUiThread(new Runnable() {
												@Override
												public void run() {
													PlatformChuKongLoginAndPay.getInstance().notifyLoginResult(login_info);
												}
											});
										}else{
												final LoginInfo login_info = new LoginInfo();
												login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
												PlatformChuKongLoginAndPay.this.isLogin = false; 
											
												game_ctx.runOnUiThread(new Runnable() {
													@Override
													public void run() {
														Toast.makeText(game_ctx, "验证失败,请重新登录", Toast.LENGTH_SHORT).show();
														PlatformChuKongLoginAndPay.getInstance().notifyLoginResult(login_info);
													}
												});
											
										}
									
									
								}
								}
							});
						
					
						}
							
					}else
					{
						int error = jsonObject.optInt("error");
						if(error == -1){
							Toast.makeText(game_ctx,"系统没有初始化", Toast.LENGTH_SHORT).show();
						}
						if(error == -2){
							Toast.makeText(game_ctx,"网络错误", Toast.LENGTH_SHORT).show();
						}
						if(error == -6){
							Toast.makeText(game_ctx,"用户已登录，但登录信息不符合", Toast.LENGTH_SHORT).show();
						}
						if(error == -5){
							Toast.makeText(game_ctx,"用户取消", Toast.LENGTH_SHORT).show();
						}
						if(error == -4){
							Toast.makeText(game_ctx,"其他错误", Toast.LENGTH_SHORT).show();
						}
					}
				}
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
		}
	}

	class MyCount extends CountDownTimer {
		public MyCount(long millisInFuture, long countDownInterval) {
			super(millisInFuture, countDownInterval);
		}

		@Override
		public void onFinish() {
			// 见文档2.2			
			JoyInterface.login((JoyCallback) new LoginCallback(), 2);
		}

		@Override
		public void onTick(long millisUntilFinished) {
			Log.e("TAG", "prepare exec JoyInterface.login "
					+ (millisUntilFinished / 1000) + " s after ");
		}
	}
	
	@Override
	public void callLogin() {
		ApplicationInfo appInfo = null;
		try {
			appInfo = game_ctx.getPackageManager().getApplicationInfo(game_ctx.getPackageName(),PackageManager.GET_META_DATA);
			String channel=String.valueOf(appInfo.metaData.getInt("coco_cid"));
			//JoyInterface.initialize(this.game_ctx, this.joyGL, this.game_info.app_id_str, channel); //new SDK
			JoyInterface.initialize(this.game_ctx, this.joyGL, this.game_info.app_id_str, channel);
			
	  		final IGameAppStateCallback callback = mCallback3;
	  		callback.showWaitingViewImp(false, -1, "");
	  		myCount = new MyCount(1000, 300); // 1秒之后开始调用登陆接口
			myCount.start();

		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
	}
	
	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result.login_result== PlatformAndGameInfo.enLoginResult_Success){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_ChuKong+login_info.account_uid_str;
			
			if (login_info.account_nick_name == null || login_info.account_nick_name.isEmpty())
				login_info.account_nick_name = login_info.account_uid_str;
			
			Toast.makeText(game_ctx,"登录成功，点击进入游戏", Toast.LENGTH_SHORT).show();
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		if (login_info != null) {
			if (isLogin)
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			else
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}
		
		return login_info;
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub
		isLogin = false;
	}

	@Override
	public void callCheckVersionUpate() {
		// TODO Auto-generated method stub

	}

	@Override
	public void notifyVersionUpateInfo(VersionInfo version_info) {
		// TODO Auto-generated method stub
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			mCallback2.notifyVersionCheckResult(version_info);
		}
	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		// TODO Auto-generated method stub
		int Error = 0;
		this.pay_info = null;
		this.pay_info = pay_info;
		
		JoyInterface.payBilling((int)this.pay_info.price, "zuanshi", "mxhzw", (int)this.pay_info.price*10, this.pay_info.order_serial, this.pay_info.product_id, this.login_info.account_uid_str, pay_info.description, new JoyCallback() {
			@Override
			public void onCallback(String data) {
				// TODO Auto-generated method stub
				try {
					JSONObject jsonObject = new JSONObject(data);
					if(jsonObject.optInt("status")==1)
					{
						if(jsonObject.optInt("state")==1)
						{
								game_ctx.runOnUiThread(new Runnable() {
								
								@Override
								public void run() {
									// TODO Auto-generated method stub
									Toast.makeText(game_ctx,"支付成功", Toast.LENGTH_SHORT).show();
									PlatformChuKongLoginAndPay.getInstance().pay_info.result = 0;
									PlatformChuKongLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformChuKongLoginAndPay.getInstance().pay_info);
								}
							});
						}
						else if(jsonObject.optInt("state")==2)
						{
							
								game_ctx.runOnUiThread(new Runnable() {
								
								@Override
								public void run() {
									// TODO Auto-generated method stub
									Toast.makeText(game_ctx,"支付信息已提交", Toast.LENGTH_SHORT).show();
									PlatformChuKongLoginAndPay.getInstance().pay_info.result = 0;
									PlatformChuKongLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformChuKongLoginAndPay.getInstance().pay_info);
								}
							});
						}
					}
					else if(jsonObject.optInt("status")==0)
					{
						if(jsonObject.optInt("error")==-2)
						{
								game_ctx.runOnUiThread(new Runnable() {
								
								@Override
								public void run() {
									// TODO Auto-generated method stub
									Toast.makeText(game_ctx,"网络错误 ", Toast.LENGTH_SHORT).show();
								}
							});
						}
						else if(jsonObject.optInt("state")==-5)
						{
								game_ctx.runOnUiThread(new Runnable() {
								@Override
								public void run() {
									// TODO Auto-generated method stub
									Toast.makeText(game_ctx,"用户取消", Toast.LENGTH_SHORT).show();
								}
							});
						}
					}
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
			}
		});
		
		return Error;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
			return;
		if (PlatformChuKongLoginAndPay.getInstance().isLogin)
			callLogout();
		callLogin();
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

}
