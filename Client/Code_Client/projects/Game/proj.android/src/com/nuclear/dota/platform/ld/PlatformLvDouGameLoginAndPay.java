package com.nuclear.dota.platform.ld;

import java.util.Date;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import co.lvdou.sdk.LDSDK;
import co.lvdou.sdk.share.GameParamInfo;
import co.lvdou.sdk.share.LDCallbackListener;
import co.lvdou.sdk.share.LDLogLevel;
import co.lvdou.sdk.share.LDSDKCode;
import co.lvdou.sdk.share.PaymentInfo;
import co.lvdou.sdk.view.OrderInfo;

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
import com.qsds.ggg.dfgdfg.fvfvf.R;


public class PlatformLvDouGameLoginAndPay implements IPlatformLoginAndPay {
	
	
	public static final String TAG = PlatformLvDouGameLoginAndPay.class.getSimpleName();
	
	private IGameActivity                               mGameActivity;
	private IPlatformSDKStateCallback                   mCallback1;
	private IGameUpdateStateCallback                    mCallback2;
	private IGameAppStateCallback                       mCallback3;
	
	private Activity                                    game_ctx = null;
	private GameInfo                                    game_info = null;
	private LoginInfo                                   login_info = null;
	private VersionInfo                                 version_info = null;
	private PayInfo                                     pay_info = null;
	private boolean                                     isLogin = false;
	
