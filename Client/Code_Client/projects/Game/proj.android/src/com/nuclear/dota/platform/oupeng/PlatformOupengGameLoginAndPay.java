package com.nuclear.dota.platform.oupeng;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.widget.Toast;

import com.oupeng.mpay.ifmgr.ILoginCallback;
import com.oupeng.mpay.ifmgr.IPayResultCallback;
import com.oupeng.mpay.ifmgr.SDKApi;
import com.oupeng.mpay.tools.PayRequest;
import com.oupeng.openid.IpayAccountApi;
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

public class PlatformOupengGameLoginAndPay implements IPlatformLoginAndPay {
	private static String TAG = PlatformOupengGameLoginAndPay.class
			.getSimpleName();

	private IGameActivity mGameActivity;
	 private IPlatformSDKStateCallback mCallback1;
	 private IGameUpdateStateCallback mCallback2;
	private IGameAppStateCallback mCallback3;
	//
	private Activity game_ctx = null;
	 private GameInfo game_info = null;
	private LoginInfo login_info = null;
	 private VersionInfo version_info = null;
	 private PayInfo pay_info = null;
	 private boolean isLogin = false;
	
	private String exorderno = null; 
//	private String notifyurl = "http://183.237.198.4:8082/monizhuang/api?type=100";
//	public static String appid = "20003800000001200038";
//	public static String appkey = "N0M3NzFFNTFDMUIwMTU2Rjk3RkQ0MDJGOUQ0RTVBOTY5RjZDN0FCNU1URTBNREV4TWpFMk9UZzFOVGc0TXpjMU5ETXJNVEU1T0RFNU9UWTRNek13TWpBNE1EWTFOelk1T0RnMU5Ua3lOVE16TmpjNU56RTRORE01";


	private static PlatformOupengGameLoginAndPay sInstance = null;

