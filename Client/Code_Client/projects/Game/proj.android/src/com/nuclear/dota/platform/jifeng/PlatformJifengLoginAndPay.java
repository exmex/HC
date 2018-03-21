package com.nuclear.dota.platform.jifeng;

import java.util.Date;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.widget.Toast;

import com.mappn.sdk.common.utils.BaseUtils;
import com.mappn.sdk.pay.GfanConfirmOrderCallback;
import com.mappn.sdk.pay.GfanPay;
import com.mappn.sdk.pay.GfanPayCallback;
import com.mappn.sdk.pay.model.Order;
import com.mappn.sdk.uc.GfanUCCallback;
import com.mappn.sdk.uc.GfanUCenter;
import com.mappn.sdk.uc.User;
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

public class PlatformJifengLoginAndPay implements IPlatformLoginAndPay {
	private static final String TAG = PlatformJifengLoginAndPay.class.getSimpleName();

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
	
	
	private static PlatformJifengLoginAndPay sInstance = null;
	public static PlatformJifengLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformJifengLoginAndPay();
		}
		return sInstance;
	}
	@Override
	public void onLoginGame() {
		
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;

		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_JiFeng;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_JiFeng;
		GfanPay.getInstance(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext()).init();
		GfanPay.getInstance(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext()).confirmPay(new GfanConfirmOrderCallback() {

			public void onExist(Order order) {
				if (order != null) {
					BaseUtils.D(TAG, "订单号为：" + order.getOrderID());
				}
			}

			public void onNotExist() {
				
			}
			
		});
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
		return 0;
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
		this.isLogined = false;
		
		PlatformJifengLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		if(isLogined)
		{
			return;
		}
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		GfanUCenter.login(PlatformJifengLoginAndPay.getInstance().game_ctx, new GfanUCCallback() {

			private static final long serialVersionUID = 8082863654145655537L;

			public void onSuccess(User user, int loginType) {
				// TODO 登录成功处理
				Toast.makeText(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext(),
						"登录成功 ", Toast.LENGTH_SHORT)
						.show();
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = user.getToken();
				login_info.account_uid_str = String.valueOf(user.getUid());
				login_info.account_uid = user.getUid();
				login_info.account_nick_name = user.getUserName();
				//
				isLogined = true;
				GfanPay.submitLogin(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext());
				PlatformJifengLoginAndPay.getInstance().notifyLoginResult(login_info);
				callback.showWaitingViewImp(false, -1, "");
			}

			public void onError(int loginType) {
				if(GfanUCenter.RETURN_TYPE_LOGIN==loginType)
				{
					Toast.makeText(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext(), "登录失败",
							Toast.LENGTH_SHORT).show();
				}
				callback.showWaitingViewImp(false, -1, "");
			}
		});
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_JiFeng+login_info.account_uid_str;
			
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
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
		// TODO Auto-generated method stub
		//if (Cocos2dxHelper.nativeHasEnterMainFrame())
		//	return;
		GfanUCenter.logout(PlatformJifengLoginAndPay.getInstance().game_ctx);
		isLogined = false;
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
		String temp = pay_info.description + "-" + pay_info.product_id.substring(0, pay_info.product_id.indexOf(".")) + "-" + this.login_info.account_uid+"-"+(int)((new Date()).getTime()/1000);//区号-物品ID-ouruserid=orderserial
		Order order = new Order(pay_info.product_name, pay_info.description, (int)pay_info.price*10, temp);//
		GfanPay.getInstance(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext()).pay(order,
				new GfanPayCallback() {

					public void onSuccess(User user, Order order) {
						Toast.makeText(
								PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext(),
								"支付成功 user：" + user.getUserName() + "金额："
										+ order.getMoney(), Toast.LENGTH_SHORT)
								.show();
						if (PlatformJifengLoginAndPay.getInstance().pay_info != null)
						{
							PlatformJifengLoginAndPay.getInstance().pay_info.result = 0;
							
							notifyPayRechargeRequestResult(PlatformJifengLoginAndPay.getInstance().pay_info);
						}
					}

					public void onError(User user) {
						if (user != null) {
							Toast.makeText(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext(),
									"未完成支付",
									Toast.LENGTH_SHORT).show();
						} else {
							Toast.makeText(PlatformJifengLoginAndPay.getInstance().game_ctx.getApplicationContext(), "用户未登录",
									Toast.LENGTH_SHORT).show();
							PlatformJifengLoginAndPay.getInstance().isLogined = false;
							PlatformJifengLoginAndPay.getInstance().callLogin();
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
		if (PlatformJifengLoginAndPay.getInstance().isLogined)
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
