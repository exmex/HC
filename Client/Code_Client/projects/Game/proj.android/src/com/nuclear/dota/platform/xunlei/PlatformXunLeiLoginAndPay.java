package com.nuclear.dota.platform.xunlei;

import java.io.IOException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.net.URLEncoder;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;
import java.util.Set;
import java.util.UUID;

import org.apache.http.conn.util.InetAddressUtils;
import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.util.Log;
import android.widget.Toast;

import com.xunlei.phone.game.XLPhonePluginHelper;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.util.XLContext;
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

public class PlatformXunLeiLoginAndPay implements IPlatformLoginAndPay {

	
	private static final String TAG = PlatformXunLeiLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	private boolean						isLogin = false;
	
	private XLContext                   xlContext;
	  public static String hostip;             //本机IP  
	  public static String customerId;
	
	private static PlatformXunLeiLoginAndPay sInstance = null;
	public static PlatformXunLeiLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformXunLeiLoginAndPay();
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
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_XunLei;
		this.game_info.platform_type =PlatformAndGameInfo.enPlatform_XunLei;
		
		//初始化SDK
		xlContext = XLPhonePluginHelper.init(this.game_ctx, String.valueOf(this.game_info.app_id), this.game_info.app_id_str, new byte[] { 11,-5,7,48,17,-28,79,-87,110,-41,-125,-7,83,-90,106,33 });
		
		isLogin = false;
		mCallback1.notifyInitPlatformSDKComplete();
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
		mCallback3= callback3;
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
		
