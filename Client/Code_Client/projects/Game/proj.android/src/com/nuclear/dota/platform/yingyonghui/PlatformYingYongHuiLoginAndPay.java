package com.nuclear.dota.platform.yingyonghui;

import java.util.UUID;

import android.app.Activity;
import android.content.pm.ActivityInfo;
import android.util.Log;
import android.widget.Toast;

import com.appchina.model.ErrorMsg;
import com.appchina.model.LoginErrorMsg;
import com.appchina.usersdk.Account;
import com.appchina.usersdk.AccountCenterListener;
import com.appchina.usersdk.AccountCenterOpenShopListener;
import com.appchina.usersdk.AccountManager;
import com.appchina.usersdk.CallBackListener;
import com.appchina.usersdk.SplashListener;
import com.appchina.usersdk.YYHToolBar;
import com.iapppay.mpay.ifmgr.IPayResultCallback;
import com.iapppay.mpay.ifmgr.SDKApi;
import com.iapppay.mpay.tools.PayRequest;
import com.nuclear.IGameActivity;
import org.cocos2dx.lib.Cocos2dxHelper;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.FeedBackDialog;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.LastLoginHelp;
import com.nuclear.dota.Config;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;

public class PlatformYingYongHuiLoginAndPay implements IPlatformLoginAndPay {
	
	public static final String TAG = PlatformYingYongHuiLoginAndPay.class.getSimpleName();
	
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
	private YYHToolBar 									mYyhToolBar;
	
	private static PlatformYingYongHuiLoginAndPay sInstance = null;
	public static PlatformYingYongHuiLoginAndPay getInstance(){
		if(sInstance == null){
			sInstance = new PlatformYingYongHuiLoginAndPay();
		}
		return sInstance;
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		this.mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_YingYongHui;
		this.game_info.platform_type =PlatformAndGameInfo.enPlatform_YingYongHui;
		
		SDKApi.init(this.game_ctx, SDKApi.PORTRAIT, game_info.app_id_str);
		
		isLogin = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
		
	}

