package com.tencent.sdk.youai;

import java.net.URLEncoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.json.JSONException;
import org.json.JSONObject;

import android.Manifest;
import android.content.Context;
import android.content.pm.PackageManager;
import android.util.Log;
import android.webkit.CookieSyncManager;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.tencent.sdk.youai.api.AccountAPI;
import com.tencent.sdk.youai.api.TencentAPI;
import com.tencent.sdk.youai.api.UsersAPI;
import com.tencent.sdk.youai.util.Utility;

/**
 */
public class Tencent {
	public static String URL_OAUTH2_ACCESS_AUTHORIZE ="https://graph.qq.com/oauth2.0/authorize";
	//正式上线的地址是  "https://oauth.Tencent.com/authorize";

	private static Tencent mTencentInstance = null;

	public static String app_key = "test";
	public static String redirecturl = "http://oauth_china_android.com";
	public static String getuidopenidurl = "https://graph.z.qq.com/moc2/me";
	public static String get_simple_userinfo = "https://graph.z.qq.com/moc2/me";
	
	public Oauth2AccessToken accessToken = null;//AccessToken实例

	public static final String KEY_TOKEN = "access_token";
	public static final String KEY_EXPIRES = "expires_in";
	public static final String KEY_REFRESHTOKEN = "refresh_token";
	public static final String KEY_SECRET = "secket";
	
	public static boolean isWifi=false;
	private String uid  ;
	private String nickname  ;
	private String error  ;
	private TencentDialog mTencentDialog;
	
	public synchronized static Tencent getInstance(String appKey, String redirectUrl) {
		if (mTencentInstance == null) {
			mTencentInstance = new Tencent();
		}
		app_key = appKey;
		Tencent.redirecturl = redirectUrl;
		return mTencentInstance;
	}
	 
	public Oauth2AccessToken getAccessToken() {
		return accessToken;
	}

	public String getUid() {
		return uid;
	}

	public void setupConsumerConfig(String appKey,String redirectUrl) {
		app_key = appKey;
		redirecturl = redirectUrl;
	}
	 
	public void authorize(Context context, TencentAuthListener listener) {
		isWifi=Utility.isWifi(context);
		startAuthDialog(context, listener);
	}

	public void startAuthDialog(Context context, final TencentAuthListener listener) {
		TencentParameters params = new TencentParameters();
//		CookieSyncManager.createInstance(context);
		startDialog(context, params, new TencentAuthListener() {
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
					Log.d("Tencent-authorize",
							"Login Success! access_token=" + accessToken.getToken() + " expires="
									+ accessToken.getExpiresTime() + " refresh_token="
									+ accessToken.getRefreshToken());
					final AsyncHttpClient client = new AsyncHttpClient();
					
					RequestParams params = new RequestParams();
					params.put("access_token", accessToken.getToken());
					client.get(getuidopenidurl, params, new AsyncHttpResponseHandler(){
						
						public void onSuccess(String response) {
							Pattern pattern = Pattern
									.compile("client_id=(.*)&openid=(.*)");
							Matcher m = pattern
									.matcher(response);
							if (m.matches()
									&& m.groupCount() == 2) {
								uid = m.group(2);
								
							}
							RequestParams paramsinfo = new RequestParams();
							paramsinfo.put("access_token", accessToken.getToken());
							paramsinfo.put("oauth_consumer_key", app_key);
							paramsinfo.put("openid", uid);
							
							client.get(get_simple_userinfo, paramsinfo, new AsyncHttpResponseHandler(){
								public void onSuccess(String response) {
									JSONObject jsonback = null;
									try {
										jsonback = new JSONObject(response);
									} catch (JSONException e1) {
										// TODO Auto-generated catch block
										e1.printStackTrace();
									}
									try {
										String msg = jsonback.getString("msg");//错误码
										String ret = jsonback.getString("ret");//0表示正确，其他失败
										String nickname = jsonback.getString("nickname");
										error = msg;
										Tencent.this.nickname = nickname;
										
										listener.onComplete(response);
										mTencentDialog.dismiss();
									} catch (Exception e) {
									}
									
								};
							});
						};
						
					});
					
				} else {
					Log.d("Tencent-authorize", "Failed to receive access token");
					listener.onTencentException(new TencentException("Failed to receive access token."));
				}
			}

			@Override
			public void onError(TencentDialogError error) {
				Log.d("Tencent-authorize", "Login failed: " + error);
				listener.onError(error);
			}

			@Override
			public void onTencentException(TencentException error) {
				Log.d("Tencent-authorize", "Login failed: " + error);
				listener.onTencentException(error);
			}

			@Override
			public void onCancel() {
				Log.d("Tencent-authorize", "Login canceled");
				listener.onCancel();
			}
		});
	}

	public void startDialog(Context context, TencentParameters parameters,
			final TencentAuthListener listener) {
		parameters.add("client_id", app_key);
		parameters.add("response_type", "code");
		parameters.add("redirect_uri",  URLEncoder.encode(redirecturl));
		parameters.add("state", "test");
		parameters.add("display", "mobile");

		
		if (accessToken != null && accessToken.isSessionValid()) {
			parameters.add(KEY_TOKEN, accessToken.getToken());
		}
		
		
		String url = URL_OAUTH2_ACCESS_AUTHORIZE + "?" +"client_id="+app_key+"&response_type="+"code"
		+"&redirect_uri="+URLEncoder.encode(redirecturl)+"&state="+"test"+"&display="+"mobile";
		
		if (context.checkCallingOrSelfPermission(Manifest.permission.INTERNET) != PackageManager.PERMISSION_GRANTED) {
			Utility.showAlert(context, "Error",
					"Application requires permission to access the Internet");
		} else {
			mTencentDialog = new TencentDialog(context, url, listener);
			mTencentDialog.show();
		}
	}

}
