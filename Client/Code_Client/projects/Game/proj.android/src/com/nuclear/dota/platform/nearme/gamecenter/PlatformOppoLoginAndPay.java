package com.nuclear.dota.platform.nearme.gamecenter;

import java.util.Date;
import java.util.Random;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.nearme.gamecenter.open.api.ApiParams;
import com.nearme.gamecenter.open.api.ApiCallback;
import com.nearme.gamecenter.open.api.FixedPayInfo;
import com.nearme.gamecenter.open.api.GameCenterSDK;
import com.nearme.oauth.model.UserInfo;
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
public class PlatformOppoLoginAndPay implements IPlatformLoginAndPay {

	private static final String TAG = PlatformOppoLoginAndPay.class.getSimpleName();

	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	public boolean isLogined = false;
	
	
	private static PlatformOppoLoginAndPay sInstance = null;
	public static PlatformOppoLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformOppoLoginAndPay();
		}
		return sInstance;
	}
	
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;

		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Oppo;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_Oppo;

		mCallback1.notifyInitPlatformSDKComplete();

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
		// TODO Auto-generated method stub
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
		this.isLogined = false;
		
		PlatformOppoLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {

		return this.game_info;
	}

	@Override
	public void callLogin() {

		if(isLogined)
		{
			return;
		}
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		GameCenterSDK.setmCurrentContext(PlatformOppoLoginAndPay.getInstance().game_ctx);
		GameCenterSDK.getInstance().doReLogin(new ApiCallback() {
			
			@Override
			public void onSuccess(String content, int code) {
				Log.d(TAG, content);
				GameCenterSDK.getInstance().doGetUserInfo(new ApiCallback() {
					@Override
					public void onSuccess(String content, int code) {
						// 获取用户信息后的处理
						isLogined=true;
						UserInfo ui = new UserInfo(content);
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.account_uid_str=ui.username;
						login_info.account_nick_name=ui.nickname;
						login_info.account_uid_str=ui.id;
						PlatformOppoLoginAndPay.getInstance().notifyLoginResult(login_info);
					}

					@Override
					public void onFailure(String content, int code) {
						// 获取失败后的处理

						Toast.makeText(game_ctx, "获取用户信息失败:" + content,
								Toast.LENGTH_SHORT).show();
					}
				}, game_ctx);
			}

			@Override
			public void onFailure(String content, int code) {
				Log.d(TAG, content);
			}
		}, this.game_ctx);
		callback.showWaitingViewImp(false, -1, "");
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Oppo+login_info.account_uid_str;
			mGameActivity.showToastMsg("登录成功，点击进入游戏");
			mCallback3.notifyLoginResut(login_result);
			
		}

	}

	@Override
	public LoginInfo getLoginInfo() {
		if (login_info != null) {
			if(isLogined)
			{
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			}
			else
			{
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
			}
		}
		
		return login_info;
	}

	@Override
	public void callLogout() {
		isLogined = false;

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
	public int callPayRecharge(final PayInfo pay_info) {
		this.pay_info = null;
		this.pay_info = pay_info;
		
		String temp = this.pay_info.description + "-" + this.pay_info.product_id.substring(0, this.pay_info.product_id.indexOf(".")) + "-" + 
			this.login_info.account_uid_str+"-"+(int)((new Date()).getTime()/1000);//区号-物品ID-orderserial
		
		int money = (int)pay_info.price*100;
		
		final com.nearme.gamecenter.open.api.PayInfo pay_info_keke = new 
				com.nearme.gamecenter.open.api.PayInfo(System.currentTimeMillis() + 
						new Random().nextInt(1000) + "", 
						temp, money);
				
		pay_info_keke.setProductDesc(pay_info.description);
		pay_info_keke.setProductName(pay_info.product_name);
		pay_info_keke.setCallbackUrl(PlatformOppoLoginAndPay.getInstance().game_info.pay_addr);
		GameCenterSDK.getInstance().doNormalKebiPayment(new ApiCallback() {
			
			@Override
			public void onSuccess(String content, int code) {
				// TODO Auto-generated method stub
				Toast.makeText(PlatformOppoLoginAndPay.getInstance().game_ctx.getApplicationContext(), "购买成功.",
						Toast.LENGTH_SHORT).show();
				if (PlatformOppoLoginAndPay.getInstance().pay_info != null)
				{
					PlatformOppoLoginAndPay.getInstance().pay_info.result = 0;
					
					notifyPayRechargeRequestResult(PlatformOppoLoginAndPay.getInstance().pay_info);
				}
			}
			
			@Override
			public void onFailure(String content, int code) {
				// TODO Auto-generated method stub
				Toast.makeText(PlatformOppoLoginAndPay.getInstance().game_ctx.getApplicationContext(),
						"购买失败:" + content,
						Toast.LENGTH_SHORT).show();
			}
		}, pay_info_keke, PlatformOppoLoginAndPay.getInstance().game_ctx);
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
	
		if(Cocos2dxHelper.nativeHasEnterMainFrame()){
			GameCenterSDK.getInstance().doShowForum(PlatformOppoLoginAndPay.getInstance().game_ctx);
			return;
		}
		else
		{
			callLogout();
			callLogin();
		}
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString().replace("-", "");
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
		// TODO Auto-generated method stub

	}

	@Override
	public void callPlatformGameBBS() {
//		GameCenterSDK.getInstance().doShowGameCenter(game_ctx);

	}

	@Override
	public void onGamePause() {
		// TODO Auto-generated method stub
		GameCenterSDK.getInstance().doDismissSprite(game_ctx);
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
		//GameCenterSDK.getInstance().doShowSprite(game_ctx);
	}

	@Override
	public boolean isTryUser() {
		
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

	@Override
	public void onLoginGame() {
		// TODO Auto-generated method stub
		
	}

}