package com.nuclear.sdk.android.config;

import com.loopj.android.http.RequestParams;

public class DoubanConfig extends FatherOAuthConfig {

	String scope;

	public DoubanConfig(String appKey, String appSecret, String redirectUrl,
			String scope) {
		super(appKey, appSecret, redirectUrl);
		this.scope = scope;
	}

	public String getCodeUrl() {
		return "https://www.douban.com/service/auth2/auth?client_id=" + appKey
				+ "&redirect_uri=" + encodedRedirectUrl()
				+ "&response_type=code&scope=" + scope;
	}

	@Override
	public String getAccessCodeUrl(String code) {
		return "https://www.douban.com/service/auth2/token?client_id=" + appKey
				+ "&client_secret=" + appSecret + "&redirect_uri="
				+ encodedRedirectUrl() + "&grant_type=authorization_code&code="
				+ code;
	}

	public RequestParams getAccessTokenParams(String code) {
		RequestParams params = new RequestParams();
		params.put("client_id", appKey);
		params.put("client_secret", appSecret);
		params.put("redirect_uri", redirectUrl);
		params.put("grant_type", "authorization_code");
		params.put("code", code);

		return params;
	}

	public String getRefreshTokenUrl() {
		return "https://www.douban.com/service/auth2/token";
	}

	public RequestParams getRefreshTokenParams(String refreshToken) {
		RequestParams params = new RequestParams();
		params.put("client_id", appKey);
		params.put("client_secret", appSecret);
		params.put("redirect_uri", redirectUrl);
		params.put("grant_type", "refresh_token");
		params.put("refresh_token", refreshToken);

		return params;
	}

}
