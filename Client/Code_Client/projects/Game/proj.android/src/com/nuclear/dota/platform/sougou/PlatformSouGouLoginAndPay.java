package com.nuclear.dota.platform.sougou;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.app.Application;
import android.util.Log;
import android.widget.Toast;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;

import com.sogou.gamecenter.sdk.FloatMenu;
import com.sogou.gamecenter.sdk.SogouGamePlatform;
import com.sogou.gamecenter.sdk.bean.UserInfo;
import com.sogou.gamecenter.sdk.bean.SogouGameConfig;
import com.sogou.gamecenter.sdk.listener.InitCallbackListener;
import com.sogou.gamecenter.sdk.listener.LoginCallbackListener;
import com.sogou.gamecenter.sdk.listener.PayCallbackListener;
import com.sogou.gamecenter.sdk.listener.PerfectAccountListener;
import com.sogou.gamecenter.sdk.listener.RefreshUserListener;
import com.sogou.gamecenter.sdk.listener.SwitchUserListener;
import com.sogou.gamecenter.sdk.listener.OnExitListener;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;

public class PlatformSouGouLoginAndPay extends Application implements IPlatformLoginAndPay {

	private static final String TAG = PlatformSouGouLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	private boolean                     isLogin = false;
	private boolean                     isLogining = false;
	
	
	private FloatMenu					mFloatMenu;
	
