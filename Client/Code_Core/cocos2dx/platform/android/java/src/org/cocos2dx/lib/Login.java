/**
 * @date   2014-07-29
 * @author Snow
 * @desc   Android Login Class
 */
package org.cocos2dx.lib;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.Locale;
import java.util.TimeZone;
import java.util.UUID;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.DialogInterface;
import android.os.Build;
import android.os.Build.VERSION;
import android.util.Log;

public class Login {
    private static Login login;

    public String loginResponse = "";

    public static Login getInstance() {
        if (null == login) {
            login = new Login();
        }
        return login;
    }

    /**
     * 登陆，先判断有没有google play登陆，
     * 
     * Google Play是否已经登陆 / \ / \ 未登陆 已经登陆了 | / \ Android ID 登陆 已绑定 未绑定 / \
     * Google Play ID登陆 绑定， 然后使用Google Play ID登陆
     * 
     * @param url
     * @return
     */
    public String doLogin() {
        Log.i("Login", "call doLogin ");
        String androId = "Android-" + Cocos2dxHelper.getAndroId();
        String uuid = UUID.nameUUIDFromBytes(androId.getBytes()).toString();

        System.out.println("Andro id : " + androId);
        System.out.println("Generate uuid: " + uuid);

        LoginDataStorage.uuid = uuid;
        LoginDataStorage.needRestartGame = false;
        
        this.postWebLogin();
        return "";
    }

