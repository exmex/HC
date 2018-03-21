package com.nearme.gamecenter.open.api;


public abstract class GameCenterSettings {
	public String app_key;
	public String app_secret;
	public static boolean isDebugModel = false;//是否是需要打印调试日志
	public static boolean isOritationPort = false;//是否是竖屏
	public static int request_time_out = 15000;//设置网络请求的超时(单位毫秒)
	public static volatile boolean isNeedShowLoading = true;
	public static boolean isNeedFullscreen = true;
	// 游戏自身 虚拟货币和人民币的 汇率  当申请的支付类型为人民币直冲时将起作用
	public static String rate = "1000"; // 1元人民币兑换1000虚拟货币
	public GameCenterSettings(String app_key, String app_secret) {
		super();
		this.app_key = app_key;
		this.app_secret = app_secret;
	}
	
	/**
	 * 由于token过期导致登录失效,需要cp重新登录.
	 */
	public abstract void onForceReLogin();

	/**
	 * 游戏自升级，后台有设置为强制升级，用户点击取消时的回调函数。
	 * 若开启强制升级模式 ，  一般要求不更新则强制退出游戏并杀掉进程。
	 * System.exit(0) or kill this process
	 */
	public abstract void onForceUpgradeCancel();
}
