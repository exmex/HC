package com.nuclear.sdk.android.token;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class QQToken extends Token {

	public QQToken(String response) {
		// access_token=FDEC0457B146137F5712F98420176C58&expires_in=7776000
		//Pattern pattern = Pattern.compile("access_token=(.+)&expires_in=(.+)&refresh_token=(.+)");
		//Matcher m = pattern.matcher(response);
		String args[] = response.split("&");
		if(args!=null&&args.length==3){
			setAccessToken(args[0].substring(13));
			setExpiresIn(Long.valueOf(args[1].substring(11)));
		}
		
		/*if (m.matches() && m.groupCount() == 2) {
			setAccessToken(m.group(0));
			setExpiresIn(Long.valueOf(m.group(1)));
		}*/
	}
}
