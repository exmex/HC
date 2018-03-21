package com.nuclear.dota.platform.sina_wyx;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONObject;

import android.app.Activity;
import android.content.DialogInterface;
import android.content.DialogInterface.OnDismissListener;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;
import cn.sina.youxi.app.AppConfig;
import cn.sina.youxi.pay.sdk.Wyx;
import cn.sina.youxi.pay.sdk.WyxAuthListener;
import cn.sina.youxi.util.JSONUtils;
import cn.sina.youxi.util.ResponseListener;
import cn.sina.youxi.util.StringUtils;
import cn.sina.youxi.util.WyxUtil;

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

public class PlatformSinaLoginAndPay implements IPlatformLoginAndPay {
	private static final String TAG = PlatformSinaLoginAndPay.class.getSimpleName();
	

	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
//	private GameHall 					mGameHall = null;
	public Wyx 							mWyx = null;
	private AuthDialogListener 			mAuthListener = null;
	private static final int 			DIALOGID = 100;
	private ResponseListener 			responseListenerForPayment = null;
	
	private static PlatformSinaLoginAndPay sInstance = null;
	public static PlatformSinaLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformSinaLoginAndPay();
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
		
//		mGameHall = GameHall.getInstance(this.game_ctx);
//		mGameHall.onCreate(this.game_ctx);
		
		// 1. 得到Wyx实例
		mWyx = Wyx.getInstance(this.game_ctx);
		
		//调用初始化方法
		mWyx.initConfig(this.game_ctx);
		
		mAuthListener = new AuthDialogListener();

		responseListenerForPayment = new ResponseListener() {

			@Override
			public void onComplete(String response) {
				Log.i(TAG, response);
				
				JSONObject jsonObj = JSONUtils.parse2JSONObject(response);

				String code = JSONUtils.getString(jsonObj, "code");

				if (!StringUtils.isBlank(code)) {
					Log.e(TAG, response);
				}
				else {
					Bundle params = new Bundle();

					final String order_id = JSONUtils.getString(jsonObj,
							"order_id");
					//final String extInfo = pay_info.description + "-" + pay_info.product_id;//区号-物品id，我们自己的订单号不是必须
					params.putString("order_id", order_id);
					params.putString("ru",  AppConfig.RU);
					//params.putString("pt", extInfo);

					StringBuffer sb = new StringBuffer();
					sb.append(AppConfig.PAY_URL).append("?method=page").append("&")
					.append(WyxUtil.encodeUrl(params));

					Log.i(TAG, "order_id:" + order_id);

					Bundle data = new Bundle();
					data.putString("url", sb.toString());
				
					Message msg = new Message();
					msg.what = 1;
					msg.setData(data);
					payHandler.sendMessage(msg);
				}
			}

			@Override
			public void onFail(Exception e) {
				e.printStackTrace();
			}
		};
		mCallback1.notifyInitPlatformSDKComplete();
	}
	
	private Handler payHandler = new Handler() {

		@Override
		public void dispatchMessage(Message msg) {
			super.dispatchMessage(msg);
			int what = msg.what;
			if(what==1)
			{
				Bundle data = msg.getData();
				if (data != null && data.containsKey("url")) {
	
					mWyx.openPaymentWebView(PlatformSinaLoginAndPay.getInstance().game_ctx,
							data.getString("url"), new ResponseListener() {
								@Override
								public void onComplete(String response) {
									PlatformSinaLoginAndPay.getInstance().pay_info.result = 0;
									PlatformSinaLoginAndPay.getInstance()
						 					.notifyPayRechargeRequestResult(PlatformSinaLoginAndPay.getInstance().pay_info);
									
								}
								@Override
								public void onFail(Exception e) {
									
								}
							}, new OnDismissListener() {
								@Override
								public void onDismiss(DialogInterface dialog) {
	
									// 在Dialog关闭时会调用该方法，如果想查询订单状态，可以在该方法中执行
									Log.i(TAG, "dialog 关闭");
	
									// mWyx.queryOrder(order_id,
									// new ResponseListener() {
									//
									// @Override
									// public void onComplete(
									// String response) {
									// Log.i(TAG, "order_id:"
									// + order_id);
									// Log.i(TAG, response);
									// }
									//
									// @Override
									// public void onFail(
									// Exception e) {
									//
									// }
									// });
								}
							});
				}
			}
		}
	};

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
		this.responseListenerForPayment = null;
		this.mWyx = null;
		this.mAuthListener = null;
		PlatformSinaLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		//if(mWyx.isLogin(PlatformSinaLoginAndPay.getInstance().game_ctx))
		//{
		//	return;//微游戏大厅可以登录账号，这里不能返回
		//}
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(false, -1, "正在登录");
		mWyx.authorize(PlatformSinaLoginAndPay.getInstance().game_ctx, mAuthListener);
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Sina+login_info.account_uid_str;
			
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		if (login_info != null) {
			if(mWyx.isLogin(PlatformSinaLoginAndPay.getInstance().game_ctx))
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
		mWyx.logout();
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
		this.pay_info = null;
		this.pay_info = pay_info;
		if (mWyx.isLogin(PlatformSinaLoginAndPay.getInstance().game_ctx)) {
			final String extInfo = pay_info.description + "-" + pay_info.product_id;//区号-物品id，我们自己的订单号不是必须
		
			mWyx.placeOrder((long)(pay_info.price*100), "购买钻石", extInfo, responseListenerForPayment);
//			mWyx.placeOrder(game_ctx, (long)(pay_info.price*100), "购买钻石", extInfo, responseListenerForPayment, new OnDismissListener() {
//				
//				@Override
//				public void onDismiss(DialogInterface dialog) {
//					// TODO Auto-generated method stub
//					
//				}
//			});
		}else {
			Toast.makeText(PlatformSinaLoginAndPay.getInstance().game_ctx, "请先登录", Toast.LENGTH_SHORT).show();
			mWyx.authorize(PlatformSinaLoginAndPay.getInstance().game_ctx, mAuthListener);
		}
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
		/*if (Cocos2dxHelper.nativeHasEnterMainFrame())
			return;
		if (mWyx.isLogin(PlatformSinaLoginAndPay.getInstance().game_ctx))
			callLogout();
		
		callLogin();*/
		if (Cocos2dxHelper.nativeHasEnterMainFrame()){
			this.callPlatformGameBBS();
		}
		else
		{
			mWyx.accountSwitch(game_ctx, mAuthListener);
		}
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
		Uri uri = Uri.parse("http://m.weibo.cn/weiba#!/postsList/11982"); 
		Intent it = new Intent(Intent.ACTION_VIEW, uri);  
		PlatformSinaLoginAndPay.getInstance().game_ctx.startActivity(it);
	}

	@Override
	public void onGamePause() {
		// TODO Auto-generated method stub
//		mGameHall.onPause();
	}

	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub
