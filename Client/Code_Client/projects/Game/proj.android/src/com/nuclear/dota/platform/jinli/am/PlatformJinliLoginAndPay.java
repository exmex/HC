package com.nuclear.dota.platform.jinli.am;

import java.util.UUID;
import org.cocos2dx.lib.Cocos2dxHelper;
import android.app.Activity;
import android.graphics.BitmapFactory;
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

public class PlatformJinliLoginAndPay implements IPlatformLoginAndPay {

	private String TAG = "Gionee";
	protected Activity mGameActivity = null;
	protected boolean isLogined = false;

	private IPlatformSDKStateCallback mCallback1 = null;
	private IGameUpdateStateCallback mCallback2 = null;
	public IGameAppStateCallback mCallback3 = null;

	private static PlatformJinliLoginAndPay sInstance = null;

	public GameInfo game_info = null;
	public LoginInfo login_info = null;
	public VersionInfo version_info = null;
	public PayInfo pay_info = null;
	private PayInfo mPayInfo = null; 
	
	String playerId = "";
	
	public static PlatformJinliLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformJinliLoginAndPay();
		}
		return sInstance;
	}

	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		isLogined = false;

		this.game_info = game_info;
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Debug;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Jinli;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_Jinli;
		
		mGameActivity = game_ctx.getActivity();
		
		
		
		mCallback1.notifyInitPlatformSDKComplete();
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
		return 0;//R.layout.logo_youai;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		mGameActivity = null;
		mCallback1 = null;
		mCallback2 = null;
		mCallback3 = null;

		this.game_info = null;
		this.login_info = null;
		this.version_info = null;
		this.pay_info = null;

		isLogined = false;
		PlatformJinliLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() 
	{
		((JinliActivity)mGameActivity).loginAccount(mGameActivity.getIntent());
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;

		if (login_result != null) {
			isLogined = true;
			login_result.account_uid_str = PlatformAndGameInfo.enPlatformShort_Jinli
					+ login_result.account_uid_str;
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		return login_info;
	}

	@Override
	public void onLoginGame() {
		// TODO Auto-generated method stub
		// Nothing to do
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub
		if (isLogined) {
			isLogined = false;
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
		mPayInfo = pay_info;
		if(((JinliActivity)mGameActivity).isPay){
			return 0;
		}
		((JinliActivity) mGameActivity).payGameFee(mPayInfo);
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
			Toast.makeText(mGameActivity, "暂未开放", Toast.LENGTH_SHORT).show();
			return;
		} else {
			Toast.makeText(mGameActivity, "请点击悬浮球进入个人中心切换", Toast.LENGTH_SHORT).show();
		}
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString().replace("-", "");
	}

	@Override
	public void callPlatformFeedback() {
		// TODO Auto-generated method stub
		if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
			String _url = Config.UrlFeedBack + "?puid="
					+ LastLoginHelp.mPuid + "&gameId=" + LastLoginHelp.mGameid
					+ "&serverId=" + LastLoginHelp.mServerID + "&playerId="
					+ LastLoginHelp.mPlayerId + "&playerName="
					+ LastLoginHelp.mPlayerName + "&vipLvl="
					+ LastLoginHelp.mVipLvl + "&platformId="
					+ LastLoginHelp.mPlatform;
			FeedBackDialog.getInstance(mGameActivity, _url).show();
		}
	}

	@Override
	public void callPlatformSupportThirdShare(ShareInfo share_info) {
		// TODO Auto-generated method stub
		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}
	}

	@Override
	public void callPlatformGameBBS() {
		// TODO Auto-generated method stub
		if (isLogined) {
			return;
		}
	}

	@Override
	public void onGamePause() {
		// TODO Auto-generated method stub
		Log.d(TAG, "I AM NOW ON PAUSE");

	}

	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub
		((JinliActivity) mGameActivity).onPayerResume();
	}

	@Override
	public void onGameExit() {
		// TODO Auto-generated method stub
		((JinliActivity) mGameActivity).onPayerDestroy();
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