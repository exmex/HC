package com.nuclear.dota.platform.vivo;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.Config;


public class VivoActivity extends GameActivity{
	
	private static final String 	TAG = "VIVO";
	private static final int 		REQUEST_CODE_LOGIN = 0;
	private static final int 		REQUEST_CODE_PAY = 1234;
	public final static String 		KEY_NAME = "name";
	public final static String 		KEY_OPENID = "openid";
	public final static String 		KEY_AUTHTOKEN = "authtoken";
	public final static String 		KEY_LOGIN_RESULT = "LoginResult";
	private boolean 				doInitWeChat = false;
	public VivoActivity() {
		// TODO Auto-generated constructor stub
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Vivo);
	}


	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		if(doInitWeChat==false)
		{
			ApplicationInfo appInfo = null;
			try {
				appInfo = this.getPackageManager().getApplicationInfo(this.getPackageName(),PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
		
			}
		
			if(appInfo!=null && appInfo.metaData != null)
			{
				String WX_APP_ID = appInfo.metaData.getString("WX_APP_ID");
				if(WX_APP_ID!=null)
				{
				Config.WX_APP_ID = WX_APP_ID;
				}
			}
			
			doInitWeChat = true;
		}
		if(null!=Config.WX_APP_ID && !Config.WX_APP_ID.equals("")){
			api = WXAPIFactory.createWXAPI(this, Config.WX_APP_ID, false);
			api.registerApp(Config.WX_APP_ID);// 将该app注册到微信
		}
	}
	/*
	 * authtoken：第三方游戏用此token到vivo用户系统服务端获取用户信息
	   openid：唯一标识用户
	   name: 帐户的用户名
	 */
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if(requestCode == REQUEST_CODE_LOGIN){
			if(resultCode == Activity.RESULT_OK){
				String loginResult = data.getStringExtra(KEY_LOGIN_RESULT);
				JSONObject loginResultObj;
				try {
					loginResultObj = new JSONObject(loginResult);
					String name = loginResultObj.getString(KEY_NAME);
					String openid = loginResultObj.getString(KEY_OPENID);
					String authtoken = loginResultObj.getString(KEY_AUTHTOKEN);
					
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.account_uid_str = openid;
					login_info.account_nick_name = name;
					login_info.account_user_name = name;
					
					PlatformVivoLoginAndPay.getInstance().mIsLogined = true;
					PlatformVivoLoginAndPay.getInstance().notifyLoginResult(login_info);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				Log.d(TAG, "loginResult="+loginResult);
			}
		}
		if(requestCode == REQUEST_CODE_PAY){
			if(data != null && null != data.getBundleExtra("payment_params")){
				Bundle extras = data.getBundleExtra("payment_params");
				String trans_no = extras.getString("transNo");
				boolean pay_result = extras.getBoolean("pay_result");
				String res_code = extras.getString("result_code");
				String pay_msg = extras.getString("pay_msg");
				Log.d(TAG, "Pay Result-->" + pay_result);
				if(pay_result){
					Log.d(TAG, "支付成功：" + "订单号：" + trans_no + " 状态码:" + res_code + " 结果信息：" + pay_msg);
					Toast.makeText(getApplicationContext(), "支付成功", Toast.LENGTH_SHORT).show();
				}else{
					Log.d(TAG, "支付失败：" + "订单号：" + trans_no + " 状态码:" + res_code + " 结果信息：" + pay_msg);
					Toast.makeText(getApplicationContext(), "支付失败", Toast.LENGTH_SHORT).show();
				}
			}else{
				//Toast.makeText(getApplicationContext(), "Data NULL", Toast.LENGTH_SHORT).show();
				Log.e(TAG, "DATA NULL");
			}
			
		}
	}

}
