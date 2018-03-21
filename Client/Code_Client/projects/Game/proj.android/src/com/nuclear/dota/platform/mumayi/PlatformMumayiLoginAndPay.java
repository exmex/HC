package com.nuclear.dota.platform.mumayi;

import java.util.ArrayList;
import java.util.List;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.mumayi.paymentcenter.business.dao.onLoginListener;
import com.mumayi.paymentcenter.business.dao.onTradeListener;
import com.mumayi.paymentcenter.business.factory.AccountFactory;
import com.mumayi.paymentcenter.business.factory.UserInfoFactory;
import com.mumayi.paymentcenter.dao.dao.IFindDataCallback;
import com.mumayi.paymentcenter.ui.PaymentCenterContro;
import com.mumayi.paymentcenter.ui.PaymentCenterInstance;
import com.mumayi.paymentcenter.ui.PaymentPayContro;
import com.mumayi.paymentcenter.ui.pay.MMYPayHome;
import com.mumayi.paymentcenter.ui.util.MyDialog;
import com.mumayi.paymentcenter.util.PaymentLog;
import com.nuclear.DeviceUtil;
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
public class PlatformMumayiLoginAndPay implements IPlatformLoginAndPay,onTradeListener , onLoginListener{

	
	private static final String TAG = PlatformMumayiLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	private int 						auto_recalllogin_count = 0;
	 
	private static PlatformMumayiLoginAndPay sInstance = null;
	public  PaymentCenterContro		usercenter		= null;
	public  PaymentCenterInstance	centerinstance	= null;
	public  PaymentPayContro		payApi		= null;
	
	private MyDialog				dialog			= null;
	private static final int		CHECK_SUCCESS	= 0;
	private static final int		CHECK_ERROR		= 1;
	
	
	
