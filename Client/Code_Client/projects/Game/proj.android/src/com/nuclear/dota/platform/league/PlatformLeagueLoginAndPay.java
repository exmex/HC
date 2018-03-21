package com.nuclear.dota.platform.league;

import java.io.File;
import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.os.Message;
import android.os.StrictMode;
import android.util.Log;
import android.widget.Toast;

import com.nuclear.DeviceUtil;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.IniFileUtil;
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
import com.youai.sdk.active.OnInitCompleteListener;
import com.youai.sdk.active.YouaiCommplatform;
import com.youai.sdk.active.YouaiPay;
import com.youai.sdk.active.YouaiPayParams;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.YouaiError;
import com.youai.sdk.android.api.BindCallback;
import com.youai.sdk.android.entry.YouaiAppInfo;
public class PlatformLeagueLoginAndPay implements IPlatformLoginAndPay {

	
	private static final String TAG = PlatformLeagueLoginAndPay.class.getSimpleName();
	
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
	public  boolean initOk = false;
	 
	private static PlatformLeagueLoginAndPay sInstance = null;
	public static PlatformLeagueLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformLeagueLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformLeagueLoginAndPay() {
		
	}
	
	@Override
	public boolean isTryUser() {
		if(com.youai.sdk.android.config.YouaiConfig.USERTYPE[2].equals(YouaiCommplatform.getInstance().getLoginUser().getUserType())){
			return true;
		}else{
			return false;
		}
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
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_League;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_League;
		this.game_info = game_info;
		YouaiAppInfo youaiAppInfo = new YouaiAppInfo();
		youaiAppInfo.setAppId(game_info.app_id);
		youaiAppInfo.setAppKey(game_info.app_key);
		youaiAppInfo.setAppSecret(game_info.app_secret);
		youaiAppInfo.setCtx(game_ctx);
		YouaiCommplatform.getInstance().Init(this.game_ctx, youaiAppInfo, new OnInitCompleteListener(){
			@Override
			protected void onComplete(int arg0){
				initOk = true;
				mCallback1.notifyInitPlatformSDKComplete();
			}
			
			@Override
			protected void onFailed(int code, String msg) {
				initOk = false;
				mCallback1.notifyInitPlatformSDKComplete();
			}
		});
		
		
		//
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
		final IGameAppStateCallback callback = mCallback3;
		YouaiCommplatform.getInstance().setYouaiBind(new BindCallback(){

			@Override
			public void onBindSuccess() {
				callback.notifyTryUserRegistSuccess();
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
		// TODO Auto-generated method stub
		return this.game_info;
	}
	
	@Override
	public void onLoginGame() {
		
	}

	@Override
	public void callLogin() {
		
		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
        /*.detectDiskReads().detectDiskWrites()*/.detectNetwork()
        /*.penaltyLog()*/.build());
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		if(initOk){
			//Toast.makeText(game_ctx, "初始化成功", Toast.LENGTH_SHORT).show(); 
		}else{
			Toast.makeText(game_ctx, "初始化失败 请重新启动", Toast.LENGTH_SHORT).show(); 
			return;
		}
		
		
		
		if(!YouaiCommplatform.getInstance().isLogined()){
		//
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		YouaiCommplatform.getInstance().youaiLogin(game_ctx,new CallbackListener() {
			@Override
			public void onLoginSuccess(String backmsg) {
				 Log.e("YouaiLogin Succeess", backmsg);
		    	if(!isTryUser())
				 Toast.makeText(game_ctx, "登录成功", Toast.LENGTH_SHORT).show();
		    	LoginInfo login_info = new LoginInfo();
		    	JSONObject jsonback = null;
				try {
					jsonback  = new JSONObject(backmsg);
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.account_uid_str = jsonback.getJSONObject("data").getString("youaiId");
					login_info.account_nick_name = jsonback.getString("username");
					notifyLoginResult(login_info);
					mCallback3.showWaitingViewImp(false, -1, "已登录");
			    	Log.i(TAG, "msgstr"+backmsg);
				} catch (JSONException e) {
					//e.printStackTrace();
					mCallback3.showWaitingViewImp(false, -1, "正在登录");
				}
		    	
			}
			
			@Override
			public void onLoginError(YouaiError error) {
				LoginInfo login_info = new LoginInfo();
				Message msg = new Message();
				msg.what = 1;
				String msgstr = error.getMErrorMessage();
		    	msg.obj =msgstr;
		    	Toast.makeText(game_ctx,"登录失败", Toast.LENGTH_SHORT).show();
		    	mCallback3.showWaitingViewImp(false, -1, "登录失败");
		    	login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		    	login_info.account_user_name = "";
		    	notifyLoginResult(login_info);
		    	
		    	
			}
			
		});
		}else{
			mCallback3.showWaitingViewImp(false, -1, "已登录");
		}
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		if (login_info != null) {
			if (YouaiCommplatform.getInstance().isLogined())
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			else
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}

		return login_info;
	}

	@Override
	public void callLogout() {
		YouaiCommplatform.getInstance().youaiLogout(game_ctx);
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		//login_info.account_uid_str = "";
		//login_info.account_nick_name = "";
		notifyLoginResult(login_info);
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
		
		String phoneNubmer = null;
		File rootfiles = new File(mGameActivity.getAppFilesResourcesPath());
		File dynamicFile = new File(rootfiles.getAbsoluteFile()+File.separator+"dynamic.ini"); 
		if(dynamicFile.exists()&&dynamicFile.isFile()){   //判断目录是否存在  
			phoneNubmer = IniFileUtil.GetPrivateProfileString(dynamicFile.getAbsolutePath(), "YouaiHelp", "PhoneNumber", "");
        }
		YouaiPay.HelpPhone = phoneNubmer;
		
		YouaiPayParams payParams = new YouaiPayParams();
		this.pay_info = pay_info;
		payParams.setOrderId(generateNewOrderSerial());
		payParams.setDesc("刀塔传奇2");
		payParams.setMoney(pay_info.price);
		String extraInfo = pay_info.product_id+"_"+pay_info.description;//这里不需要puid了 +"-"+this.login_info.account_uid_str;
		payParams.setExtraInfo(extraInfo);
		/*try {
			payParams.setExtraInfo(DES_Youai.encrypt(extraInfo));
		} catch (Exception e) {
			e.printStackTrace();
		}*/
		
		
		YouaiCommplatform.getInstance().youaiEnterRecharge(game_ctx, payParams,new CallbackListener() {
			@Override
			public void onPaymentSuccess() {
				game_ctx.runOnUiThread(new Runnable() {
					
					@Override
					public void run() {
						notifyPayRechargeRequestResult(PlatformLeagueLoginAndPay.sInstance.pay_info);
						Toast.makeText(PlatformLeagueLoginAndPay.this.game_ctx, "提交成功", Toast.LENGTH_SHORT).show();		
					}
				});
				
			}
			
			@Override
			public void onPaymentError() {
				game_ctx.runOnUiThread(new Runnable() {
					
					@Override
					public void run() {
						Toast.makeText(PlatformLeagueLoginAndPay.this.game_ctx, "提交失败", Toast.LENGTH_SHORT).show();		
					}
				});
			}
			
		});
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	
	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			YouaiCommplatform.getInstance().youaiEnterAppUserCenter(game_ctx, new CallbackListener() {
				 @Override
				public boolean onLoginOutAfter() {
					 return false;
				}
			});
			return;
		}
		if (YouaiCommplatform.getInstance().isLogined()){
			YouaiCommplatform.getInstance().EnterAccountManage(game_ctx, new CallbackListener() {
				 @Override
					public boolean onLoginOutAfter() {
					 return true;
				 } 
			});
		}else{
		callLogin();
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
		YouaiCommplatform.getInstance().EnterAccountManage(game_ctx,new CallbackListener(){});
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

}
