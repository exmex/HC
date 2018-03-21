package com.example.gtvsdk;


import java.util.HashMap;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.telephony.TelephonyManager;
import android.util.Log;

public class GTVSDK implements GTVAuthorizeViewInterface, GTVRequestInterface {

	private static final long serialVersionUID = 1L;
	private Context context;
	public static String userID;// 用户ID
	private String coID;// 合作厂商ID
	private String appKey;// 应用ID
	private String appSecret;// 应用密码
	private String deviceID;// 设备唯一ID，这个ID是首次运行程序时生成的
	private String serverID; // 充值服务器ID
	private GTVDBHelper DBHelper;
	private GTVSDKInterface delegate;// 接口
	private GTVRequest LoginRequest;
	private GTVRequest RegisterRequest;
	private GTVRequest RechargeRequest;
	private String otherInfo;
	GTVAuthorizeView authView;

	Intent intent;

	public GTVSDK(Context context, String _coID, String _appKey,
			String _appSecret, String _serverID, GTVSDKInterface _delegate) {
		this.coID = _coID;
		this.appKey = _appKey;
		this.appSecret = _appSecret;
		this.serverID = _serverID;
		this.context = context;
		this.delegate = _delegate;
		// 得到设备号
		TelephonyManager tm = (TelephonyManager) context
				.getSystemService(Context.TELEPHONY_SERVICE);
		this.deviceID = tm.getDeviceId();
	}

	// 用户登陆
	public void logIn() {
		Log.e("---------->","Show Login Page!");
		if (isLoggedIn()) {
			delegate.GTVDidLogIn(this);
		} else {
			removeAuthData();
			HashMap<String, Object> params = new HashMap<String, Object>();
			params.put("aid", this.appKey);
			params.put("device", "Android");
			params.put("dsn", deviceID);
			GTVSDKBean bean = new GTVSDKBean(
					GTVSDKConstants.kGTVWebAuthLoginURL, params, this);
			context.startActivity(new Intent(context, GTVAuthorizeView.class)
					.putExtra("bean", bean));
		}
	}

	// 检验是否登陆成功
	public boolean isLoggedIn() {

		if (userID == null) {
			return false;
		} else {
			return true;
		}
	}

	// 移除登陆信息
	public void removeAuthData() {
		userID = null;
	}

	// 请求充值页面(需要登陆)
	public boolean rechargeAccount(String money, String other) {// money,other
		if (isLoggedIn()) {
			String _deviceStr = "Android";
			String _timeStr = System.currentTimeMillis() / 1000 + "";
			otherInfo = other;
			// Md5(sid|aid|deivce|dsn|uid|id_server|time|money|other|key)
			String _sign = getMD5StringByString(coID + "|" + appKey + "|"
					+ _deviceStr + "|" + deviceID + "|" + userID + "|"
					+ serverID + "|" + _timeStr + "|" + money + "|" + other
					+ "|" + appSecret);
			System.out.println(coID + "|" + appKey + "|"
					+ _deviceStr + "|" + deviceID + "|" + userID + "|"
					+ serverID + "|" + _timeStr + "|" + money + "|" + other
					+ "|" + appSecret);
			System.out.println(_sign);

			HashMap<String, Object> params = new HashMap<String, Object>();
			params.put("aid", appKey);
			params.put("device", _deviceStr);
			params.put("dsn", deviceID);
			params.put("uid", userID);
			params.put("server", serverID);
			params.put("time", _timeStr);
			params.put("sign", _sign);
			params.put("money", money);
			params.put("other", other);
			GTVSDKBean bean = new GTVSDKBean(
					GTVSDKConstants.kGTVWebRechargeURL, params, this);
			context.startActivity(new Intent(context, GTVAuthorizeView.class)
					.putExtra("bean", bean));
			return true;
		}

		return false;
	}

	// 获取MD5字符串
	public String getMD5StringByString(String origin) {
		return MD5ToText.MD5Encode(origin);
	}

	public void requestDidFinish(GTVRequest _request) {
		_request.mGTVSDK = null;
		authView.finish();
	}

	public void webViewDidCancel() {

	}

	public void logInDidFinishWithAuthInfo(HashMap<String, Object> mMap) {
		String accessSign = mMap.get("result").toString();
	//	Log.e("----->", mMap.toString());
		if (!accessSign.equals("T")) {
			delegate.GTVSDKrequestDidFailWithError(this, "登陆失败");
		} else {
			String uid = mMap.get("uid").toString();
			if (uid == null) {
				delegate.GTVSDKrequestDidFailWithError(this, "用户ID为空");
			} else {
				Log.e("----->", "登陆成功");
				userID = uid;
				authView.finish();
				delegate.GTVDidLogIn(this);
			}

		}
	}

	public void registerDidFinishWithAuthInfo(HashMap<String, Object> mMap) {

		String accessSign = mMap.get("result").toString();
		if (!accessSign.equals("T")) {
			delegate.GTVSDKrequestDidFailWithError(this, "注册失败");
		}
		String uid = null;
		try {
			uid = mMap.get("uid").toString();
		} catch (Exception e) {
			uid = null;
		}

		if (uid == null) {
			delegate.GTVSDKrequestDidFailWithError(this, "用户ID为空");
		} else {
			Log.e("----->", "注册成功");
			userID = uid;
			authView.finish();
			delegate.GTVDidRegister(this);
		}

	}

