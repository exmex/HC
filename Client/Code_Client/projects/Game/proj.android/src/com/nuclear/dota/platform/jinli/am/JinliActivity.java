package com.nuclear.dota.platform.jinli.am;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;
import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.gionee.gsp.AmigoPayer;
import com.gionee.gsp.AmigoPayer.MyPayCallback;
import com.gionee.gsp.GnCommplatform;
import com.gionee.gsp.GnEFloatingBoxPositionModel;
import com.gionee.gsp.GnEType;
import com.gionee.gsp.GnException;
import com.gionee.gsp.service.account.sdk.listener.IGnUiListener;
import com.gionee.pay.third.GnCreateOrderUtils;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.Config;
import com.qsds.ggg.dfgdfg.fvfvf.R;

public class JinliActivity extends GameActivity {

	private String TAG = "Gionee";
	
	public static String API_KEY;
	private static String SecretKey;
	private static String RSA_PRIVATE;
	public static String LOGIN_URL = "";
	
	private Activity mActivity = null;
	private GnCommplatform mGnCommplatform = null;
	private AmigoPayer mAmigoPayer = null;
	// 支付结果回调
	private MyPayCallback mMyPayCallback;
	
	private String playerId = "";
	private PayInfo mPayInfo = null;
	private String mOrderInfo = null;
	private ProgressDialog pd = null;
	
	private boolean doInitWeChat = false;
	public boolean isPay = false;
	
