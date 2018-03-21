package com.nuclear.sdk.android.token;

import org.json.JSONObject;

public class DoubanToken extends Token {

	public DoubanToken(JSONObject json) {
		setAccessToken(json.optString("access_token"));
		setExpiresIn(json.optLong("expires_in"));
		setRefreshToken(json.optString("refresh_token"));
		setUid(json.optString("douban_user_id"));
		setUsername(json.optString("douban_user_name"));
	}
}
