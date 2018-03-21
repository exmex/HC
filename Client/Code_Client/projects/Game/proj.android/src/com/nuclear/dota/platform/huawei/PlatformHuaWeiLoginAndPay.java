package com.nuclear.dota.platform.huawei;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.util.Log;
import android.view.Window;
import android.widget.Toast;

import com.android.huawei.pay.plugin.IHuaweiPay;
import com.huawei.deviceCloud.microKernel.config.Configuration;
import com.huawei.deviceCloud.microKernel.core.MicroKernelFramework;
import com.huawei.deviceCloud.microKernel.util.EXLogger;
import com.huawei.gamebox.buoy.sdk.IBuoyCallBack;
import com.huawei.gamebox.buoy.sdk.IBuoyOpenSDK;
import com.huawei.gamebox.buoy.sdk.InitParams;
import com.huawei.gamebox.buoy.sdk.util.BuoyConstant;
import com.huawei.gamebox.buoy.sdk.util.DebugConfig;
import com.huawei.hwid.openapi.out.IHwIDCallBack;
import com.huawei.hwid.openapi.out.OutReturn;
import com.huawei.hwid.openapi.out.ResReqHandler;
import com.huawei.hwid.openapi.out.microkernel.IHwIDOpenSDK;
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

public class PlatformHuaWeiLoginAndPay implements IPlatformLoginAndPay {

	public static final String TAG = PlatformHuaWeiLoginAndPay.class.getSimpleName();
	
	private IGameActivity                            	mGameActivity;
	private IPlatformSDKStateCallback                   mCallback1;
	private IGameUpdateStateCallback                    mCallback2;
	private IGameAppStateCallback                       mCallback3;
	
	private Activity                                    game_ctx = null;
	private GameInfo                                    game_info = null;
	private LoginInfo                                   login_info = null;
	private VersionInfo                              	version_info = null;
	private PayInfo                                     pay_info = null;
	private boolean                                     isLogin = false;
	
	private static JSONObject jsonObject;
	
	
	// 正式环境
	public static final String environment = com.android.huawei.pay.util.HuaweiPayUtil.environment_live;
	public  static final  int REQUEST_CODE = 100;
	public  static final  int PAY_RESULT = 1000;
	String userName ="华为软件技术有限公司";
	String accesstoken="";
	IHuaweiPay payHelper = null;
	String HWID_PLUS_NAME = "hwIDOpenSDK";	
	MicroKernelFramework framework = null;
	IHwIDOpenSDK hwIDOpenSDKInstance = null;
	ProgressDialog mLoadWebSpinner = null;
	//悬浮窗参数
    private InitParams p;
    //悬浮窗接口
    private IBuoyOpenSDK hwBuoy;
	
	String notifyUrl = null;
 
	String str_body, str_subject, str_price;
	
	
	
	private static PlatformHuaWeiLoginAndPay            sInstance = null;
	public static PlatformHuaWeiLoginAndPay getInstance(){
		if(sInstance == null){
			sInstance = new PlatformHuaWeiLoginAndPay();
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
		Configuration.setReleaseMode(true);
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_HuaWei;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_HuaWei;
		mLoadWebSpinner = new ProgressDialog(this.game_ctx);
		mLoadWebSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
		mLoadWebSpinner.setCanceledOnTouchOutside(false);
		mLoadWebSpinner.setOnCancelListener(new OnCancelListener() {
			@Override
			public void onCancel(DialogInterface dialog) {
				mLoadWebSpinner.cancel();
			}
		});
		isLogin = false;
		if (false == initMicroKernel()) {
			Toast.makeText(this.game_ctx, "call initMicroKernel failed", Toast.LENGTH_LONG).show();
			return;
		}else{
			p = new InitParams(this.game_info.app_id_str.trim(), this.game_info.cp_id_str.trim(), this.game_info.app_secret.trim(),new FloatListenerByCpImpl());
			//开启悬浮窗的log
	        //DebugConfig.setLog(true);
	        
	        //开启插件加载的log
	        //EXLogger.setLevel(Log.VERBOSE);
	        
			boolean initPay = initPayMicroKernel();
			if(!initPay)
			{
				Toast.makeText(this.game_ctx, "call initPayMicroKernel failed", Toast.LENGTH_LONG).show();
			}
			mCallback1.notifyInitPlatformSDKComplete();
		}
		
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
		//OpenHwID.logOut(this.game_ctx, this.game_info.app_id_str, null, null);
		//HiAnalytics.onReport(this.game_ctx);
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		
		if(isLogin){
			return;
		}
		
  		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		
		
//		auth_getUsrInfo();
		
		hwIDOpenSDKInstance.setLoginProxy(this.game_ctx, p.getAppid(), new LoginCallBack(), new Bundle());
		hwIDOpenSDKInstance.login(new Bundle());
		
//		hwIDOpenSDKInstance.login(new Bundle());
		
//		HashMap hashMap = hwIDOpenSDKInstance.getUserInfo();
//		getUserInfoOne(hashMap);
		 
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_HuaWei+login_info.account_uid_str;
			Toast.makeText(game_ctx,"登录成功，点击进入游戏", Toast.LENGTH_SHORT).show();
			mCallback3.notifyLoginResut(login_result);
		}
	}

//	private void auth_getUsrInfo(){
		//String accessToken = hwIDOpenSDKInstance.getAccessToken(game_ctx, game_info.app_id_str, null, null);
		
