package com.nuclear.sdk.active;

import java.io.IOException;
import java.util.ArrayList;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.text.Editable;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.nuclear.sdk.android.CallbackListener;
import com.nuclear.sdk.android.SdkError;
import com.nuclear.sdk.android.api.SdkApi;
import com.nuclear.sdk.android.api.SdkException;
import com.nuclear.sdk.android.entry.SdkUser;
import com.nuclear.sdk.android.utils.ToolsUtil;
import com.nuclear.sdk.android.utils.Utils;
import com.nuclear.sdk.net.RequestListener;
import com.nuclear.sdk.R;

public class SdkLoginMain extends Activity {
	
	public static CallbackListener listener;

	private AutoCompleteTextView usernameEd;
	private EditText passwordEd;
	private Button registerBtn;
	private Button signBtn;
	private Button mLoginFB;
	private Button mLoginGoogle;
	private ImageButton dropdownBtn;
	private ArrayList<SdkUser> allnuclearUser = new ArrayList<SdkUser>();
	private ArrayList<SdkUser> okUserList = new ArrayList<SdkUser>();
	private SaveUserHelp savehelp;
	private ImageView mLoginBack;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if(VERSION.SDK_INT>=11){
			setFinishOnTouchOutside(false);  
		}
		 //设置无标题  
		
