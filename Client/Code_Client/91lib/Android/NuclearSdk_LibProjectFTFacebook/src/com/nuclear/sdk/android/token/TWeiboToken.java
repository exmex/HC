package com.nuclear.sdk.android.token;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class TWeiboToken extends Token {

	public TWeiboToken(String response) {
		Pattern pattern = Pattern
				.compile("access_token=(.*)&expires_in=(.*)&refresh_token=(.*)&openid=(.*)&name.*");
		Matcher m = pattern.matcher(response);
		if (m.matches() && m.groupCount() == 4) {
			setAccessToken(m.group(1));
			setExpiresIn(Long.valueOf(m.group(2)));
			setRefreshToken(m.group(3));
			setUid(m.group(4));
		}
	}
}