	private SogouGamePlatform mSogouGamePlatform = SogouGamePlatform.getInstance();
	
	
	private static PlatformSouGouLoginAndPay sInstance = null;
	public static PlatformSouGouLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformSouGouLoginAndPay();
		}
		return sInstance;
	}
	
	public PlatformSouGouLoginAndPay (){
		
	}
	
	@Override
	public void onLoginGame() {
		mFloatMenu.hide();
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		this.mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_SouGou;
		this.game_info.platform_type =PlatformAndGameInfo.enPlatform_SouGou;
		
		SogouGameConfig config = new SogouGameConfig();	
		config.devMode = false;
		config.gid = this.game_info.app_id;
		config.appKey = this.game_info.app_key;
		config.gameName = "刀塔传奇2(cjqlz)";
		
		mSogouGamePlatform.prepare(this.game_ctx, config);
		mSogouGamePlatform.setPushEnable(false);
		mSogouGamePlatform.init(this.game_ctx, new InitCallbackListener() {
			
			@Override
			public void initSuccess() {
				// TODO Auto-generated method stub
				Toast.makeText(PlatformSouGouLoginAndPay.this.game_ctx, "游戏初始化成功", Toast.LENGTH_SHORT).show();
			}
			
			@Override
			public void initFail(int arg0, String arg1) {
				// TODO Auto-generated method stub
				Toast.makeText(PlatformSouGouLoginAndPay.this.game_ctx, "游戏初始化失败，请重启！", Toast.LENGTH_SHORT).show();
			}
		});
		
		mFloatMenu = SogouGamePlatform.getInstance().createFloatMenu(this.game_ctx, true);
		
		mSogouGamePlatform.addRefreshUserListener(new RefreshUserListener() {
			@Override
			public void refresh(UserInfo userInfo) {
				Log.i("SouGouActivity","refresh:"+userInfo);
				if(Cocos2dxHelper.nativeHasEnterMainFrame()){
					GameActivity.requestRestart();
				}else{
					if(isLogin){
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.login_session = userInfo.getSessionKey();
						login_info.account_uid = userInfo.getUserId();
						login_info.account_uid_str = String.valueOf(login_info.account_uid);
						if(userInfo.getUser() != null){
							login_info.account_nick_name = userInfo.getUser();
						}
						
						isLogin = true;
						PlatformSouGouLoginAndPay.getInstance().notifyLoginResult(login_info);
					}
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
		
		SogouGamePlatform.getInstance().perfectAccount(game_ctx, new PerfectAccountListener() {
			
			@Override
			public void success() {
				// TODO Auto-generated method stub
				Toast.makeText(game_ctx, "账号完善成功", Toast.LENGTH_SHORT).show();
				callLogin();
			}
			
			@Override
			public void failure(int arg0) {
				//Toast.makeText(game_ctx, "账号完善失败："+arg0, Toast.LENGTH_SHORT).show();
			}
		});
		
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		// TODO Auto-generated method stub
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return R.layout.logo_sougou;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		// 界面销毁，浮动菜单需要回收
		mFloatMenu.hide();
		mSogouGamePlatform.loginout(game_ctx);
		mSogouGamePlatform.addRefreshUserListener(null);
		mGameActivity = null;
		mCallback1 = null;
		mCallback2 = null;
		mCallback3 = null;
        
		
		this.game_info = null;
		this.login_info = null;
		this.version_info = null;
		this.pay_info = null;
		PlatformSouGouLoginAndPay.sInstance = null;
		
		
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		boolean isSougouLogin = mSogouGamePlatform.isLogin(game_ctx);
		if(isLogin||isLogining||isSougouLogin){
			Log.w(TAG, "Logined");
			return;
		}
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		isLogining = true;
		SogouGamePlatform.getInstance().login(this.game_ctx, new LoginCallbackListener() {
			
			@Override
			public void loginSuccess(int code, UserInfo userInfo) {
				// TODO Auto-generated method stub
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = userInfo.getSessionKey();
				login_info.account_uid = userInfo.getUserId();
				login_info.account_uid_str = String.valueOf(login_info.account_uid);
				login_info.account_nick_name = userInfo.getUser();
				isLogin = true;
				PlatformSouGouLoginAndPay.getInstance().notifyLoginResult(login_info);
			}
			
			@Override
			public void loginFail(int code, String msg) {
				// TODO Auto-generated method stub
                Toast.makeText(game_ctx, msg, Toast.LENGTH_SHORT).show();
			}
		});
		callback.showWaitingViewImp(false, -1, "");
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result.login_result== PlatformAndGameInfo.enLoginResult_Success){
			if(mFloatMenu!=null){
				// 右上角位置，距左边为10，距下边为10位置（默认）
				mFloatMenu.setParamsXY(10, 10);
				mFloatMenu.show();
			}
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_SouGou+login_info.account_uid_str;
			if (login_info.account_nick_name == null || login_info.account_nick_name.isEmpty())
			{
				login_info.account_nick_name = "完善账号";
			}
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		if (login_info != null) {
			if (isLogin)
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
		this.pay_info = null;
		this.pay_info = pay_info;
		
		String appData = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		
		Map<String, Object> data = new HashMap<String, Object>();
		data.put("currency", "钻石");
		data.put("rate", 10);
		data.put("amount", (int)this.pay_info.price);
		data.put("product_name", this.pay_info.product_name);
		data.put("app_data", appData);
		
		SogouGamePlatform.getInstance().pay(this.game_ctx, data, new PayCallbackListener() {
			
			@Override
			public void paySuccess(String orderId, String appData) {
				// TODO Auto-generated method stub
				PlatformSouGouLoginAndPay.getInstance().pay_info.result = 0;
				PlatformSouGouLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformSouGouLoginAndPay.getInstance().pay_info);
				Toast.makeText(game_ctx, "订单号:"+orderId+",备注："+appData, Toast.LENGTH_SHORT).show();
				return;
			}
			
			@Override
			public void payFail(int code, String orderId, String appData) {
				// TODO Auto-generated method stub
				if(code == 0)
				{
					PlatformSouGouLoginAndPay.getInstance().pay_info.result = 0;
					PlatformSouGouLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformSouGouLoginAndPay.getInstance().pay_info);
					Toast.makeText(game_ctx, "订单号:"+orderId+",备注："+appData, Toast.LENGTH_SHORT).show();
					return;
				}
				else if(code == -1)
				{
					Toast.makeText(game_ctx, "失败", Toast.LENGTH_SHORT).show();
				}
				else if(code == 2)
				{
					Toast.makeText(game_ctx, "服务器错误", Toast.LENGTH_SHORT).show();
				}
				else if(code == 3001)
				{
					Toast.makeText(game_ctx, "提交订单失败", Toast.LENGTH_SHORT).show();
				}
				else if(code == 3002)
				{
					Toast.makeText(game_ctx, "无效的支付渠道", Toast.LENGTH_SHORT).show();
				}
				else if(code == 10002)
				{
					Toast.makeText(game_ctx, "取消支付", Toast.LENGTH_SHORT).show();
				}
			}
		},false);
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
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			Toast.makeText(game_ctx, "暂未开通，敬请期待!", Toast.LENGTH_SHORT).show();
			return;
		}
		if (PlatformSouGouLoginAndPay.getInstance().isLogin)
		{
			if(this.login_info.account_nick_name.equals("完善账号"))
			{
				SogouGamePlatform.getInstance().perfectAccount(game_ctx, new PerfectAccountListener() {
					@Override
					public void success() {
						// TODO Auto-generated method stub
						Toast.makeText(game_ctx, "账号完善成功", Toast.LENGTH_SHORT).show();
						
						SogouGamePlatform.getInstance().switchUser(game_ctx, switchUserListener);
					}
					
					@Override
					public void failure(int arg0) {
						Toast.makeText(game_ctx, "账号完善失败："+arg0, Toast.LENGTH_SHORT).show();
					}
				});
				return;
			}
			callLogout();
			SogouGamePlatform.getInstance().switchUser(this.game_ctx, switchUserListener);
		}
		else
		{
			SogouGamePlatform.getInstance().switchUser(game_ctx, switchUserListener);
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
		SogouGamePlatform.getInstance().goFeedBack(this.game_ctx);
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
		// 界面隐藏时，浮动菜单隐藏
		mFloatMenu.hide();		
	}

	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub
		mFloatMenu.show();
	}

	@Override
	public void onGameExit() {
		// TODO Auto-generated method stub
		
		Log.e(TAG, "on onGameExit");
		mSogouGamePlatform.exit(new OnExitListener(game_ctx) {
			
			@Override
			public void onCompleted() {
				// TODO Auto-generated method stub
				Log.e(TAG, "on Game Exit");
				game_ctx.finish();
				game_ctx = null;
			}
		});
	}
	
	@Override
	public void callToolBar(boolean visible) {
		// TODO Auto-generated method stub

	}

	@Override
	public boolean isTryUser() {
		// TODO Auto-generated method stub
		if (this.login_info.account_nick_name.equals("完善账号") || login_info.account_nick_name.isEmpty())
		{
			this.login_info.account_nick_name ="完善账号";
			return true;
		}
		else 
		{
			this.login_info.account_nick_name = "更换账号";
			return false;
		}
	}

	@Override
	public void callBindTryToOkUser() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public void onTerminate() {
		// TODO Auto-generated method stub
		super.onTerminate();
		
		Log.e(TAG,"onTerminate");
		// 防止内存泄露，清理相关数据务必调用SDK结束接口
		mSogouGamePlatform.onTerminate();
	}
	
	SwitchUserListener switchUserListener = new SwitchUserListener() {
		
		@Override
		public void switchSuccess(int code, UserInfo userInfo) {
			// TODO Auto-generated method stub
			Log.d(TAG,"switchSuccess code:"+code+" userInfo:"+userInfo);
			
			LoginInfo login_info = new LoginInfo();
			login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			login_info.login_session = userInfo.getSessionKey();
			login_info.account_uid = userInfo.getUserId();
			login_info.account_uid_str = String.valueOf(login_info.account_uid);
			login_info.account_nick_name = userInfo.getUser();
			isLogin = true;
			PlatformSouGouLoginAndPay.getInstance().notifyLoginResult(login_info);
		}
		
		@Override
		public void switchFail(int code, String msg) {
			// TODO Auto-generated method stub
			Log.e(TAG,"switchFail code:"+code+" msg:"+msg);	
		}
	};
}