//		mGameHall.onResume();
	}

	@Override
	public void onGameExit() {
		// TODO Auto-generated method stub

	}

	
	/**
	 * SSO登录 回调
	 */
	/*class AuthDialogListener implements WeiboAuthListener {

		@Override
		public void onComplete(Bundle values) {
			String uid = values.getString("uid");
			String token = values.getString("access_token");
			String expires_in = values.getString("expires_in");
			Oauth2AccessToken accessToken = new Oauth2AccessToken(token,
					expires_in);
			if (accessToken.isSessionValid()) {
				mWyx.exchangeSessionKey(PlatformSinaLoginAndPay.getInstance().game_ctx, uid,
						accessToken.getToken(), new ResponseListener() {

							@Override
							public void onComplete(String response) {								
								
								JSONObject jsonObject = null;
								try {
									jsonObject = new JSONObject(response);
								}
								catch (JSONException e) {
									e.printStackTrace();
								}

								String sessionKey = jsonObject
										.optString(WyxConfig.TOKEN);

								if (TextUtils.isEmpty(sessionKey)) { return; }

								// 保存sessionKey
								String expires_in = jsonObject
										.optString(WyxConfig.EXPIRES_IN);
								String userId = sessionKey.substring(
										sessionKey.lastIndexOf("_") + 1,
										sessionKey.length());
								mWyx.saveData(sessionKey, expires_in, userId);
								LoginInfo login_info = new LoginInfo();
								login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
								login_info.login_session = sessionKey;
								login_info.account_uid_str = userId;
								login_info.account_uid = Long.parseLong(login_info.account_uid_str);
								login_info.account_nick_name ="已登录";
								PlatformSinaLoginAndPay.getInstance().notifyLoginResult(login_info);

								
							}
							@Override
							public void onFail(Exception e) {

										Toast toast = Toast.makeText(
												PlatformSinaLoginAndPay.getInstance().game_ctx, "登录失败！",
												Toast.LENGTH_SHORT);
										toast.show();
							}
						});
			}
		}

		@Override
		public void onError(WeiboDialogError e) {
			Toast.makeText(PlatformSinaLoginAndPay.getInstance().game_ctx,
					"Auth error : " + e.getMessage(), Toast.LENGTH_LONG).show();
		}

		@Override
		public void onCancel() {

			// TODO 仅仅用于测试，打包时请删除
			Toast.makeText(PlatformSinaLoginAndPay.getInstance().game_ctx, "您已离开登录页面，点击“进入游戏”重新登录",
					Toast.LENGTH_LONG).show();
		}

		@Override
		public void onWeiboException(WeiboException e) {
			Toast.makeText(PlatformSinaLoginAndPay.getInstance().game_ctx,
					"Auth exception : " + e.getMessage(), Toast.LENGTH_LONG)
					.show();
		}
	}*/
	
	class AuthDialogListener implements WyxAuthListener {

		@Override
		public void onComplete(Bundle values) {
			mWyx.initFloatView(game_ctx, values);
			boolean isLogin = values != null ? values.getBoolean("isLogin"):false;
			if (isLogin&&mWyx.isLogin(PlatformSinaLoginAndPay.getInstance().game_ctx)) {
				
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = mWyx.getToken();
				login_info.account_uid_str = mWyx.getUserId();
				login_info.account_uid = Long.parseLong(login_info.account_uid_str);
				login_info.account_nick_name ="已登录";
				PlatformSinaLoginAndPay.getInstance().notifyLoginResult(login_info);
				
				Toast toast = Toast.makeText(
						PlatformSinaLoginAndPay.getInstance().game_ctx, "登录成功！",
						Toast.LENGTH_SHORT);
				toast.show();
							
			} else {
				Toast toast = Toast.makeText(
						PlatformSinaLoginAndPay.getInstance().game_ctx, "登录失败，请重新登陆",
						Toast.LENGTH_SHORT);
				toast.show();
			}
		}

		@Override
		public void onFail(Exception e) {
			e.printStackTrace();
			Toast toast = Toast.makeText(
					PlatformSinaLoginAndPay.getInstance().game_ctx, "登录失败！",
					Toast.LENGTH_SHORT);
			toast.show();
		}

		@Override
		public void onCancel() {
			Toast.makeText(PlatformSinaLoginAndPay.getInstance().game_ctx, "您已离开登录页面，点击“进入游戏”重新登录",
					Toast.LENGTH_LONG).show();
		}
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
