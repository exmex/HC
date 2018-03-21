package com.nuclear.dota.platform.game2324;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.widget.Toast;

import com.jiubang.game2324.Game2324Manager;
import com.jiubang.game2324.InitCallBack;
import com.jiubang.game2324.LoginCallBack;
import com.jiubang.game2324.RechargeCallBack;
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

public class PlatformJiubangLoginAndPay implements IPlatformLoginAndPay {

	
private static final String TAG = PlatformJiubangLoginAndPay.class.getSimpleName();
	
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
	Game2324Manager gameManager;
	private boolean isLogined = false;
	
	private static PlatformJiubangLoginAndPay sInstance = null;
	public static PlatformJiubangLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformJiubangLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformJiubangLoginAndPay() {
		
	}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		

		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Game2324;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_Game2324;
		
		this.game_info = game_info;
		gameManager = Game2324Manager.getInstance();
		gameManager.Init(game_ctx,game_info.app_id,// "gameid"
					game_info.cp_id, new InitCallBack() {//cpid

					@Override
					public void callback(int arg0) {
						if (arg0 == Game2324Manager.INIT_CODE_SUCCESS) {
							// Do something
							mCallback1.notifyInitPlatformSDKComplete();
						}else{
							Toast.makeText(game_ctx, "初始化失败", Toast.LENGTH_SHORT).show();
						}
					}
				});

		//

		//
		
	}

	@Override
	public void onLoginGame() {
			
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
		return R.layout.logo_jiubang;
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
		
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		
	 
		if(!isLogined)
		gameManager.Login(game_ctx, new LoginCallBack() {
			@Override
			public void callback(int code, String uid, String sessionID) {
				if (code == Game2324Manager.LOGIN_CODE_SUCCESS) {
					
					Toast.makeText(game_ctx,"登陆成功",Toast.LENGTH_LONG).show();
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.login_session = sessionID;
					login_info.account_uid_str = uid;
					login_info.account_nick_name = uid;
					mCallback3.showWaitingViewImp(false, -1, "已登录");
					notifyLoginResult(login_info);
					
				} else {
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
					login_info.login_session = "";
					login_info.account_uid_str = "";
					login_info.account_nick_name = "";
					isLogined = false;
					notifyLoginResult(login_info);
					
				}
			}
		});

		
		
		
		
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null&&login_info.login_result==PlatformAndGameInfo.enLoginResult_Success) {
			login_info.account_nick_name = login_info.account_uid_str;
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Game2324+login_info.account_uid_str;
			isLogined = true;
			mCallback3.notifyLoginResut(login_result);
		}else{
			
			gameManager.QuickLogin(game_info.app_key, new LoginCallBack() {
				@Override
				public void callback(int code, String arg1, String arg2) {
					if (code == Game2324Manager.LOGIN_CODE_SUCCESS) {
						login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Game2324+login_info.account_uid_str;
						login_info.account_nick_name = login_info.account_uid_str;
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						Toast.makeText(game_ctx, "登录成功",Toast.LENGTH_LONG).show();
						isLogined = true;
						mCallback3.notifyLoginResut(login_info);
					} else {
						login_info.account_uid_str = "";
						isLogined = false;
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
						mCallback3.notifyLoginResut(login_info);
						Toast.makeText(game_ctx, "登陆失败：",Toast.LENGTH_LONG).show();
					}
				}
			});
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
		gameManager.ClearUserInfo();//清除非快速登錄用戶信息
		
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
		String orderExtra = pay_info.description + "-" + pay_info.product_id.split("\\.")[0] + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		gameManager.Recharge(game_ctx, pay_info.price,
				new RechargeCallBack() {
					@Override
					public void callback(String arg0) {
						if (arg0 != null && arg0.length() > 0) {
							
							Toast.makeText(game_ctx,"获取订单：" + arg0, Toast.LENGTH_LONG).show();
							
						} else {
							
							Toast.makeText(game_ctx,"充值失败", Toast.LENGTH_LONG).show();
							
						}
					}
				}, orderExtra);//长度50
		
		
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
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
