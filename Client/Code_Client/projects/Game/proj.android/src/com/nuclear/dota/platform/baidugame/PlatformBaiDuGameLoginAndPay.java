package com.nuclear.dota.platform.baidugame;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.widget.Toast;

import com.baidu.game.LoginCallbackListener;
import com.baidu.game.OrderInfo;
import com.baidu.game.PayCallbackListener;
import com.baidu.game.PaymentInfo;
import com.baidu.game.UserInfo;
import com.baidu.game.service.BaiduGameProxy;
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

public class PlatformBaiDuGameLoginAndPay implements IPlatformLoginAndPay {
	
	public static final String TAG = PlatformBaiDuGameLoginAndPay.class.getSimpleName();
	
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
	
	private static PlatformBaiDuGameLoginAndPay   sInstance = null;
	public static PlatformBaiDuGameLoginAndPay getInstance()
	{
		if(sInstance == null)
		{
			sInstance = new PlatformBaiDuGameLoginAndPay();
		}
		return sInstance;
	}
	
	@Override
	public void onLoginGame() {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		this.mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_BaiDuGame;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_BaiDuGame;
		
		/* this.game_info.app_key = "3e57fc37013e85d538e86beb641965af";
		this.game_info.app_secret = "8a97a7b23e57fc37013e641965af6bec"; */
		//初始化SDK
		int initSucceed = BaiduGameProxy.initSDK(this.game_ctx, this.game_info.app_key, this.game_info.app_secret, "1");
		
		if(initSucceed!=1)
		{
			Toast.makeText(this.game_ctx,"SDK初始化失败,请重新启动游戏。", Toast.LENGTH_SHORT).show();
			return;
		}
		
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
		
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
		return -1;
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
		//
		
		PlatformBaiDuGameLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		if(isLogin){
			return;
		}
		
  		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		
		BaiduGameProxy.showLoginView(this.game_ctx, new LoginCallbackListener() {
			
			@Override
			public void callback(int code, UserInfo userInfo) {
				// TODO Auto-generated method stub
				if(code ==1)
				{
					//登陆成功 可以获取到 userInfo信息
					callback.showWaitingViewImp(false, -1, "");
					
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.login_session = userInfo.getSid();
					login_info.account_uid_str = userInfo.getUid();
					login_info.account_nick_name = userInfo.getUid();
					
					
					isLogin = true;
					PlatformBaiDuGameLoginAndPay.getInstance().notifyLoginResult(login_info);
				}
				else
				{
					callback.showWaitingViewImp(false, -1, "");
					//登陆失败  userInfo 为 null
					Toast.makeText(game_ctx,"取消登陆", Toast.LENGTH_SHORT).show();
				}
			}
		});
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_BaiDuGame+login_info.account_uid_str;
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
		this.pay_info = null;
		this.pay_info = pay_info;
		
		PaymentInfo payInfo = new PaymentInfo();
		payInfo.setAmount((int)this.pay_info.price);

		payInfo.setServerId(this.pay_info.description);
		//String ServerName = "安卓"+Cocos2dxHelper.nativeGetServerId()+"服";
		payInfo.setServerName("安卓服");
		
		String customInfo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		
		payInfo.setCustomInfo(customInfo);
		
		BaiduGameProxy.showPayView(this.game_ctx, payInfo, new PayCallbackListener() {
			
			@Override
			public void callback(int code, OrderInfo orderInfo) {
				// TODO Auto-generated method stub
				if(code == 0)
				{
					//用户取消支付，orderInfo不为null,可取到除orderid外的参数
					Toast.makeText(game_ctx,"取消支付", Toast.LENGTH_SHORT).show();
				}
				if(code == 1){
					PlatformBaiDuGameLoginAndPay.getInstance().pay_info.result = 0;
					PlatformBaiDuGameLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformBaiDuGameLoginAndPay.getInstance().pay_info);

				}
			}
		});
		return 0;
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
		if (PlatformBaiDuGameLoginAndPay.getInstance().isLogin)
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

	

}
