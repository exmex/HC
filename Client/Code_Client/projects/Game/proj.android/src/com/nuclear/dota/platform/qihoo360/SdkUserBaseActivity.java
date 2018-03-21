
package com.nuclear.dota.platform.qihoo360;

import com.qihoo.gamecenter.sdk.activity.ContainerActivity;
import com.qihoo.gamecenter.sdk.common.IDispatcherCallback;
import com.nuclear.dota.platform.qihoo360.bean.QihooPayInfo;
import com.nuclear.dota.platform.qihoo360.bean.QihooUserInfo;
import com.nuclear.dota.platform.qihoo360.bean.TokenInfo;
import com.qsds.ggg.dfgdfg.fvfvf.R;
import com.qihoo.gamecenter.sdk.matrix.Matrix;
import com.qihoo.gamecenter.sdk.protocols.ProtocolConfigs;
import com.qihoo.gamecenter.sdk.protocols.ProtocolKeys;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.widget.Toast;

/**
 * SdkUserBaseActivity这个基类，处理请求360SDK的登录和支付接口。
 * 使用方的Activity继承SdkUserBaseActivity，调用doSdkLogin接口发起登录请求；调用doSdkPay接口发起支付请求。
 * 子类实现onGotTokenInfo接口接收授权码，做后续处理。
 */
public abstract class SdkUserBaseActivity extends Activity {

    private static final String TAG = "SdkUserBaseActivity";

    /**
     *
     */
    protected static boolean isAccessTokenValid = true;

    protected static boolean mIsLandscape;
    
	private Activity mContext;
	public void setActivityContext(Activity context)
	{
		mContext = context;
	}

