package com.nuclear.dota.platform.fiveone;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.fiveone.gamecenter.netconnect.bean.UserInfo;
import com.fiveone.gamecenter.netconnect.listener.AccountStatusListener;
import com.fiveone.gamecenter.sdk.GameCenterService;
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

public class PlatformFiveOneLoginAndPay implements IPlatformLoginAndPay {

	
private static final String TAG = PlatformFiveOneLoginAndPay.class.getSimpleName();
	
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
	
	private static PlatformFiveOneLoginAndPay sInstance = null;
	public static PlatformFiveOneLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformFiveOneLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformFiveOneLoginAndPay() {
		
	}
	AccountStatusListener mListener;
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		com.fiveone.gamecenter.sdk.Config.GAME_CENTER_APP_KEY = game_info.app_key;
		com.fiveone.gamecenter.sdk.Config.GAME_CENTER_PRIVATE_KEY= game_info.public_str;

		mGameActivity = game_acitivity;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_FiveOne;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_FiveOne;
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;
		mListener = new AccountStatusListener() {
			
			@Override
			public void onRegisterSuccess(UserInfo arg0) {
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.account_nick_name = arg0.getUsername();
				login_info.account_uid_str = String.valueOf(arg0.getUserId());
				Toast.makeText(game_ctx, "注册成功", Toast.LENGTH_SHORT).show();
				mCallback3.showWaitingViewImp(false, -1, "已登录");
				notifyLoginResult(login_info);
			}
			
			@Override
			public void onRegisterAccountExists() {
				Toast.makeText(game_ctx, "注册结束", Toast.LENGTH_SHORT).show();
			}
			
			@Override
			public void onLoginSuccess(UserInfo arg0) {
				// TODO Auto-generated method stub
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.account_nick_name = arg0.getUsername();
				login_info.account_uid_str = String.valueOf(arg0.getUserId());
				mCallback3.showWaitingViewImp(false, -1, "已登录");
				Toast.makeText(game_ctx, "登录成功", Toast.LENGTH_SHORT).show();
				notifyLoginResult(login_info);
			}
			
			@Override
			public void onLoginPwdError() {
				// TODO Auto-generated method stub
				mCallback3.showWaitingViewImp(false, -1, "登录");
				Toast.makeText(game_ctx, "登录密码错误", Toast.LENGTH_SHORT).show();
			}
			
			@Override
			public boolean onLoginPageClose(Activity arg0) {
				mCallback3.showWaitingViewImp(false, -1, "登录");
				Toast.makeText(game_ctx, "登录界面结束", Toast.LENGTH_SHORT).show();
				return false;
			}
			
			@Override
			public void onFailed() {
				mCallback3.showWaitingViewImp(false, -1, "登录");
				Toast.makeText(game_ctx, "出现错误", Toast.LENGTH_SHORT).show();				
			}
		};
		String channelId = "51034999";
		InputStreamReader inputReader = null;
		try {
			inputReader = new InputStreamReader(
					game_acitivity.getActivity().getResources().getAssets().open("channel.properties"));
			BufferedReader bufReader = new BufferedReader(inputReader);
			String line = "";
			String Result = "";
			while ((line = bufReader.readLine()) != null){
				Result += line;
			}
			if (!Result.equals("")){
				channelId = Result;
			}
		} catch (IOException e) {
			Log.i(TAG, e.toString());
			//e.printStackTrace();
		}
		

		GameCenterService.initSDK(game_ctx,channelId, mListener);
		//
		mCallback1.notifyInitPlatformSDKComplete();
		
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
		if(isLogined){
			return;
		}else{
		
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		
		GameCenterService.startLoginActivity(game_ctx);
		}
		
	}

	@Override
	public void notifyLoginResult(LoginInfo _login_result) {
		
		login_info = null;
		login_info = _login_result;
		//
		if (_login_result != null) {
			isLogined = true;
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_FiveOne+_login_result.account_uid_str;
			mCallback3.notifyLoginResut(login_info);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		if (login_info != null) {
			if (isLogined)
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
	public void onLoginGame() {
		int sid = Cocos2dxHelper.nativeGetServerId();
		GameCenterService.setLoginServer(game_ctx, String.valueOf(sid), String.valueOf(sid));
		GameCenterService.setGameRoleNameAndGameLevel(game_ctx,String.valueOf(LastLoginHelp.mPlayerName),
				String.valueOf(LastLoginHelp.mlv));
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
		// TODO Auto-generated method stub

	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		
		
		this.pay_info = pay_info;
		String orderExtra = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		GameCenterService.startGamePayActivity(game_ctx,orderExtra,String.valueOf((int)pay_info.price));
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();	
			return;
		}
		
		isLogined = false;
		callLogin();
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
		
	}

	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
	}

}
