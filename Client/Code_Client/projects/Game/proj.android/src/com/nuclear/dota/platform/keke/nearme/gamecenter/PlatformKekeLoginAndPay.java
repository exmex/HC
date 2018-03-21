package com.nuclear.dota.platform.keke.nearme.gamecenter;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.util.Log;
import android.widget.Toast;

import com.nearme.gamecenter.open.api.ApiCallback;
import com.nearme.gamecenter.open.api.GameCenterSDK;
import com.nearme.gamecenter.open.api.GameCenterSettings;
import com.nearme.oauth.model.UserInfo;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;

public class PlatformKekeLoginAndPay implements IPlatformLoginAndPay {

	private IGameActivity mGameActivity;
	private IPlatformSDKStateCallback mCallback1;
	private IGameUpdateStateCallback mCallback2;
	private IGameAppStateCallback mCallback3;

	private Activity game_ctx = null;
	private GameInfo game_info = null;
	private LoginInfo login_info = null;
	private VersionInfo version_info = null;
	private PayInfo pay_info = null;

	private boolean isLogin = false;
	private boolean initOk = false;

	private static PlatformKekeLoginAndPay mInstance;

	private PlatformKekeLoginAndPay() {

	}

	public static PlatformKekeLoginAndPay getInstance() {
		if (mInstance == null) {
			mInstance = new PlatformKekeLoginAndPay();
		}
		return mInstance;
	}

	@Override
	public void onLoginGame() {
		
	}
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		game_info.screen_orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;

		GameCenterSDK.setmCurrentContext(this.game_ctx);
		this.game_ctx.setRequestedOrientation(game_info.screen_orientation);

		GameCenterSettings gameCenterSettings = new GameCenterSettings(
				"8Ucnr487t2Os4SckK8o844oO0", "74b33880363f263bbf2ce3473cb29A18") {// key
																					// secret

			@Override
			public void onForceUpgradeCancel() {

			}

			@Override
			public void onForceReLogin() {

			}
		};
		GameCenterSettings.isDebugModel = true;
		GameCenterSettings.isOritationPort = true;
		GameCenterSDK.init(gameCenterSettings, this.game_ctx);

		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();

	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		mCallback1 = callback1;

	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		mCallback2 = callback2;

	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		mCallback3 = callback3;

	}

	@Override
	public int isSupportInSDKGameUpdate() {
		return 0;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		return 0;
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

		PlatformKekeLoginAndPay.mInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {

		return this.game_info;
	}

	@Override
	public void callLogin() {
		if (isLogin) {
			return;
		}
		final IGameAppStateCallback callBack = mCallback3;
		callBack.showWaitingViewImp(true, -1, "正在登录");
		GameCenterSDK.getInstance().doLogin(new ApiCallback() {
			@Override
			public void onSuccess(String content, int code) {
				Log.d("aa", content);

				GameCenterSDK.getInstance().doGetUserInfo(new ApiCallback() {
					@Override
					public void onSuccess(String content, int code) {
						// 获取用户信息后的处理
						isLogin=true;
						UserInfo ui = new UserInfo(content);
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.account_uid_str=ui.username;
						login_info.account_nick_name=ui.nickname;
						login_info.account_uid_str=ui.id;
						PlatformKekeLoginAndPay.getInstance().notifyLoginResult(login_info);
					}

					@Override
					public void onFailure(String content, int code) {
						// 获取失败后的处理

						Toast.makeText(game_ctx, "获取用户信息失败:" + content,
								Toast.LENGTH_SHORT).show();
					}
				}, game_ctx);

				callBack.showWaitingViewImp(false, -1, "登录成功");

			}

			@Override
			public void onFailure(String content, int code) {
				Log.d("aa", content);
				callBack.showWaitingViewImp(false, -1, "登录失败");

			}
		}, this.game_ctx);

	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_JinShan+login_info.account_uid_str;
			mGameActivity.showToastMsg("登录成功，点击进入游戏");
			mCallback3.notifyLoginResut(login_result);
		}

	}

	@Override
	public LoginInfo getLoginInfo() {
		
		return this.login_info;
	}

	@Override
	public void callLogout() {
		

	}

	@Override
	public void callCheckVersionUpate() {
		// TODO Auto-generated method stub

	}

	@Override
	public void notifyVersionUpateInfo(VersionInfo version_info) {
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			
			mCallback2.notifyVersionCheckResult(version_info);
		}

	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		
		
		
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		

	}

	@Override
	public void callAccountManage() {
		if(Cocos2dxHelper.nativeHasEnterMainFrame()){
			return;
		}
		isLogin=false;
		callLogin();

	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {
		Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();

	}

	@Override
	public void callPlatformSupportThirdShare(ShareInfo share_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callPlatformGameBBS() {
		GameCenterSDK.getInstance().doShowGameCenter(game_ctx);

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
