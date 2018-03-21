package com.nuclear.dota.platform.vivo;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.URL;
import java.security.SecureRandom;
import java.security.cert.CertificateException;
import java.security.cert.X509Certificate;
import java.text.DecimalFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import javax.net.ssl.HostnameVerifier;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLSession;
import javax.net.ssl.TrustManager;
import javax.net.ssl.X509TrustManager;
import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;
import com.bbkmobile.iqoo.payment.PaymentActivity;
import com.vivo.account.base.activity.LoginActivity;
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

public class PlatformVivoLoginAndPay implements IPlatformLoginAndPay {
	
	private static final String TAG = "VIVO";
	private static final int REQUEST_CODE_LOGIN = 0;
	private static final int REQUEST_CODE_PAY = 1234;
	public final static String KEY_NAME = "name";
	public final static String KEY_OPENID = "openid";
	public final static String KEY_AUTHTOKEN = "authtoken";
	public final static String KEY_LOGIN_RESULT = "LoginResult";
	public final static String KEY_SWITCH_ACCOUNT = "switchAccount";
	//
	private IGameActivity mGameActivity;
	private IPlatformSDKStateCallback mCallback1;
	private IGameUpdateStateCallback mCallback2;
	public  IGameAppStateCallback mCallback3;
	private String vivoOrder;
	private String vivoSignature;
	private ProgressDialog dialog = null;
	private String payResultJSON = null;
	//
	public Activity game_ctx = null;
	public GameInfo game_info = null;
	public LoginInfo login_info = null;
	public VersionInfo version_info = null;
	public PayInfo pay_info = null;
	public boolean mIsLogined = false; 

	private static PlatformVivoLoginAndPay sInstance = null;
	
	public static PlatformVivoLoginAndPay getInstance(){
		if(sInstance == null){	
			sInstance = new PlatformVivoLoginAndPay();
		}
		return sInstance;
	}

	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Debug;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Vivo;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_Vivo;
		
		mIsLogined = false;
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
		
