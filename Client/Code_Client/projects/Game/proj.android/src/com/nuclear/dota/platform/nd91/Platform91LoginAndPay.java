/*
 * utf-8 encoding
 * */

package com.nuclear.dota.platform.nd91;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.widget.Toast;

import com.nd.commplatform.NdCallbackListener;
import com.nd.commplatform.NdCommplatform;
import com.nd.commplatform.NdErrorCode;
import com.nd.commplatform.NdMiscCallbackListener;
import com.nd.commplatform.NdMiscCallbackListener.OnPlatformBackground;
import com.nd.commplatform.NdMiscCallbackListener.OnSessionInvalidListener;
import com.nd.commplatform.NdMiscCallbackListener.OnSwitchAccountListener;
import com.nd.commplatform.NdPageCallbackListener.OnExitCompleteListener;
import com.nd.commplatform.NdPageCallbackListener.OnPauseCompleteListener;
import com.nd.commplatform.OnInitCompleteListener;
import com.nd.commplatform.entry.NdAppInfo;
import com.nd.commplatform.entry.NdBuyInfo;
import com.nd.commplatform.gc.widget.NdToolBar;
import com.nd.commplatform.gc.widget.NdToolBarPlace;
import com.tendcloud.tenddata.TDGAAccount;
import com.tendcloud.tenddata.TalkingDataGA;
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

public class Platform91LoginAndPay implements IPlatformLoginAndPay {

	private static final String TAG = Platform91LoginAndPay.class
			.getSimpleName();

	private IGameActivity mGameActivity;
	private IPlatformSDKStateCallback mCallback1;
	private IGameUpdateStateCallback mCallback2;
	private IGameAppStateCallback mCallback3;

	private Activity game_ctx = null;
	private GameInfo game_info = null;
	private LoginInfo login_info = null;
	private VersionInfo version_info = null;
	private PayInfo pay_info = null;

	private int auto_recalllogin_count = 0;
	private boolean platform_ui_hide = false;

	private static Platform91LoginAndPay sInstance = null;

	private NdToolBar mNd91ToolBar;
	