		// 如果不存在则需要进行鉴权
//		if (TextUtils.isEmpty(accessToken)) {
//			auth();
//			
//		} else {			
//			// 在该请求过程中，若服务器返回的结果说accessToken已经失效，再进行调用auth接口
//			getUserInfo(accessToken);
//		}
//	}
	
//	private void auth() {
//		try{
//			hwIDOpenSDKInstance.authorize(game_ctx, "https://www.huawei.com/auth/account", "oob", "mobile",
//					new ResReqHandler() {
//						@Override
//						public void onComplete(Bundle values) {
//							try{
//								if (OutReturn.isRequestSuccess(values)) {
//									String accessToken = OutReturn.getAccessToken(values);
//									hwIDOpenSDKInstance.storeAccessToken(game_ctx, game_info.app_id_str, null, accessToken, null);
//									Log.i(TAG, "authorize, onComplete");
//									getUserInfo(accessToken);
//								} else {
//									errDepose(values, true);
//									mCallback3.showWaitingViewImp(false, -1, "");
//								}
//							} catch (Exception e) {
//								Log.e(TAG, e.toString(), e);
//							}
//						}
//					}, game_info.app_id_str, null, null);
//		} catch (Exception e) {
//			mCallback3.showWaitingViewImp(false, -1, "正在登录");
//			Log.e(TAG, e.toString(), e);
//		}
//	}
	
	//帐号登录的回调
    private class LoginCallBack implements IHwIDCallBack
    {
        
        /**
         * Key  userState   userValidStatus userID  userName    languageCode    accesstoken
         */
        @Override
        public void onUserInfo(HashMap userInfo)
        {
            if (null == userInfo)
            {
            	Toast.makeText(game_ctx,"登录失败", Toast.LENGTH_SHORT).show();
            }
            else if (isNull((String)userInfo.get("accesstoken")))
            {
            	mCallback3.showWaitingViewImp(false, -1, "");
                Toast.makeText(game_ctx,"登录失败,请重新登陆！", Toast.LENGTH_SHORT).show();
            }
            else
            {
                DebugConfig.d(TAG, "ResReqHandler onComplete=" + userInfo.toString());
              //登陆成功 可以获取到 userInfo信息
				mCallback3.showWaitingViewImp(false, -1, "");
				accesstoken=(String)userInfo.get("accesstoken");
				jsonObject = new JSONObject(userInfo);
				
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = jsonObject.optString("userID");
				login_info.account_uid_str = jsonObject.optString("userID");
				login_info.account_nick_name = jsonObject.optString("userName");
				
				//加载浮标插件
                if (checkBuoyPluginLoad())
                {
                	//初始化浮标
                    hwBuoy.init(game_ctx.getApplicationContext(), p);
                }
                else
                {
                	Toast.makeText(game_ctx,"浮标插件加载失败", Toast.LENGTH_SHORT).show();
                }

				isLogin = true;
				PlatformHuaWeiLoginAndPay.getInstance().notifyLoginResult(login_info);
            }
        }
        
    }
    
