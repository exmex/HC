package com.nuclear.dota.platform.googleplaynus;

import java.io.File;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;
import android.preference.PreferenceManager.OnActivityResultListener;
import android.util.Log;
import android.widget.Toast;

import com.facebook.AppEventsConstants;
import com.facebook.AppEventsLogger;
import com.nuclear.DeviceUtil;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.IniFileUtil;
import com.nuclear.MD5;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;
import com.nuclear.dota.LastLoginHelp;
import com.nuclear.dota.oversea.AppsFlyerAnalytics;
import com.nuclear.sdk.active.OnInitCompleteListener;
import com.nuclear.sdk.active.SdkCommplatform;
import com.nuclear.sdk.android.CallbackListener;
import com.nuclear.sdk.android.SdkError;
import com.nuclear.sdk.android.api.BindCallback;
import com.nuclear.sdk.android.entry.SdkAppInfo;
import com.qsds.ggg.dfgdfg.fvfvf.R;
import com.studioirregular.libinappbilling.Global;
import com.studioirregular.libinappbilling.IabException;
import com.studioirregular.libinappbilling.InAppBilling;
import com.studioirregular.libinappbilling.InAppBilling.NotSupportedException;
import com.studioirregular.libinappbilling.InAppBilling.ServiceNotReadyException;
import com.studioirregular.libinappbilling.Product;
import com.studioirregular.libinappbilling.PurchasedItem;
import com.studioirregular.libinappbilling.SignatureVerificationException;



public class PlatformGpftLoginAndPay implements IPlatformLoginAndPay ,OnActivityResultListener{

	
	private static final String TAG = PlatformGpftLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	private InAppBilling iab;
	
	//IabHelper mHelper;
	private boolean iap_is_ok = false;
	
	private static  String Recharge_URL ;
	public static String mUid = "";
	public static String mToken = "";
	public static final int PURCHASE_ACITIVITY_CODEUEST = 10001;
	static final int GOODS_CATE = 9;
	private String base64EncodedPublicKey;
	private int auto_recalllogin_count = 0;
	private int tag=0;
	public  boolean initOk = false;
	
	private static final int BILLING_PAY_RESULT_ERR	= 1001;
	private static final int BILLING_PAY_ERR	= 1002;
	private static final int BILLING_PAY_RESULT_OK	= 1000;
	private static final int BILLING_RESPONSE_RESULT_OK	= 0;//	Success
	private static final int BILLING_RESPONSE_RESULT_USER_CANCELED =	1;//	User pressed back or canceled a dialog
	private static final int BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE =	3	;//Billing API version is not supported for the type requested
	private static final int BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE =	4	;//Requested product is not available for purchase
	private static final int BILLING_RESPONSE_RESULT_DEVELOPER_ERROR =	5	;//Invalid arguments provided to the API. This error can also indicate that the application was not correctly signed or properly set up for In-app Billing in Google Play, or does not have the necessary permissions in its manifest
	private static final int BILLING_RESPONSE_RESULT_ERROR =	6	;//Fatal error during the API action
	private static final int BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED	= 7	;//Failure to purchase since item is already owned
	private static final int BILLING_RESPONSE_RESULT_ITEM_NOT_OWNED	= 8	;//Failure to consume since item is not owned
	private static final int BILLING_NOT_SUPPORT	= 9	;
	private static final int BILLING_NOT_Ready	= 10	;
	private static final int BILLING_RUNTIME_EXCEPTION = 11;
	private static final int BILLING_IAB_EXCEPTION = 12;
	private static final int BILLING_SENDINTENT_EXCEPTION = 13;
	
	private static final int FB_LOGIN_SUCCESS = 14;
	private static final int FB_LOGIN_Failed_NET = 15;
	private static final int FB_LOGIN_Failed_Other = 16;
	private static final int GG_LOGIN_SUCCESS = 17;
	private static final int GG_LOGIN_Failed_NET = 18;
	private static final int GG_LOGIN_Failed_Other = 19;
	
	private static String currencyType = "twd";
	
	private String mFBappid = "";
	private String mGGappid = "";
	private final String mFbGetUrl = "https://graph.facebook.com/me?access_token=";
	
	
	//private Button mLoginGoogle;
	//private GraphUser fbUser;
	boolean isLogining = false;
	private String payUrl = "http://mycard.mxhzw.com/recharge_android_googleXMT/gashmycard/mgpay.php";
	private PurchasedItem purchase;
	
