package com.nuclear.dota.platform.thirdlogin;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.LinkedList;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.Dialog;
import android.content.DialogInterface;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;

import com.qsds.ggg.dfgdfg.fvfvf.R;

public class ThirdLoginRegisteDialog extends Dialog implements View.OnClickListener,DialogInterface.OnDismissListener

 {
	Activity context;
	private  final String TAG = ThirdLoginRegisteDialog.this.toString();
	private Button mSubmitButton ;
	private Thread submitThread ;
	private EditText mEditNick;
	private EditText mEditPassword;
	private EditText mEditOkPassword;
	private EditText mEditEmail;
	
	private  boolean isShowRegiste = false;
	
	private String Tag = ThirdLoginRegisteDialog.class.toString();
	
	private static final int BACKCODESUCCESS= 1011;
	private static final int BACKCODEFAILED = 1012;
	
	private Handler mRegisteHandler = new Handler(){

		@Override
		public void dispatchMessage(Message msg) {
			
			switch (msg.what) {
			case BACKCODESUCCESS:
				Toast.makeText(context, (String)msg.obj, Toast.LENGTH_SHORT).show();
				ThirdLoginRegisteDialog.this.dismiss();
				break;
			case BACKCODEFAILED:
				
				Toast.makeText(context, "注册失败，错误码："+msg.obj, Toast.LENGTH_SHORT).show();
				
				break;
			default:
				break;
			}
			
			super.dispatchMessage(msg);
		}
		
	};
	
	
	public boolean isShowRegister(){
		if(isShowRegiste)
			return true;
		
		return false;
	}
    public ThirdLoginRegisteDialog(Activity context) {
        super(context);
        // TODO Auto-generated constructor stub
        this.context = context;
    }
    public ThirdLoginRegisteDialog(Activity context, int theme){
        super(context, theme);
        this.context = context;
    }
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        this.setContentView(R.layout.thirdlogin_registe);
        
        mEditEmail =(EditText) findViewById(R.id.re_email);
        mEditNick =(EditText) findViewById(R.id.re_username);
        mEditPassword =(EditText) findViewById(R.id.re_password);
        mEditOkPassword =(EditText) findViewById(R.id.re_okpassword);
        
        DisplayMetrics dm = new DisplayMetrics();
		context.getWindowManager().getDefaultDisplay().getMetrics(dm);
		int widthPixels= dm.widthPixels;
		int heightPixels= dm.heightPixels;
		float density = dm.density;
		int screenWidth = (int) (widthPixels * density) ;
		int screenHeight = (int) (heightPixels * density) ; 
		
		WindowManager.LayoutParams lp = this.getWindow().getAttributes();
		this.getWindow().setGravity(Gravity.CENTER_HORIZONTAL|Gravity.TOP);
		lp.width = (int) (screenWidth*0.65);  
		lp.height = (int) (screenHeight*0.65);  
		this.getWindow().setAttributes(lp);  
		
		
        mSubmitButton = (Button) findViewById(R.id.submit_bt);
        mSubmitButton.setOnClickListener(this);
        
    }
	@Override
	public void onClick(View v) {
		 if(v.getId()==R.id.submit_bt){
			 
			 
			 if(!(mEditOkPassword.getText().toString()).equals(mEditPassword.getText().toString())){
				 Toast.makeText(context, "密码不相等，请重试", Toast.LENGTH_SHORT).show();
				 return;
			 }
			 
			 if(!checkEmail(mEditEmail.getText().toString())){
				 Toast.makeText(context, "邮箱不正确，请重试", Toast.LENGTH_SHORT).show();
				 return;
			 }
			 
			 
			 
			
			 if(null!=submitThread){
				 Log.i("status:", "status:"+submitThread.getState());
				 if(submitThread.isInterrupted()){
					  
				 }else if(Thread.State.TERMINATED==submitThread.getState()){
					 submitThread = new Thread(RegisteRun);
					 submitThread.start();
				 }
			 }else{
			 submitThread = new Thread(RegisteRun);
			 submitThread.start();
			 }
		 }else if(v.getId()==R.id.regeit_cancel){
			 isShowRegiste = true;
			 ThirdLoginRegisteDialog.this.dismiss();
		 }
		 
	}
	
	private Runnable RegisteRun = new Runnable() {
		
		@Override
		public void run() {
			// TODO Auto-generated method stub
			//��GET��ʽһ���Ƚ��������List
			 LinkedList<BasicNameValuePair> params = new LinkedList<BasicNameValuePair>();
			 params.add(new BasicNameValuePair("param1", "param1"));
			 params.add(new BasicNameValuePair("param2", "param2"));
			 
			 
			 int REQUEST_TIMEOUT = 10*1000; 
			 int SO_TIMEOUT = 10*1000;  
			   
			BasicHttpParams httpParams = new BasicHttpParams();
			HttpConnectionParams.setConnectionTimeout(httpParams, REQUEST_TIMEOUT);
			HttpConnectionParams.setSoTimeout(httpParams, SO_TIMEOUT);
			HttpClient httpClient = new DefaultHttpClient(httpParams);
			   
			 try {
			    // HttpPost postMethod = new HttpPost("http://www.baidu.com");
			    HttpGet getHttp = new HttpGet("http://192.168.1.8:8080/AccountCenterYouai/login/regist?"+"userName="+mEditNick.getText().toString()
			    		+"&passWord="+mEditOkPassword.getText().toString()+"&email="+mEditEmail.getText().toString());
				
			    
			    // postMethod.setEntity(new UrlEncodedFormEntity(params, "utf-8")); 
			   
			    
			    HttpResponse response = httpClient.execute(getHttp); 
			    int statusCode = response.getStatusLine().getStatusCode();
			     Log.i(Tag, "resCode = " + statusCode); 
			     Message handmsg = new Message();
			     if (statusCode != HttpStatus.SC_OK) { 
			    	// throw new IllegalStateException("Method failed: " + response.getStatusLine().toString()); 
			    	 handmsg.what = BACKCODEFAILED;
			    	 handmsg.obj = "网络错误，注册失败，请重试";
			    	 mRegisteHandler.sendMessage(handmsg);
			    	 
			    	 return;
			     } 
			     
			     String notifystr = EntityUtils.toString(response.getEntity(), "utf-8");
			     Log.i(Tag, notifystr);
			     JSONObject json =null;
			     try {
					json = new JSONObject(notifystr);
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			     
			     Long result = null;
			     JSONObject youaiuser = null;
			     
			     String msg="";
			     
			     try {
					result = json.getLong("result");
					
				    msg = json.getString("msg");
				} catch (JSONException e) {
					e.printStackTrace();
				}
			     
			    if(result==0){
			    	try {
			    		youaiuser = new JSONObject(json.getString("youaiuser"));
			    		
			    		handmsg.what = BACKCODESUCCESS;
				    	handmsg.obj = "注册成功";
				    	mRegisteHandler.sendMessage(handmsg);
				    	 
					} catch (JSONException e) {
						e.printStackTrace();
					}
			     return;
			    }else{
			    	
			    	handmsg.what = BACKCODEFAILED;
			    	handmsg.obj = msg;
			    	mRegisteHandler.sendMessage(handmsg);
			    	
			    }
			 				
			 } catch (UnsupportedEncodingException e) {
			     e.printStackTrace();
			 } catch (ClientProtocolException e) {
			     e.printStackTrace();
			 } catch (IOException e) {
			     e.printStackTrace();
			 }
		}
	};

	@Override
	public void onDismiss(DialogInterface dialog) {
		isShowRegiste = false;
	}
	
	
	public static boolean checkEmail(String email)
	{// 验证邮箱的正则表达式 
		String format = "\\p{Alpha}\\w{2,15}[@][a-z0-9]{3,}[.]\\p{Lower}{2,}";
		//p{Alpha}:内容是必选的，和字母字符[\p{Lower}\p{Upper}]等价。如：200896@163.com不是合法的。
		//w{2,15}: 2~15个[a-zA-Z_0-9]字符；w{}内容是必选的。 如：dyh@152.com是合法的。
		//[a-z0-9]{3,}：至少三个[a-z0-9]字符,[]内的是必选的；如：dyh200896@16.com是不合法的。
		//[.]:'.'号时必选的；	如：dyh200896@163com是不合法的。
		//p{Lower}{2,}小写字母，两个以上。如：dyh200896@163.c是不合法的。
		if (email.matches(format))
			{ 
				return true;// 邮箱名合法，返回true 
			}
		else
			{
				return false;// 邮箱名不合法，返回false
			}
	} 
	
	
}
