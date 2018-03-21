package com.nuclear.dota.platform.baidumobile;

import java.security.MessageDigest;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.util.Log;
import android.widget.Toast;

import com.baifubao.mpay.ifmgr.ILoginCallback;
import com.baifubao.mpay.ifmgr.IPayResultCallback;
import com.baifubao.mpay.ifmgr.SDKApi;
import com.baifubao.mpay.tools.PayRequest;
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
import com.youai.sdk.active.GameTalkDialog;

public class PlatformBaiDuMobileGameLoginAndPay implements IPlatformLoginAndPay {

	public static final String LOG_TAG = "BaiduMobile";

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
	private boolean isLogin = false;

	private static PlatformBaiDuMobileGameLoginAndPay mInstance = null;

	private PlatformBaiDuMobileGameLoginAndPay() {

	}

	public static PlatformBaiDuMobileGameLoginAndPay getInstance() {
		if (mInstance == null) {
			mInstance = new PlatformBaiDuMobileGameLoginAndPay();
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
		game_info.screen_orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
		this.game_info = game_info;
		this.game_ctx
				.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		SDKApi.init(this.game_ctx, game_info.screen_orientation,
				this.game_info.app_id_str);

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
		// TODO
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
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

		PlatformBaiDuMobileGameLoginAndPay.mInstance = null;

	}

	@Override
	public GameInfo getGameInfo() {

		return this.game_info;
	}

	@Override
	public void callLogin() {
		Log.v(LOG_TAG, "callLogin");

		final String time = System.currentTimeMillis() + "";
		final String sign = MD5(Sign(game_info.app_id_str, game_info.app_key,
				time));
		SDKApi.loginUI(game_ctx, game_info.app_id_str, time, sign,
				new ILoginCallback() {

					@Override
					public void onCallBack(int retcode, String userName,
							long uid, String sign) {
						if (retcode == ILoginCallback.RETCODE_SUCCESS) {

							String orderEnc = MD5(Sign_Login_Callback(
									game_info.app_id_str, game_info.app_key,
									time, userName, uid));
							if (sign.equalsIgnoreCase(orderEnc)) {
								LoginInfo login_info = new LoginInfo();
								login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
								login_info.login_session = String.valueOf(uid);
								login_info.account_uid_str = String
										.valueOf(uid);
								login_info.account_uid = uid;
								login_info.account_nick_name = userName;
								PlatformBaiDuMobileGameLoginAndPay
										.getInstance().notifyLoginResult(
												login_info);
							} else {
								Toast.makeText(
										game_ctx,
										"APP登录结果:" + userName + "登录成功,验证签名失败！"
												+ uid, Toast.LENGTH_SHORT)
										.show();
							}

						} else if (retcode == ILoginCallback.RETCODE_FAIL) {
							if (isLogin)
								return;
							else
								Toast.makeText(game_ctx, "APP登录结果:" + "登录失败",
										Toast.LENGTH_SHORT).show();
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

			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_BaiDuMobileGame
					+ login_info.account_uid_str;

			mCallback3.notifyLoginResut(login_result);
		}

	}

	@Override
	public LoginInfo getLoginInfo() {
		return login_info;
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
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			
			mCallback2.notifyVersionCheckResult(version_info);
		}

	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		this.pay_info = pay_info;
		PayRequest payRequest = new PayRequest();
		payRequest.addParam("notifyurl", this.game_info.pay_addr);
		payRequest.addParam("appid", game_info.app_id_str);
		payRequest.addParam("waresid", 1);//
		payRequest.addParam("exorderno", pay_info.order_serial);
//		payRequest.addParam("price", (int)this.pay_info.price*100);
		payRequest.addParam("price", 1);
		String cpprivateinfo = pay_info.description + "-" + pay_info.product_id
				+ "-" + this.login_info.account_uid_str;// 区号-物品ID-ouruserid
		payRequest.addParam("cpprivateinfo", cpprivateinfo);
		
		String paramUrl = payRequest.genSignedUrlParamString(game_info.app_key);
		SDKApi.startPay(game_ctx, paramUrl, new IPayResultCallback() {
			@Override
			public void onPayResult(int resultCode, String signValue,
					String resultInfo) {
				if (SDKApi.PAY_SUCCESS == resultCode) {
					Log.e("xx", "signValue = " + signValue);
					if (null == signValue) {
						// 没有签名值，默认采用finish()，请根据需要修改
						Log.e("xx", "signValue is null ");
						Toast.makeText(game_ctx, "没有签名值", Toast.LENGTH_SHORT)
								.show();
						return;
					}
					boolean flag = PayRequest.isLegalSign(signValue, resultInfo,game_info.app_key);
					if (flag) {
						Log.e("payexample", "islegalsign: true");
						Toast.makeText(game_ctx, "支付成功", Toast.LENGTH_SHORT)
								.show();
						PlatformBaiDuMobileGameLoginAndPay.getInstance().pay_info.result = 0;
						PlatformBaiDuMobileGameLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformBaiDuMobileGameLoginAndPay.getInstance().pay_info);
					} else {
						Toast.makeText(game_ctx, "支付成功，但是验证签名失败",
								Toast.LENGTH_SHORT).show();
						// 非法签名值，默认采用finish()，请根据需要修改
					}
				} else if (SDKApi.PAY_HANDLING == resultCode) {
					Toast.makeText(game_ctx, "支付处理中", Toast.LENGTH_SHORT)
							.show();
					// 如果返回支付正在处理，支付结果不确定，您需要通过您的服务器查询
					// 支付的结果
					Log.e("fang", "return handling");
				} else {
					Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT).show();
					// 计费失败处理，默认采用finish()，请根据需要修改
					Log.e("fang", "return Error");
				}
			}
		});
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		Log.v(LOG_TAG, "callAccountManage");
		PlatformBaiDuMobileGameLoginAndPay.getInstance().callLogin();
	}

	@Override
	public String generateNewOrderSerial() {
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

	/**
	 * 签名拼写
	 * 
	 * @param appid
	 * @param appKey
	 * @param CurrentTime
	 * @return
	 */
	public String Sign(String appid, String appKey, String CurrentTime) {

		StringBuilder sb = new StringBuilder();

		sb.append(appid).append(appKey).append(CurrentTime);
		String unSignValue = sb.toString();

		return unSignValue;

	}

	public static String MD5(String str) {
		MessageDigest md5 = null;
		try {
			md5 = MessageDigest.getInstance("MD5");
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}

		char[] charArray = str.toCharArray();
		byte[] byteArray = new byte[charArray.length];

		for (int i = 0; i < charArray.length; i++) {
			byteArray[i] = (byte) charArray[i];
		}
		byte[] md5Bytes = md5.digest(byteArray);

		StringBuffer hexValue = new StringBuffer();
		for (int i = 0; i < md5Bytes.length; i++) {
			int val = ((int) md5Bytes[i]) & 0xff;
			if (val < 16) {
				hexValue.append("0");
			}
			hexValue.append(Integer.toHexString(val));
		}
		return hexValue.toString();
	}

	/**
	 * 签名拼写
	 * 
	 * @param appid
	 * @param appKey
	 * @param CurrentTime
	 * @return
	 */
	public String Sign_Login_Callback(String appid, String appKey,
			String CurrentTime, String userName, long userID) {

		StringBuilder sb = new StringBuilder();
		// 按照升序排列
		sb.append(appid).append(appKey).append(CurrentTime).append(userName)
				.append(userID);
		String unSignValue = sb.toString();
		return unSignValue;

	}

}
