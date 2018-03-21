package com.nuclear.dota.platform.kupai;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.os.Message;
import android.os.StrictMode;
import android.util.Log;
import android.widget.Toast;

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

import com.youai.sdk.active.OnInitCompleteListener;
import com.youai.sdk.active.YouaiCommplatform;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.YouaiError;
import com.youai.sdk.android.api.BindCallback;
import com.youai.sdk.android.entry.YouaiAppInfo;
import com.iapppay.mpay.ifmgr.SDKApi;
import com.iapppay.mpay.ifmgr.IPayResultCallback;
import com.iapppay.mpay.tools.PayRequest;
import com.iapppay.ui.IAPPPayBaseActivity;

public class PlatformKupaiLoginAndPay extends IAPPPayBaseActivity implements IPlatformLoginAndPay{

	private static final String TAG = PlatformKupaiLoginAndPay.class.getSimpleName();
	
	private IGameActivity 								mGameActivity;
	private IPlatformSDKStateCallback 					mCallback1;
	private IGameUpdateStateCallback 					mCallback2;
	private IGameAppStateCallback 						mCallback3;
	
	private Activity 									game_ctx = null;
	private GameInfo 									game_info = null;
	public  LoginInfo 									login_info = null;
	private VersionInfo 								version_info = null;
	public PayInfo 										pay_info = null;
	private boolean 									isLogin = false;
	private boolean						 				initOk = false;
	
	private String 										exOrderNo = null;
	
	private static PlatformKupaiLoginAndPay sInstance = null;
	
	private PlatformKupaiLoginAndPay(){}
	
	public static PlatformKupaiLoginAndPay getInstance(){
		if(sInstance == null)
			sInstance = new PlatformKupaiLoginAndPay();
		return sInstance;
	}
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.use_platform_sdk_type = 1;// 0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Kupai;
		
		SDKApi.init(this.game_ctx, SDKApi.PORTRAIT, game_info.app_id_str);
		SDKApi.preGettingData(this.game_ctx);
		
		YouaiAppInfo youaiAppInfo = new YouaiAppInfo();
		youaiAppInfo.setAppId(game_info.app_id);
		youaiAppInfo.setAppKey(game_info.app_key);
		youaiAppInfo.setAppSecret(game_info.app_secret);
		youaiAppInfo.setCtx(this.game_ctx);
		