	public static PlatformMumayiLoginAndPay getInstance() {
		
		if (sInstance == null) {
			sInstance = new PlatformMumayiLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformMumayiLoginAndPay() {
		
	}
	
	@Override
	public boolean isTryUser() {
		 	return false;
	}

	@Override
	public void callBindTryToOkUser() {
		// TODO Auto-generated method stub
	}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Mumayi;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_Mumayi;
		
		this.game_info = game_info;
		
		centerinstance = PaymentCenterInstance.getInstance(game_ctx);
		centerinstance.initial(game_info.app_key);
		// 设置SDK皮肤颜色
		centerinstance.setSkin(1);
		// 设置是否开启bug模式， true打开可以显示Log日志， false关系
		centerinstance.setTestMode(true);
		// 设置监听器，用来回调交易结果
		centerinstance.setTradeListener(PlatformMumayiLoginAndPay.this);
		centerinstance.setListeners(this);
		payApi = centerinstance.getPayApi();
		
		usercenter = centerinstance.getUserCenterApi();
		mCallback1.notifyInitPlatformSDKComplete();
		
		
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		// TODO Auto-generated method stub

		this.mCallback1 = callback1;
		
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		// TODO Auto-generated method stub
		this.mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		// TODO Auto-generated method stub
		this.mCallback3 = callback3;
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

	}

	@Override
	public GameInfo getGameInfo() {

		return this.game_info;
	}
	
	@Override
	public void onLoginGame() {
		
	}

	@Override
	public void callLogin() {
		// 确保每次在刚进入游戏都会检测本地数据
		new Thread(new CheckDataRunnable()).start();
		
	}
	
	public void callLoginGoto(){
		mCallback3.showWaitingViewImp(false, 0, "正在登录");
		usercenter.go2Login();
		
	}
	

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		mCallback3.showWaitingViewImp(false, 0, "登录结果");
		login_info = null;
		if(login_result.login_result==PlatformAndGameInfo.enLoginResult_Success){
			login_result.account_uid_str = PlatformAndGameInfo.enPlatformShort_Mumayi + login_result.account_uid_str;
			login_result.account_nick_name = "个人中心";
			login_info = login_result;
		}else{
			login_result.account_nick_name = "点击登录";
		}
		//
		if (login_result != null) {
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
			return login_info;
	}

	@Override
	public void callLogout() {
		AccountFactory.createFactory(game_ctx).loginOut();
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
		
		this.pay_info = pay_info;
		String extraInfo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid

		List<String> enablePayType = new ArrayList<String>();
		enablePayType.add("3"); //屏蔽mo9支付
		
		//extraInfo 不超过 125字节
		payApi.pay(game_ctx, pay_info.product_name, String.valueOf(pay_info.price), extraInfo, "1", enablePayType);
		
		return 0;
	}

	
	private void sendMessage(int type)
	{
		MumayiActivity.mLoginAndPayHandler.sendEmptyMessage(type);
	}
	
	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	
	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
			return;
		}
		else
		{
			usercenter.go2Ucenter();
		}
		 
	}

	@Override
	public String generateNewOrderSerial() {
		return DeviceUtil.generateUUID().replace("-", "");
	}

	@Override
	public void callPlatformFeedback() {
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
	 
	}

	@Override
	public void callPlatformGameBBS() {

	}

	@Override
	public void onGamePause() {

	}

	@Override
	public void onGameResume() {

	}

	@Override
	public void onGameExit() {
		
	}

	@Override
	public void callToolBar(boolean visible) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void onPayecoTradeFinish(String arg0)
	{
		Bundle bundle = new Bundle();
		// 存放易联支付失败的消息
		bundle.putString("tradeInfo", arg0);
		Message msg = Message.obtain();
		msg.what = 10000;
		msg.setData(bundle);
		MumayiActivity.mLoginAndPayHandler.sendMessage(msg);
	}

	/* (non-Javadoc)
	 * @see com.mumayi.paymentcenter.business.dao.onTradeListener#onTradeFinish(int, android.content.Intent)
	 */
	@Override
	public void onTradeFinish(int arg0, Intent arg1)
	{
		if (arg0 == 100)
		{
			// 可在此处获取到提交的商品信息
			Bundle bundle = arg1.getExtras();
			String orderId = "";
			String productName = "";
			String productPrice = ""; // 产品价格
			String productDesc = "";
			String payType = "";

			payType = MMYPayHome.PAY_TYPE;
			orderId = bundle.getString("orderId");
			productName = bundle.getString("productName");
			productPrice = bundle.getString("productPrice");
			productDesc = bundle.getString("productDesc");
			Log.d("支付接口回调", "成功");
		}
		else
		{
			Log.d("支付接口回调", "失败");
			Toast.makeText(game_ctx, "交易失败", 0).show();
		}
	}

	class CheckDataRunnable implements Runnable
	{
		@Override
		public void run()
		{
			UserInfoFactory.createDataControllerFactory(game_ctx).getUser(new IFindDataCallback()
			{
			@Override
			public void onFindDataFinish(String uname,String uid, String token)
				{
					if (uname != null && uid != null && token != null)
					{
							//如果这些数据都不为空，则说明本地有用户帐号信息，则可以在此直接进入游戏，如果需要向服务器验证一次，才算是登录，，可用token与uid用post方式请求服务器验证接口，与登录接口一样.
							PaymentLog.getInstance().d("token》》"+token+"  uname>>"+uname +"   uid>>"+uid);
							MumayiActivity.mUid = uid;
							MumayiActivity.mUserName = uname;
							MumayiActivity.mToken = token;
							sendMessage(CHECK_SUCCESS);
					}
					else
					{
							// 这个是进入木蚂蚁定义的注册登录界面
							sendMessage(CHECK_ERROR);
							// 也可以调用你自己定义的注册登录界面，里面的方法仿造paymentcenterlogin,和paymentcenterregist
					}
				}
			});
		}	
	}

	@Override
	public void onLoginFinish(String uname, String uid, String token, String session) {
		LoginInfo login_info = new LoginInfo();
		if("".equals(uid)&&"".equals(uname)){
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		login_info.account_uid_str = "";
		PlatformMumayiLoginAndPay.getInstance().notifyLoginResult(login_info);
		}else
		{
			login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			login_info.account_uid_str = uid;
			login_info.account_nick_name = uname;
			PlatformMumayiLoginAndPay.getInstance().notifyLoginResult(login_info);
		}
	}

	@Override
	public void onLoginOut(String arg0) {
		
	}

 }
