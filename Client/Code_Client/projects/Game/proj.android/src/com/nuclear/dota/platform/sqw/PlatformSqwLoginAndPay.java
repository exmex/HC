package com.nuclear.dota.platform.sqw;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.widget.Toast;

import com.sanqi.android.sdk.apinterface.InitCallBack;
import com.sanqi.android.sdk.apinterface.LoginCallBack;
import com.sanqi.android.sdk.apinterface.LogoutCallBack;
import com.sanqi.android.sdk.apinterface.RechargeCallBack;
import com.sanqi.android.sdk.apinterface.UserAccount;
import com.sanqi.android.sdk.ui.PayManager;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.MD5;
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

public class PlatformSqwLoginAndPay implements IPlatformLoginAndPay {
	private static PlatformSqwLoginAndPay mInstance = null;
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

	private PlatformSqwLoginAndPay() {

	}

	public static PlatformSqwLoginAndPay getInstance() {
		if (mInstance == null) {
			mInstance = new PlatformSqwLoginAndPay();
		}
		return mInstance;
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		game_info.screen_orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
		this.game_info = game_info;
		PayManager.getInstance().init(this.game_ctx, this.game_info.app_key,
				new InitCallBack() {

					@Override
					public void initSuccess(String arg0, String arg1) {
						isLogin = false;
						final IPlatformSDKStateCallback callback1 = mCallback1;
						callback1.notifyInitPlatformSDKComplete();
					}

					@Override
					public void initFaile(String arg0) {
						Toast.makeText(PlatformSqwLoginAndPay.this.game_ctx,
								"初始化失败", Toast.LENGTH_SHORT).show();
					}
				}, false, this.game_info.screen_orientation);

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
		return 0;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		return 0;
	}

	@Override
	public void onLoginGame() {
		
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
		mInstance = null;

	}

	@Override
	public GameInfo getGameInfo() {
		return this.game_info;
	}

	@Override
	public void callLogin() {
		if (isLogin)
			return;
		PayManager.getInstance().login(this.game_ctx, new LoginCallBack() {

			@Override
			public void loginSuccess(UserAccount arg0) {
				String result = verifySession(arg0.getSession(), arg0
						.getUnixTime().toString());
				try {
					JSONObject dataJsonObj = new JSONObject(result);
					if (dataJsonObj.getInt("code") != 1) {
						PlatformSqwLoginAndPay.this.game_ctx
								.runOnUiThread(new Runnable() {
									@Override
									public void run() {
										Toast.makeText(game_ctx,
												"验证session失败，请重新登录",
												Toast.LENGTH_SHORT).show();
									}
								});
					} else {
						LoginInfo login_info = new LoginInfo();
						login_info.login_session = String.valueOf(arg0
								.getSession());
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.account_uid_str = String.valueOf(arg0
								.getUserUid());
						login_info.account_uid = arg0.getUserUid();
						login_info.account_nick_name = arg0.getUserName();
						PlatformSqwLoginAndPay.getInstance().notifyLoginResult(
								login_info);
						isLogin = true;
					}

				} catch (JSONException e) {
					Toast.makeText(game_ctx, "验证session失败，请重新登录",
							Toast.LENGTH_SHORT).show();
					e.printStackTrace();
				}
			}

			@Override
			public void loginFaile(final String arg0) {
				PlatformSqwLoginAndPay.this.game_ctx
						.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								Toast.makeText(game_ctx, arg0,
										Toast.LENGTH_SHORT).show();
							}
						});

			}