    public static boolean isNull(String string)
    {
        if (string != null)
        {
            string = string.trim();
            if (string.length() != 0)
            {
                return false;
            }
        }
        return true;
    }
	
//	 private void getUserInfoOne(HashMap userInfo) {
//         if(null == userInfo || !userInfo.containsKey("userName")){
////        	 	  callLogin();
//                  return;
//         }
//         
//         //登陆成功 可以获取到 userInfo信息
//         // 应用可将userID和accessToken传送给应用服务器，进行应用的注册开通。
//         // 应用服务可通过accessToken到华为开发平台去确认用户登录认证的合法性。
//         // 应用确认用户身份后，可通过userID在应用服务器中查用户的应用信息。
//         
//         getUserInfo(String.valueOf(userInfo.get("accessToken")));
//	 }
	
//	private void getUserInfo(String accessToken) {
//		try{
//			//mLoadWebSpinner.show();
//			hwIDOpenSDKInstance.userInfoRequest(game_ctx, new ResReqHandler() {
//				@Override
//				public void onComplete(Bundle bd) {
//					try{
//						mLoadWebSpinner.dismiss();
//						//无返回
//						if(null == bd){
//							mCallback3.showWaitingViewImp(false, -1, "");
//							//valueTextView.setText("null return");
//						} else if (OutReturn.isRequestSuccess(bd)) {
//							
//							String content = OutReturn.getRetContent(bd);
//							try {
//								jsonObject = new JSONObject(content);
//							} catch (JSONException e) {
//								// TODO Auto-generated catch block
//								e.printStackTrace();
//							}
//							
//							if(OutReturn.isRequestSuccess(bd)){
//								//登陆成功 可以获取到 userInfo信息
//								mCallback3.showWaitingViewImp(false, -1, "");
//								
//								LoginInfo login_info = new LoginInfo();
//								login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
//								login_info.login_session = jsonObject.optString("userID");
//								login_info.account_uid_str = jsonObject.optString("userID");
//								login_info.account_nick_name = jsonObject.optString("userName");
//								
//								//加载浮标插件
//				                if (checkBuoyPluginLoad())
//				                {
//				                	//初始化浮标
//				                    hwBuoy.init(game_ctx.getApplicationContext(), p);
//				                }
//				                else
//				                {
//				                	Toast.makeText(game_ctx,"浮标插件加载失败", Toast.LENGTH_SHORT).show();
//				                }
//
//								isLogin = true;
//								PlatformHuaWeiLoginAndPay.getInstance().notifyLoginResult(login_info);
//								
//							} else {
//								isLogin = false;
//								mCallback3.showWaitingViewImp(false, -1, "");
//								Log.i(TAG, "bd IS NULL");
//								Toast.makeText(game_ctx,"登陆失败", Toast.LENGTH_SHORT).show();
//							}
//							
//							
//						} else {
//							errDepose(bd, false);
//							mCallback3.showWaitingViewImp(false, -1, "");
//							isLogin = false;
//							Log.i(TAG, "onComplete get Token failed!!" +" err:" + OutReturn.getErrInfo(bd));
//							Toast.makeText(game_ctx,"取消登陆", Toast.LENGTH_SHORT).show();
//						}
//					} catch (Exception e) {
//						Log.e(TAG, e.toString(), e);
//						isLogin = false;
//						mCallback3.showWaitingViewImp(false, -1, "");
//					} 
//				}
//			}, accessToken);
//		} catch (Exception e) {
//			mCallback3.showWaitingViewImp(false, -1, "");
//			Log.e(TAG, e.toString(), e);
//		}
//	}
//	
//	private int getInt(Bundle bd, String key, int defVal){
//		try{
//			if(null == bd){
//				return defVal;
//			} 
//			Object o = bd.get(key);
//			return Integer.parseInt(String.valueOf(o));
//		} catch (Throwable e) {
//			return defVal;
//		}
//	}
//private void errDepose(Bundle bd, boolean isGetAccessProcess){
//	String nspStatus = OutReturn.getNSPSTATUS(bd);
//	int retCode =  OutReturn.getRetCode(bd);
//	int webProxyCode = getInt(bd, "error", 0);
//	
//	if("6".equals(nspStatus) || "102".equals(nspStatus)){
//		//服务返回session过期，需重新登录
//		if(isGetAccessProcess){
//			auth();
//		} else {
//			auth_getUsrInfo();
//		}
//		return;
//		
//	} else if(2 == retCode || 1107 == webProxyCode){
//		//用户取消了操作
//		//valueTextView.setText("用户取消了请求");
//		return;
//		
//	} else if(100 == retCode || 102 == retCode) {
//		
//		//网络异常，包括延迟太久、无网络
//		//valueTextView.setText("网络异常!");
//		showRetry("网络异常,请检查网络。是否重试?", isGetAccessProcess);
//		
//	} else {
//
//		//其它异常时，打印所有的错误信息，供定位
//		StringBuffer sb = new StringBuffer();
//		if(null != bd){
//			Set<String> key = bd.keySet();
//			for(String k:key){
//				sb.append(" ").append(k).append("=").append(bd.get(k)).append(",");
//			}
//		}
//		sb.append(" heads:[");
//		Bundle head = OutReturn.getRetHeads(bd);
//		Set<String> keys = head.keySet();
//		for(String k: keys){
//			sb.append(k).append("=").append(head.get(k)).append(",");
//		}
//		sb.append("]");
//		Log.e(TAG, "errInfo:" + sb.toString());
//		
//		//valueTextView.setText("系统异常!");
//		showRetry("系统异常,请稍候再尝试, 错误码:" + 
//				retCode + "/" + OutReturn.getRetResCode(bd) + "/"+ OutReturn.getErrInfo(bd) + "/"
//				+ "。是否重试？", 
//			isGetAccessProcess);
//	}
//	
//}
//	private void showRetry(String message, final boolean isGetAccessProcess){
//        DialogInterface.OnClickListener confirm = new DialogInterface.OnClickListener() {
//            public void onClick(DialogInterface dialog, int which) {
//                /**
//                 * 当用户确定重试时，再搞一遍
//                 */
//            	if(isGetAccessProcess){
//            		auth();
//            	} else {
//            		auth_getUsrInfo();
//            	}
//                dialog.dismiss();
//            }
//        };        
        
//        DialogInterface.OnClickListener cancel = new DialogInterface.OnClickListener() {
//            public void onClick(DialogInterface dialog, int which) {
//                dialog.dismiss();
//            }
//        };
//        
//        new AlertDialog.Builder(game_ctx)
//            .setTitle("提醒")
//            .setMessage(message)
//            .setNegativeButton("取消", cancel)
//            .setPositiveButton("确认", confirm)
//            .show();
//	}

	
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
		hwIDOpenSDKInstance.logOut(game_ctx, game_info.app_id_str, null, null);
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
		this.pay_info = null;
		this.pay_info = pay_info;

