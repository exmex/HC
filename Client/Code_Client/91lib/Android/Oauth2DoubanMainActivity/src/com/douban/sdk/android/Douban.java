package com.douban.sdk.android;

import org.json.JSONException;
import org.json.JSONObject;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.os.Bundle;
import android.util.Log;
import android.webkit.CookieSyncManager;

import com.douban.sdk.android.util.Utility;

/**
 * 
 */
public class Douban {
	public static String URL_OAUTH2_ACCESS_AUTHORIZE = "https://www.douban.com/service/auth2/auth";

	private static Douban mDoubanInstance = null;

	public static String app_key = "02e3d7298c9e5dd808ab857ca5db1988";//第三方应用的appkey
	public static String redirecturl = "http://www.7g8g.cn";// 重定向url
	public static String Secret = "b79708a2248dedf6";
	public Oauth2AccessToken accessToken = null;//AccessToken实例

	public static final String KEY_TOKEN = "access_token";
	public static final String KEY_EXPIRES = "expires_in";
	public static final String KEY_REFRESHTOKEN = "refresh_token";
	public static final String KEY_USERID = "douban_user_id";
	public static boolean isWifi=false;//当前是否为wifi
	/**
	 * 
	 * @param appKey 第三方应用的appkey
	 * @param redirectUrl 第三方应用的回调页
	 * @return Weibo的实例
	 */
	public synchronized static Douban getInstance(String appKey, String redirectUrl) {
		if (mDoubanInstance == null) {
			mDoubanInstance = new Douban();
		}
		app_key = appKey;
		Douban.redirecturl = redirectUrl;
		return mDoubanInstance;
	}
	/**
	 * 设定第三方使用者的appkey和重定向url
	 * @param appKey 第三方应用的appkey
	 * @param redirectUrl 第三方应用的回调页
	 */
	public void setupConsumerConfig(String appKey,String redirectUrl) {
		app_key = appKey;
		redirecturl = redirectUrl;
	}
	/**
	 * 
	 * 进行豆瓣认证
	 * @param activity 调用认证功能的Context实例
	 */
	public void authorize(Context context, DoubanAuthListener listener) {
		isWifi=Utility.isWifi(context);
		startAuthDialog(context, listener);
	}

	public void startAuthDialog(Context context, final DoubanAuthListener listener) {
		DoubanParameters params = new DoubanParameters();
//		CookieSyncManager.createInstance(context);
		startDialog(context, params, new DoubanAuthListener() {
		
			
			@Override
			public void onComplete(JSONObject values) {
				// ensure any cookies set by the dialog are saved
				CookieSyncManager.getInstance().sync();
				if (null == accessToken) {
					accessToken = new Oauth2AccessToken();
				}
				try {
					accessToken.setToken(values.getString(KEY_TOKEN));
				} catch (JSONException e) {
					e.printStackTrace();
				}
				try {
					accessToken.setExpiresIn(values.getString(KEY_EXPIRES));
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				try {
					accessToken.setRefreshToken(values.getString(KEY_REFRESHTOKEN));
				} catch (JSONException e) {
					e.printStackTrace();
				}
				try {
					accessToken.setMdouban_user_id(values.getString(KEY_USERID));
				} catch (JSONException e) {
					e.printStackTrace();
				}
				
				if (accessToken.isSessionValid()) {
					Log.d("Weibo-authorize",
							"Login Success! access_token=" + accessToken.getToken() + " expires="
									+ accessToken.getExpiresTime() + " refresh_token="
									+ accessToken.getRefreshToken());
					listener.onComplete(values);
				} else {
					Log.d("Weibo-authorize", "Failed to receive access token");
					listener.onDoubanException(new DoubanException("Failed to receive access token."));
				}
			}

			
			
			
			@Override
			public void onError(DoubanDialogError error) {
				Log.d("Weibo-authorize", "Login failed: " + error);
				listener.onError(error);
			}

			@Override
			public void onDoubanException(DoubanException error) {
				Log.d("Weibo-authorize", "Login failed: " + error);
				listener.onDoubanException(error);
			}

			@Override
			public void onCancel() {
				Log.d("Weibo-authorize", "Login canceled");
				listener.onCancel();
			}


			@Override
			public void onComplete(Bundle values) {
				// TODO Auto-generated method stub
				CookieSyncManager.getInstance().sync();
				if (null == accessToken) {
					accessToken = new Oauth2AccessToken();
				}
					accessToken.setToken(values.getString(KEY_TOKEN));
				 
					accessToken.setExpiresIn(values.getString(KEY_EXPIRES));
				 
					accessToken.setRefreshToken(values.getString(KEY_REFRESHTOKEN));
				 
				if (accessToken.isSessionValid()) {
					Log.d("Weibo-authorize",
							"Login Success! access_token=" + accessToken.getToken() + " expires="
									+ accessToken.getExpiresTime() + " refresh_token="
									+ accessToken.getRefreshToken());
					listener.onComplete(values);
				} else {
					Log.d("Weibo-authorize", "Failed to receive access token");
					listener.onDoubanException(new DoubanException("Failed to receive access token."));
				}
			}




			@Override
			public void onGetbackInfo(String userBack) {
				// TODO Auto-generated method stub
				Log.i("userBack", "userBack"+userBack);
				UserInfo = userBack;
			}
		});
	}
	private String UserInfo = ""  ;
	
	public String GetUserInfo(){
		
		return UserInfo;
	}
	
	public void startDialog(Context context, DoubanParameters parameters,
			final DoubanAuthListener listener) {
		parameters.add("client_id", app_key);
		
		parameters.add("redirect_uri", redirecturl);
		parameters.add("response_type", "code");
		parameters.add("scope", "shuo_basic_r,shuo_basic_w,douban_basic_common");
		
		if (accessToken != null && accessToken.isSessionValid()) {
			parameters.add(KEY_TOKEN, accessToken.getToken());
		}
		String url = URL_OAUTH2_ACCESS_AUTHORIZE + "?" + Utility.encodeUrl(parameters);
		
		
		if (context.checkCallingOrSelfPermission(Manifest.permission.INTERNET) != PackageManager.PERMISSION_GRANTED) {
			Utility.showAlert(context, "Error",
					"Application requires permission to access the Internet");
		} else {
			new DoubanDialog(context, url, listener).show();
		}
	}

}
