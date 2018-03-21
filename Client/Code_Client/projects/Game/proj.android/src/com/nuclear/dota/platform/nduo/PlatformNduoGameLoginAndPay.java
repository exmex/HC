package com.nuclear.dota.platform.nduo;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Message;
import android.os.StrictMode;
import android.util.Log;
import android.widget.Toast;

import com.nduoa.nmarket.pay.api.android.PayConnect;
import com.nduoa.nmarket.pay.api.android.PayProxyActivity;
import com.nduoa.nmarket.pay.api.android.PayRequest;
import com.nduoa.nmarket.pay.api.android.PayUtil;
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
import com.youai.sdk.active.OnInitCompleteListener;
import com.youai.sdk.active.YouaiCommplatform;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.YouaiError;
import com.youai.sdk.android.api.BindCallback;
import com.youai.sdk.android.entry.YouaiAppInfo;

public class PlatformNduoGameLoginAndPay implements IPlatformLoginAndPay{
public static final String TAG = PlatformNduoGameLoginAndPay.class.getSimpleName();
	
	private IGameActivity                         mGameActivity;
	private IPlatformSDKStateCallback             mCallback1;
	private IGameUpdateStateCallback              mCallback2;
	private IGameAppStateCallback                 mCallback3;
	
	private Activity                              game_ctx = null;
	private GameInfo                              game_info = null;
	private LoginInfo                             login_info = null;
	private VersionInfo                           version_info = null;
	private PayInfo                               pay_info = null;
	private boolean                               isLogin = false;
	private boolean initOk = false;
	
	private String exOrderNo = null;
	
	private static PlatformNduoGameLoginAndPay   sInstance = null;
	public static PlatformNduoGameLoginAndPay getInstance()
	{
		if(sInstance == null)
		{
			sInstance = new PlatformNduoGameLoginAndPay();
		}
		return sInstance;
	}
	@Override
	public void onLoginGame() {
			// TODO Auto-generated method stub
			
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Nduo;
		YouaiAppInfo youaiAppInfo = new YouaiAppInfo();
		youaiAppInfo.setAppId(game_info.app_id);
		youaiAppInfo.setAppKey(game_info.app_key);
		youaiAppInfo.setAppSecret(game_info.app_secret);
		youaiAppInfo.setCtx(this.game_ctx);
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
		
		//初始化nduoSDK
		PayConnect.getInstance(mGameActivity.getActivity()).init(game_info.app_id_str);
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
		//
		
		PlatformNduoGameLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
        /*.detectDiskReads().detectDiskWrites()*/.detectNetwork()
        /*.penaltyLog()*/.build());
		
		if(initOk){
			//Toast.makeText(game_ctx, "初始化成功", Toast.LENGTH_SHORT).show(); 
		}else{
			Toast.makeText(game_ctx, "初始化失败 请重新启动", Toast.LENGTH_SHORT).show(); 
			return;
		}
		
		
		mCallback3.showWaitingViewImp(false, -1, "正在登录");
		if(!YouaiCommplatform.getInstance().isLogined())
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
					e.printStackTrace();
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
		    	login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		    	login_info.account_user_name = "";
		    	notifyLoginResult(login_info);
			}
			
		});
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			login_info.account_uid_str = login_info.account_uid_str;
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
		
	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		this.pay_info = null;
		this.pay_info = pay_info;
		exOrderNo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;
		Intent intent = new Intent(mGameActivity.getActivity(),PayProxyActivity.class);
		PayRequest payRequest = new PayRequest(mGameActivity.getActivity());
		payRequest.addParam("waresid", game_info.app_id_str);
		payRequest.addParam("ChargePoint", getYYHPay((int)pay_info.price));
		payRequest.addParam("Quantity", pay_info.count);
		payRequest.addParam("exOrderNo", exOrderNo);
		payRequest.addParam("price", ((int)pay_info.price)*100);
		payRequest.addParam("keyFlag", 1);
		//此”199”为计费插件唯一指定的请求码，请确保在activity中保证唯一性.
		(mGameActivity.getActivity()).startActivityForResult(intent, 199);
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
		if(com.youai.sdk.android.config.Config.USERTYPE[2].equals(YouaiCommplatform.getInstance().getLoginUser().getUserType())){
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
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
		
	}
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		if(requestCode==199){
			if(Activity.RESULT_OK == resultCode && null != data) {
			String signValue = data.getStringExtra("signvalue");
			String resultInfo = data.getStringExtra("resultinfo");
			if(null == signValue) {
			//没有签名值，默认采用finish()，请根据需要修改
			}
			if (PayUtil.isLegalSign(signValue, exOrderNo, mGameActivity.getActivity())) {
			//合法签名值，支付成功，请添加支付成功后的业务逻辑
				notifyPayRechargeRequestResult(this.pay_info);
			} else {
			//非法签名值，默认采用finish()，请根据需要修改
			}
			}else {
			//计费失败处理，默认采用finish()，请根据需要修改
			}
			}
	}
	
	public static String getYYHPay(int pirce){
		String waresid="";
		switch (pirce) {
		case 10:
			waresid = "1";
			break;
		case 30:
			waresid = "3";
			break;
		case 50:
			waresid = "4";
			break;
		case 100:
			waresid = "5";
			break;
		case 200:
			waresid = "6";
			break;
		case 500:
			waresid = "8";
			break;
		case 1000:
			waresid = "9";
			break;
		case 2000:
			waresid ="10";
			break;
		case 5000:
			waresid ="11";
			break;
		default:
			break;
		}
		return waresid;
	}
}