	private static PlatformLvDouGameLoginAndPay sInstance = null;
	public static PlatformLvDouGameLoginAndPay getInstance(){
		if(sInstance == null){
			sInstance = new PlatformLvDouGameLoginAndPay();
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
		
		game_info.debug_mode =PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_LvDouGame;
		this.game_info.platform_type =PlatformAndGameInfo.enPlatform_LvDouGame;
		
		//this.game_info.app_id =10004;
		
		
		//初始化SDK
		final GameParamInfo paramInfo = new GameParamInfo();
		paramInfo.setAppId(this.game_info.app_id);
		paramInfo.setGameId(1);//游戏编号，可选
		paramInfo.setServerId(Cocos2dxHelper.nativeGetServerId());//服务器编号　可选
		try{
			LDSDK.getSDK().initLD(this.game_ctx, LDLogLevel.DEBUG, true, paramInfo, new LDCallbackListener<String>() {
				
				@Override
				public void callback(int code, String data) {
					// TODO Auto-generated method stub
	//				Logout.out("初始化监听器返回码 -> " + code);
					if(code == LDSDKCode.SUCCESS)
					{
						Log.e(TAG, "初始化SDK成功");
						return;
					}
					if(code ==LDSDKCode.INIT_FAIL)
					{
						Log.e(TAG, "初始化SDK失败");
						Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "初始化SDK失败", Toast.LENGTH_SHORT).show();
						return;
					}
				}
			});
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
		LDSDK.getSDK().setLogoutNotifyListener(new LDCallbackListener<String>() {
			
			@Override
			public void callback(int code, String data) {
				// TODO Auto-generated method stub
				if (code == LDSDKCode.NO_INIT)
				{
				    Log.e(TAG, "尚未初始化，无法进行充值操作");
					Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "尚未初始化，无法进行充值操作", Toast.LENGTH_SHORT).show();
				    return;
				}

				if (code == LDSDKCode.SUCCESS)
				{
					Log.e(TAG, "成功退出账号");
					Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "成功退出账号", Toast.LENGTH_SHORT).show();
				    return;
				}

				if (code == LDSDKCode.FAIL_API)
				{
					Log.e(TAG, "API调用失败");
					Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "API调用失败", Toast.LENGTH_SHORT).show();
				    return;
				}

				if (code == LDSDKCode.NO_LOGIN)
				{
					Log.e(TAG, "尚未登陆，无法进行登出操作");
					Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "尚未登陆，无法进行登出操作", Toast.LENGTH_SHORT).show();
				    return;
				}
			}
		});
		
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
		return 0;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return R.layout.logo_ld;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		
		//调用退出登录接口
		LDSDK.getSDK().logout();
		
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		if(isLogin)
		{
			Log.w(TAG, "Logined");
			return;
		}
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		
		//调用登录接口
		LDSDK.getSDK().login(this.game_ctx, new LDCallbackListener<String>() {
			
			@Override
			public void callback(int code, String data) {
				// TODO Auto-generated method stub
				//Logout.out("登陆监听器返回码 -> " + code);
				// 登录成功，可以执行后续操作
				if (code == LDSDKCode.SUCCESS)
				{
//				    updateLastMsg("登陆成功。\nuuid:" + LDSDK.getSDK().getUuid() + "\nssid:" + LDSDK.getSDK().getSsid());
					callback.showWaitingViewImp(false, -1, "");
					
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.login_session = LDSDK.getSDK().getSsid();
					login_info.account_uid_str = LDSDK.getSDK().getUuid();
					login_info.account_uid = Long.parseLong(LDSDK.getSDK().getUuid());
					login_info.account_nick_name = LDSDK.getSDK().getUuid();
					isLogin = true;
					PlatformLvDouGameLoginAndPay.getInstance().notifyLoginResult(login_info);
					
				    return;
				}

				// 登录界面关闭，游戏需判断此时是否已登录成功进行相应操作
				if (code == LDSDKCode.LOGIN_EXIT)
				{
					callback.showWaitingViewImp(false, -1, "");
				    return;
				}

				// 没有初始化就进行登录调用，需要游戏调用SDK初始化方法
				if (code == LDSDKCode.NO_INIT)
				{
					callback.showWaitingViewImp(false, -1, "");
				    Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "尚未初始化，无法登陆", Toast.LENGTH_SHORT).show();
				    
				    return;
				}
			}
		});
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_LvDou+login_info.account_uid_str;
			mGameActivity.showToastMsg("登录成功，点击进入游戏");
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
		isLogin = false;
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
		int Errer=0;
		this.pay_info = null;
		this.pay_info = pay_info;
		final PaymentInfo info = new PaymentInfo();
		info.setAmount(this.pay_info.price);//支付金额
		info.setNotifyUrl(this.game_info.pay_addr);//支付结果通知地址，请填写真实地址
		
		
		//String customInfo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		String customInfo = pay_info.description + "-" + pay_info.product_id.substring(0, pay_info.product_id.indexOf("."))+"-"+this.login_info.account_uid_str+"-"+(int)((new Date()).getTime()/1000);
		//info.setCustomInfo(customInfo);
		info.setCoopOrderId(customInfo);//订单编号
		info.setServerId(Cocos2dxHelper.nativeGetServerId());
		
		try{
			LDSDK.getSDK().pay(this.game_ctx,info, new LDCallbackListener<OrderInfo>() {
				
				@Override
				public void callback(int code, OrderInfo data) {
					// TODO Auto-generated method stub
					if (code == LDSDKCode.NO_INIT)
					{
					    Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "尚未初始化，无法进行充值操作", Toast.LENGTH_SHORT).show();
					    return;
					}

					if (code == LDSDKCode.SUCCESS) //充值成功
					{
					    //Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "充值成功,交易订单号:" + data.getOrderId() + ", 交易金额:" + data.getOrderAmount(), Toast.LENGTH_SHORT).show();
					    PlatformLvDouGameLoginAndPay.getInstance().pay_info.result = 0;
					    PlatformLvDouGameLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformLvDouGameLoginAndPay.getInstance().pay_info);
					    return;
					}

					if (code == LDSDKCode.PAY_EXIT)
					{
					    Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "充值界面已关闭", Toast.LENGTH_SHORT).show();
					    return;
					}

					if (code == LDSDKCode.FAIL_API)
					{
					    Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "API调用失败", Toast.LENGTH_SHORT).show();
					    return;
					}

					if (code == LDSDKCode.NO_LOGIN)
					{
					    Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "尚未登陆，无法进行充值操作", Toast.LENGTH_SHORT).show();
					    return;
					}
				}
			});
		}catch(Exception e)
		{
			e.printStackTrace();
		}
		
		return Errer;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		if (Cocos2dxHelper.nativeHasEnterMainFrame()){
			
			//进入用户中心接口
			LDSDK.getSDK().enterUserCenter(this.game_ctx, new LDCallbackListener<String>()
			{
			    @Override
			    public void callback(int code, String data)
			    {
			    	if (code == LDSDKCode.NO_INIT)
			    	{
			    		Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "尚未初始化，无法进入用户中心", Toast.LENGTH_SHORT).show();
			    		return;
			    	}
			    	if (code == LDSDKCode.NO_LOGIN)
			    	{
			    		Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "尚未登陆，无法进入用户中心", Toast.LENGTH_SHORT).show();
			    		return;
			    	}
			    	
			    	if (code == LDSDKCode.FAIL_API)
			    	{
			    		Toast.makeText(PlatformLvDouGameLoginAndPay.this.game_ctx, "API调用失败", Toast.LENGTH_SHORT).show();
			    		return;
			    	}
			    }
			});
			return;
		}if (PlatformLvDouGameLoginAndPay.getInstance().isLogin)
			callLogout();
		callLogin();
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

}