	public void RechargeDidFinishWithInfo(HashMap<String, Object> mMap) {
		String accessSign = mMap.get("result").toString();
		//Log.e("----->", mMap.toString());
		if (!accessSign.equals("T")) {
			delegate.GTVSDKrequestDidFailWithError(this, "充值失败");

		} else {
			String uid = mMap.get("uid").toString();
			if (uid == null) {
				delegate.GTVSDKrequestDidFailWithError(this, "用户ID为空");
			} else if (!userID.equals(uid)) {
				delegate.GTVSDKrequestDidFailWithError(this, "用户ID不匹配");
			} else {
				Log.e("----->", "充值成功");
				delegate.GTVDidRecharge(this);
			}
		}
	}

	@Override
	public void authorizeViewdidRecieveAuthorizationID(
			GTVAuthorizeView authView, String IDStr, String timeStr,
			String signStr) {
		this.authView = authView;
		String assembly = coID + "|" + appKey + "|" + IDStr + "|" + timeStr
				+ "|" + signStr + "|" + appSecret;
		String _newSign = getMD5StringByString(assembly);

		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("id", IDStr);
		params.put("time", timeStr);
		params.put("sign", _newSign);

		if (RegisterRequest != null) {
			RegisterRequest.disconnect();
			RechargeRequest = null;
		}

		LoginRequest = new GTVRequest(GTVSDKConstants.kGTVWebAccessTokenURL,
				"POST", params, this, this);

		LoginRequest.connect();
		// 执行Request的代码

	}

	@Override
	public void authorizeViewdidRecieveRegisterID(GTVAuthorizeView authView,
			String IDStr, String timeStr, String signStr) {
		this.authView = authView;
		Log.e("----->", "注册正常");
		String _newSign = getMD5StringByString(coID + "|" + appKey + "|"
				+ IDStr + "|" + timeStr + "|" + signStr + "|" + appSecret);

		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("id", IDStr);
		params.put("time", timeStr);
		params.put("sign", _newSign);

		if (RegisterRequest != null) {
			RegisterRequest.disconnect();
			RechargeRequest = null;
		}
		RegisterRequest = new GTVRequest(
				GTVSDKConstants.kGTVWebAuthRegisterURL, "POST", params, this,
				this);

		RegisterRequest.connect();

	}

	@Override
	public void authorizeViewdidRecieveRechargeSumbitMoneyStr(
			GTVAuthorizeView authView, String moneyStr) {
		this.authView = authView;
		String _deviceStr = "Android";
		String _timeStr = System.currentTimeMillis() / 1000 + "";
		String _sign = getMD5StringByString(coID + "|" + appKey + "|"
				+ _deviceStr + "|" + deviceID + "|" + userID + "|" + serverID
				+ "|" + _timeStr + "|" + moneyStr +"|" + otherInfo+"|"+ appSecret);
		HashMap<String, Object> params = new HashMap<String, Object>();
		params.put("aid", appKey);
		params.put("device", _deviceStr);
		params.put("dsn", deviceID);
		params.put("uid", userID);
		params.put("server", serverID);
		params.put("time", _timeStr);
		params.put("money", moneyStr);
		params.put("other", otherInfo);
		params.put("sign", _sign);
		if (RechargeRequest != null) {
			RechargeRequest.disconnect();
			RechargeRequest = null;
		}
		RechargeRequest = new GTVRequest(
				GTVSDKConstants.kGTVWebRechargeSubmitURL, "POST", params, this,
				this);
		RechargeRequest.connect();

	}

	@Override
	public void authorizeViewdidLoginFail(GTVAuthorizeView authView) {

	}

	@Override
	public void authorizeViewdidFailWithErrorInfo(GTVAuthorizeView authView,
			String errorInfo) {
		if (delegate != null && delegate instanceof GTVSDKInterface) {
			delegate.GTVSDKrequestDidFailWithError(this, errorInfo);

		}
	}

	@Override
	public void authorizeViewDidCancel(GTVAuthorizeView authView) {

	}

	@Override
	public void didFinishLoadingWithResult(HashMap mMap, GTVRequest mGTVRequest) {
		if (mGTVRequest == LoginRequest) {
			logInDidFinishWithAuthInfo(mMap);
			LoginRequest = null;
		}
		if (mGTVRequest == RechargeRequest) {
			RechargeDidFinishWithInfo(mMap);
			RechargeRequest = null;
		}
		if (mGTVRequest == RegisterRequest) {
			registerDidFinishWithAuthInfo(mMap);
			RegisterRequest = null;
		}

	}

	@Override
	public void didFailWithError(String error) {

		if (delegate != null && delegate instanceof GTVSDKInterface) {
			delegate.GTVSDKrequestDidFailWithError(this, error);

		}
	}

}