	public static PlatformOupengGameLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformOupengGameLoginAndPay();
		}
		return sInstance;
	}
	@Override
	public void onLoginGame() {
		
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		this.mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		game_info.screen_orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
		this.game_info = game_info;
		this.game_ctx
				.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		SDKApi.init(this.game_ctx, SDKApi.PORTRAIT, game_info.app_id_str);
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
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

		PlatformOupengGameLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		if(isLogin){
			return ;
		}
		final String time = System.currentTimeMillis() + "";
		final String sign = IpayAccountApi.getInstance().buildLoginSign(game_info.app_id_str,
				time, game_info.app_key);
		IpayAccountApi.getInstance().loginUI(this.game_ctx, game_info.app_id_str,
				time, sign, new ILoginCallback() {
					@Override
					public void onCallBack(int retcode, String userName,
							String uid, String sign) {
						if (retcode == ILoginCallback.RETCODE_SUCCESS) {
							if (IpayAccountApi.getInstance().checkSignValue(
									game_info.app_id_str, time, userName, uid, game_info.app_key, sign)) {
								// 登录成功，签名验证成功
								LoginInfo login_info = new LoginInfo();
								login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
								login_info.login_session = uid;
//								login_info.account_uid = Long.valueOf(uid);
								login_info.account_uid_str = uid;
								login_info.account_nick_name = userName;
								isLogin = true;
								PlatformOupengGameLoginAndPay.getInstance()
										.notifyLoginResult(login_info);
							} else {
								// 登录成功，签名验证失败
//								Toast.makeText(
//										game_ctx,
//										"APP登录结果:" + userName + "登录成功,验证签名失败！"
//												+ uid, Toast.LENGTH_SHORT)
//										.show();
							}
						} else if (retcode == ILoginCallback.RETCODE_FAIL) {
							// 登录失败
							Toast.makeText(game_ctx, "APP登录结果:" + "登录失败",
									Toast.LENGTH_SHORT).show();
						} else if (retcode == ILoginCallback.RETCODE_CANCEL) {
							// 取消登录
						}
					}
				}, true);
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {

			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Oupeng
					+ login_info.account_uid_str;
			login_result.account_nick_name = "更换帐号";
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		return this.login_info;
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub

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
		this.pay_info = pay_info;
		//pay_info.description + "-" + pay_info.product_id + "-" + 
		exorderno = this.login_info.account_uid_str;
		PayRequest payRequest = new PayRequest();
//		payRequest.addParam("notifyurl", notifyurl);
		payRequest.addParam("quantity ", 1);
		payRequest.addParam("appid", game_info.app_id_str);
		payRequest.addParam("waresid", getYYHPay((int)pay_info.price));
		payRequest.addParam("exorderno", exorderno);
		payRequest.addParam("price", (int)pay_info.price);
		payRequest.addParam("cpprivateinfo", pay_info.description + "-" + pay_info.product_id);
		String paramUrl = payRequest.genSignedUrlParamString(game_info.app_key);
		SDKApi.startPay(game_ctx, paramUrl, new IPayResultCallback() {

			@Override
			public void onPayResult(int arg0, String arg1, String arg2) {
				// TODO Auto-generated method stub
				if (SDKApi.PAY_SUCCESS == arg0) {
					if (null == arg1) {
						// 没有签名值，默认采用finish()，请根据需要修改
						Toast.makeText(game_ctx, "没有签名值", Toast.LENGTH_SHORT)
								.show();
						// finish();
					}
					boolean flag = PayRequest.isLegalSign(arg1, game_info.app_key);
					if (flag) {
						Toast.makeText(game_ctx, "支付成功", Toast.LENGTH_SHORT)
								.show();
						// 合法签名值，支付成功，请添加支付成功后的业务逻辑
						PlatformOupengGameLoginAndPay.getInstance().pay_info.result = 0;
						PlatformOupengGameLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformOupengGameLoginAndPay.getInstance().pay_info);
					} else {
						Toast.makeText(game_ctx, "支付成功，但是验证签名失败",
								Toast.LENGTH_SHORT).show();
						// 非法签名值，默认采用finish()，请根据需要修改
					}
				} else if (SDKApi.PAY_CANCEL == arg0) {
					Toast.makeText(game_ctx, "取消支付", Toast.LENGTH_SHORT).show();
					// 取消支付处理，默认采用finish()，请根据需要修改
				} else {
					Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT).show();
					// 计费失败处理，默认采用finish()，请根据需要修改
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
		{
			return;
		}
		final String time = System.currentTimeMillis() + "";
		final String sign = IpayAccountApi.getInstance().buildLoginSign(game_info.app_id_str,
				time, game_info.app_key);
		IpayAccountApi.getInstance().loginUI(this.game_ctx, game_info.app_id_str,
				time, sign, new ILoginCallback() {
					@Override
					public void onCallBack(int retcode, String userName,
							String uid, String sign) {
						if (retcode == ILoginCallback.RETCODE_SUCCESS) {
							if (IpayAccountApi.getInstance().checkSignValue(
									game_info.app_id_str, time, userName, uid, game_info.app_key, sign)) {
								// 登录成功，签名验证成功
								LoginInfo login_info = new LoginInfo();
								login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
								login_info.login_session = uid;
//								login_info.account_uid = Long.valueOf(uid);
								login_info.account_uid_str = uid;
								login_info.account_nick_name = userName;
								isLogin = true;
								PlatformOupengGameLoginAndPay.getInstance()
										.notifyLoginResult(login_info);
							} else {
								// 登录成功，签名验证失败
//								Toast.makeText(
//										game_ctx,
//										"APP登录结果:" + userName + "登录成功,验证签名失败！"
//												+ uid, Toast.LENGTH_SHORT)
//										.show();
							}
						} else if (retcode == ILoginCallback.RETCODE_FAIL) {
							// 登录失败
							Toast.makeText(game_ctx, "APP登录结果:" + "登录失败",
									Toast.LENGTH_SHORT).show();
						} else if (retcode == ILoginCallback.RETCODE_CANCEL) {
							// 取消登录
						}
					}
				}, true);
		
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
	
	public static String getYYHPay(int pirce){
		String waresid="";
		switch (pirce) {
		case 10:
			waresid = "1";
			break;
		case 30:
			waresid = "2";
			break;
		case 50:
			waresid = "3";
			break;
		case 100:
			waresid = "4";
			break;
		case 200:
			waresid = "5";
			break;
		case 500:
			waresid = "6";
			break;
		case 1000:
			waresid = "7";
			break;
		case 2000:
			waresid ="8";
			break;
		case 5000:
			waresid ="9";
			break;
		default:
			break;
		}
		return waresid;
	}

}
