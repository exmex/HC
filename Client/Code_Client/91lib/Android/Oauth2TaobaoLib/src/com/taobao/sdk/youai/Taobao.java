package com.taobao.sdk.youai;

import org.json.JSONException;
import org.json.JSONObject;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.webkit.CookieSyncManager;

import com.taobao.sdk.youai.util.Utility;

/**
 */
public class Taobao {
	public static String URL_OAUTH2_ACCESS_AUTHORIZE ="https://oauth.tbsandbox.com/authorize";
	//正式上线的地址是  "https://oauth.taobao.com/authorize";

	private static Taobao mTaobaoInstance = null;

	public static String app_key = "test";
	public static String redirecturl = "http://10.13.105.133:8080/UrlCallback/UrlCallback";

	public Oauth2AccessToken accessToken = null;//AccessToken实例

	public static final String KEY_TOKEN = "access_token";
	public static final String KEY_EXPIRES = "expires_in";
	public static final String KEY_REFRESHTOKEN = "refresh_token";
	public static final String KEY_SECRET = "secket";
	
	public static boolean isWifi=false;

	public synchronized static Taobao getInstance(String appKey, String redirectUrl) {
		if (mTaobaoInstance == null) {
			mTaobaoInstance = new Taobao();
		}
		app_key = appKey;
		Taobao.redirecturl = redirectUrl;
		return mTaobaoInstance;
	}
	 
	public void setupConsumerConfig(String appKey,String redirectUrl) {
		app_key = appKey;
		redirecturl = redirectUrl;
	}
	 
	public void authorize(Context context, TaobaoAuthListener listener) {
		isWifi=Utility.isWifi(context);
		startAuthDialog(context, listener);
	}

	public void startAuthDialog(Context context, final TaobaoAuthListener listener) {
		TaobaoParameters params = new TaobaoParameters();
//		CookieSyncManager.createInstance(context);
		startDialog(context, params, new TaobaoAuthListener() {
			@Override
			public void onComplete(String values) {
				// ensure any cookies set by the dialog are saved
				CookieSyncManager.getInstance().sync();
				if (null == accessToken) {
					accessToken = new Oauth2AccessToken();
				}
				JSONObject jsonback = null;
				try {
					jsonback = new JSONObject(values);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					accessToken.setToken(jsonback.getString(KEY_TOKEN));
					accessToken.setExpiresIn(jsonback.getString(KEY_EXPIRES));
					accessToken.setRefreshToken(jsonback.getString(KEY_REFRESHTOKEN));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				
				if (accessToken.isSessionValid()) {
					Log.d("Taobao-authorize",
							"Login Success! access_token=" + accessToken.getToken() + " expires="
									+ accessToken.getExpiresTime() + " refresh_token="
									+ accessToken.getRefreshToken());
					listener.onComplete(values);
				} else {
					Log.d("Taobao-authorize", "Failed to receive access token");
					listener.onTaobaoException(new TaobaoException("Failed to receive access token."));
				}
			}

			@Override
			public void onError(TaobaoDialogError error) {
				Log.d("Taobao-authorize", "Login failed: " + error);
				listener.onError(error);
			}

			@Override
			public void onTaobaoException(TaobaoException error) {
				Log.d("Taobao-authorize", "Login failed: " + error);
				listener.onTaobaoException(error);
			}

			@Override
			public void onCancel() {
				Log.d("Taobao-authorize", "Login canceled");
				listener.onCancel();
			}
		});
	}

	public void startDialog(Context context, TaobaoParameters parameters,
			final TaobaoAuthListener listener) {
		parameters.add("client_id", app_key);
		parameters.add("response_type", "token");
		parameters.add("redirect_uri", redirecturl);
		parameters.add("view", "wap");

		if (accessToken != null && accessToken.isSessionValid()) {
			parameters.add(KEY_TOKEN, accessToken.getToken());
		}
		String url = URL_OAUTH2_ACCESS_AUTHORIZE + "?" +"client_id="+app_key+"response_type="+"code"
		+"redirect_uri="+redirecturl+"view="+"wap";
		if (context.checkCallingOrSelfPermission(Manifest.permission.INTERNET) != PackageManager.PERMISSION_GRANTED) {
			Utility.showAlert(context, "Error",
					"Application requires permission to access the Internet");
		} else {
			new TaobaoDialog(context, url, listener).show();
		}
	}

}