        requestWindowFeature(Window.FEATURE_NO_TITLE);  
        //设置全屏  
        getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,   
                WindowManager.LayoutParams.FLAG_FULLSCREEN);  
		setContentView(R.layout.ya_login_main);
		SdkCommplatform.getInstance().addActivity(this);
		SdkCommplatform.getInstance().callOnCreate(this);
		savehelp =new SaveUserHelp(this);
		allnuclearUser= savehelp.doDbSelectAll();
		for (SdkUser itemUser : allnuclearUser) {

			// 0 是正式用户，1是第三方登录用户,2是试玩用户
			if (itemUser.getUserType().equals("0")) {

				// 0表示不是本地登出账号，应该自动登录。
				okUserList.add(itemUser);
			}
		}
		UserDialog.nuclearUsers=okUserList;
		init();
		setListener();
	}

	private void init(){
		usernameEd = (AutoCompleteTextView) findViewById(R.id.editUsername);
		passwordEd = (EditText) findViewById(R.id.editPassword);
		dropdownBtn = (ImageButton) findViewById(R.id.bt_dropdown);
		registerBtn = (Button)findViewById(R.id.registBtn);
		signBtn = (Button)findViewById(R.id.signBtn);
		mLoginFB = (Button)findViewById(R.id.btnFacebook);
		mLoginGoogle = (Button)findViewById(R.id.btnGoogle);
		mLoginBack=(ImageView)findViewById(R.id.login_main_back);
	}
	private void setListener() {
		dropdownBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				 
				 new UserDialog(SdkLoginMain.this,SdkLoginMain.this.usernameEd,SdkLoginMain.this.passwordEd).show();				
			}
		});
		registerBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				Intent intent = new Intent(SdkLoginMain.this,SdkRegist.class);
				
				SdkLoginMain.this.startActivity(intent);
			}
		});
		signBtn.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				final String userName  = usernameEd.getText().toString();
				final String passWord  = passwordEd.getText().toString();
				final ProgressBar loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
				
				if(userName==null||userName.equals("")){
					Toast.makeText(SdkLoginMain.this, R.string.namenull, Toast.LENGTH_SHORT).show();
					return ;
				}else if(passWord==null||passWord.equals("")){
					Toast.makeText(SdkLoginMain.this, R.string.passwordnull, Toast.LENGTH_SHORT).show();
					return;
				}
				else if(!ToolsUtil.checkAccount(userName)){
					Toast.makeText(SdkLoginMain.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
					return;
				}else if(!ToolsUtil.checkPassword(passWord)){
					Toast.makeText(SdkLoginMain.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
					return;
				}
			
				loginingbar.setVisibility(View.VISIBLE);
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
				try {
					data.put("nuclearName", userName); 
					data.put("password", passWord); 
					message.put("data", data);
					message.put("header", Utils.makeHead(SdkLoginMain.this));
				
				
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				
				SdkApi.Login(message.toString(), new RequestListener() {
					
					@Override
					public void onIOException(IOException e) {
						
						runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkLoginMain.this, R.string.loginfailnet, Toast.LENGTH_SHORT).show();		
							}
						});
						
					}
					
					@Override
					public void onError(SdkException e) {
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkLoginMain.this, R.string.loginfailnet, Toast.LENGTH_SHORT).show();		
							}
						});
					}
					
					@Override
					public void onComplete(String response) {
						
						
						JSONObject jsonback = null;
						String error = null;
						String nuclearId = null;
						try {
							jsonback  = new JSONObject(response);
							error = jsonback.getString("error");
							if(error.equals("200")){
							SdkUser nuclearuser = new SdkUser();
							nuclearId = jsonback.getJSONObject("data").getString("nuclearId");
							nuclearuser.setIsLocalLogout("0");
							nuclearuser.setPassword(passWord);
							nuclearuser.setUsername(userName);
							jsonback.put("username", userName);
							nuclearuser.setUidStr(nuclearId);
							nuclearuser.setUserType("0");
							final String backjsontosdk = jsonback.toString();
							SdkCommplatform.getInstance().setLoginUser(nuclearuser);
							runOnUiThread(new Runnable() {
								@Override
								public void run() {
								loginingbar.setVisibility(View.GONE);
								
								LayoutInflater inflater = LayoutInflater.from(SdkLoginMain.this);
					            View view = inflater.inflate(R.layout.ya_toast, (ViewGroup)findViewById(R.id.toast_layout_root));
					            TextView textView = (TextView) view.findViewById(R.id.welcome);
					            textView.setText(SdkCommplatform.getInstance().getLoginNickName()+","+getString(R.string.welcome)+" ！");
					            Toast toast = new Toast(SdkLoginMain.this);
					            toast.setDuration(Toast.LENGTH_LONG);
					            toast.setView(view);
					            toast.setGravity(Gravity.TOP, Gravity.CENTER, 50);
					            toast.show();
					            
								SdkLogin.listener.onLoginSuccess(backjsontosdk);
								if(!SdkCommplatform.getInstance().isLogined())
									SdkCommplatform.getInstance().LoginTry();
								SdkCommplatform.getInstance().finish();
								}
								});
							}else{
								final String errorMessage = jsonback.getString("errorMessage");
								
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										loginingbar.setVisibility(View.GONE);
										SdkLogin.listener.onLoginError(new SdkError(errorMessage));
										Toast.makeText(SdkLoginMain.this,getString(R.string.loginfail)+ "："+errorMessage, Toast.LENGTH_SHORT).show();
									}
								});
								
							}
							
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				});
				
				 return;
				
			}
		});
		mLoginBack.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				// TODO Auto-generated method stub
			      SdkLoginMain.this.finish();	
			}
		});
		mLoginFB.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				SdkCommplatform.getInstance().facebookLogin(SdkLoginMain.this);
			}
		});
		mLoginGoogle.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				SdkCommplatform.getInstance().googleLogin(SdkLoginMain.this);
				
			}
		});
		
		
	}
	
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		
		SdkCommplatform.getInstance().onActivityResult(this, requestCode, resultCode, data);
		super.onActivityResult(requestCode, resultCode, data);
		
	}
	@Override
	public void onBackPressed() {
		if(!SdkCommplatform.getInstance().isLogined()){
			if(SdkCommplatform.getInstance().mUserCallback!=null){
				SdkCommplatform.getInstance().mUserCallback.onLoginSuccess("");
			}else{
				Toast.makeText(getApplicationContext(), "內存不足，請關閉其他應用再進入本遊戲", Toast.LENGTH_SHORT);
			}
		}
		
		super.onBackPressed();
		
	}
}
