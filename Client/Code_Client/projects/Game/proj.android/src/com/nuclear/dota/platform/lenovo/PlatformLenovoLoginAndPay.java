package com.nuclear.dota.platform.lenovo;

import java.io.StringReader;
import java.util.UUID;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.cocos2dx.lib.Cocos2dxHelper;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.util.Log;
import android.widget.Toast;

import com.lenovo.lsf.gamesdk.LenovoGameApi;
import com.lenovo.lsf.gamesdk.LenovoGameApi.GamePayRequest;
import com.lenovo.lsf.gamesdk.LenovoGameApi.IPayResult;
import com.lenovo.mpay.ifmgr.SDKApi;
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


public class PlatformLenovoLoginAndPay implements IPlatformLoginAndPay {
	
	private static final String TAG = PlatformLenovoLoginAndPay.class.getSimpleName();
	
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
	
	private static PlatformLenovoLoginAndPay mInstance;

	private PlatformLenovoLoginAndPay() {
		
	}

	public static PlatformLenovoLoginAndPay getInstance() {
		if (mInstance == null) {
			mInstance = new PlatformLenovoLoginAndPay();
		}
		return mInstance;
	}

	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		game_info.screen_orientation = ActivityInfo.SCREEN_ORIENTATION_PORTRAIT;
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		game_info.use_platform_sdk_type = 1;// 0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Lenovo;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_Lenovo;
		
