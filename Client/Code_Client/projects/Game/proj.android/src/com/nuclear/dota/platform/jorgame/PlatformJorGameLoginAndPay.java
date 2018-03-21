package com.nuclear.dota.platform.jorgame;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.os.Handler;
import android.widget.Toast;

import com.jorgame.sdk.activity.SDKManager;
import com.jorgame.sdk.callback.LoginCallbackInfo;
import com.jorgame.sdk.callback.PaymentCallbackInfo;
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

public class PlatformJorGameLoginAndPay implements IPlatformLoginAndPay {

	
private static final String TAG = PlatformJorGameLoginAndPay.class.getSimpleName();
	
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
	
	private final int MSG_LOGIN_STATUS = 3333;
	private final int MSG_PAY_STATUS = 4444;
	private Handler mHandler = new Handler(){
		public void dispatchMessage(android.os.Message msg) {
			switch (msg.what) {
			
			case MSG_LOGIN_STATUS:
				mCallback3.showWaitingViewImp(false, -1, "已登录");
				LoginCallbackInfo  loginInfoObj = (LoginCallbackInfo)msg.obj;
				
				if(null!=loginInfoObj&loginInfoObj.statusCode==LoginCallbackInfo.STATUS_SUCCESS){
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.account_uid_str = SDKManager.getLoginName();
				login_info.account_nick_name = login_info.account_uid_str;
				notifyLoginResult(login_info);
				
				}else{
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
					notifyLoginResult(login_info);
				}
				
				break;
			case MSG_PAY_STATUS:
				PaymentCallbackInfo   payInfo = (PaymentCallbackInfo)msg.obj;
				
				if(null!=payInfo&payInfo.statusCode==PaymentCallbackInfo.STATUS_SUCCESS){
					Toast.makeText(game_ctx, "支付成功", Toast.LENGTH_SHORT).show();
					notifyPayRechargeRequestResult(pay_info);
				}else{
					//Toast.makeText(game_ctx, "订单提交失败", Toast.LENGTH_LONG).show();
				}
				break;
			default:
				break;
			}
		}
	};
	private static SDKManager mSDKManager;
	private static PlatformJorGameLoginAndPay sInstance = null;
	
	public static PlatformJorGameLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformJorGameLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformJorGameLoginAndPay() {
		
	}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		

		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;
		this.game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_JorGame;
		this.game_info.platform_type =PlatformAndGameInfo.enPlatform_JorGame;
		this.game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		 	
		mSDKManager = SDKManager.getInstance(game_ctx);
		mSDKManager.setConfigInfo(true,true,true); 
		
		
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
	
	
	@Override
	public void callLogin() {
		
		if(!mSDKManager.isLogined()){
			mCallback3.showWaitingViewImp(true, -1, "正在登录");
			mSDKManager.showLoginView(mHandler,MSG_LOGIN_STATUS);
		}else{
			mCallback3.showWaitingViewImp(false, -1, "已经登录");
		}
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_JorGame+login_info.account_uid_str;
			
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
		
	}

	@Override
	public void callCheckVersionUpate() {
		// TODO Auto-generated method stub

	}

	@Override
	public void notifyVersionUpateInfo(VersionInfo version_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		// TODO Auto-generated method stub
		this.pay_info = pay_info;
		String extraInfo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		mSDKManager.showPaymentView(mHandler, MSG_PAY_STATUS,pay_info.description,extraInfo,
				String.valueOf((int)pay_info.price));
		
		return 0;
	}

	@Override
	public void onLoginGame() {
			
	}
	
	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
			return ;
		}
		mSDKManager.recycle();
		mSDKManager = SDKManager.getInstance(game_ctx);
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		mSDKManager.showLoginView(mHandler,MSG_LOGIN_STATUS);
		
		
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return null;
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
		Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
		
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
		mSDKManager.recycle();
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