		String requestId = pay_info.description + "-" + pay_info.product_id.split("\\.")[0] + "-" + this.login_info.account_uid_str.split("\\_")[1]+"-"+(int)((new Date()).getTime()/1000);//区号-物品ID-ouruserid
		String price = this.pay_info.price+"";
		price = price+"0";
		
		Map<String, String> params = new HashMap<String, String>();
		params.put("userID", this.game_info.pay_id_str);
		params.put("applicationID", this.game_info.app_id_str);
		params.put("amount", price);
		params.put("productName", this.pay_info.product_name);
		params.put("productDesc", this.pay_info.product_name);
		params.put("requestId", requestId);
		
		String noSign = HuaweiPayUtil.getSignData(params);
		String	sign = Rsa.sign(noSign, this.game_info.private_str);
		
		Log.e(TAG, "pre noSign: "+noSign + "  sign: "+sign);
	
		
		Map<String, Object> payInfo = new HashMap<String, Object>();
		payInfo.put("amount", price);
		payInfo.put("productName", this.pay_info.product_name);
		payInfo.put("requestId", requestId);
		payInfo.put("productDesc", this.pay_info.product_name);
		payInfo.put("userName", "上海仁游信息科技有限公司");
		payInfo.put("applicationID", this.game_info.app_id_str);
		payInfo.put("userID", this.game_info.pay_id_str);
		payInfo.put("sign", sign);
		payInfo.put("notifyUrl", this.game_info.pay_addr);//
		payInfo.put("environment", environment);
		payInfo.put("accessToken", accesstoken);
		Log.e(TAG , "all parameters : "+payInfo.toString());
	
		payHelper.startPay(game_ctx, payInfo, handler, PAY_RESULT);
		
