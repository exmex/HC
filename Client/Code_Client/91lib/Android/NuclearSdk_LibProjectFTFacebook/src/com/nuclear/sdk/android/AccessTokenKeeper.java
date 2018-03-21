package com.nuclear.sdk.android;


import com.nuclear.sdk.android.token.Token;
import com.nuclear.sdk.android.utils.DesEncrypt;
import com.nuclear.sdk.android.utils.Utils;

import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.text.TextUtils;

class AccessTokenKeeper {

	private static String OAUTH_PREFS = "oauth";
	private String OAUTH_UID = "uid";
	private String OAUTH_TOKEN = "access_token";
	private String OAUTH_REFRESH_TOKEN = "refresh_token";
	private String OAUTH_EXPIRES_TIME = "expires_time";
	private String OAUTH_NAME = "nickname";
	public AccessTokenKeeper(String name) {
		OAUTH_UID += ("-" + name);
		OAUTH_TOKEN += ("-" + name);
		OAUTH_REFRESH_TOKEN += ("-" + name);
		OAUTH_EXPIRES_TIME += ("-" + name);
	}

	public void keepAccessToken(Context context, Token token) {
		SharedPreferences pref = context.getSharedPreferences(OAUTH_PREFS,
				Context.MODE_PRIVATE);
		Editor editor = pref.edit();

		String imei = Utils.getDeviceId(context);
		DesEncrypt des = new DesEncrypt(imei);

		editor.putString(OAUTH_TOKEN, des.getEncString(token.getAccessToken()));
		editor.putLong(OAUTH_EXPIRES_TIME, token.getExpiresTime());
		editor.putString(OAUTH_REFRESH_TOKEN,
				des.getEncString(token.getRefreshToken()));
		editor.putString(OAUTH_UID, des.getEncString(token.getUid()));
		editor.putString(OAUTH_NAME, des.getEncString(token.getUsername()));
		editor.commit();
	}

	public void clear(Context context) {
		SharedPreferences pref = context.getSharedPreferences(OAUTH_PREFS,
				Context.MODE_PRIVATE);
		Editor editor = pref.edit();
		editor.clear();
		editor.commit();
	}
	
	public void clearAccessToken(Context context) {
		SharedPreferences pref = context.getSharedPreferences(OAUTH_PREFS,
				Context.MODE_PRIVATE);
		Editor editor = pref.edit();
		editor.putString(OAUTH_TOKEN, "");
		editor.putLong(OAUTH_EXPIRES_TIME, 0l);
		editor.putString(OAUTH_REFRESH_TOKEN, "");
		editor.putString(OAUTH_UID, "");
		editor.putString(OAUTH_NAME, "");
		editor.commit();
	}

	public Token readAccessToken(Context context) {
		Token token = new Token();
		DesEncrypt des = new DesEncrypt(Utils.getDeviceId(context));
		SharedPreferences pref = context.getSharedPreferences(OAUTH_PREFS,
				Context.MODE_PRIVATE);

		String _oauth_token = pref.getString(OAUTH_TOKEN, "");
		long _oauth_expires = pref.getLong(OAUTH_EXPIRES_TIME, 0l);
		String _oauth_refresh_token = pref.getString(OAUTH_REFRESH_TOKEN, "");
		String _oauth_uid = pref.getString(OAUTH_UID, "");
		String _oauth_name = pref.getString(OAUTH_NAME, "");
		if(_oauth_token==null||_oauth_refresh_token==null||_oauth_refresh_token==null||_oauth_uid==null
				||_oauth_name==null||_oauth_token.equals("")||_oauth_refresh_token.equals("")
				||_oauth_refresh_token.equals("")||_oauth_uid.equals("")||_oauth_name.equals("")||_oauth_expires==0l){
			return null;
		}else{
		
		token.setAccessToken(des.getDesString(_oauth_token));
		token.setExpiresTime(_oauth_expires);
		token.setRefreshToken(des.getDesString(_oauth_refresh_token));
		token.setUid(des.getDesString(_oauth_uid));
		token.setUsername(des.getDesString(_oauth_name));
		}
		
		if (TextUtils.isEmpty(token.getAccessToken())) {
			return null;
		}

		return token;
	}

	public String getUid(Context context) {
		String phone_imei = Utils.getDeviceId(context);
		DesEncrypt des = new DesEncrypt(phone_imei);
		SharedPreferences prefs = context.getSharedPreferences(OAUTH_PREFS,
				Context.MODE_PRIVATE);
		String uid = des.getDesString(prefs.getString(OAUTH_UID, ""));
		return uid;
	}
}