		YouaiCommplatform.getInstance().Init(this.game_ctx, youaiAppInfo, new OnInitCompleteListener(){

			@Override
			protected void onComplete(int arg0) {
				// TODO Auto-generated method stub
				super.onComplete(arg0);
				initOk = true;
				mCallback1.notifyInitPlatformSDKComplete();
			}

			@Override
			protected void onFailed(int code, String msg) {
				// TODO Auto-generated method stub
				super.onFailed(code, msg);
				initOk = false;
				mCallback1.notifyInitPlatformSDKComplete();
			}
			
		});
		
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		// TODO Auto-generated method stub
		mCallback1=callback1;
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		// TODO Auto-generated method stub
		mCallback2=callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		// TODO Auto-generated method stub
		mCallback3 = callback3;
		final IGameAppStateCallback callback = mCallback3;
		YouaiCommplatform.getInstance().setYouaiBind(new BindCallback(){

			@Override
			public void onBindSuccess() {
				// TODO Auto-generated method stub
				super.onBindSuccess();
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
		return R.layout.logo_layout;
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
		
		PlatformKupaiLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub

		
		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
        /*.detectDiskReads().detectDiskWrites()*/.detectNetwork()
        /*.penaltyLog()*/.build());
		mCallback3.showWaitingViewImp(false, -1, "正在登录");
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
		// TODO Auto-generated method stub
		login_info=null;
		login_info=login_result;
		if(login_result!=null){
			login_info.account_uid_str =PlatformAndGameInfo.enPlatformShort_Kupai+login_info.account_uid_str;
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		return this.login_info;
	}

	@Override
	public void onLoginGame() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub
		YouaiCommplatform.getInstance().youaiLogout(game_ctx);
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		login_info.account_uid_str = "";
		login_info.account_nick_name = "";
		notifyLoginResult(login_info);
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
		int waresid = 0;
		if(pay_info.price == 10){
			waresid = IAppPaySDKConfig.WARES_ID_1;
		}else if(pay_info.price == 30){
			waresid = IAppPaySDKConfig.WARES_ID_2;
		}else if(pay_info.price == 50){
			waresid = IAppPaySDKConfig.WARES_ID_3;
		}else if(pay_info.price == 100){
			waresid = IAppPaySDKConfig.WARES_ID_4;
		}else if(pay_info.price == 200){
			waresid = IAppPaySDKConfig.WARES_ID_5;
		}else if(pay_info.price == 500){
			waresid = IAppPaySDKConfig.WARES_ID_6;
		}else if(pay_info.price == 1000){
			waresid = IAppPaySDKConfig.WARES_ID_7;
		}else if(pay_info.price == 2000){
			waresid = IAppPaySDKConfig.WARES_ID_8;
		}else if(pay_info.price == 5000){
			waresid = IAppPaySDKConfig.WARES_ID_9;
		}
		
		exOrderNo = pay_info.description + "-" + pay_info.product_id.split("\\.", 2)[0] + "-" 
				+ PlatformKupaiLoginAndPay.getInstance().login_info.account_uid_str;
		PayRequest payRequest = new PayRequest();
		payRequest.addParam("appid", game_info.app_id_str);
		payRequest.addParam("waresid", waresid);
		payRequest.addParam("quantity", 1);
		payRequest.addParam("exorderno", pay_info.order_serial);
		payRequest.addParam("price", (int)(pay_info.price * 100));
		payRequest.addParam("cpprivateinfo", exOrderNo);//区号-物品id-userid带前缀
		String paramUrl = payRequest.genSignedOrdingParams(game_info.public_str);
		
		SDKApi.startPay(game_ctx, paramUrl, new IPayResultCallback() {
			@Override
			public void onPayResult(int resultCode, String signValue,String resultInfo) {//resultInfo = 应用编号&商品编号&外部订单号
				if (SDKApi.PAY_SUCCESS == resultCode) {
					if (null == signValue) {
						// 没有签名值，默认采用finish()，请根据需要修改
						Toast.makeText(game_ctx, "没有签名值", Toast.LENGTH_SHORT).show();
						//finish();
					}
					boolean flag = PayRequest.isLegalSign(signValue,game_info.public_str);
					if (flag) {
						Toast.makeText(game_ctx, "支付成功", Toast.LENGTH_SHORT).show();
						// 合法签名值，支付成功，请添加支付成功后的业务逻辑
						PlatformKupaiLoginAndPay.getInstance().pay_info.result = 0;
						PlatformKupaiLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformKupaiLoginAndPay.getInstance().pay_info);
					} else {
						Toast.makeText(game_ctx, "支付成功，但是验证签名失败",Toast.LENGTH_SHORT).show();
						// 非法签名值，默认采用finish()，请根据需要修改
					}
				} else if(SDKApi.PAY_CANCEL == resultCode){
					Toast.makeText(game_ctx, "取消支付", Toast.LENGTH_SHORT).show();
					// 取消支付处理，默认采用finish()，请根据需要修改
					
				}else if(SDKApi.PAY_FAIL == resultCode){
					Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT).show();
				}else if(SDKApi.PAY_HANDLING == resultCode){
					Toast.makeText(game_ctx, "稍后返回支付结果", Toast.LENGTH_SHORT).show();
				}else {
					Toast.makeText(game_ctx, "支付失败", Toast.LENGTH_SHORT).show();
					// 计费失败处理，默认采用finish()，请根据需要修改
				}
		
			}
		});
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
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString().replace("-", "");
	}

	@Override
	public void callPlatformFeedback() {
		// TODO Auto-generated method stub
		if(Cocos2dxHelper.nativeHasEnterMainFrame()){
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
		if(com.youai.sdk.android.config.Config.USERTYPE[2].equals(YouaiCommplatform.getInstance().getLoginUser().getUserType())){
			return true;
		}
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
