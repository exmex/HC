package com.nuclear.sdk.android.config;

import java.util.regex.Matcher;
import java.util.regex.Pattern;


import android.net.Uri;
import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.nuclear.sdk.android.OAuthListener;
import com.nuclear.sdk.android.token.Token;

public class QQConfig extends FatherOAuthConfig {

	public QQConfig(String appKey, String appSecret, String redirectUrl) {
		super(appKey, appSecret, redirectUrl);
	}

	@Override
	public String getRefreshTokenUrl() {
		return null;
	}

	@Override
	public RequestParams getRefreshTokenParams(String refreshToken) {
		RequestParams params = new RequestParams();
		params.put("client_id", appKey);
		params.put("grant_type", "refresh_token");
		params.put("refresh_token", refreshToken);

		return params;
	}

	@Override
	public String getCodeUrl() {
		return "https://openmobile.qq.com/oauth2.0/authorize?client_id=" + appKey
				+ "&response_type=code&redirect_uri=" + encodedRedirectUrl()
				+ "&state=test&display=mobile";
	}

	@Override
	public String getAccessCodeUrl(String code) {
		return "https://openmobile.qq.com/oauth2.0/token?client_id=" + appKey
				+ "&client_secret=" + appSecret + "&redirect_uri="
				+ encodedRedirectUrl() + "&grant_type=authorization_code&code="
				+ code;
	}

	@Override
	public RequestParams getAccessTokenParams(String code) {
		RequestParams params = new RequestParams();

		return params;
	}

	public void getAccessCode(Uri uri, final OAuthListener listen) {
		final String code = uri.getQueryParameter("code");
		Log.d(TAG, "code: " + code);

		final AsyncHttpClient client = new AsyncHttpClient();
		String newUrl = getAccessCodeUrl(code);
		Log.d(TAG, "newUrl: " + newUrl);
		RequestParams requestParams = getAccessTokenParams(code);
		getAccessCodeRequest(client, newUrl, requestParams,
				new AsyncHttpResponseHandler() {
					@Override
					public void onSuccess(String response) {
						if (listen != null) {
							final Token token = Token.make(response,QQConfig.this);
							client.get("https://openmobile.qq.com/oauth2.0/me?access_token="+ token.getAccessToken(),
									new AsyncHttpResponseHandler() {
										 public void onFailure(Throwable error, String content) {
											 listen.onError(content);
										 };
										public void onSuccess(String response) {
											String openid = response.substring(response.indexOf("openid\":\"")+9, response.lastIndexOf("\""));
											token.setUid(openid);
											listen.onSuccess(token);

										};
									});

						}
					}
				});
	}

	@Override
	protected void getAccessCodeRequest(AsyncHttpClient client, String url,
			RequestParams requestParams, AsyncHttpResponseHandler l) {
		client.get(url, requestParams, l);
	}

}