	private Handler mHandler = new Handler() {

        @Override
        public void handleMessage(android.os.Message msg) {
            Log.d(TAG, GnCreateOrderUtils.getThreadName());
            switch (msg.what) {
                case 1:
                    Log.d(TAG, "Message 1: " + (String) msg.obj);
                    break;
                case 3:
                    Toast.makeText(mActivity, msg.getData().getString(AmigoPayer.STATE_CODE),
                            Toast.LENGTH_LONG).show();
                    break;
                case 4:
                    Toast.makeText(mActivity, "请先登录帐号!", Toast.LENGTH_LONG).show();
                    break;
                case 5:
                	if(pd != null && pd.isShowing())
                		pd.dismiss();
                    Toast.makeText(mActivity, "获取订单数据异常:" + msg.obj, Toast.LENGTH_SHORT).show();
                    break;
                case 6:
                	if(pd != null && pd.isShowing())
                		pd.dismiss();
					try
					{
						mAmigoPayer.pay(mOrderInfo, mMyPayCallback, mAmigoPayer.getBitmap(R.drawable.ic_launcher));
					}
					catch (GnException e)
					{
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
                default:
                    break;
            }
        };
    };
	
	public JinliActivity() {
		// TODO Auto-generated constructor stub
		super.mGameCfg = new GameConfig(this,
				PlatformAndGameInfo.enPlatform_Jinli);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		String infoStr = GameConfig
				.nativeReadGamePlatformInfo(PlatformAndGameInfo.enPlatform_Jinli);
		try {
			JSONObject dataJsonObj = new JSONObject(infoStr);
			API_KEY = dataJsonObj.getString("appkey");
			SecretKey = dataJsonObj.getString("app_secret");
			LOGIN_URL = dataJsonObj.getString("loginurl");
		} catch (JSONException e) {
			e.printStackTrace();
		}
		
		mActivity = this;
		
		//微信分享初始化
		if(doInitWeChat==false)
		{
			ApplicationInfo appInfo = null;
			try {
				appInfo = this.getPackageManager().getApplicationInfo(this.getPackageName(),PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
		
			}
		
			if(appInfo!=null && appInfo.metaData != null)
			{
				String WX_APP_ID = appInfo.metaData.getString("WX_APP_ID");
				if(WX_APP_ID!=null)
				{
				Config.WX_APP_ID = WX_APP_ID;
				}
			}
			
			doInitWeChat = true;
		}
		if(null!=Config.WX_APP_ID && !Config.WX_APP_ID.equals("")){
			api = WXAPIFactory.createWXAPI(this, Config.WX_APP_ID, false);
			api.registerApp(Config.WX_APP_ID);// 将该app注册到微信
		}
		
		//Amigo组件初始化
		mGnCommplatform = GnCommplatform.getInstance(mActivity);
		mGnCommplatform.setFloatingBoxOriginPosition(GnEFloatingBoxPositionModel.LEFT_TOP);
		mGnCommplatform.init(mActivity, GnEType.GAME, API_KEY);
        
        mAmigoPayer = new AmigoPayer(mActivity);
        mMyPayCallback = mAmigoPayer.new MyPayCallback() {

            /* 支付结束
             * @params stateCode 支付结果的返回码，代码成功还是失败
             * 返回码定义，请见文档说明
             */
            @Override
            public void payEnd(String stateCode) {
                // 这句话必须，否则不会自动调起收银台
                super.payEnd(stateCode);
                Log.d(TAG, " mSubmitButton.setOnClickListener: payEnd,stateCode=" + stateCode);
                // 如果是升级的场景，升级会在MyPayCallback自动处理，开发者可以不用处理。
                if (isAppUpdate(stateCode)) {
                    return;
                }
                
                if(pd != null && pd.isShowing()){
                	pd.dismiss();
                }
                
                isPay = false;
                // 可以在这里处理自己的业务,下面这几句，实际接入时去掉。
                //Message message = mHandler.obtainMessage(3);
                //message.getData().putString(AmigoPayer.STATE_CODE, stateCode);
                //mHandler.sendMessage(message);

            }

            private boolean isAppUpdate(String stateCode) {
                return AmigoPayer.RESULT_CODE_UPDATE.equals(stateCode)
                        || AmigoPayer.RESULT_CODE_UPDATE_IS_NOT_GIONEE.equals(stateCode);
            }
        };
	}
	
	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
//			AlertDialog.Builder builder = new Builder(mActivity);
//			builder.setMessage("游戏中切换账号需重启游戏");
//			builder.setTitle("提示");
//			builder.setPositiveButton("确认", new OnClickListener() {
//				@Override
//				public void onClick(DialogInterface dialog, int which) {
//					// TODO Auto-generated method stub
//					GameActivity.requestRestart();
//				}
//			});
//			builder.create().show();
		}
		else{
			if(intent.getBooleanExtra(Constants.RE_LOGION, false))
			{
				PlatformJinliLoginAndPay.getInstance().callLogout();
				loginAccount(intent);
			}
			
		}
		
		
	}
	//****************************Account Related Methods*******************************
	private Intent getAccountLogoutNotifyIntent() {
		Intent intent = new Intent(mActivity, com.nuclear.dota.platform.jinli.am.JinliActivity.class);
	    intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP);
	    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	    intent.putExtra(Constants.RE_LOGION, true);
		return intent;
	}
	
	public void loginAccount(final Intent intent) {
		if(Cocos2dxHelper.nativeHasEnterMainFrame()){
			isReLogin(intent);
		}
		if (PlatformJinliLoginAndPay.getInstance().isLogined == true && mGnCommplatform.isAccountLogin(mActivity)) {
			Log.d(TAG, "已登录");
		} else {
			try {
				mGnCommplatform.loginAccount(mActivity,Constants.LOGIN_REQUEST_CODE, isReLogin(intent),
						new IGnUiListener() {

							@Override
							public void onError(Exception e) {
								// TODO Auto-generated method stub
								Toast.makeText(mActivity, "登录失败",
										Toast.LENGTH_SHORT).show();
								PlatformJinliLoginAndPay.getInstance().isLogined = false;
							}

							@Override
							public void onCancel() {
								// TODO Auto-generated method stub
								Toast.makeText(mActivity, "取消登录",
										Toast.LENGTH_SHORT).show();
								PlatformJinliLoginAndPay.getInstance()
										.callLogout();
								PlatformJinliLoginAndPay.getInstance()
										.callLogin();
							}

							@Override
							public void onComplete(JSONObject jsonObject) {
								// TODO Auto-generated method stub
								Toast.makeText(mActivity, "登录成功",
										Toast.LENGTH_SHORT).show();
								PlatformJinliLoginAndPay.getInstance().isLogined = true;

								try {
									 playerId = (String) jsonObject
											.get(Constants.PLAYER_ID);
									// 获取amigoUserId
									String amigoUserId = (String) jsonObject
											.get(Constants.USER_ID);
									// 获取amigoToken
									String amigoToken = (String) jsonObject
											.get(Constants.ASSOCIATE_STRING);
									// 获取用户手机号
									String amigoTn = (String) jsonObject
											.get(Constants.TELEPHONE_NUMBER);
									// 获取玩家昵称
									String amigoNa = (String) jsonObject
											.get(Constants.NAME);

									Log.d(TAG, "Amigo User Id:" + amigoUserId);

									LoginInfo login_info = new LoginInfo();

									login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
									login_info.account_uid_str = amigoUserId;
									login_info.account_nick_name = amigoNa;
									PlatformJinliLoginAndPay.getInstance().notifyLoginResult(login_info);
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
							}

						});
			} catch(Exception e) {
				e.printStackTrace();
			}
		}
    }
	
	private boolean isReLogin(Intent intent) {
        if (intent != null && intent.getBooleanExtra(Constants.RE_LOGION, false)) {
            // 如果是收到切换账号通知的登录,会自动清除用户名和密码，需要用户输入用户名和密码
        	if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
    			AlertDialog.Builder builder = new Builder(mActivity);
    			builder.setMessage("游戏中切换账号需重启游戏");
    			builder.setTitle("提示");
    			builder.setPositiveButton("确认", new OnClickListener() {
    				@Override
    				public void onClick(DialogInterface dialog, int which) {
    					// TODO Auto-generated method stub
    					GameActivity.requestRestart();
    				}
    			});
    			builder.create().show();
        	}
        	return false;
        }
        return true;
    }
	
	//****************************Payment Related Methods*******************************
	public void onPayerResume(){
		mAmigoPayer.onResume();
	}
	
	public void onPayerDestroy(){
		mAmigoPayer.onDestroy();
	}
	
	protected String getProductInfo(String outOrderNo, String apiKey, String submitTime) throws JSONException {
        JSONObject jsonObject = new JSONObject();
        jsonObject.put("out_order_no", outOrderNo);
        jsonObject.put("api_key", apiKey);
        jsonObject.put("submit_time", submitTime);
        return jsonObject.toString();
    }
	
	public void payGameFee(PayInfo pay_info){
		//首先检查AmigoPayer组件是否存在
		mPayInfo = pay_info;
        try {
            // 检查支付的前置条件,有正式账号登录
            if (mAmigoPayer.check(new GnUiListener())) {
                createOrder();
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
	}
	
    /*
     * 当mAmigoPayer.check()为false后，会在账号登录或者升级后自动调用创建订单方法
     */
    class GnUiListener implements IGnUiListener {

        @Override
        public void onError(Exception e) {
            // TODO Auto-generated method stub

        }

        @Override
        public void onComplete(JSONObject jsonObject) {
            try {
                // 检查支付的前置条件,有正式账号登录
                if (mAmigoPayer.check(new GnUiListener())) {
                    createOrder();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }

        }

        @Override
        public void onCancel() {

        }

    }
	
	public void createOrder() {
        pd = new ProgressDialog(mActivity);
        pd.setTitle("请稍等");
        pd.setMessage("正在创建订单");
        pd.setCancelable(false);
        pd.show();
        new Thread(new Runnable() {
            @Override
            public void run() {
                // 拼装参数到自己的服务器去创建订单
            	Log.d(TAG, "Start A New Thread To Get The Order");
                getOrder();
            }
        }).start();
        isPay = true;
    }
	
	private void getOrder() {
        String outOrderNo = generateNewOrderSerial();
        String extrainfo = mPayInfo.description+"-"+mPayInfo.product_id+"-"+PlatformJinliLoginAndPay.getInstance().login_info.account_uid_str;
        String totalFee = String.valueOf(mPayInfo.price);
        String submitTime ="";
        String order = "";
        try {
        	
        	/**
        	 *  (Context contxt, String rsaPrivate, String apiKey,
        	 *  String outOrderNo, String subject, String consumedRewards,
        	 *  String totalFee, String dealPrice, String deliverType, 
        	 *  String submitTime, String expireTime, 
        	 *  String rebateRewards, String rebateExpireTime,
        	 *  String rebateMsg, String msg, String notifyUrl,
        	 *  String playerId) throws Exception
        	 * */
            
        	String url = JinliActivity.LOGIN_URL + "/pay_jinli.php";
            HttpClient httpClient = new DefaultHttpClient(); 
            HttpPost post = new HttpPost(url); 
            List<NameValuePair> paramList = new ArrayList<NameValuePair>(); 
            BasicNameValuePair param = new BasicNameValuePair("player_id",playerId);
            BasicNameValuePair param1 = new BasicNameValuePair("total_fee",totalFee);
            BasicNameValuePair param2 = new BasicNameValuePair("create_type","get_out_order_no");
            BasicNameValuePair param3 = new BasicNameValuePair("out_order_no",outOrderNo);
            BasicNameValuePair param4 = new BasicNameValuePair("subject",mPayInfo.product_name.substring(2));
            BasicNameValuePair param5 = new BasicNameValuePair("extra_info",extrainfo);
            paramList.add(param);
            paramList.add(param1); 
            paramList.add(param2); 
            paramList.add(param3); 
            paramList.add(param4);
            paramList.add(param5); 
            
            post.setEntity(new UrlEncodedFormEntity(paramList));   
            HttpResponse httpResponse = httpClient.execute(post); 
            
            if(httpResponse.getStatusLine().getStatusCode() == 200){ 
            	String result = EntityUtils.toString(httpResponse.getEntity());
            	JSONObject jsonResult = new JSONObject(result);
            	String status = jsonResult.optString("status");
            	submitTime = jsonResult.optString("submit_time");
            	if("200010000".equals(status)){
            		order = jsonResult.optString("out_order_no");
            		final String orderInfo = getProductInfo(order, JinliActivity.API_KEY, submitTime);
                    this.mOrderInfo = orderInfo;
                    Log.d(TAG, "Get Order Successfully");
             		Message message = new Message();
             		message.what = 6;
             		mHandler.sendMessage(message);
                      
            	}else{
            		Message message = new Message();
            		message.what = 5;
            		mHandler.sendMessage(message);
            	}
            	
            }
           
        } catch (Exception e) {
            e.printStackTrace();
            Message message = new Message();
            message.what = 5;
            mHandler.sendMessage(message);
        }
    }
}