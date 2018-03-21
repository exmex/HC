package com.nearme.gamecenter.open.api;

import android.app.Activity;
import android.content.Context;

import com.nearme.gamecenter.open.core.framework.GCInternal;
import com.nearme.oauth.model.NDouProductInfo;

public class GameCenterSDK {
	
	private volatile static GameCenterSDK sInstance;

	public static GameCenterSDK getInstance() {
		if (sInstance == null) {
			throw new RuntimeException(
					"GameCenterSDK must be init before call getInstance");
		}
		return sInstance;
	}

	public static void init(GameCenterSettings gameCenterSettings,
			Context context) {
		if (sInstance == null) {
			synchronized (GameCenterSDK.class) {
				sInstance = new GameCenterSDK();
			}
		}
		GCInternal.init(gameCenterSettings, context);
	}

	public static void setmCurrentContext(Context mCurrentContext) {
		GCInternal.setmCurrentContext(mCurrentContext);
	}
	
	private GameCenterSDK() {
		
	}

	/**
	 * 查询用户在游戏中心的虚拟货币的余额
	 * 
	 * @param callback
	 */
	public void doCheckBalance(final ApiCallback callback, final Activity activity) {
		GCInternal.getInstance().doNewGetBalance(callback, activity);
	}
	

	/**
	 * 查询用户N豆余额
	 * @param callback
	 */
	public void doGetUserNDou(final ApiCallback callback, final Activity activity) {
		GCInternal.getInstance().doGetNDou(callback, activity);
	}

	/**
	 * 获取用户信息
	 * 
	 * @param callback
	 */
	public void doGetUserInfo(final ApiCallback callback, final Activity activity) {
		GCInternal.getInstance().doNewGetUesrInfo(callback, activity);
	}

	/**
	 * 请求登录
	 * 
	 * @param callback
	 */
	public void doLogin(final ApiCallback callback, final Activity activity) {
		GCInternal.getInstance().doNewLogin(callback, activity);
	}
	
	public void doAutoLogin(final ApiCallback callback, final Activity activity) {
		GCInternal.getInstance().doAutoLogin(callback, activity);
	}
	
	/**
	 * 请求登录
	 * 
	 * @param callback
	 */
	public void doNewLogin(final ApiCallback callback, final Activity activity) {
		int count = GCInternal.getInstance().doGetAccountCount();
		if(count <= 1) {
			GCInternal.getInstance().doNewLogin(callback, activity);
		} else {
			GCInternal.getInstance().doReLogin(callback, activity);
		}
	}

	
	public void doNormalKebiPayment(final ApiCallback callback, final PayInfo payInfo, final Activity activity) {
		GCInternal.getInstance().doNormalKebiPayment(callback, payInfo, activity);
	}
	
	public void doRateKebiPayment(final ApiCallback callback, final RatePayInfo payInfo, final Activity activity) {
		GCInternal.getInstance().doRateKebiPayment(callback, payInfo, activity);
	}
	
	public void doFixedKebiPayment(final ApiCallback callback, final FixedPayInfo payInfo, final Activity activity) {
		GCInternal.getInstance().doFixedKebiPayment(callback, payInfo, activity);
	}
	
	public void doPaymentForNDou(final ApiCallback callback, final NDouProductInfo productInfo, final Activity activity) {
		GCInternal.getInstance().doPaymentForNDOU(callback, productInfo, activity);
	}
	
	
	/**
	 * 请求切换账号 注意,重新登录后的情况将回调到新的callback中,请开发者注意接收.
	 * 
	 * @param callback
	 */
	public void doReLogin(final ApiCallback callback, final Activity activity) {
		GCInternal.getInstance().doReLogin(callback, activity);
	}
	
	public int doGetAccountCount() {
		return GCInternal.getInstance().doGetAccountCount();
	}
	
	public void doShowKebiCharege(final ApiCallback callback, final Activity activity) {
		GCInternal.getInstance().doShowKebiCharge(activity, callback);
	}

	public void doShowForum(final Activity activity) {
		GCInternal.getInstance().doShowForum(activity);
	}
	
	public void doShowGameCenter(final Activity activity) {
		GCInternal.getInstance().doShowGameCenter(activity);
	}

	
	public void doShowSprite(final Activity activity) {
		GCInternal.getInstance().doShowSprite(activity);
	}
	
	
	public void doDismissSprite(Activity activity)	 {
		GCInternal.getInstance().doDismissSprite(activity);
	}

	
	public void doShowProfileSetting(Activity ac) {
		GCInternal.getInstance().doShowProfileSetting(ac);
	}
	
	public String doGetAccessToken() {
		return GCInternal.getInstance().getAccessToken();
	}
}
