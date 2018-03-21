package com.nuclear.sdk.android.config;

import java.net.URLEncoder;


import android.net.Uri;
import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.nuclear.sdk.android.OAuthListener;
import com.nuclear.sdk.android.token.Token;

public abstract class FatherOAuthConfig {

	protected static final String TAG = FatherOAuthConfig.class.getSimpleName();

	public String appKey = "";
	public String appSecret = "";
	public String redirectUrl = "";
	String scope;
	
	public FatherOAuthConfig(String appKey, String appSecret, String redirectUrl) {
		this.appKey = appKey;
		this.appSecret = appSecret;
		this.redirectUrl = redirectUrl;
	}

	@SuppressWarnings("deprecation")
	public String encodedRedirectUrl() {
		return URLEncoder.encode(redirectUrl);
	}

	public abstract String getRefreshTokenUrl();

	public abstract RequestParams getRefreshTokenParams(String refreshToken);

	public abstract String getCodeUrl();

	public abstract String getAccessCodeUrl(String code);

	public abstract RequestParams getAccessTokenParams(String code);

	public void getAccessCode(Uri uri, final OAuthListener olisten) {
		final String code = uri.getQueryParameter("code");
		Log.d(TAG, "code: " + code);

		AsyncHttpClient client = new AsyncHttpClient();
		String newUrl = getAccessCodeUrl(code);
		Log.d(TAG, "newUrl: " + newUrl);
		RequestParams requestParams = getAccessTokenParams(code);
		getAccessCodeRequest(client, newUrl, requestParams,
				new AsyncHttpResponseHandler() {
					
					@Override
					public void onFailure(Throwable arg0, String arg1) {
						olisten.onError(arg1);
					}
					
					@Override
					public void onSuccess(String response) {
						if (olisten != null) {
							Token token = Token
									.make(response, FatherOAuthConfig.this);
							olisten.onSuccess(token);
						}
					}
				});
	}

	protected void getAccessCodeRequest(AsyncHttpClient client, String url,
			RequestParams requestParams, AsyncHttpResponseHandler l) {
		client.post(url, requestParams, l);
	}
}