	AppEventsLogger logger ;	
	PayDialog payDialog;

	
	private int mNeedInitAppsFlyer = 1; //1：需要初始化 		0：不需要初始化 		2：已经初始化 
	
	Handler handler = new Handler(){
		public void handleMessage(android.os.Message msg) {
			switch(msg.what){
			case BILLING_PAY_ERR:
				SharedPreferences sharePre = game_ctx.getSharedPreferences("recharge", 0);
				Editor editor = sharePre.edit();
				
				String extraInfo =purchase.productId+"-"+sInstance.pay_info.description+"-"+sInstance.login_info.account_uid_str;
		        String md5values = MD5.sign(purchase.orderId,base64EncodedPublicKey);
				editor.putString("mOrderId", purchase.orderId);
				editor.putString("mOriginalJson", purchase.mOriginalJson);
				editor.putString("md5value", md5values);
				editor.putString("extraInfo", extraInfo);
				editor.putString("mPurchaseTime", String.valueOf(purchase.purchaseTime));
				editor.putString("mProductId", purchase.productId);
				editor.putString("mPurchaseState", String.valueOf(purchase.stateno));
				editor.putString("signature", purchase.mSignature);
				editor.putBoolean("result",false);
				editor.apply();
				editor.commit();
				
				Toast.makeText(game_ctx, R.string.paygoodserr, Toast.LENGTH_SHORT).show();
				break;
			case BILLING_RESPONSE_RESULT_OK:
				Toast.makeText(game_ctx, R.string.payok, Toast.LENGTH_SHORT).show();
				break;
			case BILLING_PAY_RESULT_OK:
				Bundle parameters = new Bundle();
				parameters.putString(AppEventsConstants.EVENT_NAME_ADDED_PAYMENT_INFO, "SUCCESS");
				logger.logEvent(AppEventsConstants.EVENT_NAME_ADDED_PAYMENT_INFO,parameters);
				Toast.makeText(game_ctx, R.string.paygoodsok, Toast.LENGTH_SHORT).show();
				notifyPayRechargeRequestResult(pay_info);
				
				break;
			case BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE:
				break;
			case BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE:
				break;
			case BILLING_RESPONSE_RESULT_DEVELOPER_ERROR:
				break;
			case BILLING_RESPONSE_RESULT_ERROR:
				break;
			case BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED:
				Toast.makeText(game_ctx, R.string.payok, Toast.LENGTH_SHORT).show();
				break;
			case BILLING_PAY_RESULT_ERR:
				Toast.makeText(game_ctx, R.string.paygoodserr, Toast.LENGTH_SHORT).show();
				break;
			case BILLING_NOT_SUPPORT:
				Toast.makeText(game_ctx, R.string.paynotsuport, Toast.LENGTH_SHORT).show();
				break;
			case BILLING_NOT_Ready:
			case BILLING_RUNTIME_EXCEPTION:
			case BILLING_IAB_EXCEPTION:
			case BILLING_SENDINTENT_EXCEPTION:
				Toast.makeText(game_ctx, R.string.payggerr, Toast.LENGTH_SHORT).show();
				break;
			default:
				showMessage(game_ctx.getString(R.string.app_dlg_title), game_ctx.getString(R.string.payerr));
				break;
		}
		}
		
		
	};
	
	private InAppBilling.ReadyCallback iabReady = new InAppBilling.ReadyCallback() {

		@Override
		public void onIABReady() {

		}
	};
	
	
	private static PlatformGpftLoginAndPay sInstance = null;
	public static PlatformGpftLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformGpftLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformGpftLoginAndPay() {
		
	}
	
	@Override
	public boolean isTryUser() {
		return false;
	}

