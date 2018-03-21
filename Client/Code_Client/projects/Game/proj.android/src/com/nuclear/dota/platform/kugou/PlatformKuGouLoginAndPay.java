package com.nuclear.dota.platform.kugou;

import java.util.HashMap;
import java.util.Random;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.kugou.pay.android.IAccountStateListener;
import com.kugou.pay.android.IClient;
import com.kugou.pay.android.IKugouBackListener;
import com.kugou.pay.android.IRegisterListener;
import com.kugou.pay.android.UserAccount;
import com.kugou.pay.android.ui.KugouPayManager;
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

public class PlatformKuGouLoginAndPay implements IPlatformLoginAndPay {

private static final String TAG = PlatformKuGouLoginAndPay.class.toString();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	

	private boolean                     isLogin;
	
	private static PlatformKuGouLoginAndPay sInstance = null;
	public static PlatformKuGouLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformKuGouLoginAndPay();
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
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_KuGou;
		this.game_info.platform_type =PlatformAndGameInfo.enPlatform_KuGou;
		
		//初始化SDK
		KugouPayManager.getInstance().init(this.game_ctx, mClient,
				mAccountListener, mRegisterListener, mKugouBackListener);
		
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
		
	}
	
	private IClient mClient = new IClient() {
		/**
		 * 1、作用域：注册、充值、手游统计 2、游戏厂商提供给酷狗游戏的区服id（Serverid）
		 */
		@Override
		public int getServerId() {
			return Cocos2dxHelper.nativeGetServerId();
		}

		/**
		 * 1、作用域：充值 2、游戏厂商提供给酷狗游戏当前玩家的角色
		 */
		@Override
		public String getRole() {
			// 这个是不需要encode的，我们已经在sdk里encode了
			return "酷狗角色";
		}

		/**
		 * 1、作用域：注册、充值、手游统计 2、游戏厂商向酷狗游戏申请的游戏id（Gameid）
		 */
		@Override
		public int getGameId() {
			return game_info.gameid;
		}

		/**
		 * 1、作用域：充值 2、游戏厂商提供给酷狗游戏的订单号（数字、字符，不超过256个字符）
		 */
		@Override
		public String createNewOutOrderId() {
			// 这里为了测试，随机生成一个数
//			Random r = new Random();
//			int ra = Math.abs(r.nextInt());
//			return String.valueOf(ra);
			
			return UUID.randomUUID().toString();
		}

		/**
		 * 1、作用域：充值 2、此方法是充值时使用，用于游戏厂商和酷狗游戏约定的特殊参数的传递，如没有必要请返回一个null。 2、使用方法：
		 * 例如： 游戏方和酷狗游戏约定成了一个协议，第一参数是充值日期，第二个参数是角色级数
		 * extendMap.put(IClient.EXTEND1,"2012.9.1");
		 * extendMap.put(IClient.EXTEND2, "Lv99");
		 * 3、我们在SDK中已经encode了，不需要再encode了。
		 */
		@Override
		public HashMap<String, Object> getExtendParams() {
			
			String extInfo = pay_info.description + "-" + pay_info.product_id+"-"+login_info.account_uid_str;//区号-物品id，我们自己的订单号不是必须 (15-6.haizeiwang.nuclear)
			
			HashMap<String, Object> extendMap = new HashMap<String, Object>();
			extendMap.put(IClient.EXTEND1, extInfo);
			extendMap.put(IClient.EXTEND2, null);
			return extendMap;
		}

		/**
		 * 1、作用域：切换帐号 2、此方法是有游戏厂商决定“切换账号”后是否进行游戏重启的操作。 3、返回true表示重启，false表示不重启。
		 */
		@Override
		public boolean getIsRebootGameAfterAccountChange() {
			return false;
		}

		/**
		 * 1、作用域：切换帐号 2、前置条件：此方法需getIsRebootGameAfterAccountChange()方法返回true才执行。
		 * 3、游戏厂商在此方法中调用退出游戏程序关闭游戏，请返回true，游戏厂商调用SDK的结束进程的方法强制关闭游戏程序，请返回false。
		 * 4、建议游戏厂商在此方法中调用退出游戏程序关闭游戏。
		 */
		@Override
		public void getGameCloseMethod() {

		}

	};
	
	private IAccountStateListener mAccountListener = new IAccountStateListener() {
		/**
		 * 1、作用域：切换账号 2、切换帐号后重启之前的操作，如保存数据。若果您的程序支持角色动切换，则可以在这个方法，添加相关操作。
		 */
		@Override
		public void onAccountChanged(UserAccount newAccount) {
			 String userName = newAccount.getUserName();//玩家账号
//			 String nickName = muserData.getNickName();//玩家昵称
//			 String unixTime = account.getUnixTime();//时间截
//			 String password = muserData.getPasswor d();//玩家密码
			 String token = newAccount.getToken();//时间戳
			 
			 LoginInfo login_info = new LoginInfo();
			 login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			 login_info.login_session = token;
			 login_info.account_uid_str = userName;
			 login_info.account_nick_name = userName;
			 
			 isLogin = true;
			 
			 final IGameAppStateCallback callback = mCallback3;
			 callback.showWaitingViewImp(false, -1, "");
			 PlatformKuGouLoginAndPay.getInstance().notifyLoginResult(login_info);
		}

		/**
		 * 1、作用域：游戏登录 2、登录游戏成功后调用
		 */
		@Override
		public void onLoginSuccess(UserAccount account) {
			 String userName = account.getUserName();//玩家账号
//			 String nickName = muserData.getNickName();//玩家昵称
//			 String unixTime = account.getUnixTime();//时间截
//			 String password = muserData.getPassword();//玩家密码
			 String token = account.getToken();//时间戳
			 
			 LoginInfo login_info = new LoginInfo();
			 login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			 login_info.login_session = token;
			 login_info.account_uid_str = userName;
			 login_info.account_nick_name = userName;
			 
			 isLogin = true;
			 
			 final IGameAppStateCallback callback = mCallback3;
			 callback.showWaitingViewImp(false, -1, "");
			 PlatformKuGouLoginAndPay.getInstance().notifyLoginResult(login_info);
		}

		/**
		 * 1、作用域：游戏登录 2、游戏登录失败后调用
		 */
		@Override
		public void onLoginFaile(UserAccount account, String errorMsg) {
			Toast.makeText(game_ctx, errorMsg,
					Toast.LENGTH_SHORT).show();
		}
	};

	private IRegisterListener mRegisterListener = new IRegisterListener() {
		/**
		 * 1、作用域：非登录界面的注册账号（例：切换账号界面的注册） 2、注册成功后调用 3、return true：由游戏厂商软启动实现重启
		 * false：表示有SDK实现注册后重启，
		 */
		@Override
		public boolean onRegisterListener() { 
			boolean flag = false;
			Toast.makeText(game_ctx,
					"KugouPayManager.getInstance().userCenter()",
					Toast.LENGTH_SHORT).show();
			// 此接口用于非登录界面的注册（例：切换账号界面的注册），游戏厂商保存原账号的信息，调用相对应方法退到登录界面。
			// 建议游戏厂商在此调用退出登录界面相对应方法，退到游戏登录界面
			return flag;
		}
	};
	private IKugouBackListener mKugouBackListener = new IKugouBackListener() {
		/**
		 * 1、作用域：用户中心界面
		 * 2、调用KugouPayManager.getInstance().userCenter()模块，进入了用户中心界面
		 * ，不管以何种方式退出此模块，都会调用此方法。
		 */
		@Override
		public void onUserCenterBack() {
			Toast.makeText(game_ctx, "关闭用户中心",
					Toast.LENGTH_SHORT).show();
		}

		/**
		 * 1、作用域：注册界面 2、从登录界面进入注册界面，只有当注册成功后，才会调用此方法。
		 */
		@Override
		public void onRegisterBack() {
			Toast.makeText(game_ctx, "登陆成功,点击进入游戏",
					Toast.LENGTH_SHORT).show();
		}

		/**
		 * 1、作用域：充值界面 2、调用KugouPayManager.getInstance().recharge()模块，
		 * 进入了充值界面，不管以何种方式退出此模块，都会调用此方法。
		 */
		@Override
		public void onRechargeBack() {
			Toast.makeText(game_ctx, "充值取消",
					Toast.LENGTH_SHORT).show();
		}

		/**
		 * 1、作用域：注册界面 2、调用KugouPayManager.getInstance().onLoginGame()模块，
		 * 进入了登录界面，点击左上角的“返回”按钮或“back”键，才会调用此方法。
		 */
		@Override
		public void onLoginBack() {
			final IGameAppStateCallback callback = mCallback3;
			callback.showWaitingViewImp(false, -1, "");
			
			Toast.makeText(game_ctx, "取消登陆",
					Toast.LENGTH_SHORT).show();
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
		isLogin = false;
		//
		this.game_ctx = null;
		this.game_info = null;
		this.login_info = null;
		this.version_info = null;
		this.pay_info = null;
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
			Log.e(TAG, "LOGIN SUCCESS");
			
			final IGameAppStateCallback callback = mCallback3;
			callback.showWaitingViewImp(false, -1, "");
			PlatformKuGouLoginAndPay.getInstance().notifyLoginResult(login_info);
			return;
		}
		
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		
		KugouPayManager.getInstance().onLoginGame();

	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		this.login_info = null;
		this.login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformName_KuGou+login_info.account_uid_str;
			KugouPayManager.getInstance().showWelcomMessage(this.game_ctx);
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
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
		Log.d(TAG, "PlatformRenRenLoginAndPay:notifyVersionUpateInfo");
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			
			mCallback2.notifyVersionCheckResult(version_info);
		} 
	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		// TODO Auto-generated method stub
		int Error = 0;
		this.pay_info = null;
		this.pay_info = pay_info;
		
		KugouPayManager.getInstance().recharge();
		
		return Error;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		
		
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
			return;
		if (PlatformKuGouLoginAndPay.getInstance().isLogin)
			callLogout();
		KugouPayManager.getInstance().userCenter();
			
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
