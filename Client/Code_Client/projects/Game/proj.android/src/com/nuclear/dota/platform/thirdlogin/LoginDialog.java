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
import android.content.Context;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Gravity;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.RelativeLayout;
import android.widget.TextView;

import com.qsds.ggg.dfgdfg.fvfvf.R;

public class LoginDialog extends Dialog implements View.OnClickListener {
	Context context;
	private Button mLoginButton ;
	private Thread loginThread ;
	private Button mRegisteButton ;
	
	private ImageButton mThirdLoginqq;
	private ImageButton mThirdLogintaobao;
	private ImageButton mThirdLoginrenren;
	private ImageButton mThirdLogindouban;
	private ImageButton mThirdLoginweibo;
	private IThirdLogin mMainInstance;
	private EditText mUserEdit;
	private EditText mPasswordEdit;
	
	private String Tag = LoginDialog.class.toString();
    
	private Activity mActivity;
	
    private TextView mText;
    
    private ThirdUserInfo mLoginDialogUser;
    private LoginCallback LoginReultBack;

	public ThirdUserInfo getmThirdLoginDialogUser() {
		return mLoginDialogUser;
	}
	public void setmLoginDialogUser(ThirdUserInfo pLoginDialogUser) {
		this.mLoginDialogUser = pLoginDialogUser;
	}

	private  boolean isShowRegiste = false;
	
	public boolean isShowRegister(){
		if(isShowRegiste)
			return true;
		
		return false;
	}
    public LoginDialog(Context context) {
        super(context);
        // TODO Auto-generated constructor stub
        this.context = context;
    }
    public LoginDialog(Activity pAcitivity, int theme){
        super(pAcitivity, theme);
        mActivity = pAcitivity;
        this.context = mActivity;
    }
    
    private RelativeLayout mContent; 
    
    @SuppressWarnings("deprecation")
	@Override
    protected void onCreate(Bundle savedInstanceState) {
        // TODO Auto-generated method stub
        super.onCreate(savedInstanceState);
        
       
		/*//this.getWindow().setFeatureDrawableAlpha(Window.FEATURE_OPTIONS_PANEL, 0);  
		 */
        
        requestWindowFeature(Window.FEATURE_NO_TITLE);
        setContentView(R.layout.thirdlogin_dialog);

		
        
		DisplayMetrics dm = new DisplayMetrics();
		mActivity.getWindowManager().getDefaultDisplay().getMetrics(dm);
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
		
        
        
        mLoginButton = (Button) findViewById(R.id.login_bt);
        mLoginButton.setOnClickListener(this);
        mRegisteButton = (Button) findViewById(R.id.login_regeit);
        mRegisteButton.setOnClickListener(this);
        
        mThirdLogindouban = (ImageButton) findViewById(R.id.imageButtondouban);
        mThirdLogindouban.setOnClickListener(this);
        mThirdLoginqq = (ImageButton) findViewById(R.id.imageButtonqq);
        mThirdLoginqq.setOnClickListener(this);
        mThirdLoginrenren = (ImageButton) findViewById(R.id.imageButtonrenren);
        mThirdLoginrenren.setOnClickListener(this);
        mThirdLogintaobao = (ImageButton) findViewById(R.id.imageButtontaobao);
        mThirdLogintaobao.setOnClickListener(this);
        mThirdLoginweibo = (ImageButton) findViewById(R.id.imageButtonweibo);
        mThirdLoginweibo.setOnClickListener(this);
        mText = (TextView)findViewById(R.id.show);
        mUserEdit = (EditText) findViewById(R.id.username);
        mPasswordEdit = (EditText) findViewById(R.id.password);
        
        LoginReultBack = new LoginCallback(){

			@Override
			public void onSuccess() {
				LoginDialog.this.dismiss();
				//Toast.makeText(context, "验证登录成功", Toast.LENGTH_SHORT).show();
				//mLoginDialogUser = null;
				if(mLoginDialogUser!=null){
					
				}else{
				
				mLoginDialogUser = mMainInstance.GetUserInfo();
				if(mLoginDialogUser==null){
					this.onFailed();
				}
				
				}
				
			}

			@Override
			public void onFailed() {
				//Toast.makeText(context, "验证登录失败", Toast.LENGTH_SHORT).show();
				LoginDialog.this.show();
			}
			 
		 };
        
    }
    
    @Override
    public void show() {
    	isShowRegiste = false;
    	super.show();
    }
    
