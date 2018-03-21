package com.nuclear.dota.platform.google.googleftrzgametw;

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
import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

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
import com.qsds.ggg.dfgdfg.fvfvf.R;
import com.studioirregular.libinappbilling.Global;
import com.studioirregular.libinappbilling.IabException;
import com.studioirregular.libinappbilling.InAppBilling;
import com.studioirregular.libinappbilling.InAppBilling.NotSupportedException;
import com.studioirregular.libinappbilling.InAppBilling.ServiceNotReadyException;
import com.studioirregular.libinappbilling.Product;
import com.studioirregular.libinappbilling.PurchasedItem;
import com.studioirregular.libinappbilling.SignatureVerificationException;
import com.youai.sdk.active.OnInitCompleteListener;
import com.youai.sdk.active.YouaiCommplatform;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.YouaiError;
import com.youai.sdk.android.api.BindCallback;
import com.youai.sdk.android.entry.YouaiAppInfo;
import com.youai.sdk.android.utils.MD5;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Intent;
import android.content.IntentSender.SendIntentException;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;
import android.preference.PreferenceManager.OnActivityResultListener;
import android.util.Log;
import android.widget.Toast;

public class PlatformGoogleFTDMWLoginAndPay implements IPlatformLoginAndPay ,OnActivityResultListener{

	
	private static final String TAG = PlatformGoogleFTDMWLoginAndPay.class.getSimpleName();
	
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
	
	private static  String Recharge_URL ;
	public static String mUid = "";
	public static String mToken = "";
	public static final int PURCHASE_ACITIVITY_CODEUEST = 10001;
	static final int GOODS_CATE = 9;
	private String base64EncodedPublicKey;
	
	public  boolean initOk = false;
	
	private static final int BILLING_PAY_RESULT_ERR	= 1001;
	private static final int BILLING_PAY_ERR		= 1002;
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
	
	private boolean useThirdStorelogin = false;
	private PurchasedItem purchase;
	
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
				Toast.makeText(game_ctx, R.string.paygoodsok, Toast.LENGTH_SHORT).show();
				break;
			case BILLING_RESPONSE_RESULT_USER_CANCELED:
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
			case BILLING_RESPONSE_RESULT_ITEM_NOT_OWNED:
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
	
	
	private static PlatformGoogleFTDMWLoginAndPay sInstance = null;
	public static PlatformGoogleFTDMWLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformGoogleFTDMWLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformGoogleFTDMWLoginAndPay() {
		
	}
	