    /**
     * Google play login success, initialize or click connect
     */
    public void googlePlayLoginSuccess() {
        this.postCheckGooglePlay();
    }
    
    
    public String getClientInfoUrl()
    {

    	String ret="";
		try {
			ret = "&Language=" +   URLEncoder.encode(Locale.getDefault().getLanguage() , "utf-8");
			ret += "&Model=" +  URLEncoder.encode(Build.MANUFACTURER  +","+ Build.BRAND  +","+  Build.PRODUCT  +","+ Build.MODEL, "utf-8") ;
			ret +="&OSVer=" +  URLEncoder.encode(Build.VERSION.CODENAME +"," + Build.VERSION.RELEASE + ","+Build.VERSION.SDK_INT,"utf-8");
			return ret;
		} catch (UnsupportedEncodingException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return ret;	
    }
    /**
     * Device Login
     * 
     * @param url
     * @param uuid
     * @return
     */
    public String postWebLogin() {
        Log.i("Login", "call postWebLogin ");
        String url = LoginDataStorage.deviceLoginURL + getClientInfoUrl();
        String devideId = LoginDataStorage.getDeviceId();
        String timezone = TimeZone.getDefault().getID();

        LoginDataStorage.loginError = "";
        LoginDataStorage.loginState = 0;

        JSONObject sendData = new JSONObject();
        try {
            sendData.put("uuid", LoginDataStorage.uuid);
            sendData.put("deviceID", devideId);
            sendData.put("timeZone", timezone);
        } catch (JSONException e) {

        }

        Log.i("Login", "postWebLogin url: " + url);
        Log.i("Login", "postWebLogin =====sendData: " + sendData.toString());

        if (url.equals("")) {
            Log.i("Login", "postCheckGooglePlay url is empty, return ");
            LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_URL_EMPTY;
            LoginDataStorage.loginError = "URL Empty";
            return "";
        }

        // -- send request
        String result = URLConnectionHelper.sendPostHttpRequest(url, sendData.toString());

        Log.i("Login", "postWebLogin =====Response: " + result.toString());

        JSONObject receiveData = null;
        try {
            if (result == "URLConnectionException") {
                LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_HTTP_ERROR;
                LoginDataStorage.loginError = "Http Error";
            } else {
                receiveData = new JSONObject(result);
                String error = receiveData.optString("error").toString();

                if (error.equals("")) {
                    LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_SUCCESS;
                    LoginDataStorage.loginError = "";
                    LoginDataStorage.uin = receiveData.getString("uin");
                    LoginDataStorage.sessionKey = receiveData.getString("sessionKey");
                    LoginDataStorage.userId = receiveData.getString("userId");
                    LoginDataStorage.serverId = receiveData.getString("serverId");
                    LoginDataStorage.deviceID = receiveData.getString("deviceID");
                    LoginDataStorage.serverIP = receiveData.getString("serverIP");
                    LoginDataStorage.serverPort = receiveData.getString("serverPort");

                    if (LoginDataStorage.uin == null || LoginDataStorage.sessionKey == null || LoginDataStorage.userId == null || LoginDataStorage.serverId == null) {

                    }

                    LoginDataStorage.setDevideId(Cocos2dxActivity.getContext(),LoginDataStorage.deviceID);

                    this.loginResponse = receiveData.toString();

                } else if ("no_deviceID" == error) {
                    // -- no device id
                    LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_ERROR;
                    LoginDataStorage.loginError = error;
                    Log.e("Login", "postWebLogin response error: no_deviceID");

                } else {
                    LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_ERROR;
                    LoginDataStorage.loginError = error;
                    Log.e("Login", "postWebLogin response error: uncaught " + error);
                }
            }
        } catch (Exception e) {
            LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_EXCEPTION;
            LoginDataStorage.loginError = "Http Error";
        }
        return "";
    }

    public void postCheckGooglePlay() {
        Log.i("Login", "call postCheckGooglePlay ");
        String url = LoginDataStorage.gameCenterCheckURL;
        LoginDataStorage.loginState = 0;
        LoginDataStorage.loginError = "";
        LoginDataStorage.isAccountLinked = false;

        JSONObject sendData = new JSONObject();
        try {
            sendData.put("uuid", LoginDataStorage.uuid);
            sendData.put("deviceID", LoginDataStorage.getDeviceId());
            sendData.put("timeZone", TimeZone.getDefault().getID());
            sendData.put("playerID", LoginDataStorage.googlePlayID);
        } catch (JSONException e) {

        }

        Log.i("Login", "postCheckGooglePlay url: " + url);
        Log.i("Login", "postCheckGooglePlay =====sendData: " + sendData.toString());

        if (url.equals("")) {
            Log.i("Login", "postCheckGooglePlay url is empty, return ");
            LoginDataStorage.loginState = -3;
            LoginDataStorage.loginError = "URL Empty";
            return;
        }

        // -- send request
        URLConnectionHelper.asnycPostHttpRequest(url, sendData.toString(), new URLConnectionHelper.URLConnectionAsynCallBack() {
			@Override
			public void onRequestResult(String result) {
				// TODO Auto-generated method stub
				Log.i("Login", "postCheckGooglePlay =====Response: " + result.toString());

		        JSONObject receiveData = null;
		        try {
		            if (result == "URLConnectionException") {
		                LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_HTTP_ERROR;
		                LoginDataStorage.loginError = "Http Error";
		            } else {
		                receiveData = new JSONObject(result);
		                int state = receiveData.optInt("state");
		                LoginDataStorage.loginState = state;

		                if (state == 0) {
		                    loginResponse = receiveData.toString();
		                    LoginDataStorage.isAccountLinked = true;
		                    LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_SUCCESS;
		                } else {
		                    LoginDataStorage.linkedAccountName = receiveData.optString("linkedAccountName");
		                    LoginDataStorage.linkedAccountLevel = receiveData.optString("linkedAccountLevel");
		                    LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_NEED_USER_CONFIRM;

//		                    if (!Cocos2dxHelper.gameHelper().isAutoConnect) {
		                        // -- 提示绑定窗口
		                        Cocos2dxHelper.showConfirmDialog("Bind", "Do you want to load " + LoginDataStorage.linkedAccountName + " with level " + LoginDataStorage.linkedAccountLevel
		                                + "? Warning: progress in the current game will be lost.", "OK", new DialogInterface.OnClickListener() {

		                            @Override
		                            public void onClick(DialogInterface dialog, int which) {
		                                // TODO Auto-generated method
		                                // stub
		                                Log.w("Login", "User select google play account, so reload game.");
		                                Login.this.postBindGooglePlay();

		                            }
		                        });
//		                    }

		                    Log.e("Login", "postCheckGooglePlay response error,  state: " + LoginDataStorage.loginState);
		                }
		            }
		        } catch (Exception e) {
		            LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_EXCEPTION;
		            LoginDataStorage.loginError = "Http Error";
		        }

		        // -- 不需要用户选择账号， 直接绑定的
		        if (LoginDataStorage.loginState != LoginDataStorage.LOGIN_STATE_NEED_USER_CONFIRM) {
		            Log.i("Login", "postCheckGooglePlay: call cpp runGooglePlayLoginSuccess, isAccountLinked is " + String.valueOf(LoginDataStorage.isAccountLinked));
		            LoginJNI.runGooglePlayLoginSuccess(String.valueOf(LoginDataStorage.isAccountLinked));
		        }
			}
		} );
    }

    public void postBindGooglePlay() {
        Log.i("Login", "call postBindGooglePlay ");
        String url = LoginDataStorage.gameCenterBindURL;

        JSONObject sendData = new JSONObject();
        try {
            sendData.put("uuid", LoginDataStorage.uuid);
            sendData.put("deviceID", LoginDataStorage.getDeviceId());
            sendData.put("timeZone", TimeZone.getDefault().getID());
            sendData.put("playerID", LoginDataStorage.googlePlayID);
        } catch (JSONException e) {

        }

        Log.i("Login", "postBindGooglePlay url: " + url);
        Log.i("Login", "postBindGooglePlay =====sendData: " + sendData.toString());

        // -- send request
        URLConnectionHelper.asnycPostHttpRequest(url, sendData.toString(), new URLConnectionHelper.URLConnectionAsynCallBack() {
			@Override
			public void onRequestResult(String result) {
				Log.i("Login", "postBindGooglePlay =====Response: " + result.toString());

		        LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_GOOGLE_PLAY_BIND_FAILED;
		        try {
		            if (result == "URLConnectionException") {
		                LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_HTTP_ERROR;
		                LoginDataStorage.loginError = "Http Error";
		            } else {
		                JSONObject receiveData = null;
		                receiveData = new JSONObject(result);
		                int state = receiveData.optInt("state");
		                String error = receiveData.optString("error");

		                if (state == 0 && error.equals("")) {
		                    LoginDataStorage.loginState = LoginDataStorage.LOGIN_STATE_GOOGLE_PLAY_BIND_SUCCESS;
		                }
		            }
		        } catch (Exception e) {

		        }

		        LoginDataStorage.needRestartGame = true;
		        LoginDataStorage.isAccountLinked = true;

		        // -- gamehelper 断开连接
		        Cocos2dxHelper.gameHelper().onStop();
		        
		        // -- 重启游戏后， 会再次发送登陆请求， 就不会走这里， 所以不需要处理connect按钮状态等了
		        LoginJNI.runRestartGame();
			}
        });
        
        
//        String result = URLConnectionHelper.sendPostHttpRequest(url, sendData.toString());
        
    }
}
