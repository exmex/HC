


package com.nuclear;


import com.nuclear.PlatformAndGameInfo.*;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;




public interface IPlatformLoginAndPay {
	
	/*
	 * 
	 * */
	public void init(IGameActivity game_ctx, GameInfo game_info);
	/*
	 * */
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1);
	/*
	 * */
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2);
	/*
	 * */
	public void setGameAppStateCallback(IGameAppStateCallback callback3);
	/*
	 * 
	 * */
	public int isSupportInSDKGameUpdate();
	/*
	 * 返回值：
	 * -1：标示该SDK的init过程会自己切换view，不明确是否位contentview或其他特殊情况，-1这个取值类似91SDKVer2.3.5.1版的情况
	 * 0：标示该SDK的init过程不需要切换view，沿用之前的GameLogoView
	 * 其他值：标示该SDK的init过程自己不切换view，但我们为其指定了一个layout image view显示其平台logo
	 * */
	public int getPlatformLogoLayoutId();
	/*
	 * 
	 * */
	public void unInit();
	/*
	 * 
	 * */
	public GameInfo getGameInfo();
	/*
	 * 
	 * */
	public void callLogin();
	/*
	 * 
	 * */
	public void notifyLoginResult(LoginInfo login_result);
	
	/*
	 * 
	 * */
	public LoginInfo getLoginInfo();
	
	/*
	 * 
	 */
	public void onLoginGame();
	
	
	/*
	 * 
	 * */
	public void callLogout();
	/*
	 * 
	 * */
	public void callCheckVersionUpate();
	/*
	 * 这里只是通知检查到的更新信息，并不是更新操作（下载&覆盖安装）的结果
	 * */
	public void notifyVersionUpateInfo(VersionInfo version_info);
	/*
	 * 代币充值模式
	 * */
	public int callPayRecharge(PayInfo pay_info);
	/*
	 * 
	 * */
	public void notifyPayRechargeRequestResult(PayInfo pay_info);
	/*
	 * 平台用户中心
	 * */
	public void callAccountManage();
	/*
	 * 平台客户端SDK辅助产生唯一订单号
	 * */
	public String generateNewOrderSerial();
	/*
	 * 平台支持的用户反馈界面
	 * */
	public void callPlatformFeedback();
	/*
	 * 平台支持的分享到第三方
	 * */
	public void callPlatformSupportThirdShare(ShareInfo share_info);
	/*
	 * 游戏在平台的web论坛，在SDK内部打开
	 * */
	public void callPlatformGameBBS();
	/*
	 * 
	 * */
	public void onGamePause();
	/*
	 * 
	 * */
	public void onGameResume();
	/*
	 * 
	 * */
	public void onGameExit();
	/**
	 * 添加平台菜单toolBar
	 * 目前仅91平台支持 
	 * @param visible true:显示
	 * 				  false:隐藏
	 */
	public void callToolBar(boolean visible);
	/*
	 * 
	 * */
	public boolean isTryUser();
	/*
	 * 
	 * */
	public void callBindTryToOkUser();
	/*
	 * 
	 * */
	public void receiveGameSvrBindTryToOkUserResult(int result);
}


