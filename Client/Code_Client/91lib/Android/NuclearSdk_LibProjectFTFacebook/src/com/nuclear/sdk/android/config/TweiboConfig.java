package com.nuclear.sdk.android.config;

import com.loopj.android.http.RequestParams;

public class TweiboConfig extends FatherOAuthConfig {

	public TweiboConfig(String appKey, String appSecret, String redirectUrl) {
		super(appKey, appSecret, redirectUrl);
	}

	@Override
	public String getRefreshTokenUrl() {
		return "https://open.t.qq.com/cgi-bin/oauth2/access_token";
		// return "https://api.weibo.com/oauth2/access_token";
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
		return "https://open.t.qq.com/cgi-bin/oauth2/authorize?client_id="
				+ appKey + "&response_type=code&redirect_uri="
				+ encodedRedirectUrl();
	}

	@Override
	public String getAccessCodeUrl(String code) {
		return "https://open.t.qq.com/cgi-bin/oauth2/access_token?client_id="
				+ appKey + "&client_secret=" + appSecret + "&redirect_uri="
				+ encodedRedirectUrl() + "&grant_type=authorization_code&code="
				+ code;
	}

	@Override
	public RequestParams getAccessTokenParams(String code) {
		return null;
	}

}
