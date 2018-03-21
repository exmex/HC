package com.nuclear.dota.platform.DK;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.util.Log;
import android.widget.Toast;

import com.duoku.platform.DkErrorCode;
import com.duoku.platform.DkPlatform;
import com.duoku.platform.DkPlatformSettings;
import com.duoku.platform.DkPlatformSettings.GameCategory;
import com.duoku.platform.DkProCallbackListener;
import com.duoku.platform.DkProCallbackListener.OnExitChargeCenterListener;
import com.duoku.platform.DkProCallbackListener.OnLoginProcessListener;
import com.duoku.platform.entry.DkBaseUserInfo;
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

public class PlatformDuokuLoginAndPay implements IPlatformLoginAndPay {

private static final String TAG = PlatformDuokuLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	private boolean						isLogined = false;
	
	
	private static PlatformDuokuLoginAndPay sInstance = null;
	public static PlatformDuokuLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformDuokuLoginAndPay();
		}
		return sInstance;
	}
	
	@Override
	public void onLoginGame() {
			// TODO Auto-generated method stub
			
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		
		
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_BaiduDuoKu;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_BaiduDuoKu;
		
		/*DkPlatformSettings appInfo = new DkPlatformSettings(); 
		appInfo.setGameCategory(GameCategory.ONLINE_Game);
		appInfo.setmAppid(String.valueOf(game_info.app_id));
		appInfo.setmAppkey(game_info.app_key); 
		
		DkPlatform.getInstance().init(this.game_ctx, appInfo);
		int orient = DkPlatformSettings.SCREEN_ORIENTATION_PORTRAIT;
		DkPlatform.getInstance().dkSetScreenOrientation(orient);*/
		
		
		
		DkPlatform.getInstance().dkSetOnUserLogoutListener(new 
				DkProCallbackListener.OnUserLogoutLister() {
				@Override
				public void onUserLogout() {
				
					if(Cocos2dxHelper.nativeHasEnterMainFrame())
					{
						AlertDialog dlg = new AlertDialog.Builder(PlatformDuokuLoginAndPay.getInstance().game_ctx)
						.setTitle("提示")
						.setMessage("您已退出账号登录，请重新进入游戏!")
						.setPositiveButton("确定", new DialogInterface.OnClickListener()
						{
							@Override
							public void onClick(DialogInterface dialog, int which)
							{
								//System.exit(0);
								android.os.Process.killProcess(android.os.Process.myPid());
							}
						}).setOnCancelListener(new DialogInterface.OnCancelListener()
						{

							@Override
							public void onCancel(DialogInterface dialog)
							{	
								android.os.Process.killProcess(android.os.Process.myPid());
								//System.exit(0);
							}
					
						}).create();
						dlg.show();
					}
					else
					{
						isLogined = false;	
						callLogin();
					}
				} 
		});
		
		 mCallback1.notifyInitPlatformSDKComplete();
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
		
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		
		return R.layout.logo_duoku;
		
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
		
		PlatformDuokuLoginAndPay.sInstance = null;
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
		DkPlatform.getInstance().dkLogin(this.game_ctx, new OnLoginProcessListener() {
				
				@Override
				public void onLoginProcess(int paramInt) {
					
					
					switch (paramInt) {
					case DkErrorCode.DK_LOGIN_SUCCESS:
						Toast.makeText(PlatformDuokuLoginAndPay.getInstance().game_ctx, "登录成功，点击进入游戏", Toast.LENGTH_LONG).show();
						DkBaseUserInfo baseInfo = DkPlatform.getInstance().dkGetMyBaseInfo(PlatformDuokuLoginAndPay.getInstance().game_ctx);
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.login_session = baseInfo.getSessionId();
						login_info.account_uid_str = baseInfo.getUid();
						login_info.account_uid = Long.parseLong(login_info.account_uid_str);
						login_info.account_nick_name = baseInfo.getUserName();
						//
						isLogined = true;
						PlatformDuokuLoginAndPay.getInstance().notifyLoginResult(login_info);
						callback.showWaitingViewImp(false, -1, "");
						break;
	
					default:
						callback.showWaitingViewImp(false, -1, "");
						break;
					}
				}
			});
	
	}

	
	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_BaiduDuoKu+login_info.account_uid_str;
			
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		
		if (login_info != null) {
			if(DkPlatform.getInstance().dkIsLogined())
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
				
		DkPlatform.getInstance().dkSetOnUserLogoutListener(new DkProCallbackListener.OnUserLogoutLister() {
					
					@Override
					public void onUserLogout() {
						
						Toast.makeText(PlatformDuokuLoginAndPay.getInstance().game_ctx, "注销成功", Toast.LENGTH_LONG).show();
						isLogined = false;
						callLogin();
					}
				});
	}

	@Override
	public void callCheckVersionUpate() {
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
		
	OnExitChargeCenterListener mOnExitChargeCenterListener = new OnExitChargeCenterListener() {
			
			// 此处的orderid是调用充值接口时开发者传入的，原样返回
			@Override
			public void doOrderCheck(boolean needcheck, String orderid) {
				// TODO Auto-generated method stub
				Log.d("test", "orderid == " + orderid);
				if(needcheck) {
				//	Toast.makeText(game_ctx, "退出充值中心, 请注意查询订单的支付状态！", Toast.LENGTH_LONG).show();
				}else {
					//Toast.makeText(game_ctx, "无需查询订单状态！", Toast.LENGTH_LONG).show();
				}
					
			}
		};
	 //payDesc参数若不需要，可传入空串
		String temp = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		int price = (int)pay_info.price;
		pay_info.order_serial = generateNewOrderSerial();
		DkPlatform.getInstance().dkUniPayForCoin(PlatformDuokuLoginAndPay.getInstance().game_ctx, 10, "钻石", pay_info.order_serial, price, temp,
				mOnExitChargeCenterListener);
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
			mGameActivity.showToastMsg("暂未开通,敬请期待!");
			return;
		}
		if (DkPlatform.getInstance().dkIsLogined()){
			DkPlatform.getInstance().dkAccountManager(game_ctx);
		}else{
		callLogin();
		}
		
		if(!isLogined)
		{
			callLogin();
			return;
		}
	}

	@Override
	public String generateNewOrderSerial() {
		
		return UUID.randomUUID().toString();
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
		
		
	}

	@Override
	public void callPlatformGameBBS() {
		
		
	}

	@Override
	public void onGameExit() {
		

	}

	@Override
	public void onGamePause() {
		
		
	}

	@Override
	public void onGameResume() {
		
		
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		
		mCallback1 = callback1;
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
