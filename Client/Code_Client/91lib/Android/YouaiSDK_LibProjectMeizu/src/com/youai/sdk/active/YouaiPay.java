package com.youai.sdk.active;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningServiceInfo;
import android.app.ProgressDialog;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.Bundle;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.RemoteException;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.meizu.common.IAppProduct;
import com.meizu.common.IProductResponse;
import com.meizu.interfaces.IMStorePurchaseService;
import com.meizu.interfaces.IMStorePurchaseServiceCallback;
import com.youai.sdk.R;
import com.youai.sdk.alipay.AlixId;
import com.youai.sdk.alipay.BaseHelper;
import com.youai.sdk.alipay.MobileSecurePayHelper;
import com.youai.sdk.alipay.MobileSecurePayer;
import com.youai.sdk.alipay.PartnerConfig;
import com.youai.sdk.alipay.ResultChecker;
import com.youai.sdk.alipay.Rsa;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.api.HttpParameters;
import com.youai.sdk.android.api.YouaiException;
import com.youai.sdk.android.config.YouaiConfig;
import com.youai.sdk.android.utils.Utility;
import com.youai.sdk.net.AsyncUserRunner;
import com.youai.sdk.net.RequestListener;
import com.youai.sdk.webpay.AliPayDialog;
import com.youai.sdk.webpay.PayWebListen;
import com.youai.sdk.webpay.TencentPayDialog;
import com.youai.sdk.webpay.YibaoPayDialog;
public class YouaiPay  extends Activity{

	private final String  TAG = YouaiPay.class.toString();
	private ProgressDialog mProgress = null;
	private  static CallbackListener mPayCallback;
	private ImageView Alipay;
	private ImageView alipayWeb; 
	private ImageView TencentPay;
	private ImageView YinlianPay;
	private ImageView MeizuPay;
	
	private AliPayClick apayClick;
	private WebPayClick tpayClick;
	private Button u2_title_back;
	private TextView payMoneytv;
	private TextView payUsertv;
	private TextView payInfotv;
	private TextView payProducttv;
	
	private static YouaiPayParams mPayinfo;
	public static final int TecentPaySuccess = 7001;
	public static final int TecentPayFailed = 7002;
	public static final int TecentPayWait = 7003;
	public static final int YibaoPaySubmitSuccess = 8001;
	public static final int YibaoPayFailed = 8002;
	public static final int YibaoPayWait = 8003;
	public static final int PayErrorNet = 2001;
	public static final int PayErrorRequest = 2002;
	protected static String appkey;
	protected static String appsecret;
	public static String channelId;
	public static String HelpPhone;
	private  TextView mHelpPhoneTv;
	private static int initService = 0;
	 
	private ProgressDialog mProgressDialog;
	
	
	public static void setPayInfo(YouaiPayParams pPayInfo){
		mPayinfo = pPayInfo;
	}
	public static void setPayCallback(CallbackListener pPayCallbackListener){
		mPayCallback = pPayCallbackListener;
	}
	
	private  boolean lowTwenty = false;//充值是否低于20元
	private  int atPayCode = 0;
	private ImageView TianyiPay;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		 super.onCreate(savedInstanceState);
		 setContentView(R.layout.youai_charge_main);
		 Alipay = (ImageView) findViewById(R.id.u2_charge_alipay);
		 u2_title_back = (Button)findViewById(R.id.u2_title_back);
		 mHelpPhoneTv = (TextView)findViewById(R.id.youai_help_phone);
		 TencentPay = (ImageView)findViewById(R.id.u2_charge_tencent);
		 YinlianPay = (ImageView) findViewById(R.id.u2_charge_yinlian);
		 alipayWeb = (ImageView) findViewById(R.id.u2_charge_alipay_web);
		 MeizuPay = (ImageView) findViewById(R.id.u2_charge_meizu);
		 
