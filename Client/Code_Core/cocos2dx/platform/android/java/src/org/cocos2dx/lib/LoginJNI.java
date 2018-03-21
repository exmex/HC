/**
 * @date   2014-07-29
 * @author Snow
 * @desc   JNI
 */
package org.cocos2dx.lib;

import android.util.Log;

public class LoginJNI {
    /**
     * device login
     * 
     * @param deviceLoginURL
     * @param gameCenterCheckURL
     * @param gameCenterBindURL
     */
    public static void onDologin(final String deviceLoginURL, final String gameCenterCheckURL, final String gameCenterBindURL) {
        LoginDataStorage.deviceLoginURL = deviceLoginURL;
        LoginDataStorage.gameCenterCheckURL = gameCenterCheckURL;
        LoginDataStorage.gameCenterBindURL = gameCenterBindURL;

        Log.i("LoginJNI", "onDologin deviceLoginURL: " + LoginDataStorage.deviceLoginURL);
        Log.i("LoginJNI", "onDologin gameCenterCheckURL: " + LoginDataStorage.gameCenterCheckURL);
        Log.i("LoginJNI", "onDologin gameCenterBindURL: " + LoginDataStorage.gameCenterBindURL);

        // -- use device id to login
        Cocos2dxHelper.runOnUIThread(new Runnable() {
            @Override
            public void run() {
                LoginTask postTask = new LoginTask();
                postTask.execute(LoginTask.asyncTypeDeviceLogin);
            }
        });
    }

    /**
     * when enter game call this to initialize google play service
     * 
     * @param deviceLoginURL
     * @param gameCenterCheckURL
     * @param gameCenterBindURL
     */
    public static void onDoInitGooglePlay(final String deviceLoginURL, final String gameCenterCheckURL, final String gameCenterBindURL) {
        LoginDataStorage.deviceLoginURL = deviceLoginURL;
        LoginDataStorage.gameCenterCheckURL = gameCenterCheckURL;
        LoginDataStorage.gameCenterBindURL = gameCenterBindURL;

        // -- use device id to login
        Cocos2dxHelper.runOnUIThread(new Runnable() {
            @Override
            public void run() {
                LoginTask postTask = new LoginTask();
                postTask.execute(LoginTask.asyncTypeGooglePlayInit);
            }
        });
    }

    /**
     * called when google connect button clicked
     * 
     * @param deviceLoginURL
     * @param gameCenterCheckURL
     * @param gameCenterBindURL
     */
    public static void onDoGooglePlayLogin(final String deviceLoginURL, final String gameCenterCheckURL, final String gameCenterBindURL) {
        LoginDataStorage.deviceLoginURL = deviceLoginURL;
        LoginDataStorage.gameCenterCheckURL = gameCenterCheckURL;
        LoginDataStorage.gameCenterBindURL = gameCenterBindURL;

        Cocos2dxHelper.runOnUIThread(new Runnable() {
            @Override
            public void run() {
                LoginTask postTask = new LoginTask();
                postTask.execute(LoginTask.asyncTypeGooglePlayLogin);
            }
        });
    }

    public static native void deviceLoginSuccess(String status, String session, String uin, String userId, String serverId, String serverIP, String serverPort);

    /**
     * 登陆成功后通知cpp
     * 中间函数， 避免出现E/libEGL(1851): call to OpenGL ES API with no current context
     * (logged once per thread)问题，
     * 
     * @param session
     * @param uin
     * @param userId
     * @param serverId
     * @param serverIP
     * @param serverPort
     */
    public static void runDeviceLoginSuccess(final String status, final String session, final String uin, final String userId, final String serverId, final String serverIP, final String serverPort) {
        Cocos2dxGLSurfaceView.getInstance().queueEvent(new Runnable() {
            @Override
            public void run() {
                Log.i("runDeviceLoginSuccess", "Java Login Response: error->" + status + ", session: " + session);
                LoginJNI.deviceLoginSuccess(status, session, uin, userId, serverId, serverIP, serverPort);
            }
        });
    }

    public static native void googlePlayLoginSuccess(String isAccountLinked);

    public static void runGooglePlayLoginSuccess(final String isAccountLinked) {
        Cocos2dxGLSurfaceView.getInstance().queueEvent(new Runnable() {
            @Override
            public void run() {
                Log.i("runGooglePlayLoginSuccess", "Java Login Response: isAccountLinked->" + isAccountLinked);
                LoginJNI.googlePlayLoginSuccess(isAccountLinked);
            }
        });
    }

    public static void runRestartGame() {
        Log.i("LoginJNI", "runRestartGame");
        Cocos2dxGLSurfaceView.getInstance().queueEvent(new Runnable() {
            @Override
            public void run() {

                LoginJNI.restartGame();
            }
        });
    }

    private static native void restartGame();
}