	@Override
	public void onLoginGame() {
		
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
		PlatformYingYongHuiLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		if(this.isLogin){
			Log.w(TAG, "Logined");
			return;
		}
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		AccountManager.initSetting(game_ctx);
		//开启欢迎界面
		AccountManager.openYYHSplash(game_ctx, ActivityInfo.SCREEN_ORIENTATION_PORTRAIT, 1500, new SplashListener() {
			@Override
			public void onAnimOver() {
				// TODO Auto-generated method stub
				//欢迎界面结束的回调
				//开启登录Activity
				AccountManager.openYYHLoginActivity(game_ctx, ActivityInfo.SCREEN_ORIENTATION_PORTRAIT, new CallBackListener() {
					
					@Override
					public void onLoginSuccess(Activity activity, Account account) {
						// TODO Auto-generated method stub
					//  用户唯一标识 
						String userId =""+account.userId;
						String userName = account.userName;
						//  开放用户名（强烈推荐使用，为用户注册时使用的标准名称可能是用户名、手机号码或者邮箱） 
						//String openName = account.openName;
						//  账户类型（现只支持应用汇账户类型yyh_account） 
					//	String accountType = account.accountType;
						// 用户昵称
//						String nickName = account.nickName;
						//  用来获取用户详细信息的令牌
						String ticket = account.ticket;
						
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.login_session = ticket;
						login_info.account_uid_str = userId;
						login_info.account_uid = Long.parseLong(login_info.account_uid_str);
						//login_info.account_uid = Long.parseLong(userId);
						login_info.account_nick_name = userName;
						isLogin = true;
						
						//需要调用LoginActivity以后才初始化
						/*
						 * @param activity
						 * 
						 * @param place 悬浮框初始位置
						 * 
						 * @param color 悬浮框样式，现在固定为小鸟
						 * 
						 * @param orientation 方向
						 * 
						 * @param fullScreen 是否全屏
						 * 
						 * @param accountCenterListener
						 * 个人中心的Listener，包括注销和切换账号
						 * 
						 * @param autoUnfold 点击客服等自动关闭
						 * 
						 * @param isUnfold 默认状态{关闭 展开}
						 */
						if (mYyhToolBar == null){
							mYyhToolBar = new YYHToolBar(
									game_ctx,
									YYHToolBar.YYH_TOOLBAR_MID_LEFT,
									YYHToolBar.YYH_TOOLBAR_BLUE,
									ActivityInfo.SCREEN_ORIENTATION_PORTRAIT,
									false, new AccountCenterListener() {
										
										@Override
										public void onLogout() {
											// TODO Auto-generated method stub
											mYyhToolBar.hide();
											//用户登出的回调
											if(Cocos2dxHelper.nativeHasEnterMainFrame())
											{
												GameActivity.requestRestart();
												return;
											}
											else
											{
												callLogout();
												callLogin();
												return;
											}
										}
										
										@Override
										public void onChangeAccount(Account account2, Account account) {  //account2 表示当前账号,account表示切换的账号
											// TODO Auto-generated method stub
											if(Cocos2dxHelper.nativeHasEnterMainFrame())
											{
												GameActivity.requestRestart();
												return;
											}
											else
											{
											//  用户唯一标识 
												String userId =""+account.userId;
												String userName = account.userName;
												//  开放用户名（强烈推荐使用，为用户注册时使用的标准名称可能是用户名、手机号码或者邮箱） 
												//String openName = account.openName;
												//  账户类型（现只支持应用汇账户类型yyh_account） 
											//	String accountType = account.accountType;
												// 用户昵称
//												String nickName = account.nickName;
												//  用来获取用户详细信息的令牌
												String ticket = account.ticket;
												
												LoginInfo login_info = new LoginInfo();
												login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
												login_info.login_session = ticket;
												login_info.account_uid_str = userId;
												login_info.account_uid = Long.parseLong(login_info.account_uid_str);
												//login_info.account_uid = Long.parseLong(userId);
												login_info.account_nick_name = userName;
												isLogin = true;
												
												Toast.makeText(game_ctx, "账号切换成功!",Toast.LENGTH_SHORT).show();
												
												PlatformYingYongHuiLoginAndPay.getInstance().notifyLoginResult(login_info);
											}
										}
									}, true, new AccountCenterOpenShopListener() {
										
										@Override
										public boolean openShop(Activity arg0) {
											// TODO Auto-generated method stub
											//Intent it = new Intent(game_ctx, Test.class);
											//startActivity(it);
											return false;
										}
									}, true);
						}
						
						mYyhToolBar.show();
						
						activity.finish();
						PlatformYingYongHuiLoginAndPay.getInstance().notifyLoginResult(login_info);
					
					}
					
					@Override
					public void onLoginError(Activity activity, LoginErrorMsg error) {
						// TODO Auto-generated method stub
						//  用户取消登录(用户按 Back 键取消登录
						if(error.status == 100){
							callback.showWaitingViewImp(false, -1, "");
							//  关闭登录界面(为保证用户开始游戏前必须登录，此处不推荐调用 finish()方法)
							//activity.finish();
							Toast.makeText(game_ctx,"取消登陆！", Toast.LENGTH_SHORT)
			    			.show();
							
						}
						if(error.status == 201){
							Toast.makeText(game_ctx,"用户名不能为空！", Toast.LENGTH_SHORT)
			    			.show();
						}
						if(error.status == 202){
							Toast.makeText(game_ctx,"密码不能为空！", Toast.LENGTH_SHORT)
			    			.show();
						}
					}
					
					@Override
					public void onError(Activity arg0, ErrorMsg arg1) {
						// TODO Auto-generated method stub
						String errorMessage=arg1.message;
		                Toast.makeText(game_ctx,errorMessage, Toast.LENGTH_SHORT)
		    			.show();
					}
				}, true);
			}
		});
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_YingYongHui+login_info.account_uid_str;
			//Toast.makeText(game_ctx, "登录成功，点击进入游戏", Toast.LENGTH_SHORT).show();
			
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
		
		int aError=0;
		this.pay_info = null;
		this.pay_info = pay_info;
		
		String extInfo=pay_info.order_serial; // CP自定义信息，多为CP订单号
		extInfo = pay_info.description + "-" + pay_info.product_id+"-"+this.login_info.account_uid_str;//区号-物品id，我们自己的订单号不是必须 (15-6.haizeiwang.nuclear)
		
		PayRequest payRequest = new PayRequest();
		payRequest.addParam("notifyurl", this.game_info.pay_addr);  //交易结果同步回调地址。
		payRequest.addParam("appid", this.game_info.app_id_str);
		String waresid = getYYHPay((int)this.pay_info.price);
		payRequest.addParam("waresid", waresid);
		payRequest.addParam("quantity", 1);
		payRequest.addParam("exorderno", pay_info.order_serial);//外部订单号外部订单号作为区分订单的标志，同时作为在支付成功后，应用对支付结果签名的校验字段，关系到支付安全，请务必定义。
		payRequest.addParam("price", (int)this.pay_info.price*100);   //这里的单位为分
		payRequest.addParam("cpprivateinfo", extInfo);
		
		
		String paramUrl = payRequest.genSignedUrlParamString(this.game_info.app_key);
		SDKApi.startPay(this.game_ctx,paramUrl, new IPayResultCallback() {
			
			@Override
			public void onPayResult(int resultCode, String signValue,String resultInfo) {//resultInfo = 应用编号&商品编号&外部订单号
				// TODO Auto-generated method stub
				if (SDKApi.PAY_SUCCESS == resultCode) {
					Log.e("xx", "signValue = " + signValue);
					if (null == signValue) {
						// 没有签名值，默认采用finish()，请根据需要修改
						Log.e("xx", "signValue is null ");
						Toast.makeText(game_ctx, "没有签名值", Toast.LENGTH_SHORT).show();
						//    finish();
					}
					boolean flag = PayRequest.isLegalSign(signValue,game_info.app_key);
					if (flag) {
						Log.e("payexample", "islegalsign: true"+resultInfo);
						Toast.makeText(game_ctx, "支付成功", Toast.LENGTH_SHORT).show();
						// 合法签名值，支付成功，请添加支付成功后的业务逻辑
						
						PlatformYingYongHuiLoginAndPay.getInstance().pay_info.result = 0;
						PlatformYingYongHuiLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformYingYongHuiLoginAndPay.getInstance().pay_info);
					} else {
						Toast.makeText(game_ctx, "支付成功，但是验证签名失败",Toast.LENGTH_SHORT).show();
						// 非法签名值，默认采用finish()，请根据需要修改
					}
				} else if(SDKApi.PAY_CANCEL == resultCode){
					Toast.makeText(game_ctx, "取消支付", Toast.LENGTH_SHORT).show();
					// 取消支付处理，默认采用finish()，请根据需要修改
					Log.e("fang", "return cancel");
				}else {
					Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT).show();
					// 计费失败处理，默认采用finish()，请根据需要修改
					Log.e("fang", "return Error");
				}
			}
		});
		return aError;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		AccountManager.openYYHAccountCenter(this.game_ctx, ActivityInfo.SCREEN_ORIENTATION_PORTRAIT, true,new AccountCenterListener() {
			
			@Override
			public void onLogout() {
				// TODO Auto-generated method stub
				mYyhToolBar.hide();
				//用户登出的回调
				if(Cocos2dxHelper.nativeHasEnterMainFrame())
				{
					GameActivity.requestRestart();
					return;
				}
				else
				{
					callLogout();
					callLogin();
					return;
				}
			}
			
			@Override
			public void onChangeAccount(Account account2, Account account) {  //account2 表示当前账号,account表示切换的账号
				// TODO Auto-generated method stub
				if(Cocos2dxHelper.nativeHasEnterMainFrame())
				{
					GameActivity.requestRestart();
					return;
				}
				else
				{
				//  用户唯一标识 
					String userId =""+account.userId;
					String userName = account.userName;
					//  开放用户名（强烈推荐使用，为用户注册时使用的标准名称可能是用户名、手机号码或者邮箱） 
					//String openName = account.openName;
					//  账户类型（现只支持应用汇账户类型yyh_account） 
				//	String accountType = account.accountType;
					// 用户昵称
//					String nickName = account.nickName;
					//  用来获取用户详细信息的令牌
					String ticket = account.ticket;
					
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.login_session = ticket;
					login_info.account_uid_str = userId;
					login_info.account_uid = Long.parseLong(login_info.account_uid_str);
					//login_info.account_uid = Long.parseLong(userId);
					login_info.account_nick_name = userName;
					isLogin = true;
					
					Toast.makeText(game_ctx, "账号切换成功!",Toast.LENGTH_SHORT).show();
					
					PlatformYingYongHuiLoginAndPay.getInstance().notifyLoginResult(login_info);
				}
			}
		},null);

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
	
	public static String getYYHPay(int pirce){
		String waresid="";
		switch (pirce) {
		case 10:
			waresid = "1";
			break;
		case 30:
			waresid = "2";
			break;
		case 50:
			waresid = "3";
			break;
		case 100:
			waresid = "4";
			break;
		case 200:
			waresid = "5";
			break;
		case 500:
			waresid = "6";
			break;
		case 1000:
			waresid = "7";
			break;
		case 2000:
			waresid ="8";
			break;
		case 5000:
			waresid ="9";
			break;
		default:
			break;
		}
		return waresid;
	}

	@Override
	public void callToolBar(boolean visible) {
		// TODO Auto-generated method stub
		//展示工具条
		if (mYyhToolBar != null)
			mYyhToolBar.show();
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