	public static Platform91LoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new Platform91LoginAndPay();
		}
		return sInstance;
	}

	private Platform91LoginAndPay() {

	}

	public int getPlatformLogoLayoutId() {
		// return R.layout.logo_nuclear;
		return -1;
	}

	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {

		mGameActivity = game_acitivity;

		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;
		game_info.use_platform_sdk_type = 1;// 0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = NdCommplatform.SCREEN_ORIENTATION_PORTRAIT;
		//
		if (game_info.debug_mode == PlatformAndGameInfo.enDebugMode_Debug) {
			NdCommplatform.getInstance().ndSetDebugMode(0);// 设置调试模式
		}
		//
		NdCommplatform.getInstance().setRestartWhenSwitchAccount(false);
		//
		NdCommplatform.getInstance().ndSetScreenOrientation(
				this.game_info.screen_orientation);
		//
		NdAppInfo appInfo = new NdAppInfo();
		appInfo.setCtx(this.game_ctx);
		appInfo.setAppId(this.game_info.app_id);// 应用ID
		appInfo.setAppKey(this.game_info.app_key);// 应用Key
		//
		// NdCommplatform.getInstance().initial(0, appInfo); //初始�?1SDK

		final IPlatformSDKStateCallback callback1 = mCallback1;

		NdCommplatform.getInstance().ndInit(game_ctx, appInfo,
				new OnInitCompleteListener() {

					@Override
					protected void onComplete(int arg0) {

						callback1.notifyInitPlatformSDKComplete();
					}

				});

		//
		NdCommplatform.getInstance().setOnPlatformBackground(
				new OnPlatformBackground() {
					@Override
					public void onPlatformBackground() {

						platform_ui_hide = true;
						Log.d(TAG, "NdCommplatform.onPlatformBackground");
					}
				});
		//
		NdCommplatform.getInstance().setOnSwitchAccountListener(
				new OnSwitchAccountListener() { // 设置玩家在社区界面�?择注�?��号时的监听事�?
					@Override
					public void onSwitchAccount(int code) {
						if (code == NdErrorCode.ND_COM_PLATFORM_ERROR_USER_SWITCH_ACCOUNT) {
							// 玩家点击社区注销账号并确定注�?��号时，捕捉该状�?，此时可保存被注�?��家的游戏数据
							// 有捕捉到该状态说明游戏不会重启，而只是单纯的切换到登录界面由玩家用新的账号登�?
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"玩家将要注销帐号", Toast.LENGTH_SHORT).show();
						} else if (code == NdErrorCode.ND_COM_PLATFORM_ERROR_USER_RESTART) {
							// 玩家点击社区注销账号并确定注�?��号时，捕捉该状�?，此时可保存被注�?��家的游戏数据
							// 有捕捉到该状态说明游戏接下去会进行重�?
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"游戏将重新启动", Toast.LENGTH_SHORT).show();
						} else if (code == NdErrorCode.ND_COM_PLATFORM_SUCCESS) {
							// 玩家点击社区注销账号按钮输入新的账号并登录成功时可捕捉该状�?，此时可初始化新玩家的游戏数�?
							LoginInfo login_info = new LoginInfo();
							login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
							login_info.login_session = NdCommplatform
									.getInstance().getSessionId();
							login_info.account_uid_str = NdCommplatform
									.getInstance().getLoginUin();
							login_info.account_uid = Long
									.parseLong(login_info.account_uid_str);
							login_info.account_nick_name = NdCommplatform
									.getInstance().getLoginNickName();
							//
							Platform91LoginAndPay.getInstance()
									.notifyLoginResult(login_info);
							//
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"新帐号登录成功", Toast.LENGTH_SHORT).show();
						} else if (code == NdErrorCode.ND_COM_PLATFORM_ERROR_CANCEL) {
							// 玩家点击社区注销账号按钮但未输入新账号登录，而是�?��界面可捕捉此状�?
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"取消帐号登录", Toast.LENGTH_SHORT).show();
						} else {
							// 玩家点击社区注销账号按钮输入新的账号并登录失败时可捕捉此状�?
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"帐号登录失败", Toast.LENGTH_SHORT).show();
						}
					}
				});
		//
		NdCommplatform.getInstance().setOnSessionInvalidListener(
				new OnSessionInvalidListener() {
					@Override
					public void onSessionInvalid() {

						//Platform91LoginAndPay.getInstance().callLogin();
						Toast.makeText(
								Platform91LoginAndPay.getInstance().game_ctx,
								"会话失效，请重新登录", Toast.LENGTH_SHORT).show();
					}
				});

		try {
			ApplicationInfo info = Platform91LoginAndPay.getInstance().game_ctx
					.getPackageManager()
					.getApplicationInfo(
							Platform91LoginAndPay.getInstance().game_ctx
									.getPackageName(),
							PackageManager.GET_META_DATA);
			TalkingDataGA.init(Platform91LoginAndPay.getInstance().game_ctx,
					info.metaData.getString("TDGA_APP_ID"),
					info.metaData.getString("TDGA_CHANNEL_ID"));
		} catch (NameNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		//
		// mCallback1.notifyInitPlatformSDKComplete();
		
		//悬浮工具条
		mNd91ToolBar = NdToolBar.create(game_ctx, NdToolBarPlace.NdToolBarRightMid);
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
		
		if(this.mNd91ToolBar!=null){
			this.mNd91ToolBar.recycle();
			this.mNd91ToolBar=null;
		}
		
		//
		NdCommplatform.getInstance().destory();
		//
		Platform91LoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {

		return this.game_info;
	}

	@Override
	public void callLogin() {

		Log.d(TAG, "NdCommplatform.getInstance().ndLogin");

		if (NdCommplatform.getInstance().isLogined())
			return;

		// try {

		final IGameAppStateCallback callback = mCallback3;

		callback.showWaitingViewImp(true, -1, "正在登录");

		NdCommplatform.getInstance().ndLogin(this.game_ctx,
				new NdMiscCallbackListener.OnLoginProcessListener() {

					@Override
					public void finishLoginProcess(int code) {
						String tip = "";
						// 登录的返回码�?��
						Log.d(Platform91LoginAndPay.TAG,
								"NdCommplatform.getInstance().ndLogin, responseCode: "
										+ String.valueOf(code));
						if (code == NdErrorCode.ND_COM_PLATFORM_SUCCESS) {
							tip = "登录成功，点击进入游戏";
							// 账号登录成功，测试可用初始化玩家游戏数据
							// 有购买漏单的此时可向玩家补发相关的道�?
							LoginInfo login_info = new LoginInfo();
							login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
							login_info.login_session = NdCommplatform
									.getInstance().getSessionId();
							login_info.account_uid_str = NdCommplatform
									.getInstance().getLoginUin();
							login_info.account_uid = Long
									.parseLong(login_info.account_uid_str);
							login_info.account_nick_name = NdCommplatform
									.getInstance().getLoginNickName();
							//
							Platform91LoginAndPay.getInstance()
									.notifyLoginResult(login_info);
							try
							{
							TDGAAccount.setAccount(TalkingDataGA
									.getDeviceId(Platform91LoginAndPay
											.getInstance().game_ctx));
							}catch(Exception e)
							{
							}
							//
						} else if (code == NdErrorCode.ND_COM_PLATFORM_ERROR_CANCEL) {
							tip = "取消登录";
							callback.showWaitingViewImp(false, -1, "");
						} else {
							tip = "91SDK登录失败，错误代码：" + code;
							tip = tip + "，正在重试，请稍后";
							if (Platform91LoginAndPay.getInstance().auto_recalllogin_count < 5) {
								Platform91LoginAndPay.getInstance().auto_recalllogin_count++;

								try {
									Thread.sleep(2000);
								} catch (InterruptedException e) {
									//
									e.printStackTrace();
								}

								// if
								// (Platform91LoginAndPay.getInstance().auto_recalllogin_count
								// >= 2)
								Platform91LoginAndPay.getInstance().callLogin();
							} else {
								tip = "91SDK登录失败，请检查手机网络，并重新启动游戏";
								callback.showWaitingViewImp(false, -1, "");
							}
						}

						Toast.makeText(
								Platform91LoginAndPay.getInstance().game_ctx,
								tip, Toast.LENGTH_SHORT).show();
					}
				});

		// }
		// catch (Exception e) {
		// e.printStackTrace();
		// }
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {

		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			if(login_info.login_result == PlatformAndGameInfo.enLoginResult_Success)
			{
				
				mNd91ToolBar.show();
			}
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_91
					+ login_info.account_uid_str;

			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {

		if (login_info != null) {
			if (NdCommplatform.getInstance().isLogined())
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			else
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}

		return login_info;
	}

	@Override
	public void callLogout() {

		// LOGOUT_TO_RESET_AUTO_LOGIN_CONFIG
		NdCommplatform.getInstance().ndLogout(
				NdCommplatform.LOGOUT_TO_NON_RESET_AUTO_LOGIN_CONFIG, game_ctx);
	}

	@Override
	public void callCheckVersionUpate() {

		NdCallbackListener<Integer> callback = new NdCallbackListener<Integer>() {

			@Override
			public void callback(int responseCode, Integer t) {
				Log.d(Platform91LoginAndPay.TAG,
						"callCheckVersionUpate, responseCode: "
								+ String.valueOf(responseCode)
								+ ", update status: " + String.valueOf(t));
				if (responseCode == NdErrorCode.ND_COM_PLATFORM_SUCCESS) {
					switch (t) {
						case NdCommplatform.UPDATESTATUS_NONE: {
							// 本地已是�?��版本，此时玩家可直接进入游戏
							VersionInfo version_info = new VersionInfo();
							version_info.update_info = PlatformAndGameInfo.enUpdateInfo_No;
							Platform91LoginAndPay.getInstance()
									.notifyVersionUpateInfo(version_info);
							break;
						}
						case NdCommplatform.UPDATESTATUS_UNMOUNTED_SDCARD: {
							// 玩家手机无SD卡，不进行更�?
							VersionInfo version_info = new VersionInfo();
							version_info.update_info = PlatformAndGameInfo.enUpdateInfo_No;
							Platform91LoginAndPay.getInstance()
									.notifyVersionUpateInfo(version_info);
							break;
						}
						case NdCommplatform.UPDATESTATUS_CANCEL_UPDATE: {
							// 玩家取消更新，此时玩家可继续玩旧版本的游�?
							VersionInfo version_info = new VersionInfo();
							version_info.update_info = PlatformAndGameInfo.enUpdateInfo_No;
							Platform91LoginAndPay.getInstance()
									.notifyVersionUpateInfo(version_info);
							break;
						}
						case NdCommplatform.UPDATESTATUS_CHECK_FAILURE: {
							// 新版本检查失�?
							VersionInfo version_info = new VersionInfo();
							version_info.update_info = PlatformAndGameInfo.enUpdateInfo_No;
							Platform91LoginAndPay.getInstance()
									.notifyVersionUpateInfo(version_info);
							break;
						}
						case NdCommplatform.UPDATESTATUS_FORCES_LOADING: {
							// 玩家选择了强制更新，此时如果说游戏要在新版本才能玩的话，可强制玩家推出游戏，等下载安装完后再继续�?
							// 此时会在手机桌面的的消息通知栏下载本游戏的最新版�?
							VersionInfo version_info = new VersionInfo();
							version_info.update_info = PlatformAndGameInfo.enUpdateInfo_Force;
							Platform91LoginAndPay.getInstance()
									.notifyVersionUpateInfo(version_info);
	
							break;
						}
						case NdCommplatform.UPDATESTATUS_RECOMMEND_LOADING: {
							// 玩家选择了推荐更新，此时会在手机桌面的的消息通知栏下载本游戏的最新版本，不影响玩家继续玩本游戏，等下载完成后玩家可自行安�?
							/*
							 * VersionInfo version_info = new VersionInfo();
							 * version_info.update_info =
							 * PlatformAndGameInfo.enUpdateInfo_Suggest;
							 * Platform91LoginAndPay
							 * .getInstance().notifyVersionUpateInfo(version_info);
							 */
							AlertDialog dlg = new AlertDialog.Builder(
									Platform91LoginAndPay.getInstance().game_ctx)
									.setTitle("提示")
									.setMessage(
											"游戏已经开始下载，请在手机消息通知栏查看下载状态。（从屏幕最上方往下滑打开状态栏）")
									.setPositiveButton("确定",
											new DialogInterface.OnClickListener() {
												@Override
												public void onClick(
														DialogInterface dialog,
														int which) {
													System.exit(0);
	
												}
											})
									.setOnCancelListener(
											new DialogInterface.OnCancelListener() {
	
												@Override
												public void onCancel(
														DialogInterface dialog) {
													System.exit(0);
												}
	
											}).create();
							dlg.show();
						}
					}
				} else {

					Toast.makeText(
							Platform91LoginAndPay.getInstance().game_ctx,
							"91SDK检查游戏更新失败", Toast.LENGTH_LONG).show();
				}
				//
			}

		};
		// 91SDK�?��游戏版本更新
		// 更新91SDK NdComPlatformSDK_UI_android_20130829_3.2.6.1废了这个接口
		// NdCommplatform.getInstance().ndAppVersionUpdate(this.game_ctx,
		// callback);
		// 另见SDK有不带提示及下载功能的ndCheckVersionUpdate使用方法
		VersionInfo version_info = new VersionInfo();
		version_info.update_info = PlatformAndGameInfo.enUpdateInfo_No;
		Platform91LoginAndPay.getInstance()
			.notifyVersionUpateInfo(version_info);
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

		NdBuyInfo buy_info = new NdBuyInfo();
		buy_info.setSerial(pay_info.order_serial);
		buy_info.setProductId(pay_info.product_id);
		buy_info.setProductName(pay_info.product_name);
		buy_info.setProductPrice(pay_info.price);
		buy_info.setProductOrginalPrice(pay_info.orignal_price);
		buy_info.setCount(pay_info.count);
		// buy_info.setPayDescription("1");//对应91通知gamesvr的note字段
		buy_info.setPayDescription(pay_info.description);// 客户端区号
		//
		this.pay_info = null;
		this.pay_info = pay_info;
		//
		int aError = NdCommplatform.getInstance().ndUniPayAsyn(buy_info,
				game_ctx, new NdMiscCallbackListener.OnPayProcessListener() {
					@Override
					public void finishPayProcess(int code) {
						switch (code) {
						case NdErrorCode.ND_COM_PLATFORM_SUCCESS:
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"购买成功", Toast.LENGTH_SHORT).show();
							break;
						case NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_FAILURE:
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"购买失败", Toast.LENGTH_SHORT).show();
							break;
						case NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_CANCEL:
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"取消购买", Toast.LENGTH_SHORT).show();
							break;
						case NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_ASYN_SMS_SENT:
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"订单已提交，充值短信已发送", Toast.LENGTH_SHORT).show();
							code = 0;
							break;
						case NdErrorCode.ND_COM_PLATFORM_ERROR_PAY_REQUEST_SUBMITTED:
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"订单已提交", Toast.LENGTH_SHORT).show();
							code = 0;
							break;
						default:
							Toast.makeText(
									Platform91LoginAndPay.getInstance().game_ctx,
									"购买失败", Toast.LENGTH_SHORT).show();
						}
						//
						Platform91LoginAndPay.getInstance().pay_info.result = code;
						Platform91LoginAndPay
								.getInstance()
								.notifyPayRechargeRequestResult(
										Platform91LoginAndPay.getInstance().pay_info);
					}
				});
		//
		if (aError != 0) {
			Toast.makeText(game_ctx, "您输入参数有错，无法提交购买请求", Toast.LENGTH_SHORT)
					.show();
			this.pay_info.result = aError;
			notifyPayRechargeRequestResult(this.pay_info);
		}
		//
		return aError;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {

		mCallback3.notifyPayRechargeResult(pay_info);
		//
	}

	@Override
	public void callAccountManage() {

		if (Cocos2dxHelper.nativeHasEnterMainFrame())
			NdCommplatform.getInstance().setRestartWhenSwitchAccount(true);

		NdCommplatform.getInstance().ndEnterPlatform(0, this.game_ctx);
	}

	@Override
	public String generateNewOrderSerial() {

		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {

		NdCommplatform.getInstance().ndUserFeedback(this.game_ctx);
	}

	@Override
	public void callPlatformSupportThirdShare(ShareInfo share_info) {

		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}

		NdCommplatform.getInstance().ndShareToThirdPlatform(game_ctx,
				share_info.content, share_info.bitmap);
	}

	@Override
	public void onLoginGame() {
		NdCommplatform.getInstance().setRestartWhenSwitchAccount(true);
	}
	
	@Override
	public void callPlatformGameBBS() {

		NdCommplatform.getInstance().ndEnterAppBBS(game_ctx, 0);
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
		/*
		 * 2013-06-23 Ver3.2.5.1SDK的init自动发起了更新检查，但没有单独的回调
		 * 91要求用其ndinit接口自动调用的更新检查，故不设置SupportUpdateCheckAndDownload了
		 */
		return PlatformAndGameInfo.SupportUpdateCheckAndDownload;
	}

	@Override
	public void onGameExit() {

		NdCommplatform.getInstance().ndExit(
				new OnExitCompleteListener(this.game_ctx) {

					@Override
					public void onComplete() {
						mGameActivity.requestDestroy();
					}
				});
	}

	@Override
	public void onGamePause() {
		platform_ui_hide = false;
		try
		{
			TalkingDataGA.onPause(Platform91LoginAndPay.getInstance().game_ctx);
		}
		catch(Exception e)
		{
			
		}
	}

	@Override
	public void onGameResume() {
		
		try
		{
			TalkingDataGA.onResume(Platform91LoginAndPay.getInstance().game_ctx);
		}catch(Exception e)
		{
			
		}

		if (platform_ui_hide) {
			return;
		}

		NdCommplatform.getInstance().ndPause(
				new OnPauseCompleteListener(this.game_ctx) {

					@Override
					public void onComplete() {

						platform_ui_hide = false;
					}

				});
	}

	@Override
	public void callToolBar(boolean visible) {
		
		NdCommplatform.getInstance().setRestartWhenSwitchAccount(true);
		
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
