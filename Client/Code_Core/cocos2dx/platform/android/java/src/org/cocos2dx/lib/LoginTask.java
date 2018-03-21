/**
 * @date   2014-07-29
 * @author Snow
 * @desc   网站请求
 */
package org.cocos2dx.lib;

import android.os.AsyncTask;
import android.util.Log;

/**
 * 
 * @author Snow
 * @desc AsyncTask<>的参数类型由用户设定，这里设为三个String<br />
 *       第一个String代表输入到任务的参数类型，也即是doInBackground()的参数类型<br />
 *       第二个String代表处理过程中的参数类型，也就是doInBackground()执行过程中的产出参数类型，通过publishProgress
 *       ()发消息<br />
 *       传递给onProgressUpdate()一般用来更新界面<br />
 *       第三个String代表任务结束的产出类型，也就是doInBackground()的返回值类型，和onPostExecute()的参数类型<br />
 */
public class LoginTask extends AsyncTask<String, String, String> {
    private Login login;
    private String asyncType = "";
    public final static String asyncTypeDeviceLogin = "asyncTypeDeviceLogin";
    public final static String asyncTypeGooglePlayInit = "asyncTypeGooglePlayInit";
    public final static String asyncTypeGooglePlayLogin = "asyncTypeGooglePlayLogin";

    private boolean isDoDisconnect = false;
    /**
     * 后台任务开始执行之前调用，用于进行一些界面上的初始化操作，比如显示一个进度条对话框等。
     */
    @Override
    protected void onPreExecute() {
        login = new Login();
    }

    /**
     * 这个方法中的所有代码都会在子线程中运行，我们应该在这里去处理所有的耗时任务。
     * 任务一旦完成就可以通过return语句来将任务的执行结果进行返回，如果AsyncTask的第三个泛型参数指定的是Void
     * ，就可以不返回任务执行结果。
     * 注意，在这个方法中是不可以进行UI操作的，如果需要更新UI元素，比如说反馈当前任务的执行进度，可以调用publishProgress
     * (Progress...)方法来完成。
     */
    @Override
    protected String doInBackground(String... params) {
        asyncType = params[0].toString();
        String loginStatus = "";
        Log.e("LoginTask", "doInBackground async type: " + asyncType);

        if (asyncType == LoginTask.asyncTypeGooglePlayInit) {
            Cocos2dxHelper.gameHelper().onStart(Cocos2dxHelper.activity());
        } else if (asyncType == LoginTask.asyncTypeGooglePlayLogin) {
            if (LoginDataStorage.isAccountLinked) {
                // -- 已经关联了，取消登陆
                Cocos2dxHelper.gameHelper().signOut();
                LoginDataStorage.isAccountLinked = false;
                isDoDisconnect = true;
            } else {
                // -- google play登陆
                Cocos2dxHelper.gameHelper().beginUserInitiatedSignIn();
            }
        } else {
            loginStatus = login.doLogin();
        }

        return loginStatus;
    }

    /**
     * 当在后台任务中调用了publishProgress(Progress...)方法后，这个方法就很快会被调用，
     * 方法中携带的参数就是在后台任务中传递过来的。 在这个方法中可以对UI进行操作，利用参数中的数值就可以对界面元素进行相应的更新。
     */
    @Override
    protected void onProgressUpdate(String... progress) {

    }

    /**
     * 当后台任务执行完毕并通过return语句进行返回时，这个方法就很快会被调用。返回的数据会作为参数传递到此方法中，
     * 可以利用返回的数据来进行一些UI操作，比如说提醒任务执行的结果，以及关闭掉进度条对话框等。
     */
    @Override
    protected void onPostExecute(String result) {
        if (LoginDataStorage.loginState == LoginDataStorage.LOGIN_STATE_URL_EMPTY || LoginDataStorage.loginState == LoginDataStorage.LOGIN_STATE_NEED_USER_CONFIRM
                || LoginDataStorage.loginState == LoginDataStorage.LOGIN_STATE_INIT) {
            Log.i("LoginTask", "onPostExecute: do nothing, loginState: " + LoginDataStorage.loginState + ", asyncType:" + asyncType);
            return;
        }

        // -- device 登陆成功后通知cpp
        if (asyncType == LoginTask.asyncTypeDeviceLogin) {
            LoginJNI.runDeviceLoginSuccess("" + LoginDataStorage.loginState, LoginDataStorage.sessionKey, LoginDataStorage.uin, LoginDataStorage.userId, LoginDataStorage.serverId,
                    LoginDataStorage.serverIP, LoginDataStorage.serverPort);

            Log.i("LoginTask", "onPostExecute: call cpp runDeviceLoginSuccess, LoginDataStorage.loginState is: " + LoginDataStorage.loginState + ", LoginDataStorage.loginError is: "
                    + LoginDataStorage.loginError + ", LoginDataStorage.uin is: " + LoginDataStorage.uin);
        } else {
            if (isDoDisconnect) {
                Log.i("LoginTask", "onPostExecute: call cpp runGooglePlayLoginSuccess, isAccountLinked is " + String.valueOf(LoginDataStorage.isAccountLinked));
                LoginJNI.runGooglePlayLoginSuccess(String.valueOf(LoginDataStorage.isAccountLinked));
            } else {
                // -- 不做事， 由google play登陆线程处理
                Log.i("LoginTask", "onPostExecute: do nothing, wait for google play thread ");
            }
        }
    }

    @Override
    protected void onCancelled() {

    }
}