	@Override
	public void onClick(View v) {
		
		 LoginDialog.this.hide();
		
		 if(v.getId()==R.id.login_bt){
			 mMainInstance = new ThirdLoginYouai();
			 if(null!=loginThread){
				 Log.i("status:", "status:"+loginThread.getState());
				 if(loginThread.isInterrupted()){
					  
				 }else if(Thread.State.TERMINATED==loginThread.getState()){
					 loginThread = new Thread(loginRun);
					 loginThread.start();
				 }
			 }else{
			 loginThread = new Thread(loginRun);
			 loginThread.start();
			 }
		 }else if(v.getId()==R.id.login_regeit){
			 isShowRegiste = true;
			 this.dismiss();
		 }else if(v.getId()==R.id.imageButtondouban){
			 
			 mMainInstance =  new ThirdLoginDouban().GetInstance();
			 mMainInstance.setContext(context);
			 mMainInstance.setActivity(mActivity);
			 mMainInstance.authorize(LoginReultBack);
			 
			 
		 }else if(v.getId()==R.id.imageButtonqq){
			 
			 mMainInstance =  new ThirdLoginQQWeb().GetInstance();
			 mMainInstance.setContext(context);
			 mMainInstance.setActivity(mActivity);
			 mMainInstance.authorize(LoginReultBack);
			 
		 }else if(v.getId()==R.id.imageButtonrenren){
			 
			 mMainInstance =  new ThirdLoginRenren().GetInstance();
			 mMainInstance.setContext(context);
			 mMainInstance.setActivity(mActivity);
			 mMainInstance.authorize(LoginReultBack);
			 
		 }else if(v.getId()==R.id.imageButtontaobao){
			 mMainInstance =  new ThirdLoginTaobao().GetInstance();
			 mMainInstance.setContext(context);
			 
			 mMainInstance.authorize(LoginReultBack);
			 
			 
		 }else if(v.getId()==R.id.imageButtonweibo){
			 mMainInstance =  new ThirdLoginWeibo().GetInstance();
			 mMainInstance.setContext(context);
			 
			 mMainInstance.authorize(LoginReultBack);
		 }
		 
	}
	
	interface LoginCallback {
		public void onSuccess();
		public void onFailed();
	}
	
	private Runnable loginRun = new Runnable() {
		
		@Override
		public void run() {
			// TODO Auto-generated method stub
			 LinkedList<BasicNameValuePair> params = new LinkedList<BasicNameValuePair>();
			 params.add(new BasicNameValuePair("userName", mUserEdit.getText().toString()));
			 params.add(new BasicNameValuePair("passWord", mPasswordEdit.getText().toString()));
			 
			 
			 int REQUEST_TIMEOUT = 10*1000; 
			 int SO_TIMEOUT = 10*1000;  
			   
			BasicHttpParams httpParams = new BasicHttpParams();
			HttpConnectionParams.setConnectionTimeout(httpParams, REQUEST_TIMEOUT);
			HttpConnectionParams.setSoTimeout(httpParams, SO_TIMEOUT);
			HttpClient httpClient = new DefaultHttpClient(httpParams);
			   
			 try {
				 HttpGet getMethod = new HttpGet("http://192.168.1.8:8080/AccountCenterYouai/login?"+"userName="+ mUserEdit.getText().toString()+
						 "&passWord="+mPasswordEdit.getText().toString());
			    // HttpPost postMethod = new HttpPost("http://192.168.2.141:8080/AccountCenterYouai/login/");
				 
				// postMethod.setEntity(new UrlEncodedFormEntity(params, "utf-8")); 
			     HttpResponse response = httpClient.execute(getMethod); 
			     int statusCode = response.getStatusLine().getStatusCode();
			     Log.i(Tag, "resCode = " + statusCode); 
			     
			     if (statusCode != HttpStatus.SC_OK) { 
			    	// throw new IllegalStateException("Method failed: " + response.getStatusLine().toString()); 
			    	
			    	 LoginReultBack.onFailed();
			    	 return;
			     } 
			     
			     String notifystr = EntityUtils.toString(response.getEntity(), "utf-8");
			     Log.i("notifystr", notifystr);
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
			    		
					} catch (JSONException e) {
						e.printStackTrace();
					}
			    	 
			    	mLoginDialogUser = new ThirdUserInfo();
			    	try {
			    	mLoginDialogUser.setNickname((String)youaiuser.get("userName"));
			    	mLoginDialogUser.setUid((Long)youaiuser.get("registTime"));
			    	mLoginDialogUser.setUidStr(String.valueOf((Long)(youaiuser.get("registTime"))));
			    	LoginReultBack.onSuccess();
			    	 
			    	}catch (JSONException e){
			    		LoginReultBack.onFailed();
			    	}
			    	
			    }else{
			    	
			    	 LoginReultBack.onFailed();
			    	 return;
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
	
	
}

