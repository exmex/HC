package com.nuclear.dota.platform.GTV;

import java.util.UUID;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;


import org.cocos2dx.lib.Cocos2dxHelper;
import com.example.gtvsdk.GTVSDK;
import com.example.gtvsdk.GTVSDKInterface;
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

public class PlatformGTVLoginAndPay implements IPlatformLoginAndPay {
private static final String TAG = PlatformGTVLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	public IGameAppStateCallback		mCallback3;
	private GTVSDK 						mGTVSDK;
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	public PayInfo 						pay_info = null;
	public boolean						isLogin = false;
	
	
	private static PlatformGTVLoginAndPay sInstance = null;
	public static PlatformGTVLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformGTVLoginAndPay();
		}
		return sInstance;
	}
	
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_GTV;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_GTV;
		
		final String secret = String.valueOf(game_info.app_secret);
        final String appId = game_info.app_id_str;
        final String serverSeqNum = String.valueOf(game_info.svr_id);
        final String appKey = game_info.app_key;
        mGTVSDK = new GTVSDK(this.game_ctx, appId, appKey, secret,serverSeqNum, (GTVSDKInterface)this.game_ctx);

        isLogin = false;
        mCallback1.notifyInitPlatformSDKComplete();
	}

	@Override
	public void onLoginGame() {
			
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
		/*
		 *
		 * */
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
		
		this.isLogin = false;
		mGTVSDK = null;
		
		//
		//
		PlatformGTVLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		
		if(this.isLogin)
		{
			Log.w(TAG, "Logined");
			return;
		}
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(false, -1, "");
		mGTVSDK.logIn();
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_GTV+login_info.account_uid_str;
			mCallback3.notifyLoginResut(login_result);
			Toast.makeText(game_ctx, "登录成功，点击进入游戏", Toast.LENGTH_SHORT)
			.show();
			
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
		if (mGTVSDK.isLoggedIn()) {
			mGTVSDK.removeAuthData();
			this.isLogin = false;
		}
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
		if(!mGTVSDK.isLoggedIn()) {
			Toast.makeText(game_ctx, "用户信息失效，请您重新登录游戏！", Toast.LENGTH_SHORT).show();
             return 0;
         }
		float money=pay_info.price;
		String otherInfo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;
		if (!mGTVSDK.rechargeAccount(String.valueOf((int)money),otherInfo)) {
			Toast.makeText(game_ctx, "支付调用失败", Toast.LENGTH_SHORT).show();
		}   
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
		if (PlatformGTVLoginAndPay.getInstance().isLogin)
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
	public void onGameExit() {
		
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
