package com.nuclear.sdk.active;

import java.util.UUID;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;
import android.os.SystemClock;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.nuclear.sdk.android.CallbackListener;
import com.nuclear.sdk.android.SdkError;
import com.nuclear.sdk.android.entry.SdkAppInfo;
import com.nuclear.sdk.R;

public class TestDemo extends Activity {

	private static final String Tag = TestDemo.class.toString();
	private TextView tv1;
	private TextView tv2;
	private TextView tv3;
	private TextView tv4;
	
	Handler handler = new Handler(){
		public void dispatchMessage(Message msg) {
			if(msg.what==1){
				tv1.setText((String)msg.obj);
			}
		}
	};
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		Log.i(Tag, "onCreate");
		Log.i("timemillos","timemillos"+SystemClock.currentThreadTimeMillis());
		setContentView(R.layout.activity_main);
		Button buttonLogin = (Button)findViewById(R.id.buttonLogin);
		Button btnCenter = (Button)findViewById(R.id.buttoncenter);
		Button btnPay = (Button)findViewById(R.id.buttonPay);
		Button logout =(Button) findViewById(R.id.buttonlogout);
		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
        /*.detectDiskReads().detectDiskWrites()*/.detectNetwork()
        /*.penaltyLog()*/.build());
		
		logout.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				SdkCommplatform.getInstance().nuclearLogout(TestDemo.this);
			}
		});
	 
		btnPay.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				SdkPayParams payinfo = new SdkPayParams();
				payinfo.setOrderId(UUID.randomUUID().toString());
				payinfo.setMoney(1);
				payinfo.setDesc("test");
				payinfo.setExtraInfo("1.haizeiwang.nuclear-178-ya10041");
				
				SdkCommplatform.getInstance().nuclearEnterRecharge(TestDemo.this,payinfo, new CallbackListener() {
					@Override
					public void onPaymentSuccess() {
						runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								Toast.makeText(TestDemo.this, "提交支付成功", Toast.LENGTH_SHORT).show();		
							}
						});
						
					}
					
					@Override
					public void onPaymentError() {
						runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								// TODO Auto-generated method stub
								Toast.makeText(TestDemo.this, "提交支付失败", Toast.LENGTH_SHORT).show();		
							}
						});
					}
					
				});
			
			}
		});
		
		tv1 = (TextView) findViewById(R.id.textView1);
		tv2 = (TextView) findViewById(R.id.textView2);
		tv3 = (TextView) findViewById(R.id.textView3);
		tv4 = (TextView) findViewById(R.id.textView4);
		
		SdkAppInfo nuclearAppInfo = new SdkAppInfo();
		nuclearAppInfo.setAppId(0);
		nuclearAppInfo.setAppKey("mxhzw");
		nuclearAppInfo.setAppSecret("youaihzw5588hzwyouai");
		nuclearAppInfo.setCtx(TestDemo.this);
		nuclearAppInfo.setOrientation(SdkCommplatform.LANDSCAPE);
		SdkCommplatform.getInstance().Init(TestDemo.this, nuclearAppInfo, new OnInitCompleteListener(){
			@Override
			protected void onComplete(int arg0)
			{
				
				Toast.makeText(TestDemo.this, "初始化成功", Toast.LENGTH_SHORT).show();
			}
			
			@Override
			protected void onFailed(int code, String msg) {
				 
				Toast.makeText(TestDemo.this, "初始化失败", Toast.LENGTH_SHORT).show();
			}
		});
		
		
		buttonLogin.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				SdkCommplatform.getInstance().nuclearLogin(TestDemo.this,new CallbackListener() {
					@Override
					public void onLoginSuccess(String backmsg) {
						
					/*	Message msg = new Message();
						msg.what = 1;
						String msgstr = bundle.getString("msg");
				    	msg.obj =msgstr; */
				    	Toast.makeText(TestDemo.this, "登录成功", Toast.LENGTH_SHORT).show();
				    	//handler.sendMessage(msg);
				    	
				    	Log.i(Tag, "msgstr"+backmsg);
				    	
					}
					
					@Override
					public void onLogoutError(SdkError error) {

						Message msg = new Message();
						msg.what = 1;
						String msgstr = error.getMErrorMessage();
				    	msg.obj =msgstr; 
				    	Toast.makeText(TestDemo.this, "登录失败", Toast.LENGTH_SHORT).show();
				    	//handler.sendMessage(msg);
				    	Log.i(Tag, "msgstr"+msgstr);
				    	
					}
					
				});
			}
		});
		
		btnCenter.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				SdkCommplatform.getInstance().EnterAccountManage(TestDemo.this, new CallbackListener() {
				});
			}
		});

	}

	@Override
	protected void onRestart() {
		// TODO Auto-generated method stub
		super.onRestart();
		Log.i(Tag, "onRestart");
	}
	
	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		Log.i(Tag, "onResume");
	}
	
	@Override
	protected void onPause() {
		// TODO Auto-generated method stub
		super.onPause();
		Log.i(Tag, "onPause");
	}
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		Log.i(Tag, "onDestroy");
	}
}