		LenovoGameApi.doInit(this.game_ctx, this.game_info.app_id_str);
		
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();

	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		this.mCallback3 = callback3;

	}

	@Override
	public int isSupportInSDKGameUpdate() {
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		return -1;//R.layout.logo_lenovo;
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

	//	PsAuthenServiceL.exit();

		PlatformLenovoLoginAndPay.mInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {

		return this.game_info;
	}

	@Override
	public void callLogin() {
		
		if(isLogin)
		{
			return;
		}
		
		final IGameAppStateCallback callBack = mCallback3;
		callBack.showWaitingViewImp(true, -1, "正在登录");
		
//		Bundle loginOption = new Bundle();
		
		//loginOption.putBoolean(LenovoGameSdk.SHOW_WELCOME, true);
		
		//LenovoGameSdk.quickLogin(game_ctx, callback, loginOption);
		
		LenovoGameApi.doAutoLogin(game_ctx, call);
	}
	
	LenovoGameApi.IAuthResult call = new LenovoGameApi.IAuthResult() {
		
		@Override
		public void onFinished(boolean ret, final String data) {
			// TODO Auto-generated method stub
			if (ret) {
				final IGameAppStateCallback callBack = mCallback3;
				
				final LoginInfo login_info = new LoginInfo();

				PlatformLenovoLoginAndPay.getInstance().isLogin = true;
				
				new Thread() {
					@Override
					public void run() {
						// TODO Auto-generated method stub
						String urls = "http://passport.lenovo.com/interserver/authen/1.2/getaccountid";
						try {
							String url = urls + "?" + "lpsust="
									+ data + "&realm=" + game_info.app_id_str;
							HttpGet get = new HttpGet(url);
							HttpClient client = new DefaultHttpClient();
							org.apache.http.HttpResponse response = client
									.execute(get);
							String resultString = EntityUtils
									.toString(response.getEntity());
							Log.e(TAG,
									resultString);

							DocumentBuilderFactory factory = DocumentBuilderFactory
									.newInstance();
							DocumentBuilder builder = factory
									.newDocumentBuilder();
							Document doc = builder
									.parse(new InputSource(
											new StringReader(
													resultString)));
							Element root = doc.getDocumentElement();
							NodeList nodes = root.getChildNodes();

							Node nodeid = nodes.item(0);
							String keyid = nodeid.getNodeName();
							String valueid = nodeid.getFirstChild()
									.getNodeValue();

							Node nodename = nodes.item(1);
							String keyname = nodename.getNodeName();
							String valuename = nodename
									.getFirstChild().getNodeValue();

							Log.e(TAG, keyid
									+ "::::" + valueid+":::"+valuename);
							if (!keyid.equals("AccountID")
									|| !keyname.equals("Username")
									|| valueid == "") { // 用户信息不合法，联想说了才做。
								mGameActivity
										.showToastMsg("用户信息不合法，请重新登陆。");
								// GameActivity.requestRestart();
								return;
							}
							
							login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
							login_info.login_session = valueid;
							login_info.account_uid_str = valueid;
							login_info.account_nick_name = valuename;
							
							PlatformLenovoLoginAndPay.getInstance()
									.notifyLoginResult(login_info);
							callBack.showWaitingViewImp(false, -1, "");
						} catch (Exception e) {
							// TODO: handle exception
							PlatformLenovoLoginAndPay.getInstance().isLogin = false;
							mGameActivity
									.showToastMsg("用户信息不合法，请重新点击登陆。");
							e.printStackTrace();
						}

					}
				}.start();
				
				callBack.showWaitingViewImp(false, -1, "");
			}
//			else if (data == "cancel") {
//				PlatformLenovoLoginAndPay.getInstance().callLogout();
//				mGameActivity.showToastMsg("取消登陆");
//			} else if (data.startsWith("USS")) {
//				mGameActivity.showToastMsg("USS");
//			}
			else {
				//后台快速登录失败(失败原因开启飞行模式、 网络不通等)
				Log.i(TAG, "login fail");
			}
		}
	};
	
	/**
	 * 处理登录成功回调接口
	 * 
	 */
//	OnAuthenListener callback = new OnAuthenListener() {
//		
//		@Override
//		public void onFinished(boolean ret, final String data) {
//			// TODO Auto-generated method stub
//			if (ret) 
//			{
//				final IGameAppStateCallback callBack = mCallback3;
//				
////				String uid = PsAuthenServiceL.getUserId(game_ctx,
////						data, game_info.app_id_str);
////				String userName = PsAuthenServiceL
////						.getUserName(game_ctx);
////				
////				Log.e(TAG, "uid:"+uid+"--------> userName:"+userName);
//				
//				final LoginInfo login_info = new LoginInfo();
//
//				PlatformLenovoLoginAndPay.getInstance().isLogin = true;
//				
//				new Thread() {
//					@Override
//					public void run() {
//						// TODO Auto-generated method stub
//						String urls = "http://passport.lenovo.com/interserver/authen/1.2/getaccountid";
//						try {
//							String url = urls + "?" + "lpsust="
//									+ data + "&realm=" + game_info.app_id_str;
//							HttpGet get = new HttpGet(url);
//							HttpClient client = new DefaultHttpClient();
//							org.apache.http.HttpResponse response = client
//									.execute(get);
//							String resultString = EntityUtils
//									.toString(response.getEntity());
//							Log.e(TAG,
//									resultString);
//
//							DocumentBuilderFactory factory = DocumentBuilderFactory
//									.newInstance();
//							DocumentBuilder builder = factory
//									.newDocumentBuilder();
//							Document doc = builder
//									.parse(new InputSource(
//											new StringReader(
//													resultString)));
//							Element root = doc.getDocumentElement();
//							NodeList nodes = root.getChildNodes();
//
//							Node nodeid = nodes.item(0);
//							String keyid = nodeid.getNodeName();
//							String valueid = nodeid.getFirstChild()
//									.getNodeValue();
//
//							Node nodename = nodes.item(1);
//							String keyname = nodename.getNodeName();
//							String valuename = nodename
//									.getFirstChild().getNodeValue();
//
//							Log.e(TAG, keyid
//									+ "::::" + valueid+":::"+valuename);
//							if (!keyid.equals("AccountID")
//									|| !keyname.equals("Username")
//									|| valueid == "") { // 用户信息不合法，联想说了才做。
//								mGameActivity
//										.showToastMsg("用户信息不合法，请重新登陆。");
//								// GameActivity.requestRestart();
//								return;
//							}
//							
//							login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
//							login_info.login_session = valueid;
//							login_info.account_uid_str = valueid;
//							login_info.account_nick_name = valuename;
//							
//							PlatformLenovoLoginAndPay.getInstance()
//									.notifyLoginResult(login_info);
//							callBack.showWaitingViewImp(false, -1, "");
//						} catch (Exception e) {
//							// TODO: handle exception
//							PlatformLenovoLoginAndPay.getInstance().isLogin = false;
//							mGameActivity
//									.showToastMsg("用户信息不合法，请重新点击登陆。");
//							e.printStackTrace();
//						}
//
//					}
//				}.start();
//				
//				callBack.showWaitingViewImp(false, -1, "");
//			}
//			else if (data == "cancel") {
//					PlatformLenovoLoginAndPay.getInstance().callLogout();
//					mGameActivity.showToastMsg("取消登陆");
//			} else if (data.startsWith("USS")) {
//					String err = PsAuthenServiceL
//							.getLastErrorString(PlatformLenovoLoginAndPay
//									.getInstance().game_ctx);
//					mGameActivity.showToastMsg(err);
//			} else {
////					mGameActivity.showToastMsg("");
//			}
//		}
//	};
	

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		login_info = null;
		login_info = login_result;
		
		//
		if (login_result != null) {
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Lenovo
					+ login_info.account_uid_str;
			mGameActivity.showToastMsg("登陆成功,点击进入游戏。");
			mCallback3.notifyLoginResut(login_result);
			
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		if (login_info != null) {
			if (isLogin)
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			else
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}
		
		return login_info;
	}

	@Override
	public void callLogout() {
		isLogin = false;
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
	public int callPayRecharge(final PayInfo pay_info) {
		this.pay_info = null;
		this.pay_info = pay_info;

		String waresid = getYYHPay((int) this.pay_info.price);
		GamePayRequest payRequest = new GamePayRequest();
//		payRequest.addParam("notifyurl", this.game_info.pay_addr);// game_info.pay_addr
		payRequest.addParam("appid", game_info.pay_id_str);
		payRequest.addParam("waresid", waresid);//
		payRequest.addParam("exorderno", pay_info.order_serial);
		payRequest.addParam("price", (int) this.pay_info.price * 100);
		String cpprivateinfo = pay_info.description + "-" + pay_info.product_id
				+ "-" + this.login_info.account_uid_str;// 区号-物品ID-ouruserid
		payRequest.addParam("cpprivateinfo", cpprivateinfo);

//		String paramUrl = payRequest
//				.genSignedUrlParamString(game_info.public_str);
		
		LenovoGameApi.doPay(game_ctx,this.game_info.public_str, payRequest, new IPayResult() {
			
			@Override
			public void onPayResult(int resultCode, String signValue, String resultInfo) {
				// TODO Auto-generated method stub
				if (LenovoGameApi.PAY_SUCCESS == resultCode) {
					Log.e(TAG, "signValue = " + signValue);
					if (null == signValue) {
						// 没有签名值，默认采用finish()，请根据需要修改
						Log.e("xx", "signValue is null ");
						Toast.makeText(game_ctx, "没有签名值", Toast.LENGTH_SHORT)
								.show();
						return;
					}
					boolean flag = GamePayRequest.isLegalSign(signValue,
							game_info.public_str);
					if (flag) {
						Log.e(TAG, "islegalsign: true");
						Toast.makeText(game_ctx, "支付成功",
								Toast.LENGTH_SHORT).show();
						// 合法签名值，支付成功，请添加支付成功后的业务逻辑
						PlatformLenovoLoginAndPay.getInstance().pay_info.result = 0;
						PlatformLenovoLoginAndPay
								.getInstance()
								.notifyPayRechargeRequestResult(
										PlatformLenovoLoginAndPay.getInstance().pay_info);
					} else {
						Toast.makeText(game_ctx,
								"支付成功，但是验证签名失败", Toast.LENGTH_SHORT)
								.show();
						// 非法签名值，默认采用finish()，请根据需要修改
					}
				} else if (LenovoGameApi.PAY_CANCEL == resultCode) {
					Toast.makeText(game_ctx, "取消支付",
							Toast.LENGTH_SHORT).show();
					// 取消支付处理，默认采用finish()，请根据需要修改
					Log.e(TAG, "return cancel");
				} else {
					Toast.makeText(game_ctx, "支付失败",
							Toast.LENGTH_SHORT).show();
					// 计费失败处理，默认采用finish()，请根据需要修改
					Log.e(TAG, "return Error");
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
		if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
			mGameActivity.showToastMsg("暂未开放,敬请期待!");
		} else {
//			PsAuthenServiceL.showAccountPage(this.game_ctx, game_info.app_id_str);
//			mGameActivity.showToastMsg("暂时不能切换账号!");
			callLogout();
			callLogin();
		}

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

	}

	@Override
	public void callPlatformGameBBS() {
		// Intent intent = new Intent();
		// intent.setAction("android.intent.action.VIEW");
		// Uri content_url =
		// Uri.parse("http://bbs.lenovo.com/forum.php?mod=forumdisplay&fid=705");
		// intent.setData(content_url);
		// game_ctx.startActivity(intent);
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

	public static String getYYHPay(int pirce) {
		String waresid = "";
		switch (pirce) {
		case 10:
			waresid = "1";
			break;
		case 30:
			waresid = "3";
			break;
		case 50:
			waresid = "4";
			break;
		case 100:
			waresid = "5";
			break;
		case 200:
			waresid = "6";
			break;
		case 500:
			waresid = "7";
			break;
		case 1000:
			waresid = "8";
			break;
		case 2000:
			waresid = "9";
			break;
		case 5000:
			waresid = "10";
			break;
		default:
			break;
		}
		return waresid;
	}

//	public static final String LOGOUT_NORMAL = "com.nuclear.dota.platform.lenovo.android.intent.action.LENOVOUSER_STATUS";
//	public static final String LOGOUT_LENOVO = "android.intent.action.LENOVOUSER_STATUS";
//
//	public void callLoginout(Context context, Intent intent) {
//		String action = intent.getAction();
//		if (action.equals(LOGOUT_NORMAL)) {
//			Log.v("AAAAAAAAA", "status : " + "非单点");
//			String state = intent.getStringExtra("status");
//			Log.v("AAAAAAAAA", "status : " + state);
//			state = state.trim();
//			if (Integer.getInteger(state, 1) == PsAuthenServiceL.LENOVOUSER_OFFLINE) {
//				// LenovoFunc.dealEnterPlatform();
//				
////				loginOk = false;
//				isLogin = false;
////				callLogout();
//				callLogin();
//				
//			}
//		} else if (action.equals(LOGOUT_LENOVO)) {
//			Log.v("AAAAAAAAA", "LogoutReciver 单点");
//			String state = intent.getStringExtra("status");
//			Log.v("AAAAAAAAA", "status : " + state);
//			state = state.trim();
//			if (Integer.getInteger(state, 1) == PsAuthenServiceL.LENOVOUSER_OFFLINE) {
//				// LenovoFunc.dealEnterPlatform();
////				loginOk = false;
//				isLogin = false;
////				callLogout();
//				callLogin();
//			}
//		}
//	}

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
	public void onLoginGame() {
		// TODO Auto-generated method stub
		
	}

}
