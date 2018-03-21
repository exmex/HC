package com.nuclear.dota.platform.pipaw;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.util.Log;
import android.widget.Toast;

import com.pipaw.pipawpay.PayRequest;
import com.pipaw.pipawpay.PipawSDK;
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

public class PlatformPipawLoginAndPay implements IPlatformLoginAndPay {

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

	private static PlatformPipawLoginAndPay mInstance;

	private PlatformPipawLoginAndPay() {

	}

	public static PlatformPipawLoginAndPay getInstance() {
		if (mInstance == null) {
			mInstance = new PlatformPipawLoginAndPay();
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

		PlatformPipawLoginAndPay.mInstance = null;

	}

	@Override
	public GameInfo getGameInfo() {

		return this.game_info;
	}

	@Override
	public void callLogin() {
		if (isLogin)
			return;
		PipawSDK.getInstance().login(this.game_ctx,
				String.valueOf(this.game_info.cp_id),
				String.valueOf(this.game_info.gameid),
				this.game_info.app_id_str);
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {

			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Pipaw
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
		payRequest.setMerchantId(String.valueOf(this.game_info.cp_id));
		/**
		 * merchantAppId 商户应用Id
		 */
		payRequest.setMerchantAppId(String.valueOf(this.game_info.gameid));
		/**
		 * appId 应用Id
		 */
		payRequest.setAppId(this.game_info.app_id_str);
		/**
		 * payerId 唯一的支付用户Id
		 */
		payRequest.setPayerId(pay_info.order_serial.substring(0, 10));
		/**
		 * isPipawId payerId是否是琵琶网用户 是琵琶网用户为true 反之为false
		 */
		payRequest.setIsPipawId("true");
		/**
		 * exOrderNo 交易的订单号
		 */
		payRequest.setExOrderNo(pay_info.order_serial);
		/**
		 * subject 交易的商品名称
		 */
		payRequest.setSubject(pay_info.product_name);
		/**
		 * price 交易的金额
		 */
		String price = String.valueOf(pay_info.price);
		payRequest.setPrice(price);
		/**
		 * extraParam 商户私有信息
		 */
		String cpprivateinfo = pay_info.description + "-" + pay_info.product_id
				+ "-" + this.login_info.account_uid_str;// 区号-物品ID-ouruserid
		payRequest.setExtraParam(cpprivateinfo);
		/**
		 * 将merchantId，merchantAppId，appId，payerId，exOrderNo，subject，price，
		 * extraParam，privateKey直接连接起来获取md5签名值。
		 * 建议:签名在商户服务器端进行，同时商户私钥也应存储在服务器端，避免可能的安全隐患。
		 */
		StringBuilder content = new StringBuilder();
		content.append(String.valueOf(this.game_info.cp_id))
				.append(String.valueOf(this.game_info.gameid))
				.append(this.game_info.app_id_str)
				.append(pay_info.order_serial.substring(0, 10))
				.append(pay_info.order_serial).append(pay_info.product_name)
				.append(price).append(cpprivateinfo)
				.append(this.game_info.private_str);
		Log.d("pay", "content " + content);
		String merchantSign = getMd5(content.toString());
		Log.d("pay", "merchantSign " + merchantSign);
		/**
		 * merchantSign 交易签名
		 */
		payRequest.setMerchantSign(merchantSign);
		PipawSDK.getInstance().pay(this.game_ctx, payRequest);

		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
			Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
			return;
		}
		PipawSDK.getInstance().login(this.game_ctx,
				String.valueOf(this.game_info.cp_id),
				String.valueOf(this.game_info.gameid),
				this.game_info.app_id_str);
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {
		Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
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

	public void onActivityResult(int requestCode, int resultCode, Intent data) {

		if (requestCode == PipawSDK.REQUEST_PAY) {
			if (resultCode == PipawSDK.PAY_CANCEL) {
				/**
				 * 用户取消支付
				 */
				Toast.makeText(this.game_ctx, "取消支付", Toast.LENGTH_SHORT)
						.show();
			} else if (resultCode == PipawSDK.PAY_SUCCESS) {
				/**
				 * 支付成功
				 */
				PlatformPipawLoginAndPay.getInstance().pay_info.result = 0;
				PlatformPipawLoginAndPay
						.getInstance()
						.notifyPayRechargeRequestResult(
								PlatformPipawLoginAndPay.getInstance().pay_info);

				Toast.makeText(this.game_ctx, "支付成功", Toast.LENGTH_SHORT)
						.show();
			} else if (resultCode == PipawSDK.PAY_FAIL) {
				/**
				 * 支付失败
				 */
				Toast.makeText(this.game_ctx, "支付失败", Toast.LENGTH_SHORT)
						.show();
				if (data != null) {
					Toast.makeText(this.game_ctx, data.getAction(),
							Toast.LENGTH_SHORT).show();
				}
			} else if (resultCode == PipawSDK.PAY_CHECK_SIGN_FAIL) {
				/**
				 * 验签失败，可能支付成功，请以服务端异步通知为准。
				 */
				Toast.makeText(this.game_ctx, "验签失败，可能支付成功", Toast.LENGTH_SHORT)
						.show();
				if (data != null) {
					Toast.makeText(this.game_ctx, data.getAction(),
							Toast.LENGTH_SHORT).show();
				}
			}
		}

		if (requestCode == PipawSDK.REQUEST_LOGIN) {
			if (resultCode == PipawSDK.LOGIN_EXIT) {
				/**
				 * 退出登录
				 */
				Toast.makeText(this.game_ctx, "退出登录", Toast.LENGTH_SHORT)
						.show();
			} else if (resultCode == PipawSDK.LOGIN_SUCCESS) {
				/**
				 * 返回包含username，sid，time的json对象。
				 * 游戏服务端可通过merchantId，merchantAppId，appId，username，sid，time向
				 * 支付SDK服务端请求验证sid。 注：sid的有效时间为1小时，游戏服务端须在1小时内完成sid验证。
				 */
				try {
					JSONObject dataJsonObj = new JSONObject(data.getAction());

					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.login_session = dataJsonObj
							.getString("username");
					login_info.account_uid_str = dataJsonObj
							.getString("username");
					login_info.account_nick_name = dataJsonObj
							.getString("username");
					PlatformPipawLoginAndPay.getInstance().notifyLoginResult(
							login_info);
				} catch (JSONException e) {
					e.printStackTrace();
					Toast.makeText(this.game_ctx, "登录失败", Toast.LENGTH_SHORT)
							.show();
				}
				this.isLogin = true;
				Toast.makeText(this.game_ctx, "登录成功", Toast.LENGTH_SHORT)
						.show();
			} else if (resultCode == PipawSDK.LOGIN_FAIL) {
				/**
				 * 登录失败
				 */
				Toast.makeText(this.game_ctx, "登录失败", Toast.LENGTH_SHORT)
						.show();
				if (data != null) {
					Toast.makeText(this.game_ctx, data.getAction(),
							Toast.LENGTH_SHORT).show();
				}
			}
		}
	}

	public static String getMd5(String str) {
		StringBuilder sb = new StringBuilder();
		String s;
		try {
			MessageDigest md = MessageDigest.getInstance("MD5");
			md.update(str.getBytes("UTF-8"));
			byte[] hash = md.digest();
			for (byte b : hash) {
				s = Integer.toHexString(0xff & b);
				if (s.length() == 1) {
					sb.append("0");
				}
				sb.append(s);
			}
		} catch (NoSuchAlgorithmException e) {
			e.printStackTrace();
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}
		return sb.toString();
	}
}
