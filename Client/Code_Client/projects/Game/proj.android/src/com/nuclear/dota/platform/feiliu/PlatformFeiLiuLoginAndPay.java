package com.nuclear.dota.platform.feiliu;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.widget.Toast;

import com.fl.gamehelper.base.info.AccountInfo;
import com.fl.gamehelper.base.info.UserInfo;
import com.fl.gamehelper.managers.ChargeManager;
import com.fl.gamehelper.managers.CommunityManager;
import com.fl.gamehelper.managers.FlGameSdkMSg;
import com.fl.gamehelper.managers.SDKInitializeCallback;
import com.fl.gamehelper.managers.SDKInitializeManager;
import com.fl.gamehelper.managers.UserAccountCallback;
import com.fl.gamehelper.managers.UserAccountManager;
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

public class PlatformFeiLiuLoginAndPay implements IPlatformLoginAndPay,UserAccountCallback , SDKInitializeCallback {
	
	public static final String TAG = PlatformFeiLiuLoginAndPay.class.getSimpleName();
	
	private IGameActivity                               mGameActivity;
	private IPlatformSDKStateCallback                   mCallback1;
	private IGameUpdateStateCallback                    mCallback2;
	private IGameAppStateCallback                       mCallback3;
	
	private UserAccountManager                          mUserAccountManager;
	
	private Activity                                    game_ctx = null;
	private GameInfo                                    game_info = null;
	private LoginInfo                                   login_info = null;
	private VersionInfo                                 version_info = null;
	private PayInfo                                     pay_info = null;
	private boolean                                     isLogin = false;
	private GameSdkMSgReceiver                          receiver;
	
	private static PlatformFeiLiuLoginAndPay            sInstance = null;
	public static PlatformFeiLiuLoginAndPay getInstance(){
		if(sInstance == null){
			sInstance = new PlatformFeiLiuLoginAndPay();
		}
		return sInstance;
	}
	
	@Override
	public void onLoginGame() {
		
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		this.mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_FeiLiu;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_FeiLiu;
		
		//初始化飞流SDK
		com.fl.gamehelper.base.info.GameInfo aGInfo = new com.fl.gamehelper.base.info.GameInfo(this.game_ctx);
		SDKInitializeManager.getInstance().setmInitCallbck(PlatformFeiLiuLoginAndPay.this);
		SDKInitializeManager.getInstance().initSDK(this.game_ctx, aGInfo, false);
		
		//实例化UserAccountManager对象
		mUserAccountManager = new UserAccountManager(this.game_ctx); 
		
		
		IntentFilter intentFilter = new IntentFilter();
		intentFilter.addAction("com.fl.gamesdk.flsdk_play_game_action");
		receiver = new GameSdkMSgReceiver();
		
		this.game_ctx.registerReceiver(receiver, intentFilter);
		
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
	}

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
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return -1;
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
		//
		mUserAccountManager = null;
		
		PlatformFeiLiuLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}
	
	@Override
	public void callLogin() {
		
		int islogin = mUserAccountManager.getLogonStatus();
		switch (islogin) {
		case 0:// 0 未登录
			mUserAccountManager.flLogin(isAutoLogin(game_ctx));
			break;
		case 1: //已登陆
		AccountInfo ainfo = mUserAccountManager.getFlAccountInfo();  //获取飞流SDK登录信息
		//获取uuid，必选项，与游戏玩家账号一一对应
		String uuid = ainfo.getUuid();

		UserInfo _u = UserInfo.getUserInfo(this.game_ctx);
		LoginInfo login_info = new LoginInfo();
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
		String sourceid = ainfo.getSourceid();
		if(sourceid.equals("0"))//飞流账号
		{
			login_info.login_session = ainfo.getUniqueid();
			login_info.account_uid_str = uuid;
			login_info.account_uid = Long.parseLong(login_info.account_uid_str);
		
			login_info.account_nick_name = _u.getmUserName();
			isLogin = true;
			PlatformFeiLiuLoginAndPay.getInstance().notifyLoginResult(login_info);
		}
		else if(sourceid.equals("2"))
		{
			login_info.login_session = ainfo.getUniqueid();
			login_info.account_uid_str = uuid;
			login_info.account_uid = Long.parseLong(login_info.account_uid_str);

			login_info.account_nick_name = ainfo.getUniqueid();
			isLogin = true;
			PlatformFeiLiuLoginAndPay.getInstance().notifyLoginResult(login_info);
		}
		else if(sourceid.equals("6"))
		{
			login_info.login_session = ainfo.getUniqueid();
			login_info.account_uid_str = uuid;
			login_info.account_uid = Long.parseLong(login_info.account_uid_str);
		
			login_info.account_nick_name = _u.getmUUid();
			isLogin = true;
			PlatformFeiLiuLoginAndPay.getInstance().notifyLoginResult(login_info);
		}
	}
}
	
	/*
	 * 内部类----广播消息
	 */
	public class GameSdkMSgReceiver extends BroadcastReceiver
	{
		@Override
		public void onReceive(Context context, Intent intent) {
			// TODO Auto-generated method stub
			if (intent.getAction().equals(FlGameSdkMSg.PLAY_GAME_ACTION)) //action常量
			{
				String _msg = intent.getStringExtra(FlGameSdkMSg.MSG_TAG); //tag常量
				if (_msg.equals(FlGameSdkMSg.MSG_TO_GAME_MAIN_SCREEN))
				{
					/*Intent _toGameScreenIntent = new Intent(context, GameActivity.class);
					_toGameScreenIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					context.startActivity(_toGameScreenIntent);*/
				}
				else if (_msg.equals(FlGameSdkMSg.MSG_LOGIN_RESULT)) //登录结果通知
				{
					Boolean _succ = intent.getBooleanExtra(FlGameSdkMSg.MSG_OP_RES, true); // 判断登录是否成功
					if (_succ)   //登录成功后的操作
					{
						//Toast.makeText(context, "登陆成功！", Toast.LENGTH_SHORT).show();
						callLogin();
						
						Intent _toGameScreenIntent = new Intent(context, FeiLiuActivity.class);
						_toGameScreenIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						context.startActivity(_toGameScreenIntent);
					}
					else  //登录失败后的操作
					{
						callLogin();
						Toast.makeText(context, "登陆失败！", Toast.LENGTH_SHORT).show();
					}
				}
				else if (_msg.equals(FlGameSdkMSg.MSG_LOGIN_CANCELED)) //用户取消登录的通知
				{	//callLogin();
					final IGameAppStateCallback callback = mCallback3;
					isLogin = false;
					callback.showWaitingViewImp(false, -1, "");
					Toast.makeText(context, "登陆取消！", Toast.LENGTH_SHORT).show();
					Intent _toGameScreenIntent = new Intent(context, FeiLiuActivity.class);
					_toGameScreenIntent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					context.startActivity(_toGameScreenIntent);
				}
				else if (_msg.equals(FlGameSdkMSg.MSG_LOGOUT_RESULT)) //用户注销当前账号的通知
				{	
					Toast.makeText(context, "账号登出成功！", Toast.LENGTH_SHORT).show();
					isLogin = false;
				}
				else if (_msg.equals(FlGameSdkMSg.MSG_ACCOUNT_UPLOAD_INFO)) //游戏上传玩家信息的通知
				{
					Boolean _succ = intent.getBooleanExtra(FlGameSdkMSg.MSG_OP_RES, true); // 判断操作结果
					if (_succ) //成功的操作
					{
						Toast.makeText(context, "上传成功！", Toast.LENGTH_SHORT).show();
					}
					else     //失败的操作
					{
						Toast.makeText(context, "上传失败！", Toast.LENGTH_SHORT).show();
					}
				}
				else if (_msg.equals(FlGameSdkMSg.MSG_CHARGE_CANCELED))   //用户取消购买的通知
				{
					Toast.makeText(context, "充值取消！", Toast.LENGTH_SHORT).show();
				}
				else if (_msg.equals(FlGameSdkMSg.MSG_CHARGE_RESULT)) //用户购买下单的通知
				{
					Boolean _succ = intent.getBooleanExtra(FlGameSdkMSg.MSG_OP_RES, true); //判断是否成功
					if (_succ)  //下单成功的操作
					{
						Toast.makeText(context, "下单成功！", Toast.LENGTH_SHORT).show();
					}
					else
					{
						Toast.makeText(context, "下单失败！", Toast.LENGTH_SHORT).show();
					}
				}else if(_msg.equals(FlGameSdkMSg.MSG_SET_ACCOUNT_RESULT)){ //游客转正账号的通知
					Boolean _succ = intent.getBooleanExtra(FlGameSdkMSg.MSG_OP_RES, true);//判断是否成功
					if(_succ){
						Toast.makeText(context, "设置账号成功！", Toast.LENGTH_SHORT).show();	
					}
				}
			}
		}
 
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_FeiLiu+login_info.account_uid_str;
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
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
		// TODO Auto-generated method stub

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
		int aError=0;
		this.pay_info = null;
		this.pay_info = pay_info;
		
		 float money=pay_info.price; // 商品价格，单位：元
         String productName=pay_info.product_name; // 商品名称
         String cporderid = pay_info.order_serial; // CP自定义信息，多为CP订单号
         String merpriv = pay_info.description + "-" + pay_info.product_id + "-"+this.login_info.account_uid_str;//区号-物品id，我们自己的订单号不是必须
		ChargeManager.flPayAsyn(this.game_ctx, productName,(int) (money*100) , cporderid , pay_info.product_name, merpriv);
		
		PlatformFeiLiuLoginAndPay.getInstance().pay_info.result = 0;
		PlatformFeiLiuLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformFeiLiuLoginAndPay.getInstance().pay_info);
		return aError;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		 //TODO Auto-generated method stub
		if(Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			CommunityManager.flBBS(game_ctx);
		}else
		{
			mUserAccountManager.flAccountManage(true);  //切换账号
		}
		
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
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
		  CommunityManager.flBBS(game_ctx);
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
		game_ctx.unregisterReceiver(receiver);
	}

	//初始化失败处理逻辑
	@Override
	public void initFailed() {
		// TODO Auto-generated method stub
	//	Toast.makeText(game_ctx,"初始化失败！", Toast.LENGTH_SHORT)
		//.show();
	}

	//初始化成功后，这里处理游戏的下一步逻辑；
	@Override
	public void initOver() {
		// TODO Auto-generated method stub
//		Toast.makeText(game_ctx,"初始化成功！", Toast.LENGTH_SHORT)
//		.show();
	}

	@Override
	public void UpdateGameInfoOver(boolean arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void acquireUserInfo(UserInfo arg0, boolean arg1) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void acquireUserNickName(String arg0) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void errorToExit() {
		// TODO Auto-generated method stub
		
	}
	
	public static boolean isAutoLogin(Context aContext)
	{
		SharedPreferences _sp = aContext.getSharedPreferences("fl_sdk_game_autologin_set", Context.MODE_PRIVATE);
		boolean _islandscape = _sp.getBoolean("isAutoLogin", true);
		return _islandscape;
	}

	public static void setAutoLogin(Context aContext, boolean isAutoLogin)
	{
		SharedPreferences _sp = aContext.getSharedPreferences("fl_sdk_game_autologin_set", Context.MODE_PRIVATE);
		Editor _editor = _sp.edit();
		_editor.putBoolean("isAutoLogin", isAutoLogin);
		_editor.commit();

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
