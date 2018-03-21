package com.youai.sdk.android.config;

import com.loopj.android.http.RequestParams;

public class SinaConfig extends FatherOAuthConfig {

	public SinaConfig(String appKey, String appSecret, String redirectUrl) {
		super(appKey, appSecret, redirectUrl);
	}

	@Override
	public String getRefreshTokenUrl() {
		return "https://api.weibo.com/oauth2/access_token";
	}

	@Override
	public RequestParams getRefreshTokenParams(String refreshToken) {
		RequestParams params = new RequestParams();
		params.put("client_id", appKey);
		params.put("client_secret", appSecret);
		params.put("grant_type", "refresh_token");
		params.put("refresh_token", refreshToken);

		return params;
	}

	@Override
	public String getCodeUrl() {
		return "https://api.weibo.com/oauth2/authorize?client_id=" + appKey
				+ "&response_type=code&display=mobile&redirect_uri="+redirectUrl;
				//+ encodedRedirectUrl();
	}

	@Override
	public String getAccessCodeUrl(String code) {
		return "https://api.weibo.com/oauth2/access_token?client_id=" + appKey
				+ "&client_secret=" + appSecret
				+ "&grant_type=authorization_code&redirect_uri="+ redirectUrl + "&code=" + code;
			//	+ encodedRedirectUrl() + "&code=" + code;
	 

	}

	@Override
	public RequestParams getAccessTokenParams(String code) {
		RequestParams params = new RequestParams();
		
		return params;
	}

}