    // ---------------------------------调用360SDK接口------------------------------------
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if (savedInstanceState == null) {
            // 调用其他SDK接口之前必须先调用init
            Matrix.init(mContext);
        }
    }

    /**
     * 使用360SDK的登录接口
     *
     * @param isLandScape 是否横屏显示登录界面
     * @param isBgTransparent 是否以透明背景显示登录界面
     */
    protected void doSdkLogin(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // *** 以下非界面相关参数 ***

        // 必需参数，使用360SDK的登录模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_LOGIN);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.invokeActivity(mContext, intent, new IDispatcherCallback() {
            @Override
            public void onFinished(String data) {
                Log.d(TAG, "mLoginCallback, data is " + data);
                procGotTokenInfoResult(data);
            }
        });
    }


    /**
     * 使用360SDK的切换账号接口
     *
     * @param isLandScape 是否横屏显示登录界面
     * @param isBgTransparent 是否以透明背景显示登录界面
     */
    protected void doSdkSwitchAccount(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // *** 以下非界面相关参数 ***

        // 必需参数，使用360SDK的切换账号模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_SWITCH_ACCOUNT);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.invokeActivity(mContext, intent, new IDispatcherCallback() {

            @Override
            public void onFinished(String data) {
                Log.d(TAG, "mAccountSwitchCallback, data is " + data);
                procGotTokenInfoResult(data);
            }
        });
    }


    /**
     * 使用360SDK的支付接口
     *
     * @param isLandScape 是否横屏显示支付界面
     * @param isFixed 是否定额支付
     */
    protected void doSdkPay(final boolean isLandScape, final boolean isFixed,
            final boolean isBgTransparent) {

        if(!isAccessTokenValid) {
            Toast.makeText(mContext, R.string.access_token_invalid, Toast.LENGTH_SHORT).show();
            return;
        }

        // 支付基础参数
        Intent intent = getPayIntent(isLandScape, isFixed);

        // 必需参数，使用360SDK的支付模块。
        intent.putExtra(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_PAY);

        // 界面相关参数，360SDK登录界面背景是否透明。
        intent.putExtra(ProtocolKeys.IS_LOGIN_BG_TRANSPARENT, isBgTransparent);

        Matrix.invokeActivity(mContext, intent, mPayCallback);
    }

    /**
     * 使用360SDK的退出接口
     *
     * @param isLandScape 是否横屏显示支付界面
     */
    protected void doSdkQuit(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的退出模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_QUIT);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.invokeActivity(mContext, intent, mQuitCallback);
    }

    /**
     * 使用360SDK的论坛接口
     *
     * @param isLandScape 是否横屏显示支付界面
     */
    protected void doSdkBBS(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的论坛模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_BBS);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.invokeActivity(mContext, intent, null);
    }

    /**
     * 使用360SDK客服中心接口
     *
     * @param isLandScape 是否横屏显示界面
     */
    protected void doSdkCustomerService(boolean isLandScape) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，使用360SDK的客服模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_CUSTOMER_SERVICE);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.invokeActivity(mContext, intent, null);
    }

    /**
     * 使用360SDK实名注册接口
     *
     * @param isLandScape 是否横屏显示登录界面
     * @param isBgTransparent 是否以透明背景显示登录界面
     */
    protected void doSdkRealNameRegister(boolean isLandScape, String qihooUserId) {

        Bundle bundle = new Bundle();

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.QIHOO_USER_ID, qihooUserId);

        // 必需参数，使用360SDK的实名注册模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_REAL_NAME_REGISTER);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.invokeActivity(mContext, intent, new IDispatcherCallback() {
            @Override
            public void onFinished(String data) {
                Log.d(TAG, "mRealNameRegisterCallback, data is " + data);
            }
        });
    }


    // -----------------------------------------防沉迷查询接口----------------------------------------

    /**
     * 本方法中的callback实现仅用于测试, 实际使用由游戏开发者自己处理
     *
     * @param qihooUserId
     * @param accessToken
     */
    protected void doSdkAntiAddictionQuery(String accessToken, String qihooUserId) {

        Bundle bundle = new Bundle();

        // 必需参数，用户access token，要使用注意过期和刷新问题，最大64字符。
        bundle.putString(ProtocolKeys.ACCESS_TOKEN, accessToken);

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.QIHOO_USER_ID, qihooUserId);

        // 必需参数，使用360SDK的防沉迷查询模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_ANTI_ADDICTION_QUERY);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.execute(mContext, intent, new IDispatcherCallback() {

            @Override
            public void onFinished(String data) {
                Log.d("demo,anti-addiction query result = ", data);
                if (!TextUtils.isEmpty(data)) {
                    try {
                        JSONObject resultJson = new JSONObject(data);
                        int errorCode = resultJson.optInt("error_code");
                        if (errorCode == 0) {
                            JSONObject contentData = resultJson.getJSONObject("content");
                            // 保存登录成功的用户名及密码
                            JSONArray retData = contentData.getJSONArray("ret");
                            Log.d(TAG, "ret data = " + retData);
                            if(retData != null && retData.length() > 0) {
                                int status = retData.getJSONObject(0).optInt("status");
                                Log.d(TAG, "status = " + status);
                                if (status == 0) {
                                    Toast.makeText(mContext,
                                    		mContext.getString(R.string.anti_addiction_query_result_0),
                                            Toast.LENGTH_LONG).show();
                                } else if (status == 1) {
                                    Toast.makeText(mContext,
                                            mContext.getString(R.string.anti_addiction_query_result_1),
                                            Toast.LENGTH_LONG).show();
                                } else if (status == 2) {
                                    Toast.makeText(mContext,
                                            mContext.getString(R.string.anti_addiction_query_result_2),
                                            Toast.LENGTH_LONG).show();
                                }
                            }
                        } else {
                            Toast.makeText(mContext,
                                    resultJson.optString("error_msg"), Toast.LENGTH_SHORT).show();
                        }

                    } catch (JSONException e) {
                        Toast.makeText(mContext,
                                mContext.getString(R.string.anti_addiction_query_exception),
                                Toast.LENGTH_LONG).show();
                        e.printStackTrace();

                    }
                }
            }
        });
    }


    // -----------------------------------------查询用户信息接口----------------------------------------

    /**
     * 本方法中的callback实现仅用于测试, 实际使用由游戏开发者自己处理
     *
     * @param accessToken
     */
    protected void doSdkQueryUserInfo(String accessToken) {

        if(!isAccessTokenValid) {
            Toast.makeText(mContext, R.string.access_token_invalid, Toast.LENGTH_SHORT).show();
            return;
        }

        Bundle bundle = new Bundle();

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.ACCESS_TOKEN, accessToken);

        // 必需参数，使用360SDK的防沉迷查询模块。
        bundle.putInt(ProtocolKeys.FUNCTION_CODE, ProtocolConfigs.FUNC_CODE_QUERY_USER_INFO);

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        Matrix.execute(mContext, intent, new IDispatcherCallback() {

            @Override
            public void onFinished(String data) {
                try {
                    if(TextUtils.isEmpty(data)) {
                        return;
                    }

                    JSONObject jsonRes = new JSONObject(data);
                    int errorCode = jsonRes.optInt("error_code");
                    switch (errorCode) {
                        case 0:
                            onGotUserInfo(QihooUserInfo.parseJson(data));
                            break;

                        case 4010201:
                            isAccessTokenValid = false;
                            Toast.makeText(mContext, R.string.access_token_invalid, Toast.LENGTH_SHORT).show();
                            break;

                        default:
                            break;
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }

            }
        });
    }



    // -----------------------------------参数Intent-------------------------------------


    /***
     * 生成调用360SDK支付接口基础参数的Intent
     *
     * @param isLandScape
     * @param pay
     * @return Intent
     */
    protected Intent getPayIntent(boolean isLandScape, boolean isFixed) {

        Bundle bundle = new Bundle();

        QihooPayInfo pay = getQihooPayInfo(isFixed);

        // 界面相关参数，360SDK界面是否以横屏显示。
        bundle.putBoolean(ProtocolKeys.IS_SCREEN_ORIENTATION_LANDSCAPE, isLandScape);

        // *** 以下非界面相关参数 ***

        // 设置QihooPay中的参数。
        // 必需参数，用户access token，要使用注意过期和刷新问题，最大64字符。
        bundle.putString(ProtocolKeys.ACCESS_TOKEN, pay.getAccessToken());

        // 必需参数，360账号id，整数。
        bundle.putString(ProtocolKeys.QIHOO_USER_ID, pay.getQihooUserId());

        // 必需参数，所购买商品金额, 以分为单位。金额大于等于100分，360SDK运行定额支付流程； 金额数为0，360SDK运行不定额支付流程。
        bundle.putString(ProtocolKeys.AMOUNT, pay.getMoneyAmount());

        // 必需参数，人民币与游戏充值币的默认比例，例如2，代表1元人民币可以兑换2个游戏币，整数。
        bundle.putString(ProtocolKeys.RATE, pay.getExchangeRate());

        // 必需参数，所购买商品名称，应用指定，建议中文，最大10个中文字。
        bundle.putString(ProtocolKeys.PRODUCT_NAME, pay.getProductName());

        // 必需参数，购买商品的商品id，应用指定，最大16字符。
        bundle.putString(ProtocolKeys.PRODUCT_ID, pay.getProductId());

        // 必需参数，应用方提供的支付结果通知uri，最大255字符。360服务器将把支付接口回调给该uri，具体协议请查看文档中，支付结果通知接口–应用服务器提供接口。
        bundle.putString(ProtocolKeys.NOTIFY_URI, pay.getNotifyUri());

        // 必需参数，游戏或应用名称，最大16中文字。
        bundle.putString(ProtocolKeys.APP_NAME, pay.getAppName());

        // 必需参数，应用内的用户名，如游戏角色名。 若应用内绑定360账号和应用账号，则可用360用户名，最大16中文字。（充值不分区服，
        // 充到统一的用户账户，各区服角色均可使用）。
        bundle.putString(ProtocolKeys.APP_USER_NAME, pay.getAppUserName());

        // 必需参数，应用内的用户id。
        // 若应用内绑定360账号和应用账号，充值不分区服，充到统一的用户账户，各区服角色均可使用，则可用360用户ID最大32字符。
        bundle.putString(ProtocolKeys.APP_USER_ID, pay.getAppUserId());

        // 可选参数，应用扩展信息1，原样返回，最大255字符。
        bundle.putString(ProtocolKeys.APP_EXT_1, pay.getAppExt1());

        // 可选参数，应用扩展信息2，原样返回，最大255字符。
        bundle.putString(ProtocolKeys.APP_EXT_2, pay.getAppExt2());

        // 必选参数，应用订单号，应用内必须唯一，最大32字符。
        bundle.putString(ProtocolKeys.APP_ORDER_ID, pay.getAppOrderId());

        Intent intent = new Intent(mContext, ContainerActivity.class);
        intent.putExtras(bundle);

        return intent;
    }

    /**
     * 钩子方法，留给使用支付的子类实现getQihooPayInfo
     *
     * @param isFixed
     * @return
     */
    protected QihooPayInfo getQihooPayInfo(boolean isFixed) {
        return null;
    }


    // ---------------------------------360SDK接口的回调-----------------------------------


    private void procGotTokenInfoResult(String data) {
        boolean isCallbackParseOk = false;

        if(!TextUtils.isEmpty(data)) {
            JSONObject jsonRes;

            try {
                jsonRes = new JSONObject(data);
                // error_code 状态码： 0 登录成功， -1 登录取消， 其他值：登录失败
                // error_msg 状态描述
                int errorCode = jsonRes.optInt("error_code");
                switch (errorCode) {
                    case 0:
                        TokenInfo tokenInfo = TokenInfo.parseJson(jsonRes.optString("content"));
                        if (tokenInfo != null && tokenInfo.isValid()) {
                            isCallbackParseOk = true;
                            isAccessTokenValid = true;
                            onGotTokenInfo(tokenInfo);
                        }

                        break;

                    case -1:
                        Toast.makeText(mContext, R.string.user_login_cancelled, Toast.LENGTH_SHORT).show();
                        return;

                    default:
                        break;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        if(!isCallbackParseOk) {
            Toast.makeText(mContext, R.string.get_token_fail, Toast.LENGTH_LONG).show();
        }
    }


    /**
     * 子类继承
     * @param userInfo
     */
    public void onGotUserInfo(QihooUserInfo userInfo) {}


    /**
     * 子类继承
     * @param userInfo
     */
    public void onGotTokenInfo(TokenInfo tokenInfo) {}


    // 支付的回调
    protected IDispatcherCallback mPayCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            Log.d(TAG, "mPayCallback, data is " + data);
            if(TextUtils.isEmpty(data)) {
                return;
            }

            boolean isCallbackParseOk = false;
            JSONObject jsonRes;
            try {
                jsonRes = new JSONObject(data);
                // error_code 状态码： 0 支付成功， -1 支付取消， 1 支付失败， -2 支付进行中。
                // error_msg 状态描述
                int errorCode = jsonRes.optInt("error_code");
                isCallbackParseOk = true;
                switch (errorCode) {
                    case 0:
                    case 1:
                    case -1:
                    case -2: {
                        isAccessTokenValid = true;
                        String errorMsg = jsonRes.optString("error_msg");
                        String text = mContext.getString(R.string.pay_callback_toast, errorCode, errorMsg);
                        Toast.makeText(mContext, text, Toast.LENGTH_SHORT).show();

                    }
                        break;
                    case 4010201:
                        isAccessTokenValid = false;
                        Toast.makeText(mContext, R.string.access_token_invalid, Toast.LENGTH_SHORT).show();
                        break;
                    default:
                        break;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }

            // 用于测试数据格式是否异常。
            if (!isCallbackParseOk) {
                Toast.makeText(mContext, mContext.getString(R.string.data_format_error),
                        Toast.LENGTH_LONG).show();
            }
        }
    };


    // ----------------------------------------------------------------

    // 退出的回调
    private IDispatcherCallback mQuitCallback = new IDispatcherCallback() {

        @Override
        public void onFinished(String data) {
            Log.d(TAG, "mQuitCallback, data is " + data);
            JSONObject json;
            try {
                json = new JSONObject(data);
                int which = json.optInt("which", -1);
                String label = json.optString("label");

                Toast.makeText(mContext,
                        "按钮标识：" + which + "，按钮描述:" + label, Toast.LENGTH_LONG)
                        .show();

                switch (which) {
                    case 0: // 用户关闭退出界面
                        return;
                    default:// 退出游戏
                        mContext.finish();
                        return;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

    };

    @Override
    protected void onDestroy() {
        // 游戏退出前，不再调用SDK其他接口时，需要调用Matrix.destroy接口
        Matrix.destroy(mContext);
        super.onDestroy();
    };




}