		this.isLogin = false;
		
		
		//
		//
		PlatformXunLeiLoginAndPay.sInstance = null;
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
			return;
		}
		final IGameAppStateCallback callback = PlatformXunLeiLoginAndPay.sInstance.mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登陆");
		XLPhonePluginHelper.login(this.game_ctx,new LoginCallback());
		callback.showWaitingViewImp(false, -1, "");
	}
	
	static class LoginCallback implements ICallBack {
        /**
		 * 
		 */
		private static final long serialVersionUID = -2103246624804977293L;

		
		@Override
        public void onCallBack(int resultCode, Object resultData) {
            Log.d("xlsdk", "result code:" + resultCode);
            Log.d("xlsdk", "info token:" + resultData == null ? "" : resultData.toString());
            
            final IGameAppStateCallback callback = PlatformXunLeiLoginAndPay.sInstance.mCallback3;
			callback.showWaitingViewImp(false, -1, "");
            
            final Object orObject = resultData;
            new Thread() {
				@Override
				public void run() {
					// TODO Auto-generated method stub
					try
    				{
    					String url = "http://203.195.147.63/tokenValidate/xunlei.php";
    					Map<String, String> params = new HashMap<String, String>();

    					params.put("gameId", String.valueOf(PlatformXunLeiLoginAndPay.sInstance.game_info.app_id));
    					params.put("serverId", "0");
    					
    					hostip = getLocalIpAddress();  //获取本机IP     
    					params.put("clientIp", hostip);
    					/*url编码，采用UTF-8*/
    					String encoding = "UTF-8";
    					String info = URLEncoder.encode(orObject.toString(), "UTF-8");
    					params.put("info",info);
    					
    					/*post请求*/
    					try {
    						HttpResponse response = HttpReqUtil.sendGet(url, params, encoding);
    						Properties properties = response.getContent();
    						Set<Entry<Object, Object>> set = properties.entrySet();
    						for(Entry<Object, Object> entry : set){
    							String key = entry.getKey().toString();
    							String value = entry.getValue().toString();
//    							Log.d("KKKKKKKKKKKKK", key+"==========="+value);
    							if(key.equals("customerId"))
    							{
    								customerId = value.trim();
    							}
    							if(key.equals("code")){
    								if(value.equals("0000"))
    								{
    									
    									final LoginInfo login_info = new LoginInfo();
    									login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
    									login_info.login_session = customerId;
    									login_info.account_uid_str = customerId;
    									login_info.account_nick_name ="更换账号";
    									
    									
    									PlatformXunLeiLoginAndPay.sInstance.game_ctx.runOnUiThread(new Runnable() {
    										@Override
    										public void run() {
    											// TODO Auto-generated method stub
    											PlatformXunLeiLoginAndPay.sInstance.isLogin = true;
    	    									PlatformXunLeiLoginAndPay.getInstance().notifyLoginResult(login_info);
    										}
    									});
    								}
    								else if(value.equals("0001")){
    									PlatformXunLeiLoginAndPay.sInstance.game_ctx.runOnUiThread(new Runnable() {
    										@Override
    										public void run() {
    											// TODO Auto-generated method stub
    											Toast.makeText(PlatformXunLeiLoginAndPay.sInstance.game_ctx,"账号密码错误", Toast.LENGTH_SHORT).show();
    		    								
    										}
    									});
        								Log.e("QQQQQQQQQQQQQQ", value);
        								return;
        								
        							}
        							else if(value.equals("0002")){
        								
        								PlatformXunLeiLoginAndPay.sInstance.game_ctx.runOnUiThread(new Runnable() {
    										@Override
    										public void run() {
    											// TODO Auto-generated method stub
    											Toast.makeText(PlatformXunLeiLoginAndPay.sInstance.game_ctx,"账号未激活", Toast.LENGTH_SHORT).show();
    		    								
    										}
    									});
        								Log.e("QQQQQQQQQQQQQQ", value);
        								return;
        							}
        							else if(value.equals("0003")){
        								
        								PlatformXunLeiLoginAndPay.sInstance.game_ctx.runOnUiThread(new Runnable() {
    										@Override
    										public void run() {
    											// TODO Auto-generated method stub
    											Toast.makeText(PlatformXunLeiLoginAndPay.sInstance.game_ctx,"账号被冻结", Toast.LENGTH_SHORT).show();
    		    								
    										}
    									});
        								Log.e("QQQQQQQQQQQQQQ", value);
        								return;
        							}
        							else if(value.equals("0004")){
        								
        								PlatformXunLeiLoginAndPay.sInstance.game_ctx.runOnUiThread(new Runnable() {
    										@Override
    										public void run() {
    											// TODO Auto-generated method stub
    											Toast.makeText(PlatformXunLeiLoginAndPay.sInstance.game_ctx,"账号被限制", Toast.LENGTH_SHORT).show();
    		    								
    										}
    									});
        								Log.e("QQQQQQQQQQQQQQ", value);
        								return;
        							}
        							else if(value.equals("0005")){
        								
        								PlatformXunLeiLoginAndPay.sInstance.game_ctx.runOnUiThread(new Runnable() {
    										@Override
    										public void run() {
    											// TODO Auto-generated method stub
    											Toast.makeText(PlatformXunLeiLoginAndPay.sInstance.game_ctx,"账号验证时发生异常", Toast.LENGTH_SHORT).show();
    		    								
    										}
    									});
        								Log.e("QQQQQQQQQQQQQQ", value);
        								return;
        							}
        							else if(value.equals("0006")){
        								
        								PlatformXunLeiLoginAndPay.sInstance.game_ctx.runOnUiThread(new Runnable() {
    										@Override
    										public void run() {
    											// TODO Auto-generated method stub
    											Toast.makeText(PlatformXunLeiLoginAndPay.sInstance.game_ctx,"登陆被限制", Toast.LENGTH_SHORT).show();
    										}
    									});
        								
        								Log.e("QQQQQQQQQQQQQQ", value);
        								return;
        							}
    							}
    							
    						}
    					} catch (IOException e) {
    						// TODO Auto-generated catch block
    						e.printStackTrace();
    					}
    				}catch(Exception e){
    					e.printStackTrace();
    				}
				}
            }.start();
        }
    }

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if(login_result != null){
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_XunLei+login_info.account_uid_str.trim();
			Toast.makeText(game_ctx,"登录成功，点击进入游戏", Toast.LENGTH_SHORT).show();
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
		int Error = 0;
		this.pay_info = null;
		this.pay_info = pay_info;
		
		String extendInfo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		xlContext.setServerid(Cocos2dxHelper.nativeGetServerId()+"");
		int price =(int)this.pay_info.price;
		xlContext.setChargeNum(String.valueOf(price));
        XLPhonePluginHelper.pay(this.game_ctx, extendInfo, new ChargeCallback());
		
		return Error;
	}
	
	static class ChargeCallback implements ICallBack {

        /**
		 * 
		 */
		private static final long serialVersionUID = -1432121009889576099L;

		@Override
        public void onCallBack(int resultCode, Object resultData) {
            Log.d("xlsdk", "result code:" + resultCode);
            Log.d("xlsdk", "order id from xl:" + resultData == null ? "" : resultData.toString());
            switch (resultCode) {
			case XLContext.SUCCESS:
				Log.d(TAG, "支付成功");
				PlatformXunLeiLoginAndPay.getInstance().pay_info.result = 0;
				PlatformXunLeiLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformXunLeiLoginAndPay.getInstance().pay_info);
				break;
			default:
				Log.d(TAG, "支付失败");
				break;
			}
        }

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
			Toast.makeText(game_ctx,"暂未开放,敬请期待!", Toast.LENGTH_SHORT).show();
			return;
		}
		if (PlatformXunLeiLoginAndPay.getInstance().isLogin)
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
	
	public static String getLocalIpAddress(){
		
		try{
			 for (Enumeration<NetworkInterface> en = NetworkInterface.getNetworkInterfaces(); en.hasMoreElements();) {
				 NetworkInterface intf = en.nextElement();  
	                for (Enumeration<InetAddress> enumIpAddr = intf  
	                        .getInetAddresses(); enumIpAddr.hasMoreElements();) {  
	                    InetAddress inetAddress = enumIpAddr.nextElement();  
	                    if (!inetAddress.isLoopbackAddress() && InetAddressUtils.isIPv4Address(inetAddress.getHostAddress())) {  
	                        
	                    	return inetAddress.getHostAddress().toString();  
	                    }  
	                }  
			 }
		}catch (SocketException e) {
			// TODO: handle exception
			Log.e("AAAA","WifiPreference IpAddress---error-" + e.toString());
		}
		
		return null; 
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
