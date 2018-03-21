package com.nuclear.sdk.android.config;

import android.app.AlertDialog;
import android.text.TextUtils;

import com.loopj.android.http.RequestParams;

public class RenrenConfig extends FatherOAuthConfig {

	

	public RenrenConfig(String appKey, String appSecret, String redirectUrl,
			String scope) {
		super(appKey, appSecret, redirectUrl);
		this.scope = scope;
	}

	public String getCodeUrl() {
		return "https://graph.renren.com/oauth/authorize?client_id=" + appKey
				+ "&redirect_uri=" + encodedRedirectUrl()
				+ "&response_type=code"
				+ (TextUtils.isEmpty(scope) ? "" : ("&scope" + scope)+"&display=touch");
	}

	@Override
	public String getAccessCodeUrl(String code) {
		return "https://graph.renren.com/oauth/token?grant_type=authorization_code&client_id="
				+ appKey
				+ "&redirect_uri="
				+ encodedRedirectUrl()
				+ "&client_secret=" + appSecret + "&code=" + code;
	}

	public RequestParams getAccessTokenParams(String code) {
		RequestParams params = new RequestParams();
		
		return params;
	}

	public String getRefreshTokenUrl() {
		return "https://graph.renren.com/oauth/token?";
	}
	
	public RequestParams getRefreshTokenParams(String refreshToken) {
		RequestParams params = new RequestParams();
		params.put("client_id", appKey);
		params.put("client_secret", appSecret);
		params.put("grant_type", "refresh_token");
		params.put("refresh_token", refreshToken);

		return params;
	}

}