	@Override
	public boolean isTryUser() {
		if( com.youai.sdk.android.config.Config.USERTYPE[2].
				equals(YouaiCommplatform.getInstance().getLoginUser().getUserType())){
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
		Global.DEBUG_LOG = false;
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		
		ApplicationInfo appInfo = null;
		try 
		{
			appInfo = this.game_ctx.getPackageManager().getApplicationInfo(this.game_ctx.getPackageName(),PackageManager.GET_META_DATA);
		} 
		catch (NameNotFoundException e) 
		{
			e.printStackTrace();
		}
	
		if(appInfo!=null && appInfo.metaData != null)
		{
			String PAY_ADDR = appInfo.metaData.getString("PAY_ADDR");
			String PAY_PRIVATE = appInfo.metaData.getString("PAY_PRIVATE");
			if(PAY_ADDR != null && PAY_PRIVATE != null)
			{
				game_info.pay_addr = PAY_ADDR;
				game_info.public_str = PAY_PRIVATE;
			}
		}
		
		base64EncodedPublicKey = game_info.public_str;
		Recharge_URL = game_info.pay_addr;
		
		//此处请填写你应用的appkey
		
		iab = new InAppBilling(base64EncodedPublicKey, iabReady);
		iab.open(game_ctx);
		
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_GoogleFT;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_GoogleFT;
		this.game_info = game_info;
		YouaiAppInfo youaiAppInfo = new YouaiAppInfo();
		youaiAppInfo.setAppId(Integer.parseInt(game_info.app_id_str));
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
	public void callLogin() {
		
		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
        /*.detectDiskReads().detectDiskWrites()*/.detectNetwork()
        /*.penaltyLog()*/.build());
		mCallback3.showWaitingViewImp(true, -1, "正在登陸");
		if(initOk){
			//Toast.makeText(game_ctx, "初始化成功", Toast.LENGTH_SHORT).show(); 
		}else{
			Toast.makeText(game_ctx, "初始化失敗 請重新啓動", Toast.LENGTH_SHORT).show();
			return;
		}
		
		
		
		if(!YouaiCommplatform.getInstance().isLogined()){
		//
		mCallback3.showWaitingViewImp(true, -1, "正在登陸");
		YouaiCommplatform.getInstance().youaiLogin(game_ctx,new CallbackListener() {
			@Override
			public void onLoginSuccess(String backmsg) {
				Log.e("YouaiLogin Succeess", backmsg);
		    	if(!isTryUser())
				 Toast.makeText(game_ctx, "登入成功", Toast.LENGTH_SHORT).show();
		    	LoginInfo login_info = new LoginInfo();
		    	JSONObject jsonback = null;
				try {
					jsonback  = new JSONObject(backmsg);
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					String youaiId = jsonback.getJSONObject("data").getString("youaiId");
					String thirdStoreId = jsonback.getJSONObject("data").optString("thirdStoreId");
					
					if(null==thirdStoreId||"".equals(thirdStoreId)){
						login_info.account_uid_str = youaiId;
						useThirdStorelogin = false;
					}else{
						login_info.account_uid_str = thirdStoreId;
						useThirdStorelogin = true;
					}
					
					login_info.account_nick_name = jsonback.getString("username");
					notifyLoginResult(login_info);
					mCallback3.showWaitingViewImp(false, -1, "已經登入");
			    	Log.i(TAG, "msgstr"+backmsg);
				} catch (JSONException e) {
					//e.printStackTrace();
					mCallback3.showWaitingViewImp(false, -1, "正在登入");
				}
		    	
			}
			
			@Override
			public void onLoginError(YouaiError error) {
				LoginInfo login_info = new LoginInfo();
				Message msg = new Message();
				msg.what = 1;
				String msgstr = error.getMErrorMessage();
		    	msg.obj =msgstr;
		    	Toast.makeText(game_ctx,"登入失敗", Toast.LENGTH_SHORT).show();
		    	mCallback3.showWaitingViewImp(false, -1, "登入失敗");
		    	login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		    	login_info.account_user_name = "";
		    	notifyLoginResult(login_info);
		    	
		    	
			}
			
		});
		}else{
			mCallback3.showWaitingViewImp(false, -1, "已經登入");
		}
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			this.login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_GoogleFT+login_info.account_uid_str;
			
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
			return 0;
		} catch (ServiceNotReadyException e) {
			handler.sendEmptyMessage(BILLING_NOT_Ready);
			e.printStackTrace();
			return 0;
		} catch (RuntimeException e) {
			handler.sendEmptyMessage(BILLING_RUNTIME_EXCEPTION);
			e.printStackTrace();
			return 0;
		} catch (IabException e) {
			handler.sendEmptyMessage(BILLING_IAB_EXCEPTION);
			e.printStackTrace();
			return 0;
		} catch (SendIntentException e) {
			handler.sendEmptyMessage(BILLING_SENDINTENT_EXCEPTION);
			e.printStackTrace();
			return 0;
		}
		
		

		return 0;
 
		
	}
	
	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	
	@Override
	public void callAccountManage() {
		
/*		String webSite = "";
		File rootfiles = new File(mGameActivity.getAppFilesResourcesPath());
		File dynamicFile = new File(rootfiles.getAbsoluteFile()+File.separator+"dynamic.ini"); 
		if(dynamicFile.exists()&&dynamicFile.isFile()){   //判断目录是否存在  
			webSite = IniFileUtil.GetPrivateProfileString(dynamicFile.getAbsolutePath(), "YouaiUrl", "Webindex", "");
        }
		
		if(!webSite.equals(""))
		{
			com.youai.sdk.android.config.YouaiConfig.Webindex = webSite;
		}
		*/
		
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
		}
		else
		{
			callLogin();
		}

	}

	@Override
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
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			String _url = Config.UrlFeedBack + "?puid="+LastLoginHelp.mPuid+"&gameId="+LastLoginHelp.mGameid
					 	+"&serverId="+LastLoginHelp.mServerID+"&playerId="+LastLoginHelp.mPlayerId+"&playerName="
					 	+LastLoginHelp.mPlayerName+"&vipLvl="+LastLoginHelp.mVipLvl+"&platformId="+LastLoginHelp.mPlatform
					 	+"&language="+language;
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
		if (iab != null) {
			iab.close();
		}
	}

	@Override
	public void callToolBar(boolean visible) {
		// TODO Auto-generated method stub
		
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
		        
		        String extraInfo =purchase.productId+"-"+sInstance.pay_info.description+"-"+sInstance.login_info.account_uid_str;
		        
		        BasicNameValuePair  param3 = new BasicNameValuePair("md5value",MD5.sign(purchase.orderId,base64EncodedPublicKey));
		        
		        
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
			        	handler.sendEmptyMessage(BILLING_PAY_RESULT_ERR);
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
		
		final SharedPreferences sharePre = game_ctx.getSharedPreferences("recharge", 0);
		boolean result = sharePre.getBoolean("result", true);
		if (result) {
			return;
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
				        int returnCode =	resultObj.getInt("returnCode");
				        Log.e(TAG, "returnCode=====>>>>"+returnCode);
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