		return 0;
	}
	
	private Handler handler = new Handler(){
		public void handleMessage(Message msg) {
			try {
				switch (msg.what) {
				case PAY_RESULT: {
					pay_info.result = 0 ; 
					String pay = "支付失败！";
					String payResult = (String)msg.obj;
					Log.e(TAG, "GET PAY RESULT "+ payResult);
					JSONObject jsonObject = new JSONObject(payResult);
					String returnCode = jsonObject.getString("returnCode");
					if(returnCode.equals("0"))
					{
						String errMsg = jsonObject.getString("errMsg");
						if(errMsg.equals("success"))
						{
							//支付成功，验证信息的安全性
							String amount = jsonObject.getString("amount");
							String sign = jsonObject.getString("sign");
							String orderID = jsonObject.getString("orderID");
							String requestId = jsonObject.getString("requestId");
							String Name = jsonObject.getString("userName");
							String time = jsonObject.getString("time");
							Map<String, String> paramsa = new HashMap<String, String>();
							paramsa.put("userName", Name);
							paramsa.put("orderID",orderID);
							paramsa.put("amount", amount);
							paramsa.put("errMsg", errMsg);
							paramsa.put("time", time);
							paramsa.put("requestId", requestId);
							String noSigna = HuaweiPayUtil.getSignData(paramsa);
							boolean s = Rsa.doCheck(noSigna, sign, game_info.public_str);
							
							if(s)
							{
								pay = "支付成功！";
							
								notifyPayRechargeRequestResult(pay_info);
							}else
							{
								pay = "支付成功，但验签失败！";
								notifyPayRechargeRequestResult(pay_info);
							}
							
							Log.e(TAG, "Rsa.doChec = " + s );
						}
					}else if(returnCode.equals("30002"))
					{
						pay = "支付结果查询超时！";
						notifyPayRechargeRequestResult(pay_info);
					}else{
						notifyPayRechargeRequestResult(pay_info);
					}
					Toast.makeText(game_ctx, pay, Toast.LENGTH_SHORT).show();
				}
				}
			}catch(Exception e)
			{
				e.printStackTrace();
			}
		}
	};

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			mGameActivity.showToastMsg("暂未开通,敬请期待!");
			return;
		}
		if (PlatformHuaWeiLoginAndPay.getInstance().isLogin)
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
		if (hwBuoy != null)
        {
            hwBuoy.hideSmallWindow(this.game_ctx.getApplicationContext());
            hwBuoy.hideBigWindow(this.game_ctx.getApplicationContext());
        }
	}

	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub
		if (hwBuoy != null)
        {
            hwBuoy.showSamllWindow(this.game_ctx.getApplicationContext());
        }
	}

	@Override
	public void onGameExit() {
		// TODO Auto-generated method stub
		framework = null;
		//在退出的时候销毁浮标
        if (hwBuoy != null)
        {
            hwBuoy.destroy(this.game_ctx.getApplicationContext());
        }
        //清空帐号资源
        if (null != hwIDOpenSDKInstance)
        {
        	hwIDOpenSDKInstance.releaseResouce();
        }
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
	
	private MicroKernelFramework  payFramwork;
	
	 /**
     * 初始化，加载支付插件
     * @return
     */
    private boolean initPayMicroKernel(){
		try {
			payFramwork = MicroKernelFramework.getInstance(game_ctx);
			//framework.start();
						
		    //检查插件是否有更新时调用的方法，同时传递handler,框架SDK会用此handler发送状态信息
			payFramwork.checkSinglePlugin("HuaweiPaySDK", new UpdateNotifierHandler(game_ctx, payFramwork));

            List<Object> services = payFramwork.getService("HuaweiPaySDK");
			if(null != services){
				Log.e(TAG, "get " + "HuaweiPaySDK" + " services size:" + services.size());
			} else {
				Log.e(TAG, "get empty " + "HuaweiPaySDK" + " services");
			}
			if(null == services || services.size() == 0){
				Log.e(TAG, "begin to load " + "HuaweiPaySDK");
				payFramwork.loadPlugin("HuaweiPaySDK");
			}
			
			Object payObject =  payFramwork.getPluginContext().getService(IHuaweiPay.interfaceName).get(0);
			
			if(payObject == null)
			{
				Log.e(TAG, "no huaweipay  interface " + IHuaweiPay.interfaceName);
				return false;
			}
			
			payHelper = (IHuaweiPay)payObject;
		
			return true;
		} catch (Exception e) {
			Log.e(TAG, e.toString(), e);
			return false;
		}
    }
    
	
	 /**
     * 初始化
     * @return
     */
	private boolean initMicroKernel() {
		try {
			framework = MicroKernelFramework.getInstance(game_ctx);
			framework.start();

			// 检查插件是否有更新时调用的方法，同时传递handler,框架SDK会用此handler发送状态信息
			framework.checkSinglePlugin(HWID_PLUS_NAME, new UpdateNotifierHandler(game_ctx, framework));

			List<Object> services = framework.getService(HWID_PLUS_NAME);
			if (null != services) {
				Log.d(TAG, "get " + HWID_PLUS_NAME + " services size:" + services.size());
			} else {
				Log.d(TAG, "get empty " + HWID_PLUS_NAME + " services");
			}
			if (null == services || services.size() == 0) {
				Log.d(TAG, "begin to load " + HWID_PLUS_NAME);
				framework.loadPlugin(HWID_PLUS_NAME);
				services = framework.getService(HWID_PLUS_NAME);
			}
			if (null != services && !services.isEmpty()) {
				hwIDOpenSDKInstance = (IHwIDOpenSDK) (services.get(0));
			}
			if (null == hwIDOpenSDKInstance) {
				Log.e(TAG, "no " + HWID_PLUS_NAME + " find!!");
				return false;
			}
			
			return true;
		} catch (Exception e) {
			Log.e(TAG, e.toString(), e);
			return false;
		}
	}
	
	/**
     * 加载浮标插件
     * @return
     * @see [类、类#方法、类#成员]
     */
    @SuppressWarnings("unchecked")
    private boolean checkBuoyPluginLoad()
    {
        initMicroKernel();
        if (framework != null)
        {
            framework.checkSinglePlugin(BuoyConstant.PLUGIN_NAME, new UpdateNotifierHandler(game_ctx, framework));
            List<Object> services = framework.getService(BuoyConstant.PLUGIN_NAME);
            if (null == services || services.size() == 0)
            {
//                DebugConfig.d(TAG, "第一次getService为空，并开始loadPlugin：" + BuoyConstant.PLUGIN_NAME);
                framework.loadPlugin(BuoyConstant.PLUGIN_NAME);
//                DebugConfig.d(TAG, "loadPlugin结束： " + BuoyConstant.PLUGIN_NAME);
                services = framework.getService(BuoyConstant.PLUGIN_NAME);
            }
            else
            {
//                DebugConfig.d(TAG, BuoyConstant.PLUGIN_NAME + " 第一次getService不为空，services size=" + services.size());
            }
            
            if (null != services && !services.isEmpty())
            {
//                DebugConfig.d(TAG, BuoyConstant.PLUGIN_NAME + " 第二次getService不为空:" + services.get(0));
                hwBuoy = (IBuoyOpenSDK)(services.get(0));
            }
            else
            {
            	//
            }
            if (null == hwBuoy)
            {
                Log.e(TAG, "no " + "获取插件为空 :  "+ HWID_PLUS_NAME + " find!!");
            }
            else
            {
                return true;
            }
            
        }
        return false;
    }
	
	/**
     * 和浮标sdk交互的回调
     * 
     * @author  c00206870
     * @version  [版本号, 2014-4-1]
     * @see  [相关类/方法]
     * @since  [产品/模块版本]
     */
    private class FloatListenerByCpImpl implements IBuoyCallBack
    {
        protected FloatListenerByCpImpl()
        {
        }
        
        @Override
        public void onInitStarted()
        {
//            Toast.makeText(game_ctx, "初始化开始", Toast.LENGTH_LONG).show();
        }
        
        @Override
        public void onInitFailed(int errorCode)
        {
//            Toast.makeText(game_ctx, "初始化失败", Toast.LENGTH_LONG).show();
        }
        
        @Override
        public void onInitSuccessed()
        {
        	//Toast.makeText(game_ctx, "初始化成功", Toast.LENGTH_LONG).show();
            if (hwBuoy != null)
            {
                hwBuoy.showSamllWindow(game_ctx.getApplicationContext());
            }
        }
        
        @Override
        public void onShowSuccssed()
        {
//            Toast.makeText(game_ctx, "显示成功", Toast.LENGTH_LONG).show();
        }
        
        @Override
        public void onShowFailed(int errorCode)
        {
        	//Toast.makeText(game_ctx, "显示失败====="+errorCode, Toast.LENGTH_LONG).show();
        }
        
        @Override
        public void onHidenSuccessed()
        {
//        	Toast.makeText(game_ctx, "隐藏成功", Toast.LENGTH_LONG).show();
        }
        
        @Override
        public void onHidenFailed(int errorCode)
        {
//        	Toast.makeText(game_ctx, "隐藏失败", Toast.LENGTH_LONG).show();
        }
        
        @Override
        public void onDestoryed()
        {
//        	Toast.makeText(game_ctx, "退出完成", Toast.LENGTH_LONG).show();
        }
    }

}
