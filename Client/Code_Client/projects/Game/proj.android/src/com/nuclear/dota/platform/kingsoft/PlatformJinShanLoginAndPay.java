package com.nuclear.dota.platform.kingsoft;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.util.Log;
import android.widget.Toast;

import com.ijinshan.ksmglogin.inteface.IKSGameSdkCallback;
import com.ijinshan.ksmglogin.manager.KSGameSdkManager;
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

public class PlatformJinShanLoginAndPay implements IPlatformLoginAndPay {
	
	private static final String TAG = PlatformJinShanLoginAndPay.class.getSimpleName();
	
	private IGameActivity                               mGameActivity;
	private IPlatformSDKStateCallback                   mCallback1;
	private IGameUpdateStateCallback                    mCallback2;
	private IGameAppStateCallback                       mCallback3;
	
	private Activity                                    game_ctx = null;
	private GameInfo                                    game_info = null;
	private LoginInfo                                   login_info = null;
	private VersionInfo                                 version_info = null;
	private PayInfo                                     pay_info = null;
	private boolean                                     isLogin = false;
	
	private static PlatformJinShanLoginAndPay sInstance = null;
	public static PlatformJinShanLoginAndPay getInstance()
	{
		if(sInstance == null){
			sInstance = new PlatformJinShanLoginAndPay();
		}
		return sInstance;
	}
	
	@Override
	public void onLoginGame() {
		// 正式进入游戏世界了，调用一下
        KSGameSdkManager.getInstance().entryGame(this.game_ctx);
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		this.mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;

		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_JinShan;
		this.game_info.platform_type =PlatformAndGameInfo.enPlatform_JinShan;
		
		KSGameSdkManager.getInstance().init(this.game_ctx, mIksGameSdkCallback);
		
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
	}
	
	private IKSGameSdkCallback mIksGameSdkCallback = new IKSGameSdkCallback() {

        @Override
        public void onQuitGame() {
            Log.i(TAG, "回调：退出游戏");
        }

        @Override
        public void onPayResult(boolean isSuccess) {
            Log.i(TAG, "回调：支付结果：" + (isSuccess ? "成功" : "失败或者取消了"));
            if(isSuccess)
			{
				PlatformJinShanLoginAndPay.getInstance().pay_info.result = 0;
				PlatformJinShanLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformJinShanLoginAndPay.getInstance().pay_info);
			}
			else
			{
				mGameActivity.showToastMsg("支付失败！");
			}
        }

        @Override
        public void onLoginResult(boolean isSuccess, String uid, String guid, String mutk) {
            Log.i(TAG, "回调：登录结果 是否成功:" + (isSuccess ? "是" : "否") + " uid:" + uid);
            final IGameAppStateCallback callback = mCallback3;
            if (isSuccess) {
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = mutk;
				login_info.account_uid_str = uid;
				login_info.account_nick_name = login_info.account_uid_str;
				isLogin = true;
				PlatformJinShanLoginAndPay.getInstance().notifyLoginResult(login_info);
			} else {
				
				mGameActivity.showToastMsg("登陆失败！");
			}
            callback.showWaitingViewImp(false, -1, "");
        }

        @Override
        public void onLogout() {
            Log.i(TAG, "回调：注销/切换了账号");
            // 注销的回调，sdk自带的切换按钮被点击或者调用 logout方法都会被触发
            callLogout();
            //mGameActivity.showToastMsg("账号注销！");
        }
    };

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
		return 0;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return R.layout.logo_kingsoft;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		KSGameSdkManager.getInstance().quit(game_ctx);
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
		PlatformJinShanLoginAndPay.sInstance = null;
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
		callback.showWaitingViewImp(true, -1, "正在登录");
		
		boolean isLogin = KSGameSdkManager.getInstance().isLogin();
		if (!isLogin) {
            KSGameSdkManager.getInstance().login(this.game_ctx);
        } else {
        	mGameActivity.showToastMsg("登陆成功！");
        }
		
		callback.showWaitingViewImp(false, -1, "");
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
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
		String cpparam = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		
		 // 获取是否已经登录了
        boolean isLogin = KSGameSdkManager.getInstance().isLogin();
        if (isLogin) {
            // 打开支付 注意，金钱的单位是“分”
            // cpparam，sid，sname 由游戏厂家定义，用于游戏厂家自己做区分
            KSGameSdkManager.getInstance().pay(cpparam,
            		String.valueOf(this.pay_info.price*100), pay_info.description, "安卓"+pay_info.description);
        } else {
        	mGameActivity.showToastMsg("登陆失效，请重新登陆~");
        }
		
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
		{
			mGameActivity.showToastMsg("暂未开通,敬请期待!");
			return;
		}
		if (PlatformJinShanLoginAndPay.getInstance().isLogin && KSGameSdkManager.getInstance().isLogin()){
			callLogout();
			KSGameSdkManager.getInstance().logout(this.game_ctx);
		}else{
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
