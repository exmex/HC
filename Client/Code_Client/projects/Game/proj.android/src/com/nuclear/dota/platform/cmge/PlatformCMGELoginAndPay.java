package com.nuclear.dota.platform.cmge;


import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.os.Handler;
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
import com.zz.sdk.LoginCallbackInfo;
import com.zz.sdk.MSG_STATUS;
import com.zz.sdk.MSG_TYPE;
import com.zz.sdk.PaymentCallbackInfo;
import com.zz.sdk.SDKManager;

public class PlatformCMGELoginAndPay implements IPlatformLoginAndPay {

	private static final int _MSG_USER_ = 2013;
	private static final int MSG_LOGIN_CALLBACK = _MSG_USER_ + 1;
	private static final int MSG_PAYMENT_CALLBACK = _MSG_USER_ + 2;
	private static final int MSG_ORDER_CALLBACK = _MSG_USER_ + 3;

	private static PlatformCMGELoginAndPay mInstance = null;
	private SDKManager mSDKManager = null;

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
	private boolean isCloseWindow = true;

	private Handler mHandler = new Handler() {
		public void handleMessage(android.os.Message msg) {
			switch (msg.what) {
			case MSG_LOGIN_CALLBACK: {
				if (msg.arg1 == MSG_TYPE.LOGIN) {

					if (msg.arg2 == MSG_STATUS.SUCCESS) {
						if (msg.obj instanceof LoginCallbackInfo) {
							LoginCallbackInfo info = (LoginCallbackInfo) msg.obj;
							LoginInfo login_info = new LoginInfo();
							login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
							login_info.account_nick_name = info.loginName;
							login_info.account_uid_str = info.loginName;
							login_info.login_session = info.loginName;
							PlatformCMGELoginAndPay.this
									.notifyLoginResult(login_info);
						} else {
							// 设计上这里是不可能到达的
						}
					} else if (msg.arg2 == MSG_STATUS.CANCEL) {
						// pushLog(" - 用户取消了登录.");
						mGameActivity.showToastMsg("取消了登录");
					} else if (msg.arg2 == MSG_STATUS.EXIT_SDK) {
						// pushLog(" - 登录业务结束。");
					} else {
						// pushLog(" ! 未知登录结果，请检查：s=" + msg.arg2 + " info:"
						// + msg.obj);
					}
				} else {
					// pushLog(" # 未知类型 t=" + msg.arg1 + " s=" + msg.arg2
					// + " info:" + msg.obj);
				}
			}
				break;

			case MSG_PAYMENT_CALLBACK: {
				if (msg.arg1 == MSG_TYPE.PAYMENT) {
					PaymentCallbackInfo info; // 支付信息

					if (msg.obj instanceof PaymentCallbackInfo) {
						info = (PaymentCallbackInfo) msg.obj;
						// ordernumber = info.cmgeOrderNumber;
					} else {
						info = null;
					}
					
					if (msg.arg2 == MSG_STATUS.SUCCESS) {
						Toast.makeText(game_ctx, "支付成功", Toast.LENGTH_SHORT)
								.show();
						PlatformCMGELoginAndPay.getInstance().pay_info.result = 0;
						PlatformCMGELoginAndPay
								.getInstance()
								.notifyPayRechargeRequestResult(
										PlatformCMGELoginAndPay.getInstance().pay_info);
						Log.v("CMGE", msg.toString()+"    "+pay_info.toString());
					} else if (msg.arg2 == MSG_STATUS.FAILED) {
						Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT)
								.show();
					} else if (msg.arg2 == MSG_STATUS.CANCEL) {
						Toast.makeText(game_ctx, "取消支付", Toast.LENGTH_SHORT)
								.show();
					} else if (msg.arg2 == MSG_STATUS.EXIT_SDK) {
						Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT)
								.show();
					} else {
						Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT)
								.show();
					}
				} else {
					Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT).show();
				}

			}
				break;

			case MSG_ORDER_CALLBACK: {
				PaymentCallbackInfo info = (PaymentCallbackInfo) msg.obj;
				// Log.d(DBG_TAG, "zz_sdk" + "info----- : " + info.toString());
				// Log.d(DBG_TAG, "---------订单查询-------");
				// pushLog(info.toString(), msg.arg1, msg.arg2);
			}
				break;
			}
		}
	};

	private PlatformCMGELoginAndPay() {

	}

	public static PlatformCMGELoginAndPay getInstance() {
		if (mInstance == null) {
			mInstance = new PlatformCMGELoginAndPay();
		}
		return mInstance;
	}

	@Override
	public void onLoginGame() {
		
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		mSDKManager = SDKManager.getInstance(this.game_ctx);
		mSDKManager.setConfigInfo(true, true, true);

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
		mGameActivity = null;
		mCallback1 = null;
		mCallback2 = null;
		mCallback3 = null;
		//
		this.game_ctx = null;
		this.game_info = null;
		this.login_info = null;
		this.pay_info = null;
		this.version_info = null;

		SDKManager.recycle();
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		if (mSDKManager.isLogined()) {
			return;
		}
		mSDKManager.showLoginView(mHandler, MSG_LOGIN_CALLBACK);
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {

			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_CMGE
					+ login_info.account_nick_name;

			mCallback3.notifyLoginResut(login_result);
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
		this.pay_info = pay_info;
		// int amount= (int)this.pay_info.price*100;
		int amount = 1;
		String gameRole = pay_info.description + "-" + pay_info.product_id
				+ "-" + this.login_info.account_uid_str;// 区号-物品ID-ouruserid

		mSDKManager.showPaymentView(mHandler, MSG_PAYMENT_CALLBACK,
				this.game_info.app_id_str, "安卓", login_info.account_nick_name,
				gameRole, amount, isCloseWindow, "");
		Log.v("CMGE", "login_info.account_nick_name:"+login_info.account_nick_name
				+"  gameRole:"+gameRole);

		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		mSDKManager.showLoginView(mHandler, MSG_LOGIN_CALLBACK);

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
		// TODO Auto-generated method stub

	}

	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub

	}

}
