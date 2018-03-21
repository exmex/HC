package com.youai.sdk.android.token;

import org.json.JSONObject;

public class FaceBookToken extends Token {

	public FaceBookToken(JSONObject json) {
		/*
		 * {"expires_in":2592328,"refresh_token":
		 * "228341|0.3Br49tM7zJbPIjpRaCbM2Y8C7Z2GZVt5.340271078.1362214471814"
		 * ,"user" :{"id":id,"name":"name","avatar":[]},"access_token":
		 * "228341|6.6dc10bdb153d32c09d61a01409ba1af3.2592000.1364806800-340271078"
		 * }
		 */
		setUid(json.optString("id"));
		setUsername(json.optString("username"));
		 
	}
}