		mIsLogined = false;
		PlatformVivoLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		
		if(mIsLogined == true){
			Log.d(TAG, "已登录");
		}else{
			Intent loginIntent = new Intent(game_ctx, LoginActivity.class);
			game_ctx.startActivityForResult(loginIntent, REQUEST_CODE_LOGIN);
			PlatformVivoLoginAndPay.getInstance().notifyLoginResult(login_info);
			
		}
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		
		if (login_result != null) {
			mIsLogined = true;
			login_result.account_uid_str = 
					PlatformAndGameInfo.enPlatformShort_Vivo + login_result.account_uid_str;
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public void onLoginGame() {
		// TODO Auto-generated method stub

	}
	
	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		return login_info;
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub
		mIsLogined = false;
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

	private Handler handler = new Handler() {  
	    public void handleMessage(android.os.Message msg) {    
	        switch (msg.what) {  
	        case 123:  
	        	Toast.makeText(game_ctx, "订单生成成功", Toast.LENGTH_SHORT).show();
				JSONObject payResultObj;
				try {
					payResultObj = new JSONObject(payResultJSON);
					vivoOrder = payResultObj.getString("vivoOrder");
					vivoSignature = payResultObj.getString("vivoSignature");
					
					String packageName = "com.youai.dreamonepiece.platform.vivo";
					String description =  pay_info.description + "_" + pay_info.product_id+"_"+login_info.account_uid_str;
					Bundle localBundle = new Bundle();
					DecimalFormat format_d = new DecimalFormat("#.##");
					localBundle.putString("transNo", vivoOrder);// 交易流水号
					localBundle.putString("signature", vivoSignature);// 签名信息
					localBundle.putString("package", packageName); //应用的包名
					localBundle.putString("useMode", "00");
					localBundle.putString("productName", pay_info.product_name);//商品名称
					localBundle.putString("productDes", description);//商品描述
					String price = String.format("%.2f", pay_info.price);
					try {
						localBundle.putDouble("price",format_d.parse(price).doubleValue());
					} catch (ParseException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					//localBundle.putDouble("price",0.01);
					localBundle.putString("userId", login_info.account_uid_str);//vivo账户id（可以为空）
					
					Intent target = new Intent(game_ctx, PaymentActivity.class);
					target.putExtra("payment_params", localBundle);
					game_ctx.startActivityForResult(target, REQUEST_CODE_PAY);
					
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Log.d(TAG, "vivoOrder-->" + vivoOrder + " vivoSignature-->" + vivoSignature);
	            dialog.dismiss(); 
	            break;  
	        case -123:  
	        	Toast.makeText(game_ctx, "数据传输错误，订单生成失败", Toast.LENGTH_SHORT).show();
				Log.e(TAG, "HTTP JSON ERROR!");
	            dialog.dismiss();
	            break;  
	        }  
	    };  
	};  
	@Override
	public int callPayRecharge(final PayInfo pay_info) {
		// TODO Auto-generated method stub
		this.pay_info = null;
		this.pay_info = pay_info;
		dialog = ProgressDialog.show(game_ctx, "", "数据传输，请稍等");
		new Thread() {  
            @Override  
            public void run() {  
                try {    
                     
                    getHttpsData(pay_info);
                } catch (Exception e) {
                	Message message = new Message();  
                    message.what = -123;  
                    handler.sendMessage(message);  
                    e.printStackTrace();  
                }  
            }  
        }.start();  
		
		
		
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
		if (Cocos2dxHelper.nativeHasEnterMainFrame()){
			Toast.makeText(game_ctx, "暂未开放", Toast.LENGTH_SHORT).show();
			return;
		}else{
			Intent swithIntent = new Intent(game_ctx, LoginActivity.class);
			swithIntent.putExtra(KEY_SWITCH_ACCOUNT, true);
			game_ctx.startActivityForResult(swithIntent, REQUEST_CODE_LOGIN);
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
		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}
	}

	@Override
	public void callPlatformGameBBS() {
		// TODO Auto-generated method stub
		if(mIsLogined){
			return;
		}
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
	
	private class MyTrustManager implements X509TrustManager{  
        @Override  
        public void checkClientTrusted(X509Certificate[] chain, String authType)  
                        throws CertificateException {  
                // TODO Auto-generated method stub  
        }  

        @Override  
        public void checkServerTrusted(X509Certificate[] chain, String authType)  
                        throws CertificateException {  
                // TODO Auto-generated method stub  
        }  

        @Override  
        public X509Certificate[] getAcceptedIssuers() {  
                // TODO Auto-generated method stub  
                return null;  
        }          
	}
	private class MyHostnameVerifier implements HostnameVerifier{  
        @Override  
        public boolean verify(String hostname, SSLSession session) {  
                // TODO Auto-generated method stub  
                return true;  
        }  
	}
	
	private void getHttpsData(PayInfo pay_info){
		//改，从JSON得到
		String storeId = this.game_info.app_secret;
		String appId = this.game_info.app_id+"";
		String storekey = this.game_info.app_key;
		//异步返回商户服务器地址ַ
		String notifyUrl = this.game_info.pay_addr;
		
		//转译字符
		String[] product_id_split = pay_info.product_id.split("\\.",2);
		
		String description = pay_info.description + "_" + product_id_split[0] + "_"+this.login_info.account_uid_str;
		//商户自定义订单号
		String storeOrder = generateNewOrderSerial() + "_" + description;
		Log.d(TAG, "storeOrder Length:" + storeOrder.length());
		//日期格式化输出
		SimpleDateFormat formatter = new SimpleDateFormat("yyyyMMddHHmmss");
        Date date = new Date();
        String orderTime = formatter.format(date);
      //价格格式化输出必须是小数点后两位，否则https请求会失败
        String price = String.format("%.2f",pay_info.price);
        
        Map<String,String> para = new HashMap<String, String>();
    	para.clear();
    	
    	para.put("storeId", storeId);
    	para.put("appId", appId);
    	para.put("storeOrder", storeOrder);
    	para.put("notifyUrl",notifyUrl);
    	para.put("orderTime", orderTime);
    	//para.put("orderAmount", "0.01");
    	para.put("orderAmount", price);
    	para.put("orderTitle", pay_info.product_name);
    	para.put("orderDesc", description);
    	//得到Vivo签名
    	String signature = VivoSignUtils.getVivoSign (para, storekey);
    	para.put("version", "1.0.0");
    	para.put("signMethod", "MD5");
    	para.put("signature", signature);
    	
		String https = "https://pay.vivo.com.cn/vivoPay/getVivoOrderNum";
		
    	String query_str = VivoSignUtils.buildReq(para, storekey);
    	Log.d(TAG,query_str);
        
    	byte[] entity_data = query_str.getBytes();
        try{
        	SSLContext sc = SSLContext.getInstance("TLS");
        	sc.init(null, new TrustManager[]{
        			new MyTrustManager()}, new SecureRandom());
        	HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
        	HttpsURLConnection.setDefaultHostnameVerifier(new MyHostnameVerifier());
        	HttpsURLConnection conn = (HttpsURLConnection)new URL(https).openConnection();
        	
        	conn.setRequestProperty("Content-Type","application/x-www-form-urlencoded;charset=UTF-8"); 
        	conn.setRequestProperty("Content-Length", String.valueOf(entity_data.length));
        	conn.setDoOutput(true);  
            conn.setDoInput(true); 
            conn.setConnectTimeout(3000);
            conn.connect(); 
            
            OutputStream outStream = conn.getOutputStream();  
            outStream.write(entity_data);  
            outStream.flush();  
            outStream.close(); 
            
            Log.d(TAG, "Reading response");
            
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));  
            StringBuffer sb = new StringBuffer();  
            String line;  
            while ((line = br.readLine()) != null)  
                    sb.append(line);  
            payResultJSON = sb.toString();
            Message message = new Message();  
            message.what = 123;  
            handler.sendMessage(message);
        }catch(Exception e){
        	e.printStackTrace();
        }
	}

}