			@Override
			public void backKey(String arg0) {
				PlatformSqwLoginAndPay.this.game_ctx
						.runOnUiThread(new Runnable() {
							@Override
							public void run() {
								Toast.makeText(game_ctx, "取消登录",
										Toast.LENGTH_SHORT).show();
							}
						});

			}
		});
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {

			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Sqw
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
		String pext = pay_info.description + "-" + pay_info.product_id + "-"
				+ this.login_info.account_uid_str;// 区号-物品ID-ouruserid
		PayManager.getInstance().rechargeByQuota(this.game_ctx,
				Cocos2dxHelper.getPlatformLoginSessionId(),
				this.login_info.account_nick_name, "", pext, pay_info.price,
				new RechargeCallBack() {

					@Override
					public void rechargeSuccess(UserAccount arg0) {
						PlatformSqwLoginAndPay.getInstance().pay_info.result = 0;
						PlatformSqwLoginAndPay
								.getInstance()
								.notifyPayRechargeRequestResult(
										PlatformSqwLoginAndPay.getInstance().pay_info);

					}

					@Override
					public void rechargeFaile(String arg0) {
						Toast.makeText(game_ctx, arg0, Toast.LENGTH_SHORT)
								.show();

					}

					@Override
					public void backKey(String arg0) {
						Toast.makeText(game_ctx, "取消支付", Toast.LENGTH_SHORT)
								.show();

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
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
			return;
		PayManager.getInstance().logout2(new LogoutCallBack() {
			@Override
			public void logoutCallBack() {
				LoginInfo login_info = new LoginInfo();
				login_info.login_session = "";
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
				login_info.account_uid_str = "";
				login_info.account_uid = 0;
				login_info.account_nick_name = "";
				PlatformSqwLoginAndPay.getInstance().notifyLoginResult(
						login_info);
				isLogin = false;
				PayManager.getInstance().login(game_ctx, new LoginCallBack() {

					@Override
					public void loginSuccess(UserAccount arg0) {
						String result = verifySession(arg0.getSession(), arg0
								.getUnixTime().toString());
						try {
							JSONObject dataJsonObj = new JSONObject(result);
							if (dataJsonObj.getInt("code") != 1) {
								PlatformSqwLoginAndPay.this.game_ctx
										.runOnUiThread(new Runnable() {
											@Override
											public void run() {
												Toast.makeText(game_ctx,
														"验证session失败，请重新登录",
														Toast.LENGTH_SHORT)
														.show();
											}
										});
							} else {
								LoginInfo login_info = new LoginInfo();
								login_info.login_session = String.valueOf(arg0
										.getSession());
								login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
								login_info.account_uid_str = String
										.valueOf(arg0.getUserUid());
								login_info.account_uid = arg0.getUserUid();
								login_info.account_nick_name = arg0
										.getUserName();
								PlatformSqwLoginAndPay.getInstance()
										.notifyLoginResult(login_info);
								isLogin = true;
							}

						} catch (JSONException e) {
							Toast.makeText(game_ctx, "验证session失败，请重新登录",
									Toast.LENGTH_SHORT).show();
							e.printStackTrace();
						}
					}

					@Override
					public void loginFaile(final String arg0) {
						PlatformSqwLoginAndPay.this.game_ctx
								.runOnUiThread(new Runnable() {
									@Override
									public void run() {
										Toast.makeText(game_ctx, arg0,
												Toast.LENGTH_SHORT).show();
									}
								});

					}

					@Override
					public void backKey(String arg0) {
						PlatformSqwLoginAndPay.this.game_ctx
								.runOnUiThread(new Runnable() {
									@Override
									public void run() {
										Toast.makeText(game_ctx, "取消登录",
												Toast.LENGTH_SHORT).show();
									}
								});

					}
				});
			}
		});

	}

	@Override
	public String generateNewOrderSerial() {
		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
			String _url = Config.UrlFeedBack + "?puid="
					+ LastLoginHelp.mPuid + "&gameId=" + LastLoginHelp.mGameid
					+ "&serverId=" + LastLoginHelp.mServerID + "&playerId="
					+ LastLoginHelp.mPlayerId + "&playerName="
					+ LastLoginHelp.mPlayerName + "&vipLvl="
					+ LastLoginHelp.mVipLvl + "&platformId="
					+ LastLoginHelp.mPlatform;
			FeedBackDialog.getInstance(game_ctx, _url).show();
		}
	}

	@Override
	public void callPlatformSupportThirdShare(ShareInfo share_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callPlatformGameBBS() {
		PayManager.getInstance().enterBBS(this.game_ctx);
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

	private String verifySession(String sessionid, String time) {
		//strtolower(md5($gameid.$partner.$sessionid.$time.$LOGIN_KEY))
		String str = this.game_info.app_id+"1" + sessionid + "" + time + ""
				+ this.game_info.app_key;
		String sign = MD5.get(str).toLowerCase();
		StringBuffer sb = new StringBuffer();
		sb.append("http://sy.api.37wan.cn/sdk/checklogin/?gameid="+this.game_info.app_id+"&partner=1&sessionid=");
		sb.append(sessionid);
		sb.append("&time=");
		sb.append(time);
		sb.append("&sign=");
		sb.append(sign);
		String result = executeHttpGet(sb.toString());
		return result;
	}

	private String executeHttpGet(String urlString) {
		String result = null;
		URL url = null;
		HttpURLConnection connection = null;
		InputStreamReader in = null;
		try {
			url = new URL(urlString);
			connection = (HttpURLConnection) url.openConnection();
			connection.setReadTimeout(5000);
			connection.setConnectTimeout(5000);
			in = new InputStreamReader(connection.getInputStream());
			BufferedReader bufferedReader = new BufferedReader(in);
			StringBuffer strBuffer = new StringBuffer();
			String line = null;
			while ((line = bufferedReader.readLine()) != null) {
				strBuffer.append(line);
			}
			result = strBuffer.toString();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}
		return result;

	}
}