	@Override
	public void callBindTryToOkUser() {
	}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		Global.DEBUG_LOG = false;
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		
		base64EncodedPublicKey = game_info.public_str;
		Recharge_URL = game_info.pay_addr;
		//此处请填写你应用的appkey
		Log.i("base64EncodedPublicKey", base64EncodedPublicKey);
		iab = new InAppBilling(base64EncodedPublicKey, iabReady);
		iab.open(game_ctx);
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_GoogleNUS;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_GoogleNUS;
		this.game_info = game_info;
		SdkAppInfo sdkAppInfo = new SdkAppInfo();
		sdkAppInfo.setAppId(Integer.parseInt(game_info.app_id_str));
		sdkAppInfo.setAppKey(game_info.app_key);
		sdkAppInfo.setAppSecret(game_info.app_secret);
		sdkAppInfo.setCtx(game_ctx);
		sdkAppInfo.setOrientation(SdkCommplatform.LANDSCAPE);
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		SdkCommplatform.getInstance().Init(this.game_ctx, sdkAppInfo, new OnInitCompleteListener(){
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
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {

		this.mCallback1 = callback1;
		
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		this.mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		this.mCallback3 = callback3;
		final IGameAppStateCallback callback = mCallback3;
		SdkCommplatform.getInstance().setNuclearBind(new BindCallback(){

			@Override
			public void onBindSuccess() {
				callback.notifyTryUserRegistSuccess();
				AppsFlyerAnalytics.register(game_ctx, "bindRegistration");
				//註冊綁定成功
			}
			
		});
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		return 0;
	}

	@Override
	public void unInit() {
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

	public  int dip2px(float dpValue) {  
         float scale = game_ctx.getResources().getDisplayMetrics().density;  
        return (int) (dpValue * scale + 0.5f);  
    } 
	@Override
	public void callLogin() {
		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
        /*.detectDiskReads().detectDiskWrites()*/.detectNetwork()
        /*.penaltyLog()*/.build());
		mCallback3.showWaitingViewImp(true, -1, game_ctx.getString(R.string.logining));
		if(initOk){
			//Toast.makeText(game_ctx, "初始化成功", Toast.LENGTH_SHORT).show(); 
		}else{
			Toast.makeText(game_ctx, game_ctx.getString(R.string.initfail), Toast.LENGTH_SHORT).show();
			return;
		}
		
		sendAppsFlyer();
		if(!SdkCommplatform.getInstance().isLogined()){
		//
		mCallback3.showWaitingViewImp(true, -1, game_ctx.getString(R.string.logining));
		SdkCommplatform.getInstance().nuclearLogin(game_ctx,new CallbackListener() {
			@Override
			public void onLoginSuccess(String backmsg) {
				
		    	LoginInfo login_info = new LoginInfo();
		    	JSONObject jsonback = null;
				try {
					jsonback  = new JSONObject(backmsg);
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					String nuclearId = jsonback.getJSONObject("data").getString("nuclearId");
					String thirdStoreId = jsonback.getJSONObject("data").optString("thirdStoreId");
					
					if(null==thirdStoreId||"".equals(thirdStoreId)){
						login_info.account_uid_str = nuclearId;
					}else{
						login_info.account_uid_str = thirdStoreId;
					}
					
					login_info.account_nick_name = jsonback.getString("username");
					notifyLoginResult(login_info);
					mCallback3.showWaitingViewImp(false, -1, game_ctx.getString(R.string.loginsuccess));
			    	Log.i(TAG, "msgstr"+backmsg);
				} catch (JSONException e) {
					//e.printStackTrace();
					mCallback3.showWaitingViewImp(false, -1, "");
				}
		    	
			}
			
			@Override
			public void onLoginError(SdkError error) {
				initAppsFlyer(game_ctx);
				
				LoginInfo login_info = new LoginInfo();
				Message msg = new Message();
				msg.what = 1;
				String msgstr = error.getMErrorMessage();
		    	msg.obj =msgstr;
		    	Toast.makeText(game_ctx,R.string.loginfail, Toast.LENGTH_SHORT).show();
		    	mCallback3.showWaitingViewImp(false, -1, "");
		    	login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		    	login_info.account_user_name = "";
		    	notifyLoginResult(login_info);
		    	
		    	
			}
			
			@Override
			public void onTryRegister() {
				AppsFlyerAnalytics.register(game_ctx, "tryRegistration");
			}
			
			@Override
			public void onNomalRegister() {
				
				AppsFlyerAnalytics.register(game_ctx, "registration");
			}

			
			@Override
			public void isOldDeviceUser() {
				mNeedInitAppsFlyer = 0;
				//AppsFlyerAnalytics.setDeviceTrackingDisabled(false);
			}
			
		});
		}else{
			mCallback3.showWaitingViewImp(false, -1, "");
		}
	}

	
	
	public void sendAppsFlyer()
	{
		/*if(mNeedInitAppsFlyer==0||mNeedInitAppsFlyer==2)
		{
			return;
		}
		mNeedInitAppsFlyer = 2;
		AppsFlyerAnalytics.init();
		AppsFlyerAnalytics.onCreate(game_ctx);*/
		
		SharedPreferences appsFlyerPre = game_ctx.getSharedPreferences("appsflyer",Context.MODE_PRIVATE);
		boolean isSendData = appsFlyerPre.getBoolean("sendCollectData", false);
		if(isSendData==false)		
		AppsFlyerAnalytics.converData(game_ctx,game_info,"2.3.1.11");
	}
	
	/**初始化appsflyer广告SDK*/
	public void initAppsFlyer(Activity game_tx)
	{
		if(mNeedInitAppsFlyer==0||mNeedInitAppsFlyer==2)
		{
			return;
		}
		
		mNeedInitAppsFlyer = 2;
		
		AppsFlyerAnalytics.init();
		AppsFlyerAnalytics.onCreate(game_tx);
		
	}
	
	
	@Override
	public void notifyLoginResult(LoginInfo login_result) {

		
		login_info = null;
		login_info = login_result;

		if (login_result!= null) {
			if(login_result.login_result==PlatformAndGameInfo.enLoginResult_Success)
			{
				
				//暂时注释
				login_result.account_uid_str=PlatformAndGameInfo.enPlatformShort_GoogleNUS+login_result.account_uid_str;
				mCallback3.notifyLoginResut(login_result);
				AppsFlyerAnalytics.login(game_ctx);
			}
			
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		return login_info;
	}

	@Override
	public void callLogout() {
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
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

	  public static boolean isWiFiActive(Context inContext) {
          WifiManager mWifiManager = (WifiManager) inContext
          .getSystemService(Context.WIFI_SERVICE);
          WifiInfo wifiInfo = mWifiManager.getConnectionInfo();
          int ipAddress = wifiInfo == null ? 0 : wifiInfo.getIpAddress();
          if (mWifiManager.isWifiEnabled() && ipAddress != 0) {
              return true;
          } else {
             return false;   
         }
 }
	  
	@Override
	public int callPayRecharge(final PayInfo pay_info) {
		//logger.logEvent(AppEventsConstants.EVENT_NAME_VIEWED_CONTENT);
		
		this.pay_info = pay_info;
		
		boolean wifiactive = isWiFiActive(game_ctx);
		
		String payGoogle = "";
		File rootfiles = new File(mGameActivity.getAppFilesResourcesPath());
		File dynamicFile = new File(rootfiles.getAbsoluteFile()+File.separator+"dynamic.ini"); 
		if(dynamicFile.exists()&&dynamicFile.isFile()){   //判断目录是否存在  
			payGoogle = IniFileUtil.GetPrivateProfileString(dynamicFile.getAbsolutePath(), 
					"RechargeAddressBak", LastLoginHelp.mPlatform+"_paygoogle", "1");
        }
		
		/*if (!wifiactive||!payGoogle.equals("1"))
		{
			boolean ggpayflag = true;
			if(!payGoogle.equals("1")){
				ggpayflag = false;
			}
			payDialog = new PayDialog(game_ctx,R.style.PuidDialog,ggpayflag);
			
			payDialog.callShowPay(new PayClickResult() {
				
				@Override
				public void onPayClick(int pPayType) {
					notifyPayRechargeRequestResult(pay_info);
					payDialog.dismiss();
					if (pPayType==PayDialog.payType.google.ordinal()) {
						callPayGoogle();
					} else {
						
					Locale locale = game_ctx.getResources().getConfiguration().locale;
					String language = locale.getLanguage();
					if(language.equals("zh")){
					  	 language = locale.getCountry();
					}
					String data = "puid="+LastLoginHelp.mPuid+"&gameId="+LastLoginHelp.mGameid+"&productId="+pay_info.product_id
							 	+"&serverId="+LastLoginHelp.mServerID+"&platformId="+LastLoginHelp.mPlatform
							 	+"&language="+language+"&payType="+pPayType+"&price="+pay_info.price+
							 	"&currencyType="+currencyType+"&orderId="+pay_info.order_serial;
								
					PayWebDialog.getInstance(game_ctx, payUrl,EncodingUtils.getBytes(data, "UTF-8")).show();
					}
				}
				
				@Override
				public void onPayCancel() {
					
				}
			});
			
		}else
		{
			notifyPayRechargeRequestResult(pay_info);
			callPayGoogle();
		}*/
		
		callPayGoogle();
		return 0;
	}
	
	private void callPayGoogle(){
		
		try {
			iab.consume(Product.Type.ONE_TIME_PURCHASE, pay_info.product_id);	
			
		} catch (NotSupportedException e) {
			e.printStackTrace();
		} catch (ServiceNotReadyException e) {
			e.printStackTrace();
		} catch (RuntimeException e) {
			e.printStackTrace();
		} catch (IabException e) {
			e.printStackTrace();
		}

		
	try {
			iab.purchase(Product.Type.ONE_TIME_PURCHASE, pay_info.product_id, game_ctx,
					PURCHASE_ACITIVITY_CODEUEST);
		} catch (NotSupportedException e) {
			e.printStackTrace();
			handler.sendEmptyMessage(BILLING_NOT_SUPPORT);
			return;
		} catch (ServiceNotReadyException e) {
			handler.sendEmptyMessage(BILLING_NOT_Ready);
			e.printStackTrace();
			return;
		} catch (RuntimeException e) {
			handler.sendEmptyMessage(BILLING_RUNTIME_EXCEPTION);
			e.printStackTrace();
			return;
		} catch (IabException e) {
			handler.sendEmptyMessage(BILLING_IAB_EXCEPTION);
			e.printStackTrace();
			return;
		} catch (SendIntentException e) {
			handler.sendEmptyMessage(BILLING_SENDINTENT_EXCEPTION);
			e.printStackTrace();
			return;
		}
	}
	
	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
		
		AppsFlyerAnalytics.purchase(game_ctx, PlatformGpftLoginAndPay.sInstance.pay_info.price);
	}

	
	@Override
	public void callAccountManage() {
		String webSite = "";
		File rootfiles = new File(mGameActivity.getAppFilesResourcesPath());
		File dynamicFile = new File(rootfiles.getAbsoluteFile()+File.separator+"dynamic.ini"); 
		if(dynamicFile.exists()&&dynamicFile.isFile()){   //判断目录是否存在  
			webSite = IniFileUtil.GetPrivateProfileString(dynamicFile.getAbsolutePath(), "NuclearUrl", "webindex", "");
        }
		
		if(!webSite.equals(""))
		{
			com.nuclear.sdk.android.config.SdkConfig.WebsiteIndex = webSite;
		}
		
		if (SdkCommplatform.getInstance().isLogined()){
			
			SdkCommplatform.getInstance().EnterAccountManage(game_ctx, new CallbackListener() {
				 @Override
					public boolean onLoginOutAfter() {
					 return true;
				 } 
			});
		}else{
			callLogin();
		}
	}

	public String generateNewOrderSerial() {
		return DeviceUtil.generateUUID().replace("-", "");
	}

	@Override
	public void callPlatformFeedback() {
		 Locale locale = game_ctx.getResources().getConfiguration().locale;
	     String language = locale.getLanguage();
	     if(language.equals("zh")){
	    	 language = locale.getCountry();
	     }
		 //Log.e("language:",language+"country:"+locale.getLanguage());
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
		if (iab != null) {
			iab.close();
		}
		
	}

	@Override
	public void callToolBar(boolean visible) {
		
	}


	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
		
	}
	
	
	void complain(String message) {
        Log.e(TAG, "**** TrivialDrive Error: " + message);
        alert("Error: " + message);
    }
	void alert(String message) {
        AlertDialog.Builder bld = new AlertDialog.Builder(this.game_ctx);
        bld.setMessage(message);
        bld.setNeutralButton("OK", null);
        Log.d(TAG, "Showing alert dialog: " + message);
        bld.create().show();
    }
	private void showMessage(String title,String message){
		new AlertDialog.Builder(game_ctx).setTitle(title).setMessage(message).setPositiveButton("確定", null).show();
	}
	
	public  void sendPostRequest(PurchasedItem _purchase) throws Exception 
	{

		String payAddress = "";
		File rootfiles = new File(mGameActivity.getAppFilesResourcesPath());
		File dynamicFile = new File(rootfiles.getAbsoluteFile()+File.separator+"dynamic.ini"); 
		if(dynamicFile.exists()&&dynamicFile.isFile()){   //判断目录是否存在  
			payAddress = IniFileUtil.GetPrivateProfileString(dynamicFile.getAbsolutePath(), "RechargeAddressBak", PlatformAndGameInfo.enPlatform_GoogleENG+"_payaddress", "");
			if("".equals(payAddress)||payAddress==null){
			    payAddress=game_info.pay_addr;
			}
//			Log.i("payAddress", payAddress);
//			Toast.makeText(game_ctx, payAddress, 1).show();
        }
		
		if(!payAddress.equals(""))
		{
			Recharge_URL = payAddress;
		}
		
		
    	if(_purchase.purchaseState != PurchasedItem.PurchaseState.PURCHASED){
    		handler.sendEmptyMessage(BILLING_RESPONSE_RESULT_USER_CANCELED);
    		return;
    	}
    	
		purchase = _purchase;
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				HttpClient client = new DefaultHttpClient();
				HttpPost post= new HttpPost(Recharge_URL);
				String result="";
				List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		        BasicNameValuePair param1 = new BasicNameValuePair("mOrderId",purchase.orderId);
		        BasicNameValuePair param2 = new BasicNameValuePair("mOriginalJson",purchase.mOriginalJson);
		        String extraInfo =purchase.productId+"_"+sInstance.pay_info.description;
		        String md5values = MD5.sign(purchase.orderId,base64EncodedPublicKey);
		        BasicNameValuePair  param3 = new BasicNameValuePair("md5value",md5values);
		        BasicNameValuePair param4 = new BasicNameValuePair("extraInfo",extraInfo);
		        BasicNameValuePair param5 = new BasicNameValuePair("mPurchaseTime",String.valueOf(purchase.purchaseTime));
		        BasicNameValuePair param6 = new BasicNameValuePair("mProductId",purchase.productId);
		        BasicNameValuePair param7 = new BasicNameValuePair("mPurchaseState",""+purchase.stateno);
		        BasicNameValuePair  param8 = new BasicNameValuePair("signature",purchase.mSignature);
		        
		        paramList.add(param1);
		        paramList.add(param2);
		        paramList.add(param3);
		        paramList.add(param4);
		        paramList.add(param5);
		        paramList.add(param6);
		        paramList.add(param7);
		        paramList.add(param8);
		        
		        try {
					post.setEntity(new UrlEncodedFormEntity(paramList));
					HttpResponse httpResponse = null;
					httpResponse = client.execute(post);
					int statusCode = httpResponse.getStatusLine().getStatusCode();
					if(statusCode == 200)
			        { 
						Log.e(TAG, "httpStatusCode"+200);
						result = EntityUtils.toString(httpResponse.getEntity());
						Log.e(TAG, "httpStatusCode"+result);
						JSONObject resultObj = new JSONObject(result);
				        int returnCode =	resultObj.getInt("returnCode")	;
				        handler.sendEmptyMessage(returnCode);
						 //json {returnCode:"1000",  returnDesc:""}
			        	
			        }else
			        {
			        	Log.e(TAG, "httpStatusCode"+statusCode);
			        	handler.sendEmptyMessage(BILLING_PAY_ERR);
			        	onLoginGame();
			        }		
					
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				} catch (ClientProtocolException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
		        
		        
			}
		}).start();
		
		
			
	}

