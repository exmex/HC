package com.youai.sdk.android.config;

import android.text.TextUtils;

import com.loopj.android.http.RequestParams;

public class FacebookConfig extends FatherOAuthConfig {

	

	public FacebookConfig(String appKey, String appSecret, String redirectUrl,
			String scope) {
		super(appKey, appSecret, redirectUrl);
		this.scope = scope;
	}

	public String getCodeUrl() {
		return "";
	}

	@Override
	public String getAccessCodeUrl(String code) {
		return "";
	}

	public RequestParams getAccessTokenParams(String code) {
		RequestParams params = new RequestParams();
		
		return params;
	}

	public String getRefreshTokenUrl() {
		return "";
	}
	
	public RequestParams getRefreshTokenParams(String refreshToken) {
		RequestParams params = new RequestParams();

		return params;
	}

}
