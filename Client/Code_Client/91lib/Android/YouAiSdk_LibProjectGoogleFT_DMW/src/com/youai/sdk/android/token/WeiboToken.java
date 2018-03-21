package com.youai.sdk.android.token;

import org.json.JSONObject;

public class WeiboToken extends Token {

	public WeiboToken(JSONObject json) {
		setAccessToken(json.optString("access_token"));
		setExpiresIn(json.optLong("expires_in"));
		setRefreshToken(json.optString("refresh_token"));
		setUid(json.optString("uid"));
	}
}