	public boolean onActivityResult(int requestCode, int resultCode, Intent data) {
		Log.d(TAG, "onActivityResult requestCode:" + requestCode
				+ ",resultCode:" + resultCode + ",data:" + data);
		
		if (requestCode == PURCHASE_ACITIVITY_CODEUEST) {
			
			if (resultCode == Activity.RESULT_OK) {
				try {
					PurchasedItem item = iab.onPurchaseActivityResult(data);
					Log.w(TAG, "Purchase item:" + item);
					if (item != null) {
					sendPostRequest(item);
					iab.consume(Product.Type.ONE_TIME_PURCHASE, pay_info.product_id);
					}	
				} catch (IabException e) {
					e.printStackTrace();
				} catch (SignatureVerificationException e) {
					e.printStackTrace();
				} catch (JSONException e) {
					e.printStackTrace();
				}catch (NotSupportedException e) {
					e.printStackTrace();
				} catch (ServiceNotReadyException e) {
					e.printStackTrace();
				} catch (RuntimeException e) {
					e.printStackTrace();
				}catch (Exception e) {
					e.printStackTrace();
				}
				
			} else if (resultCode == Activity.RESULT_CANCELED) {
				Log.w(TAG, "onActivityResult: user canceled purchasing.");
				Toast.makeText(game_ctx, R.string.purchase_canceled, Toast.LENGTH_LONG).show();
			}
			
			return false;
			
		} else {
			return true;
		}
		
	}