		 payMoneytv = (TextView) findViewById(R.id.u2_charge_money_amount);
		 payInfotv = (TextView) findViewById(R.id.u2_charge_game_name);
		 payUsertv = (TextView) findViewById(R.id.u2_charge_user);
		 payProducttv = (TextView) findViewById(R.id.u2_charge_product); 
		 
		 
		 
		 payMoneytv.setText("充值金额："+String.valueOf(mPayinfo.getMoney())+" 元");
		 payInfotv.setText("充值游戏："+getPackageManager().getApplicationLabel(getApplicationInfo()).toString());
		 
		 
		 if(YouaiConfig.USERTYPE[2].equals(YouaiCommplatform.getInstance().getLoginUser().getUserType())){
			 payUsertv.setText("充值帐号："+ "游客");
		 }else{
			 payUsertv.setText("充值帐号："+ YouaiCommplatform.getInstance().getLoginNickName());
		 }
		 
		 payProducttv.setText("订单商品："+(int)(mPayinfo.getMoney()*10)+"钻石");
		 if(null!=HelpPhone){
			 HelpPhone = "客服热线："+HelpPhone;
			 mHelpPhoneTv.setVisibility(View.VISIBLE);
			 mHelpPhoneTv.setText(HelpPhone);
		 }else{
			 mHelpPhoneTv.setVisibility(View.GONE);			
		 }
		 
		 apayClick = new AliPayClick();
		 tpayClick = new WebPayClick();
		 TencentPay.setOnClickListener(tpayClick);
		
		 Alipay.setOnClickListener(apayClick);
		 YinlianPay.setOnClickListener(tpayClick);
		 alipayWeb.setOnClickListener(tpayClick);
		 
		 u2_title_back.setOnClickListener(new View.OnClickListener() {
			
			@Override                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
			public void onClick(View v) {

				onBackPressed();
			}
		});
		 
		mbRunning = true;
		PACKAGE_NAME = getApplication().getPackageName();
	
			
		 // 如果还没有获取到购买服务的对象，则进行获取
	    if(mPurchaseService == null ){
	    	Intent serviceIntent = new Intent();
	    	serviceIntent.setAction(IMStorePurchaseService.class.getName());
	    	if(!isWorked(YouaiPay.this)){
	    	bindService(serviceIntent, mPurchaseConnection, Context.BIND_AUTO_CREATE);
	    	}
		}
		
	    YouaiPay.this.getProduct();
		
		
		 MeizuPay.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				if(null==mDatas){
					Toast.makeText(YouaiPay.this, "获取产品编号失败!", Toast.LENGTH_SHORT).show();
					return;
				}
				
