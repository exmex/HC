package com.nearme.gamecenter.open.api;

import android.app.Activity;
import android.content.Context;

import com.nearme.gamecenter.open.core.framework.GCInternal;
import com.nearme.oauth.model.UserInfo;

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
	public void doCheckBalance(ApiCallback callback) {
		GCInternal.getInstance().doNewGetBalance(callback);
	}

	/**
	 * 获取用户信息
	 * 
	 * @param callback
	 */
	public void doGetUserInfo(final ApiCallback callback) {
		GCInternal.getInstance().doNewGetUesrInfo(callback);
	}

	/**
	 * 修改个人信息
	 * 
	 * @param callback
	 */
	public void doModifyUserInfo(final ApiCallback callback,
			final UserInfo userInfo) {
		GCInternal.getInstance().doNewModifyUserInfo(callback, userInfo);
	}
	
	/**
	 * 请求登录
	 * 
	 * @param callback
	 */
	public void doLogin(final ApiCallback callback) {
		GCInternal.getInstance().doNewLogin(callback);
	}
	
	/**
	 * 请求登录
	 * 
	 * @param callback
	 */
	public void doNewLogin(final ApiCallback callback) {
		int count = GCInternal.getInstance().doGetAccountCount();
		if(count <= 1) {
			GCInternal.getInstance().doNewLogin(callback);
		} else {
			GCInternal.getInstance().doReLogin(callback);
		}
	}

	/**
	 * 消费游戏中心虚拟货币
	 * 
	 * @param callback
	 *            回调对象
	 */
	public void doPaymentForNBAO(ApiCallback callback, final ProductInfo proInfo) {
		GCInternal.getInstance().doNewPaymentForNBAO(callback, proInfo);
	}
	
	/**
	 * 直接消耗RMB
	 * 
	 * @param callback
	 *            回调对象
	 * @param proInfo
	 * 
	 */
	public void doChargeForRMB(ApiCallback callback, final ProductInfo proInfo) {
		GCInternal.getInstance().doChargeForRMB(callback, proInfo);
	}
	
	/**
	 * 请求切换账号 注意,重新登录后的情况将回调到新的callback中,请开发者注意接收.
	 * 
	 * @param callback
	 */
	public void doReLogin(ApiCallback callback) {
		GCInternal.getInstance().doReLogin(callback);
	}
	
	public int doGetAccountCount() {
		return GCInternal.getInstance().doGetAccountCount();
	}

	/**
	 * 分享游戏相关的一些信息到平台.
	 * 
	 * @param callback
	 * @param cotent
	 */
	@Deprecated
	public void doShareInfo(ApiCallback callback, final String[] params,
			final String id) {
	}

//	/**
//	 * 弹出游戏中心充值页面
//	 */
//	public void doShowCharge(ApiCallback callback) {
//		GCInternal.getInstance().doShowCharge(callback);
//	}

	/**
	 * @param callback
	 * @param callbackUrl
	 *            充值成功后的回调接口
	 */
	public void doShowNBAOCharge(ApiCallback callback, String callbackUrl) {
		GCInternal.getInstance().doShowNBAOCharge(callback, callbackUrl);
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