	@Override
	public void onLoginGame() {
	
		//mLoginGoogle.setVisibility(View.GONE);
		
		Log.e("LastLoginHelp", LastLoginHelp.mGameid);
		final SharedPreferences sharePre = game_ctx.getSharedPreferences("recharge", 0);
		boolean result = sharePre.getBoolean("result", true);
		if (result) {
			return;
		}
		
		String payAddress = "";
		File rootfiles = new File(mGameActivity.getAppFilesResourcesPath());
		File dynamicFile = new File(rootfiles.getAbsoluteFile()+File.separator+"dynamic.ini"); 
		if(dynamicFile.exists()&&dynamicFile.isFile()){   //判断目录是否存在  
			payAddress = IniFileUtil.GetPrivateProfileString(dynamicFile.getAbsolutePath(), "RechargeAddressBak", LastLoginHelp.mPlatform+"_payaddress", "");
        }
		
		if(!payAddress.equals(""))
		{
			Recharge_URL = payAddress;
		}
		
		new Thread(new Runnable() {
			
			@Override
			public void run() {
				HttpClient client = new DefaultHttpClient();
				HttpPost post= new HttpPost(Recharge_URL);
				String result="";
				List<NameValuePair> paramList = new ArrayList<NameValuePair>();
		        BasicNameValuePair param1 = new BasicNameValuePair("mOrderId",sharePre.getString("mOrderId", "mOrderId"));
		        BasicNameValuePair param2 = new BasicNameValuePair("mOriginalJson",sharePre.getString("mOriginalJson","mOriginalJson"));
		        BasicNameValuePair  param3 = new BasicNameValuePair("md5value",sharePre.getString("md5value","md5value"));
		        BasicNameValuePair param4 = new BasicNameValuePair("extraInfo",sharePre.getString("extraInfo","extraInfo"));
		        BasicNameValuePair param5 = new BasicNameValuePair("mPurchaseTime",sharePre.getString("mPurchaseTime","mPurchaseTime"));
		        BasicNameValuePair param6 = new BasicNameValuePair("mProductId",sharePre.getString("mProductId","mProductId"));
		        BasicNameValuePair param7 = new BasicNameValuePair("mPurchaseState",sharePre.getString("mPurchaseState","mPurchaseState"));
		        BasicNameValuePair  param8 = new BasicNameValuePair("signature",sharePre.getString("signature","signature"));
		        paramList.add(param1);
		        paramList.add(param2);
		        paramList.add(param3);
		        paramList.add(param4);
		        paramList.add(param5);
		        paramList.add(param6);
		        paramList.add(param7);
		        paramList.add(param8);
		        
		        try {
					post.setEntity(new UrlEncodedFormEntity(paramList));
					HttpResponse httpResponse = null;
					httpResponse = client.execute(post);
					int statusCode = httpResponse.getStatusLine().getStatusCode();
					Editor editor = sharePre.edit();
					if(statusCode == 200)
			        { 
						
						editor.putBoolean("result", true);
						editor.apply();
						editor.commit();
						
						Log.e(TAG, "httpStatusCode"+200);
						result = EntityUtils.toString(httpResponse.getEntity());
						Log.e(TAG, "httpStatusCode"+result);
						JSONObject resultObj = new JSONObject(result);
				        int returnCode =	resultObj.getInt("returnCode")	;
			        	
			        }else
			        {
			        	editor.putBoolean("result", false);
						editor.apply();
						editor.commit();
			        	Log.e(TAG, "httpStatusCode"+statusCode);
			        }		
					
				} catch (UnsupportedEncodingException e) {
					e.printStackTrace();
				} catch (ClientProtocolException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
		        
		        
			}
		}).start();
	}	
}