				String[] indexStr = mPayinfo.getExtraInfo().split("\\.");
		        int index = Integer.valueOf(indexStr[0]);
		        try {
					// 进行子产品的购买（该购买方式为第三方没有自己服务器的情况下使用）
					/**
					 * 以下方式为第三方拥有自己的服务器方式，大致步骤如下:
					 * 	1.首先第三方通过网络，从自己的服务器获取订单号
					 * 	2.使用订单号，通过软件中心接口进行购买
					 */
				mPurchaseService.purchaseProductOwnService(mDatas.get(index-1).getProductId(), 1, PACKAGE_NAME, mPayinfo.getExtraInfo()+"-"+ mPayinfo.getOrderId());
					
				} catch (RemoteException e) {
					//e.printStackTrace();
					Toast.makeText(YouaiPay.this, "下定单失败!", Toast.LENGTH_SHORT).show();
					return;
				}
			}
		});
		
			
	}
	
	 
	/**
	 * 返回键监听事件
	 */
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if (keyCode == KeyEvent.KEYCODE_BACK) {
			BaseHelper.log(TAG, "onKeyDown back");

			this.onBackPressed();
			return true;
		}

		return false;
	}

	//
	@Override
	public void onDestroy() {
		super.onDestroy();
		Log.v(TAG, "onDestroy");
		closeProgress();
	}
	
	
	// 这里接收支付结果，支付宝手机端同步通知
	public  Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			try {
				String strRet = (String) msg.obj;

				//Log.e(TAG, strRet);	// strRet范例：resultStatus={9000};memo={};result={partner="2088201564809153"&seller="2088201564809153"&out_trade_no="050917083121576"&subject="123456"&body="2010新款NIKE 耐克902第三代板鞋 耐克男女鞋 386201 白红"&total_fee="0.01"&notify_url="http://notify.java.jpxx.org/index.jsp"&success="true"&sign_type="RSA"&sign="d9pdkfy75G997NiPS1yZoYNCmtRbdOP0usZIMmKCCMVqbSG1P44ohvqMYRztrB6ErgEecIiPj9UldV5nSy9CrBVjV54rBGoT6VSUF/ufjJeCSuL510JwaRpHtRPeURS1LXnSrbwtdkDOktXubQKnIMg2W0PreT1mRXDSaeEECzc="}
				switch (msg.what) {
				case PayErrorNet:
					Toast.makeText(YouaiPay.this, "网络异常,请重试", Toast.LENGTH_SHORT).show();
					break;
				case PayErrorRequest:
					Toast.makeText(YouaiPay.this, "网络请求异常", Toast.LENGTH_SHORT).show();
					break;
				case YibaoPaySubmitSuccess:
					YouaiPay.this.finish();
					mPayCallback.onPaySubmitSuccess();
					break;
				case YibaoPayFailed:
					//YouaiPay.this.finish();
					mPayCallback.onPaymentError();
					break;
				case TecentPaySuccess:
					YouaiPay.this.finish();
					mPayCallback.onPaymentSuccess();
					break;
				case TecentPayFailed:
					//YouaiPay.this.finish();
					mPayCallback.onPaymentError();
					break;
				case AlixId.RQF_PAY: {
					//
					closeProgress();

					BaseHelper.log(TAG, strRet);

					// 处理交易结果
					try {
						// 获取交易状态码，具体状态代码请参看文档
						String tradeStatus = "resultStatus={";
						int imemoStart = strRet.indexOf("resultStatus=");
						imemoStart += tradeStatus.length();
						int imemoEnd = strRet.indexOf("};memo=");
						tradeStatus = strRet.substring(imemoStart, imemoEnd);
						
						//先验签通知
						ResultChecker resultChecker = new ResultChecker(strRet);
						int retVal = 2;//resultChecker.checkSign();
						// 验签失败
						if (retVal == ResultChecker.RESULT_CHECK_SIGN_FAILED) {
							BaseHelper.showDialog(
									YouaiPay.this,"提示",getResources().getString(
									R.string.check_sign_failed),android.R.drawable.ic_dialog_alert);
						} else {// 验签成功。验签成功后再判断交易状态码
							if(tradeStatus.equals("9000"))//判断交易状态码，只有9000表示交易成功，并不是真正的支付到帐！
							{
							//	BaseHelper.showDialog(YouaiPay.this, "提示","支付成功。交易状态码："+tradeStatus, R.drawable.ic_launcher);
							
							YouaiPay.this.finish();
							mPayCallback.onPaymentSuccess();
							}else{
							//BaseHelper.showDialog(YouaiPay.this, "提示", "支付失败。交易状态码:"+ tradeStatus, R.drawable.ic_launcher);
							
							//YouaiPay.this.finish();
							mPayCallback.onPaymentError();
							}
						}

					} catch (Exception e) {
						e.printStackTrace();
						mPayCallback.onPaymentError();
						//BaseHelper.showDialog(YouaiPay.this, "提示", strRet,R.drawable.ic_launcher);
					}
				}
					break;
				}

				super.handleMessage(msg);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	};
	
	class WebPayClick implements OnClickListener{

		@Override
		public void onClick(View v) {
			if(v.getId()==R.id.u2_charge_alipay_web){
				String url = YouaiConfig.AlipayWeb;
				
				HttpParameters params = new HttpParameters();

				params.add("youaiId",mPayinfo.getUid());
				params.add("totalFee",String.valueOf(mPayinfo.getMoney()));
				params.add("appKey",  YouaiPay.appkey);
				params.add("extraInfo", mPayinfo.getExtraInfo());
				params.add("orderId", mPayinfo.getOrderId());
				params.add("desc", mPayinfo.getDesc());
				params.add("body",mPayinfo.getDesc());
				params.add("subject",  "有爱互动游戏社区");
				params.add("channel", YouaiCommplatform.channelName);
				params.add("signature", params.getSignData(YouaiPay.appsecret));
				String url_to = url + "?" + Utility.encodeUrl(params);
				 
				AliPayDialog paydialog = new AliPayDialog(YouaiPay.this,url_to);
				paydialog.setWebListener(new PayWebListen(){
					@Override
					public void onSuccess(String response) {
						mHandler.sendEmptyMessage(TecentPaySuccess);
					}

					@Override
					public void onCancel() {
						mHandler.sendEmptyMessage(TecentPayWait);						
					}

					@Override
					public void onFailed(String response) {
						mHandler.sendEmptyMessage(TecentPayFailed);
					}
				});
				paydialog.show();
				return;
			}else if(v.getId()==R.id.u2_charge_tencent){
				String url = YouaiConfig.Tenpay;
				HttpParameters params = new HttpParameters();
				
				params.add("youaiId",mPayinfo.getUid());
				params.add("totalFee",String.valueOf(mPayinfo.getMoney()));
				params.add("appKey",  YouaiPay.appkey);
				params.add("extraInfo", mPayinfo.getExtraInfo());
				params.add("orderId", mPayinfo.getOrderId());
				params.add("desc", mPayinfo.getDesc());
				params.add("channel", YouaiCommplatform.channelName);
				params.add("signature", params.getSignData(YouaiPay.appsecret));
				String url_to = url + "?" + Utility.encodeUrl(params);
				TencentPayDialog paydialog = new TencentPayDialog(YouaiPay.this,url_to);
				paydialog.setWebListener(new PayWebListen(){
					@Override
					public void onSuccess(String response) {
						// TODO Auto-generated method stub
						mHandler.sendEmptyMessage(TecentPaySuccess);
					}

					@Override
					public void onCancel() {
						mHandler.sendEmptyMessage(TecentPayWait);						
					}

					@Override
					public void onFailed(String response) {
						mHandler.sendEmptyMessage(TecentPayFailed);
					}
				});
				paydialog.show();
				return;
			}else if(v.getId()==R.id.u2_charge_yinlian){
				
				String url = YouaiConfig.Yibao;
				HttpParameters params = new HttpParameters();
				
				params.add("youaiId",mPayinfo.getUid());
				params.add("totalFee",String.valueOf(mPayinfo.getMoney()));
				params.add("appKey",  YouaiPay.appkey);
				params.add("extraInfo", mPayinfo.getExtraInfo());
				params.add("orderId", mPayinfo.getOrderId());
				params.add("desc", "mxhzw");
				params.add("channel", YouaiCommplatform.channelName);
				params.add("signature", params.getSignData(YouaiPay.appsecret));
				String url_to = url + "?" + Utility.encodeUrl(params);
				YibaoPayDialog paydialog = new YibaoPayDialog(YouaiPay.this,url_to);
				paydialog.setWebListener(new PayWebListen(){
					@Override
					public void onSuccess(String response) {
						// TODO Auto-generated method stub
						mHandler.sendEmptyMessage(YibaoPaySubmitSuccess);
					}
					@Override
					public void onCancel() {
						mHandler.sendEmptyMessage(YibaoPayFailed);						
					}
					@Override
					public void onFailed(String response) {
						mHandler.sendEmptyMessage(YibaoPayFailed);
					}
				});
				paydialog.show();
				
			}
		}
		
	}
	
	class AliPayClick implements OnClickListener{

		@Override
		public void onClick(View v) {
			// TODO Auto-generated method stub
			if(v.getId()==R.id.u2_charge_alipay){

				// check to see if the MobileSecurePay is already installed.
				// 检测安全支付服务是否被安装
				MobileSecurePayHelper mspHelper = new MobileSecurePayHelper(YouaiPay.this);
				boolean isMobile_spExist = mspHelper.detectMobile_sp();
				if (!isMobile_spExist){
					closeProgress();
					return;
				}

				// check some info.
				// 检测配置信息
				if (!checkInfo()) {
					BaseHelper
							.showDialog(
									YouaiPay.this,
									"提示",
									"缺少partner或者seller，请在src/com/alipay/android/appDemo4/PartnerConfig.java中增加。",
									R.drawable.ic_launcher);
					return;
				}
				
				
				String url = YouaiConfig.Alipay;
				HttpParameters params = new HttpParameters();

				params.add("youaiId",mPayinfo.getUid());
				params.add("totalFee",String.valueOf(mPayinfo.getMoney()));
				params.add("appKey",  YouaiPay.appkey);
				params.add("extraInfo", mPayinfo.getExtraInfo());
				params.add("orderId", mPayinfo.getOrderId());
				params.add("desc", mPayinfo.getDesc());
				params.add("body",mPayinfo.getDesc());
				params.add("subject",  "有爱互动游戏社区");
				params.add("channel", YouaiCommplatform.channelName);
				params.add("signature", params.getSignData(YouaiPay.appsecret));
				
				String url_to = url + "?" + Utility.encodeUrl(params);
				Log.i("url_to", url_to);
				AsyncUserRunner.request(url_to, null, "GET", new RequestListener(){

					@Override
					public void onComplete(String response) {
						// TODO Auto-generated method stub
						
						Log.i("response", response);
						String content = null;
						String isSuccess = null;
						String strsign = null;
 						try {
							JSONObject jsonback = new JSONObject(response);
							content = jsonback.getString("content");
							isSuccess = jsonback.getString("isSuccess");
							strsign = jsonback.getString("sign");
						} catch (JSONException e) {
							e.printStackTrace();
						}
						
						String strOrderInfo = content;
						
						
						// start pay for this order.
						// 根据订单信息开始进行支付
						try {
							// prepare the order info.
							// 准备订单信息
							String orderInfo = strOrderInfo;
							// 这里根据签名方式对订单信息进行签名
							strsign = URLEncoder.encode(strsign);
							// 组装好参数
							String info = orderInfo + "&sign=" + "\"" + strsign + "\"" + "&"+ getSignType();
							Log.e("orderInfo:", info);
							// start the pay.
							// 调用pay方法进行支付
							MobileSecurePayer msp = new MobileSecurePayer();
							boolean bRet = msp.pay(info, mHandler, AlixId.RQF_PAY, YouaiPay.this);

							if (bRet) {
								// show the progress bar to indicate that we have started
								// paying.
								// 显示“正在支付”进度条
								mProgress = BaseHelper.showProgress(YouaiPay.this, null, "正在支付", false,
										true);
							} else
								;
						} catch (Exception ex) {
							Toast.makeText(YouaiPay.this, R.string.remote_call_failed,
									Toast.LENGTH_SHORT).show();
							closeProgress();
						}
				}
					

					@Override
					public void onIOException(IOException e) {
						Log.i("IOexception", "IOexception");
						mHandler.sendEmptyMessage(PayErrorRequest);
					}

					@Override
					public void onError(YouaiException e) {
						Log.i("YouaiException", "onError");
						mHandler.sendEmptyMessage(PayErrorNet);
					}
					
				});
					
			}
					
		}
		
	} 
	
	private boolean checkInfo() {
		String partner = PartnerConfig.PARTNER;
		String seller = PartnerConfig.SELLER;
		if (partner == null || partner.length() <= 0 || seller == null
				|| seller.length() <= 0)
			return false;

		return true;
	}
	
	String getOutTradeNo() {
		SimpleDateFormat format = new SimpleDateFormat("MMddHHmmss");
		Date date = new Date();
		String strKey = format.format(date);

		java.util.Random r = new java.util.Random();
		strKey = strKey + r.nextInt();
		strKey = strKey.substring(0, 15);
		return strKey;
	}
	
	/**
	 * get the sign type we use. 获取签名方式
	 * 
	 * @return
	 */
	String getSignType() {
		String getSignType = "sign_type=" + "\"" + "RSA" + "\"";
		return getSignType;
	}
	
	/**
	 * sign the order info. 对订单信息进行签名
	 * 
	 * @param signType
	 *            签名方式
	 * @param content
	 *            待签名订单信息
	 * @return
	 */
	String sign(String signType, String content) {
		return Rsa.sign(content, PartnerConfig.RSA_PRIVATE);
	}
	
	
	//
	// close the progress bar
	// 关闭进度框
	void closeProgress() {
		try {
			if (null!=mProgress) {
				mProgress.dismiss();
				mProgress = null;
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	//
	//
	/**
	 * the OnCancelListener for lephone platform. lephone系统使用到的取消dialog监听
	 */
	public static class AlixOnCancelListener implements
			DialogInterface.OnCancelListener {
		Activity mcontext;

		public AlixOnCancelListener(Activity context) {
			mcontext = context;
		}

		public void onCancel(DialogInterface dialog) {
			mcontext.onKeyDown(KeyEvent.KEYCODE_BACK, null);
		}
	}

	
	
	
	
	
	ArrayList<IAppProduct> mDatas;
	
	// 记录本应用的packageName
	private static String PACKAGE_NAME;
	
	// 从魅族开发者社区中申请到的子产品ID值(用户根据实际情况输入，或者可通过网络从自己的服务器上获取)
	private static final String[] PRODUCT_ARRAY = {
		"010",
		"011",
		"012",
		"013",
		"014",
		"015",
		"016",
		"017",
		"018",
		"019",
		"020" 
	}; 
	
	private static final int MSG_GET_PRODUCT_FINISH = 1;
	private static final int MSG_GET_PRODUCT_ERROR = -1;
	private static final int MSG_PURCHASE_RESTORE = 2;
	private static final int MSG_PURCHASE_SUCCESS = 5;
	private static final int MSG_PURCHASE_FAIL = 6;
	
	// 购买的结构状态值
	private static final int RESULT_CODE_SUCCESS = 1;	//< 购买成功
    private static final int RESULT_CODE_FAIL = -1;		//< 购买失败
    private static final int RESULT_CODE_RESTORED = -2;	//< 重复购买
    
    private boolean mbRunning = false; 

    private void getProduct(){
		new Thread(new Runnable() {
			
			public void run() {
				try {
					try {
						// 等待服务绑定，应用可根据需要添加
						Thread.sleep(1000);
					} catch (InterruptedException e) {
						e.printStackTrace();
					}
					if(mPurchaseService == null){
						sendMessage(MSG_GET_PRODUCT_ERROR, "绑定服务失败!");
					}else{
						// 获取本应用的子产品的信息,返回值为IProductResponse类的对象
						IProductResponse res = mPurchaseService.getProducts(PRODUCT_ARRAY, PACKAGE_NAME);
						if(res == null){
							sendMessage(MSG_GET_PRODUCT_ERROR, "获取产品列表失败!");
						}else{
							sendMessage(MSG_GET_PRODUCT_FINISH, res);
						}
					}
				} catch (RemoteException e) {
					e.printStackTrace();
					sendMessage(MSG_GET_PRODUCT_ERROR, "获取产品列表失败!");
				}
				
			}
		}).start();
}
    
	Handler mMeizuHandler = new Handler() {
		public void handleMessage(Message msg) {
			if(!mbRunning){
				return;
			}
			switch (msg.what) {
			case MSG_GET_PRODUCT_FINISH:{
				// 获取子产品信息成功
				IProductResponse res = (IProductResponse)msg.obj;
				mDatas = res.getProductsArray();
				YouaiPay.this.MeizuPay.setVisibility(View.VISIBLE);
			}
				break;
			case MSG_GET_PRODUCT_ERROR:
				Toast.makeText(YouaiPay.this, msg.obj.toString(), Toast.LENGTH_LONG).show();
				break;
			case MSG_PURCHASE_SUCCESS:
				// 购买成功
				Toast.makeText(YouaiPay.this, "购买成功,license为:" + msg.obj.toString(), Toast.LENGTH_SHORT).show();
				break;
			case MSG_PURCHASE_RESTORE:
				// 重复购买
				Toast.makeText(YouaiPay.this, "重复购买,license为:" + msg.obj.toString(), Toast.LENGTH_SHORT).show();
				break;
			case MSG_PURCHASE_FAIL:
				// 购买失败
				Toast.makeText(YouaiPay.this, "购买失败:" + msg.obj.toString(), Toast.LENGTH_SHORT).show();
				break;
			}
	        super.handleMessage(msg);
	    }
	};
	private void sendMessage(int what, Object obj) {
		Message msg = mMeizuHandler.obtainMessage(what, obj);
		mMeizuHandler.sendMessage(msg);
	}
	
	
	// 魅族MStore购买服务接口实例
	private IMStorePurchaseService mPurchaseService = null;
	private ServiceConnection mPurchaseConnection = new ServiceConnection() {

		public void onServiceDisconnected(ComponentName name) {
			mPurchaseService = null;

		}

		public void onServiceConnected(ComponentName name, IBinder service) {
			mPurchaseService = IMStorePurchaseService.Stub.asInterface(service);
			
			// 绑定成功后，可直接注册回调
			try {
				mPurchaseService.addPurchaseListener(PACKAGE_NAME, mPurchaseCallback);
			} catch (RemoteException e) {
				e.printStackTrace();
			}

		}
	};
	
	// 实现IMStorePurchaseServiceCallback回调接口的各个方法，做出对应处理
	private IMStorePurchaseServiceCallback mPurchaseCallback = new IMStorePurchaseServiceCallback.Stub() {

		public void transactionFail(int errorCode, String errorMsg,
				String packageName, String productIdentify, String orderNum)
				throws RemoteException {
			// 购买失败
			sendMessage(MSG_PURCHASE_FAIL, errorMsg);
			
			// 将该购买请求移除。如果未移除，在该packageName下次再注册购买服务的回调时，购买服务会再次发送该回调
			mPurchaseService.removeBusiness(orderNum);
			
		}

		public void transactionSuccess(int result,
				String license, String packageName, String productIdentify,
				String orderNum) throws RemoteException {
			// 购买成功
			if(result == RESULT_CODE_RESTORED){
				// 状态为重复购买
				sendMessage(MSG_PURCHASE_RESTORE, license);
			}else{
				// 状态为购买成功
				sendMessage(MSG_PURCHASE_SUCCESS, license);
			}
			
			// 根据需要将该购买请求移除。如果未移除，在该packageName下次再注册购买服务的回调时，购买服务会再次发送该回调
			mPurchaseService.removeBusiness(orderNum);
		}
	};
	
	public static boolean isWorked(Context context)
	 {
	  
	  ActivityManager myManager=(ActivityManager)context.getSystemService(Context.ACTIVITY_SERVICE);
	  ArrayList<RunningServiceInfo> runningService = (ArrayList<RunningServiceInfo>) myManager.getRunningServices(Integer.MAX_VALUE);
	  for(int i = 0 ; i<runningService.size();i++)
	  {
	   if(runningService.get(i).service.getClassName().toString().equals(IMStorePurchaseService.class.getName()))
	   {
	    return true;
	   }
	  }
	  return false;
	 }

}
