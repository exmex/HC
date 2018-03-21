package com.tencent.sdk.youai;

import org.json.JSONException;
import org.json.JSONObject;

import android.text.TextUtils;

/**
 */
public class Oauth2AccessToken {
	private String mAccessToken = "";
	private String mRefreshToken = "";
	private long mExpiresTime = 0;

//	private String mOauth_verifier = "";
//	protected String[] responseStr = null;
//	protected SecretKeySpec mSecretKeySpec;
	/**
	 */
	public Oauth2AccessToken() {
	}
	/**

	 */
	public Oauth2AccessToken(String responsetext) {
		if (responsetext != null) {
			if (responsetext.indexOf("{") >= 0) {
				try {
					JSONObject json = new JSONObject(responsetext);
					setToken(json.optString("access_token"));
					setExpiresIn(json.optString("expires_in"));
					setRefreshToken(json.optString("refresh_token"));
				} catch (JSONException e) {
					
				}
			}
		}
	}
	/**
	 */
	public Oauth2AccessToken(String accessToken, String expires_in) {
		mAccessToken = accessToken;
		mExpiresTime = System.currentTimeMillis() + Long.parseLong(expires_in)*1000;
	}
	/**

	 */
	public boolean isSessionValid() {
		return (!TextUtils.isEmpty(mAccessToken) && (mExpiresTime == 0 || (System
				.currentTimeMillis() < mExpiresTime)));
	}
	/**
	 * ��ȡaccessToken
	 */
	public String getToken() {
		return this.mAccessToken;
	}
	/**
     * ��ȡrefreshToken
     */
	public String getRefreshToken() {
		return mRefreshToken;
	}
	/**
	 * ����refreshToken
	 * @param mRefreshToken
	 */
	public void setRefreshToken(String mRefreshToken) {
		this.mRefreshToken = mRefreshToken;
	}
	/**

	 */
	public long getExpiresTime() {
		return mExpiresTime;
	}

	/**

	 *            
	 */
	public void setExpiresIn(String expiresIn) {
		if (expiresIn != null && !expiresIn.equals("0")) {
			setExpiresTime(System.currentTimeMillis() + Long.parseLong(expiresIn) * 1000);
		}
	}

	/**
	 *            
	 */
	public void setExpiresTime(long mExpiresTime) {
		this.mExpiresTime = mExpiresTime;
	}
	/**
	 * ����accessToken
	 * @param mToken
	 */
	public void setToken(String mToken) {
		this.mAccessToken = mToken;
	}
//	/**
//	 * ���ü�����
//	 * @param verifier
//	 */
//	public void setVerifier(String verifier) {
//		mOauth_verifier = verifier;
//	}
//	/**
//	 * ��ȡ������
//	 * @return
//	 */
//	public String getVerifier() {
//		return mOauth_verifier;
//	}
//	
//	public String getParameter(String parameter) {
//		String value = null;
//		for (String str : responseStr) {
//			if (str.startsWith(parameter + '=')) {
//				value = str.split("=")[1].trim();
//				break;
//			}
//		}
//		return value;
//	}

//	protected void setSecretKeySpec(SecretKeySpec secretKeySpec) {
//		this.mSecretKeySpec = secretKeySpec;
//	}
//
//	protected SecretKeySpec getSecretKeySpec() {
//		return mSecretKeySpec;
//	}
}