package com.nuclear.sdk.active;

import java.io.IOException;

import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.InputType;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.AppEventsLogger;
import com.facebook.LoggingBehavior;
import com.facebook.Session;
import com.facebook.SessionState;
import com.facebook.Settings;
import com.nuclear.sdk.active.SdkControlCenter.ClickListen;
import com.nuclear.sdk.android.CallbackListener;
import com.nuclear.sdk.android.OAuthChina;
import com.nuclear.sdk.android.OAuthListener;
import com.nuclear.sdk.android.SdkError;
import com.nuclear.sdk.android.api.IUserdApi;
import com.nuclear.sdk.android.api.SdkApi;
import com.nuclear.sdk.android.api.SdkException;
import com.nuclear.sdk.android.api.UserApiSina;
import com.nuclear.sdk.android.api.UserApiTencent;
import com.nuclear.sdk.android.config.DoubanConfig;
import com.nuclear.sdk.android.config.FacebookConfig;
import com.nuclear.sdk.android.config.FatherOAuthConfig;
import com.nuclear.sdk.android.config.QQConfig;
import com.nuclear.sdk.android.config.RenrenConfig;
import com.nuclear.sdk.android.config.SdkConfig;
import com.nuclear.sdk.android.config.SinaConfig;
import com.nuclear.sdk.android.entry.SdkUser;
import com.nuclear.sdk.android.token.FaceBookToken;
import com.nuclear.sdk.android.token.Token;
import com.nuclear.sdk.android.utils.MD5;
import com.nuclear.sdk.android.utils.RSAUtil;
import com.nuclear.sdk.android.utils.ToolsUtil;
import com.nuclear.sdk.android.utils.Utils;
import com.nuclear.sdk.net.RequestListener;
import com.nuclear.sdk.R;


public class SdkLogin extends Activity {
	private ImageButton buttonQQ;//QQ登录
	private ImageButton buttonWeibo;//微博登录
	private ImageButton mLoginFB;
	private ImageView showpassword;
	private boolean isChecked = false;
	
	private ImageButton backBtn;
	private IUserdApi userapi;
	private Button registerBtn;
	private Button loginBtn;
	private TextView findUserTv;
	private ImageView quickDeleteUser;//
	private ImageView quickDeletePass;
	private ImageView quickDeleteEmail;
	public static CallbackListener listener;
	private View thirdLoginLayout;
	private static final String TAG = SdkLogin.class.toString();
	private MyOAuthListener mOAuthListener ;
	private static int nowwhich = -1;//
	static boolean autoLogin = false;
	private int mPosition;
	protected static boolean showRegister = false;
	private AutoCompleteTextView usernameEd;//
	private EditText passwordEd;//
	private EditText emailEd ;//
	private ImageButton buttonRenren;//
	private ImageButton buttonDouban;//
	private ImageButton btnClose;
	
	private EditText  reusernameEd ;//
	private EditText repasswordEd ;//
	private ImageView logineduser ;
	private ProgressBar progressbar;
	protected static SdkUser mRecentnuclearUser;
	private loginViewOnClickListen ClickListen ;
	
	private Button btn_website;
	private Button btn_fbfans;
	private Button btn_loginTry;
	
	private static  String FB_URL_PREFIX_ME = "";
	private static final String FB_URL_TOKEN= "https://graph.facebook.com/me/?access_token=";

	private static final int FBLoginResultS = 20000;
	private static final int FBLoginResultF = 30000;
	private static final int FBLoginStart = 10000;
	private boolean isFBloging = false;
	
	private Handler mHandler = new Handler()
	{
		public void dispatchMessage(android.os.Message msg) {
			switch (msg.what) {
			case FBLoginStart:
				progressbar.setVisibility(View.VISIBLE);
				isFBloging = true;
				break;
			case FBLoginResultS:
				progressbar.setVisibility(View.INVISIBLE);
				isFBloging = false;
				JSONObject jsonback;
				try {
					jsonback = new JSONObject((String)msg.obj);
					Token token = new Token();
					token.setUid(jsonback.getString("id"));
					//token.setUsername(jsonback.getString("username"));
					doThirdLogin(token);
				} catch (JSONException e) {
					e.printStackTrace();
				}
				
				
				break;
			case FBLoginResultF:
				isFBloging = false;
				progressbar.setVisibility(View.INVISIBLE);
				
				break;
			}
			
		}
	};
	
	
	private FatherOAuthConfig[] mConfigs = {
			new QQConfig("100520124", "47dc571f56352ab5e5246d3e53c57c34",
					"http://open.z.qq.com/moc2/success.jsp"),
			new SinaConfig("975989016", "207c7f86b4d98852c04d8a9efb0c5674",
					"http://mxhzw.com/"),
			new DoubanConfig(
					"09c6ec236960982f1d54c46a3c21c88d",
					"78076dfa2875beab",
					"http://mxhzw.com/",
					"shuo_basic_r,shuo_basic_w,douban_basic_common"),
			new RenrenConfig("241271",
					"6a9ab4567a7549c9ba5c70daf5af6f31",
					"http://graph.renren.com/oauth/login_success.html", " read_user_status read_user_album"),
			new FacebookConfig("","",FB_URL_PREFIX_ME, ""),
			};
	
	private Session.StatusCallback statusCallback = new SessionStatusCallback();
	  
	    
	@Override
	protected  void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		AppEventsLogger.activateApp(this,  getString(R.string.app_id));
		
	        
		Bundle bundleIntent = getIntent().getExtras();
	    this.mPosition = bundleIntent.getInt("KEY_POSITION",0);
	    Log.i(TAG, "KEY_POSITION"+mPosition);
		switch (this.mPosition) {
		case 1:
			showLoginView();
			break;
		case 2:
			showBindView();
			break;
		case 3:
			showTryView();
			}
	  	}

	    @Override
	    public void onStop() {
	        super.onStop();
	        Session session =  Session.getActiveSession();
	        if (session!=null) {
	        	session.removeCallback(statusCallback);	
			}
	        
	    }

	    @Override
	    public void onActivityResult(int requestCode, int resultCode, Intent data) {
	        super.onActivityResult(requestCode, resultCode, data);
	        Session.getActiveSession().onActivityResult(this, requestCode, resultCode, data);
	    }

	    @Override
	    protected void onSaveInstanceState(Bundle outState) {
	        super.onSaveInstanceState(outState);
	        Session session = Session.getActiveSession();
	        Session.saveSession(session, outState);
	    }

	
	@Override
	public void onBackPressed() {
		if(!SdkCommplatform.getInstance().isLogined())
		SdkCommplatform.getInstance().LoginTry();
		super.onBackPressed();
		
	}
	public void showTryView(){
		SdkCommplatform.getInstance().innerLoginTry();
		
		SdkLogin.this.setContentView(R.layout.ya_try);
		
		Button intoGame = (Button)findViewById(R.id.intogame);
		Button tryBind = (Button)findViewById(R.id.u2_try_bind);
		TextView tryUser = (TextView)findViewById(R.id.tv_tryuser);
		tryUser.setText(getString(R.string.account)+"UID:"+SdkCommplatform.getInstance().getLoginUin());
		progressbar = (ProgressBar)findViewById(R.id.loadingbar);
		TextView tvChangeuser = (TextView)findViewById(R.id.tv_changeuser);
		intoGame.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				SdkLogin.this.onBackPressed();
			}
		});
		
		tryBind.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				showBindView();
			}
		});
		tvChangeuser.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				if(SdkCommplatform.getInstance().getLoginUser()==null)return;
				progressbar.setVisibility(View.VISIBLE);
				SdkCommplatform.getInstance().nuclearLogoutPopu(SdkLogin.this);
				progressbar.setVisibility(View.GONE);
				SdkLogin.this.finish();
			}
		});
		
	}
	
	private TextView mNowTryUserTv;
	
	public void showBindView(){
		SdkLogin.this.setContentView(R.layout.ya_register_bind);
		bindViewOnClickListen	bindClickListen = new bindViewOnClickListen();
		mNowTryUserTv =(TextView) findViewById(R.id.nowtryuser_tv);
		mNowTryUserTv.setText(getString(R.string.account)+": "+ SdkCommplatform.getInstance().getLoginNickName());
		
		usernameEd = (AutoCompleteTextView)SdkLogin.this. findViewById(R.id.u2_account_login_account);
		passwordEd = (EditText)SdkLogin.this.findViewById(R.id.u2_account_login_password);
		emailEd = (EditText)SdkLogin.this.findViewById(R.id.u2_account_login_email);
		usernameEd.requestFocus();
		Button _loginBtn = (Button)SdkLogin.this. findViewById(R.id.u2_account_login_log);
		Button _registerBtn = (Button)SdkLogin.this. findViewById(R.id.u2_account_login_reg);
		_registerBtn.setVisibility(View.VISIBLE);
		
		quickDeleteUser = (ImageView) SdkLogin.this.findViewById(R.id.quickdelete);
		final ImageView quickDeleteEmail = (ImageView) SdkLogin.this.findViewById(R.id.quickdelete_email);
		quickDeletePass = (ImageView) SdkLogin.this.findViewById(R.id.quickdel_pass);
		ImageButton _btnClose = (ImageButton) SdkLogin.this.findViewById(R.id.u2_title_bar_button_left);
		TextView tvProtocol =  (TextView)SdkLogin.this.findViewById(R.id.u2_account_protocol);
		tvProtocol.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				ProtocalDialog _protocal = new ProtocalDialog(SdkLogin.this);
				_protocal.show();
			}
		});
		
		_btnClose.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				SdkLogin.this.onBackPressed();
			}
		});
		quickDeleteEmail.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				emailEd.setText("");
			}
		});
		quickDeleteUser.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				usernameEd.setText("");
			}
		});
		quickDeletePass.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				passwordEd.setText("");
			}
		});
		emailEd.addTextChangedListener(new TextWatcher() {
			
			@Override
			public void onTextChanged(CharSequence arg0, int arg1, int arg2, int arg3) {
				if(TextUtils.isEmpty(arg0)){
					quickDeleteEmail.setVisibility(View.INVISIBLE);
				}else{
					quickDeleteEmail.setVisibility(View.VISIBLE);
				}				
			}
			
			@Override
			public void beforeTextChanged(CharSequence arg0, int arg1, int arg2,
					int arg3) {
			}
			@Override
			public void afterTextChanged(Editable arg0) {
			}
		});
		usernameEd.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if(TextUtils.isEmpty(s)){
					quickDeleteUser.setVisibility(View.INVISIBLE);
				}else{
					quickDeleteUser.setVisibility(View.VISIBLE);
				}
			}
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}
			@Override
			public void afterTextChanged(Editable s) {
			}
		});
		passwordEd.addTextChangedListener(new TextWatcher() {
			
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if(TextUtils.isEmpty(s)){
					quickDeletePass.setVisibility(View.INVISIBLE);
				}else{
					quickDeletePass.setVisibility(View.VISIBLE);
				}
			}
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}
			@Override
			public void afterTextChanged(Editable s) {
			}
		});
		 
		_loginBtn.setOnClickListener(bindClickListen);
		_registerBtn.setOnClickListener(bindClickListen);
		 
		 
	}
	
	public void showLoginView(){
			
		SdkLogin.this.setContentView(R.layout.ya_account_login);
		ClickListen = new loginViewOnClickListen();
		
		usernameEd = (AutoCompleteTextView)SdkLogin.this. findViewById(R.id.u2_account_login_account);
		passwordEd = (EditText)SdkLogin.this.findViewById(R.id.u2_account_login_password);
		loginBtn = (Button)SdkLogin.this. findViewById(R.id.u2_account_login_log);
		buttonQQ = (ImageButton)SdkLogin.this. findViewById(R.id.imageButtonqq);
		findUserTv =(TextView)SdkLogin.this. findViewById(R.id.u2_account_forget_password);
		logineduser = (ImageView)SdkLogin.this.findViewById(R.id.logineduser);//右键头按钮查看登录的用户
		buttonWeibo = (ImageButton)SdkLogin.this. findViewById(R.id.imageButtonweibo);
		buttonRenren = (ImageButton)SdkLogin.this.findViewById(R.id.imageButtonrenren);
		registerBtn = (Button)SdkLogin.this. findViewById(R.id.u2_account_login_reg);
		mLoginFB = (ImageButton)SdkLogin.this.findViewById(R.id.imageButtonfb);
		showpassword = (ImageView)SdkLogin.this.findViewById(R.id.showpassword);
		thirdLoginLayout = (View)SdkLogin.this.findViewById(R.id.u2_account_login_other_layout);
		btn_website = (Button)SdkLogin.this.findViewById(R.id.btn_website);
		btn_fbfans = (Button)SdkLogin.this.findViewById(R.id.btn_fbfans);
		btn_loginTry = (Button)SdkLogin.this.findViewById(R.id.u2_account_login_try);
		progressbar =  (ProgressBar)SdkLogin.this.findViewById(R.id.loadingbar);
		
		btn_loginTry.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				 showTryView();
			}
		});
		mLoginFB.setOnClickListener(new LoginClickListen());
		
		
		Settings.addLoggingBehavior(LoggingBehavior.INCLUDE_ACCESS_TOKENS);
		
		
		btn_fbfans.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				WebindexDialog webindexdialog = new WebindexDialog(SdkLogin.this, "");
				webindexdialog.show();
			}
		});
		
		btn_website.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				WebindexDialog webindexdialog = new WebindexDialog(SdkLogin.this, SdkConfig.nuclearWebSite);
				webindexdialog.show();
			}
		});

		/*if(showRegister){
			thirdLoginLayout.setVisibility(View.VISIBLE);
		}else{
			thirdLoginLayout.setVisibility(View.INVISIBLE);
		}*/
		
		buttonDouban = (ImageButton)SdkLogin.this.findViewById(R.id.imageButtondouban);
		backBtn = (ImageButton)SdkLogin.this.findViewById(R.id.u2_title_bar_button_left);
		quickDeleteUser = (ImageView) SdkLogin.this.findViewById(R.id.quickdelete);
		quickDeletePass = (ImageView) SdkLogin.this.findViewById(R.id.quickdel_pass);
		
		showpassword.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View v) {
				isChecked = !isChecked;
				if (isChecked) {
					passwordEd.setInputType(InputType.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD);	
					showpassword.setImageResource(R.drawable.lock_k);
				}else{
					passwordEd.setInputType(InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD);
					showpassword.setImageResource(R.drawable.lock_l);
				}
			}
		});
		quickDeleteUser.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				usernameEd.setText("");
			}
		});
		quickDeletePass.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View v) {
				passwordEd.setText("");
			}
		});
		usernameEd.addTextChangedListener(new TextWatcher() {
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if(TextUtils.isEmpty(s)){
					quickDeleteUser.setVisibility(View.INVISIBLE);
				}else{
					quickDeleteUser.setVisibility(View.VISIBLE);
				}
			}
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count,
					int after) {
			}
			@Override
			public void afterTextChanged(Editable s) {
			}
		});
		passwordEd.addTextChangedListener(new TextWatcher() {
			
			@Override
			public void onTextChanged(CharSequence s, int start, int before, int count) {
				if(TextUtils.isEmpty(s)){
					quickDeletePass.setVisibility(View.INVISIBLE);
				}else{
					quickDeletePass.setVisibility(View.VISIBLE);
				}				
			}
			@Override
			public void beforeTextChanged(CharSequence s, int start, int count, int after) {
			}
			@Override
			public void afterTextChanged(Editable s) {
			}
		});
		 
		buttonQQ.setOnClickListener(ClickListen);
		buttonWeibo.setOnClickListener(ClickListen);
		buttonRenren.setOnClickListener(ClickListen);
		buttonDouban.setOnClickListener(ClickListen);
		loginBtn.setOnClickListener(ClickListen);
		findUserTv.setOnClickListener(ClickListen);
		logineduser.setOnClickListener(ClickListen);
		backBtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
			 SdkLogin.this.onBackPressed();
				 
			}
		});
		
		
		registerBtn.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View arg0) {
			 Log.i(TAG,"quickBtn");
			 SdkLogin.this.setContentView(R.layout.ya_account_register);
			 Button back = (Button) findViewById(R.id.u2_title_bar_button_left);
			 back.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View arg0) {
					SdkLogin.this.showLoginView();
				}
			});
			 reusernameEd = (EditText) findViewById(R.id.u2_account_register_nickname);
			 repasswordEd = (EditText)findViewById(R.id.u2_account_register_password);
			 emailEd = (AutoCompleteTextView)findViewById(R.id.u2_account_register_email);
			 TextView  mTv_Account_Protocol = (TextView)findViewById(R.id.u2_account_protocol);
			 mTv_Account_Protocol.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					
				}
			});
			 progressbar = (ProgressBar)findViewById(R.id.precreatebar);
			 reusernameEd.requestFocus();
			 
			 
			 final Button register = (Button) findViewById(R.id.u2_title_bar_button_right);
			 mTv_Account_Protocol.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View v) {
					ProtocalDialog _protocal = new ProtocalDialog(SdkLogin.this);
					_protocal.show();
				}
			});
			 register.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						
						final String userName  = SdkLogin.this.reusernameEd.getText().toString();
						final String passWord  = SdkLogin.this.repasswordEd.getText().toString();
						String userEmail  = SdkLogin.this.emailEd.getText().toString();
						if(userName==null||userName.equals("")){
							Toast.makeText(SdkLogin.this, R.string.namenull, Toast.LENGTH_SHORT).show();
							return;
						}
						if(passWord==null||passWord.equals("")){
							Toast.makeText(SdkLogin.this, R.string.passwordnull, Toast.LENGTH_SHORT).show();
							return;
						}
						if(userEmail==null||userEmail.equals("")){
							Toast.makeText(SdkLogin.this, getString(R.string.emailnull), Toast.LENGTH_SHORT).show();
							return;
						}
						if(!ToolsUtil.checkAccount(userName)){
							Toast.makeText(SdkLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
							return;
						}else if(!ToolsUtil.checkPassword(passWord)){
							Toast.makeText(SdkLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
							return;
						}else if(userEmail!=null&&!userEmail.equals("")){
							if(!ToolsUtil.checkEmail(userEmail)){
							Toast.makeText(SdkLogin.this, R.string.mailerr, Toast.LENGTH_SHORT).show();
							return;
							}
						}
						register.setClickable(false);
						progressbar.setVisibility(View.VISIBLE);
						String md5sign = null;
						
						JSONObject message = new JSONObject();
						
						
						JSONObject data = new JSONObject(); 
						try {
							data.put("nuclearName", userName);
							data.put("password", passWord); 
							data.put("channel", SdkCommplatform.channelName);
							data.put("email", userEmail!=null?userEmail:"");
							message.put("data", data);
							message.put("header", Utils.makeHead(SdkLogin.this));
						} catch (JSONException e1) {
							e1.printStackTrace();
						}
						String putmessage = "";
						try {
							putmessage = RSAUtil.encryptByPubKey(message.toString(),RSAUtil.pub_key_hand);
						} catch (Exception e1) {
							e1.printStackTrace();
						}
						
						md5sign = MD5.sign(putmessage, SdkConfig.md5key);
						SdkApi.Register(md5sign, putmessage, new RequestListener() {
							
							@Override
							public void onIOException(IOException e) {
								register.setClickable(true);
								SdkLogin.this.progressbar.setVisibility(View.INVISIBLE);
								Toast.makeText(SdkLogin.this, R.string.registererr, Toast.LENGTH_SHORT).show();
							}
							
							@Override
							public void onError(SdkException e) {
								register.setClickable(true);
								SdkLogin.this.progressbar.setVisibility(View.INVISIBLE);
								Toast.makeText(SdkLogin.this,  R.string.registererr, Toast.LENGTH_SHORT).show();
							}
							
							@Override
							public void onComplete(String response) {
								
								listener.onNomalRegister();
								
								String backjson = null;
								try {
									backjson = RSAUtil.decryptByPubKey(response, RSAUtil.pub_key_hand);
									JSONObject jsonback = new JSONObject(backjson);
									
									if(jsonback.getString("error").equals("200")){
										String nuclearId = jsonback.getJSONObject("data").getString("nuclearId");
										
										SdkUser nuclearuser = new SdkUser();
										nuclearId = jsonback.getJSONObject("data").getString("nuclearId");
										
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
											register.setClickable(true);
											SdkLogin.this.progressbar.setVisibility(View.INVISIBLE);
											Toast.makeText(SdkLogin.this, R.string.registeryes, Toast.LENGTH_SHORT).show();
											listener.onLoginSuccess(backjsontosdk);
											SdkLogin.this.finish();
											}
											});
									}else{
										final String errorMessage = jsonback.getString("errorMessage");
										runOnUiThread(new Runnable() {
											@Override
											public void run() {
												register.setClickable(true);
												SdkLogin.this.progressbar.setVisibility(View.INVISIBLE);
												Toast.makeText(SdkLogin.this, getString(R.string.registererr)+  "："+errorMessage, Toast.LENGTH_SHORT).show();
											}
										});
									}
								} catch (Exception e1) {
									//e1.printStackTrace();
									SdkLogin.this.progressbar.setVisibility(View.INVISIBLE);
								}
							}
						});
					}
				});
			}
			
		});
		
	        
		SharedPreferences cofigSharePre = getSharedPreferences("config", 0);
		autoLogin = cofigSharePre.getBoolean("autologin", false);
		
		
		 Session sessionget = Session.getActiveSession();
	        
		    if (sessionget!=null&&sessionget.isOpened()) 
		    {
		        	FB_URL_PREFIX_ME = FB_URL_TOKEN+ sessionget.getAccessToken();
		        	//islogined; can logout
		    } else 
		    {
		        	//islogout; can login
		    }
		    
		if(mRecentnuclearUser!=null){
		usernameEd.setText(mRecentnuclearUser.getUsername());
		passwordEd.setText(mRecentnuclearUser.getPassword());
		}
		usernameEd.requestFocus();
		((InputMethodManager) getSystemService(INPUT_METHOD_SERVICE))
        .hideSoftInputFromWindow(this
                        .getCurrentFocus().getWindowToken(),
                        InputMethodManager.HIDE_NOT_ALWAYS);
	    	
		
	 

	}
		
		
	class loginViewOnClickListen implements OnClickListener{

		@Override
		public void onClick(View clview) {
			 if(clview.getId()==R.id.u2_account_login_log){
				 
				final String userName  = SdkLogin.this.usernameEd.getText().toString();
				final String passWord  = SdkLogin.this.passwordEd.getText().toString();
				final ProgressBar loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
				
				if(userName==null||userName.equals("")){
					Toast.makeText(SdkLogin.this, R.string.namenull, Toast.LENGTH_SHORT).show();
					return ;
				}else if(passWord==null||passWord.equals("")){
					Toast.makeText(SdkLogin.this, R.string.passwordnull, Toast.LENGTH_SHORT).show();
					return;
				}
				else if(!ToolsUtil.checkAccount(userName)){
					Toast.makeText(SdkLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
					return;
				}else if(!ToolsUtil.checkPassword(passWord)){
					Toast.makeText(SdkLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
					return;
				}
			
				loginingbar.setVisibility(View.VISIBLE);
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
				try {
					data.put("nuclearName", userName); 
					data.put("password", passWord); 
					message.put("data", data);
					message.put("header", Utils.makeHead(SdkLogin.this));
				
				
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
								Toast.makeText(SdkLogin.this, R.string.loginfailnet, Toast.LENGTH_SHORT).show();		
							}
						});
						
					}
					
					@Override
					public void onError(SdkException e) {
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkLogin.this, R.string.loginfailnet, Toast.LENGTH_SHORT).show();		
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
								
								LayoutInflater inflater = LayoutInflater.from(SdkLogin.this);
					            View view = inflater.inflate(R.layout.ya_toast, (ViewGroup)findViewById(R.id.toast_layout_root));
					            TextView textView = (TextView) view.findViewById(R.id.welcome);
					            textView.setText(SdkCommplatform.getInstance().getLoginNickName()+","+getString(R.string.welcome)+" ！");
					            Toast toast = new Toast(SdkLogin.this);
					            toast.setDuration(Toast.LENGTH_LONG);
					            toast.setView(view);
					            toast.setGravity(Gravity.TOP, Gravity.CENTER, 50);
					            toast.show();
					            
								listener.onLoginSuccess(backjsontosdk);
								SdkLogin.this.onBackPressed();
								}
								});
							}else{
								final String errorMessage = jsonback.getString("errorMessage");
								
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										loginingbar.setVisibility(View.GONE);
										listener.onLoginError(new SdkError(errorMessage));
										Toast.makeText(SdkLogin.this,getString(R.string.loginfail)+ "："+errorMessage, Toast.LENGTH_SHORT).show();
									}
								});
								
							}
							
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				});
				
				 return;
			 }else if(clview.getId()==R.id.u2_account_forget_password){
				 SdkLogin.this.setContentView(R.layout.ya_find_pass);
				 final EditText userNameET  = (EditText) findViewById(R.id.u2_account_et);
				 Button backBtn = (Button) findViewById(R.id.u2_back_btn);
				 Button findPassBtn = (Button) findViewById(R.id.u2_find_pass);
				 findPassBtn.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						String md5sign = null;
						JSONObject message = new JSONObject();
						JSONObject data = new JSONObject();
						try {
							data.put("nuclear_name", userNameET.getText().toString());
							message.put("data", data);
							message.put("header",Utils.makeHead(SdkLogin.this));
						} catch (JSONException e1) {
							e1.printStackTrace();
						}

						String putmessage = "";
						try {
							putmessage = RSAUtil.encryptByPubKey(message.toString(),
									RSAUtil.pub_key_hand);
						} catch (Exception e1) {
							e1.printStackTrace();
						}

						md5sign = MD5.sign(putmessage, SdkConfig.md5key);

						SdkApi.findPass(putmessage, md5sign, new RequestListener() 
						{

							@Override
							public void onComplete(final String response) {
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										Toast.makeText(SdkLogin.this, response, Toast.LENGTH_SHORT).show();
									}
								});
							}

							@Override
							public void onIOException(IOException e) {
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										Toast.makeText(SdkLogin.this, R.string.netwarning, Toast.LENGTH_SHORT).show();
									}
								});
							}

							@Override
							public void onError(SdkException e) {
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										Toast.makeText(SdkLogin.this, R.string.netwarning, Toast.LENGTH_SHORT).show();
									}
								});
							}
							
						});
					}
				});
				 backBtn.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						SdkLogin.this.showLoginView();
					}
				});
						 
				 return;
			 }else if(clview.getId()==R.id.logineduser){
				 new UserDialog(SdkLogin.this,SdkLogin.this.usernameEd,SdkLogin.this.passwordEd).show();
				 
				 return;
			 }else  if(clview.getId()==R.id.imageButtonqq){
				nowwhich = 0;
			}else if(clview.getId()==R.id.imageButtonweibo){
				nowwhich = 1;
			}else if(clview.getId()==R.id.imageButtondouban){
				Log.i(TAG, "onClick douban");
				nowwhich = 2;
			}else if(clview.getId()==R.id.imageButtonrenren){
				nowwhich = 3;
			}else if(clview.getId()==R.id.imageButtonfb){
				nowwhich = 4;
				 Session session = Session.getActiveSession();
			        if (session!=null&&session.isOpened()) {
			        	OAuthChina oauthChina = new OAuthChina(SdkLogin.this,mConfigs[nowwhich]);
						Token token = oauthChina.getToken();
						token.setAccessToken(session.getAccessToken());
			        }else{
			        	onClickLogin();
			        }
				
				return;
			}
			 
			OAuthChina oauthChina = new OAuthChina(SdkLogin.this,mConfigs[nowwhich]);
			mOAuthListener = new MyOAuthListener();
			Token token = oauthChina.getToken();
			if (token != null) {
				if (token.isSessionValid()&autoLogin) {
					doThirdLogin(token);
				} else {
					oauthChina.startOAuth(mOAuthListener);
					//oauthChina.refreshToken(
					//		token.getRefreshToken(), mOAuthListener);
				}
			} else {
				oauthChina.startOAuth(mOAuthListener);
			}
		
			
		}
		
	}
	
	class bindViewOnClickListen implements OnClickListener{

		@Override
		public void onClick(View clview) {
			 if(clview.getId()==R.id.u2_account_login_reg){
				 final String userName  = SdkLogin.this.usernameEd.getText().toString();
				 final String passWord  = SdkLogin.this.passwordEd.getText().toString();
				 final String emailstr = SdkLogin.this.emailEd.getText().toString();
					final ProgressBar loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
					
					if(userName==null||userName.equals("")){
						Toast.makeText(SdkLogin.this, getString(R.string.namenull), Toast.LENGTH_SHORT).show();
						return ;
					}else if(passWord==null||passWord.equals("")){
						Toast.makeText(SdkLogin.this, getString(R.string.passwordnull), Toast.LENGTH_SHORT).show();
						return;
					}else if(emailstr==null||emailstr.equals("")){
						Toast.makeText(SdkLogin.this, getString(R.string.emailnull), Toast.LENGTH_SHORT).show();
						return;
					}
					else if(!ToolsUtil.checkAccount(userName)){
						Toast.makeText(SdkLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
						return;
					}else if(!ToolsUtil.checkPassword(passWord)){
						Toast.makeText(SdkLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
						return;
					}else if((!emailstr.equals(""))&&!ToolsUtil.checkEmail(emailstr)){
						Toast.makeText(SdkLogin.this, R.string.mailerr, Toast.LENGTH_SHORT).show();
						return;
					}
				
					loginingbar.setVisibility(View.VISIBLE);
					JSONObject message = new JSONObject();
					JSONObject data = new JSONObject(); 
					try {
						data.put("nuclearId", SdkCommplatform.getInstance().getLoginUin());
						data.put("nuclearName", userName); 
						data.put("channel", SdkCommplatform.channelName);
						data.put("oldPassword", "");
						data.put("password", passWord);
						data.put("email", emailstr);
						data.put("isGuestConversion", 1);
						data.put("isInitPassword", 1);
						message.put("data", data);
						message.put("header", Utils.makeHead(SdkLogin.this));
					
					
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					
					SdkUser _newBindUser = SdkCommplatform.getInstance().getLoginUser();
					_newBindUser.setPassword(passWord);
					_newBindUser.setUsername(userName);
					_newBindUser.setEmail(emailstr);
					_newBindUser.setUserType("3");
					_newBindUser.setIsLocalLogout("0");
					final SdkUser newBindUser = _newBindUser;
					
					//nuclearId - 游客账号的有爱Id	boundnuclearName - 被绑定的账号的userName  boundPassword - 被绑定的账号的密码
					SdkApi.TryToOk(message.toString(), new RequestListener() {
						
						@Override
						public void onIOException(IOException e) {
							
							runOnUiThread(new Runnable() {
								
								@Override
								public void run() {
									loginingbar.setVisibility(View.GONE);
									Toast.makeText(SdkLogin.this, R.string.registfailnet, Toast.LENGTH_SHORT).show();		
								}
							});
							
						}
						
						@Override
						public void onError(SdkException e) {
							runOnUiThread(new Runnable() {
								@Override
								public void run() {
									loginingbar.setVisibility(View.GONE);
									Toast.makeText(SdkLogin.this, R.string.registfailnet, Toast.LENGTH_SHORT).show();		
								}
							});
						}
						
						@Override
						public void onComplete(String response) {
							
							
							JSONObject jsonback = null;
							String error = null;
							try {
								jsonback  = new JSONObject(response);
								error = jsonback.getString("error");
								if(error.equals("200")){
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
									loginingbar.setVisibility(View.GONE);
									
									SdkCommplatform.getInstance().setLoginUser(newBindUser);
									SdkLogin.this.onBackPressed();
									SdkCommplatform.getInstance().notifyBind(true);
									
									}
									});
								}else{
									final String errorMessage = jsonback.getString("errorMessage");
									
									runOnUiThread(new Runnable() {
										@Override
										public void run() {
											loginingbar.setVisibility(View.GONE);
											listener.onLoginError(new SdkError(errorMessage));
											Toast.makeText(SdkLogin.this, getString(R.string.registererr)+"："+errorMessage, Toast.LENGTH_SHORT).show();
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
			 
			 
			 if(clview.getId()==R.id.u2_account_login_log){
				 
				final String userName  = SdkLogin.this.usernameEd.getText().toString();
				final String passWord  = SdkLogin.this.passwordEd.getText().toString();
				final ProgressBar loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
				
				if(userName==null||userName.equals("")){
					Toast.makeText(SdkLogin.this, R.string.namenull, Toast.LENGTH_SHORT).show();
					return ;
				}else if(passWord==null||passWord.equals("")){
					Toast.makeText(SdkLogin.this, R.string.passwordnull, Toast.LENGTH_SHORT).show();
					return;
				}
				else if(!ToolsUtil.checkAccount(userName)){
					Toast.makeText(SdkLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
					return;
				}else if(!ToolsUtil.checkPassword(passWord)){
					Toast.makeText(SdkLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
					return;
				}
			
				loginingbar.setVisibility(View.VISIBLE);
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
				try {
					data.put("guestnuclearId", SdkCommplatform.getInstance().getLoginUin());
					data.put("boundnuclearName", userName); 
					data.put("boundPassword", passWord); 
					message.put("data", data);
					message.put("header", Utils.makeHead(SdkLogin.this));
				
				
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				//nuclearId - 游客账号的有爱Id	boundnuclearName - 被绑定的账号的userName  boundPassword - 被绑定的账号的密码
				SdkApi.TryBinding(message.toString(), new RequestListener() {
					
					@Override
					public void onIOException(IOException e) {
						
						runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkLogin.this, R.string.bindneterr, Toast.LENGTH_SHORT).show();		
							}
						});
						
					}
					
					@Override
					public void onError(SdkException e) {
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkLogin.this, R.string.bindneterr, Toast.LENGTH_SHORT).show();		
							}
						});
					}
					
					@Override
					public void onComplete(String response) {
						
						
						JSONObject jsonback = null;
						String error = null;
						try {
							jsonback  = new JSONObject(response);
							error = jsonback.getString("error");
							if(error.equals("200")){
							final String backjsontosdk = jsonback.toString();
							runOnUiThread(new Runnable() {
								@Override
								public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkLogin.this, getString(R.string.bindsuccess)+"："+backjsontosdk,Toast.LENGTH_SHORT).show();
								listener.onLoginSuccess(backjsontosdk);
								SdkLogin.this.onBackPressed();
								}
								});
							}else{
								final String errorMessage = jsonback.getString("errorMessage");
								
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										loginingbar.setVisibility(View.GONE);
										listener.onLoginError(new SdkError(errorMessage));
										Toast.makeText(SdkLogin.this, getString(R.string.binderr)+"："+errorMessage, Toast.LENGTH_SHORT).show();
									}
								});
								
							}
							
						} catch (JSONException e) {
							e.printStackTrace();
						}
					}
				});
				
				 return;
			 }else if(clview.getId()==R.id.u2_account_forget_password){
				 WebindexDialog findpass = new WebindexDialog(SdkLogin.this, SdkConfig.WebsiteIndex);
				 findpass.show();
				 
				 return;
			 }else if(clview.getId()==R.id.logineduser){
				 new UserDialog(SdkLogin.this,SdkLogin.this.usernameEd,SdkLogin.this.passwordEd).show();
				 
				 return;
			 }
			 
		}
		
	}
	
	private void showFbCenterView()
	{
		SdkCommplatform.getInstance().innerFbEnterAccoutManager();
		
	}
	
	public void thirdLogin(String message){
		final ProgressBar	loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
		loginingbar.setVisibility(View.VISIBLE);
		
		SdkApi.thirdLogin(message, new RequestListener() {
			
			@Override
			public void onIOException(IOException e) {
				
				runOnUiThread(new Runnable() {
					
					@Override
					public void run() {
						loginingbar.setVisibility(View.GONE);
						Toast.makeText(SdkLogin.this, R.string.loginfail, Toast.LENGTH_SHORT).show();		
					}
				});
				
			}
			
			@Override
			public void onError(SdkException e) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						loginingbar.setVisibility(View.GONE);
						Toast.makeText(SdkLogin.this, R.string.loginfail, Toast.LENGTH_SHORT).show();
					}
				});
			}
			
			@Override
			public void onComplete(String response) {
				
				
				JSONObject jsonback = null;
				String error = null;
				String nuclearId = null;
				String username = null;
				String password = null;
				try {
					jsonback  = new JSONObject(response);
					error = jsonback.getString("error");
					if(error.equals("200")){
					SdkUser nuclearuser = new SdkUser();
					nuclearId = jsonback.getJSONObject("data").getString("nuclearId");
					username = jsonback.getJSONObject("data").getString("nuclearName");
					password = jsonback.getJSONObject("data").getString("password");
					nuclearuser.setUserType("1");
					
					nuclearuser.setIsLocalLogout("0");
					nuclearuser.setUsername(username);
					jsonback.put("username", username);                                 
					nuclearuser.setUidStr(nuclearId);
					final String backjsontosdk = jsonback.toString();
					
					if(!password.equals("")&&password!=null){
						nuclearuser.setPassword(password);
						nuclearuser.setIsFirstThird("1");
						SdkCommplatform.getInstance().setThirdLoginUser(nuclearuser);
						SdkCommplatform.getInstance().setLoginUser(nuclearuser);
						SdkControlCenter.thirdLoginFirst = true;
					}else{
						SdkControlCenter.thirdLoginFirst = false;
						SdkCommplatform.getInstance().setLoginUser(nuclearuser);
						SdkCommplatform.getInstance().setThirdLoginUser(nuclearuser);
					}
					final String pasword = password;
					final String userName = username;
					runOnUiThread(new Runnable() {
						@Override
						public void run() {
						usernameEd.setText(userName);
						passwordEd.setText(pasword);
						loginingbar.setVisibility(View.GONE);
						LayoutInflater inflater = LayoutInflater.from(SdkLogin.this);
			            View view = inflater.inflate(R.layout.ya_toast, (ViewGroup)findViewById(R.id.toast_layout_root));
			            TextView textView = (TextView) view.findViewById(R.id.welcome);
			            textView.setText(SdkCommplatform.getInstance().getLoginNickName()+","+getString(R.string.welcome)+" ！");
			            Toast toast = new Toast(SdkLogin.this);
			            toast.setDuration(Toast.LENGTH_LONG);
			            toast.setView(view);
			            toast.setGravity(Gravity.TOP, Gravity.CENTER, 50);
			            toast.show();
			            SdkCommplatform.getInstance().OnSuccesBackJsonStr = backjsontosdk;
			            listener.onLoginSuccess(backjsontosdk);
			            showFbCenterView();
			            SdkLogin.this.finish();
						}
						});
					}else{
						final String errorMessage = jsonback.getString("errorMessage");
						
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								listener.onLoginError(new SdkError(errorMessage));
								Toast.makeText(SdkLogin.this, getString(R.string.loginfail)+":"+errorMessage, Toast.LENGTH_SHORT).show();
							}
						});
						
					}
					
				} catch (JSONException e) {
					e.printStackTrace();
				}
			}
		});
	}

	class MyOAuthListener implements OAuthListener {

		 

		public MyOAuthListener() {
			 
		}

		@Override
		public void onSuccess(Token token) {
		switch (nowwhich) {
		case 0:
			userapi = new UserApiTencent(token);
			 
			break;
		case 1:
			userapi = new UserApiSina(token,mConfigs[1].appKey);
			break;
		 
		}
		doThirdLogin(token);
		
	/*	
		userapi.getMeUser(new RequestListener() {
			
			@Override
			public void onIOException(IOException e) {
				// TODO Auto-generated method stub
				
			}
			
			@Override
			public void onError(nuclearException e) {
				// TODO Auto-generated method stub
				
				listener.onLoginError(new nuclearError(e.getStatusCode(), e.toString()));
		    	
			}
			
			@Override
			public void onComplete(String response) {
				switch (nowwhich) {
				case 0:
					try {
						JSONObject jsobj = new JSONObject(response);
						String name =(String) jsobj.get("nickname");
						String ret =(String) jsobj.get("ret");
						String msg =(String) jsobj.get("msg");
						
						 Bundle backBundle = new Bundle();
					     backBundle.putString("result", ""+name);
					     backBundle.putString("msg", msg);
					     
					 	listener.onLoginSuccess("��¼�ɹ�");
				    	//nuclearLogin.this.finish();
				    	
					} catch (JSONException e) {
						e.printStackTrace();
					}
					
					break;
				case 1:
					try {
						JSONObject jsobj = new JSONObject(response);
						String name = (String)jsobj.get("screen_name");
						String code = (String)jsobj.get("error_code");
						jsobj.get("error");
						 Bundle backBundle = new Bundle();
					     backBundle.putString("result", ""+name);
					     backBundle.putString("msg", code);
					 	 listener.onLoginSuccess("��¼�ɹ�");
				    	 //nuclearLogin.this.finish();
					} catch (JSONException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
					
					break;
				}
			}
		});*/
		
		
			
			
		}
		
		@Override
		public void onError(String error) {
			 
		}

		@Override
		public void onCancel() {
		 

		}
	};
	
	private void doThirdLogin(Token ptoken){
		if(nowwhich == 0){
			//Bundle backBundle = new Bundle();
		   //backBundle.putString("uid", token.getUid());
		 	
		    JSONObject message = new JSONObject();
			JSONObject data = new JSONObject(); 
					try {
						data.put("thirdId", ptoken.getUid()); 
						data.put("platform", SdkConfig.THIRD_PLATFORM.QQ.ordinal());
						data.put("nickName", ""); 
						data.put("channel", SdkCommplatform.channelName);
						message.put("data", data);
						message.put("header", Utils.makeHead(SdkLogin.this));
						thirdLogin(message.toString());
					
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					
		}
		else if(nowwhich ==1){
			//Bundle backBundle = new Bundle();
		   //  backBundle.putString("uid", token.getUid());
		 	
		     JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
					try {
						data.put("thirdId", ptoken.getUid()); 
						data.put("platform", SdkConfig.THIRD_PLATFORM.SINA.ordinal());
						data.put("channel", SdkCommplatform.channelName);
						message.put("data", data);
						data.put("nickName", "");
						message.put("header", Utils.makeHead(SdkLogin.this));
						thirdLogin(message.toString());
					
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
		}
		else if(nowwhich==2){
			// Bundle backBundle = new Bundle();
		  //   backBundle.putString("username:", ""+token.getUsername());
		  //   backBundle.putString("uid", token.getUid());
		 	
		    JSONObject message = new JSONObject();
			JSONObject data = new JSONObject(); 
				try {
					data.put("thirdId", ptoken.getUid()); 
					data.put("nickName", "");
					data.put("platform", SdkConfig.THIRD_PLATFORM.DOUBAN.ordinal());
					data.put("channel", SdkCommplatform.channelName);
					message.put("data", data);
					message.put("header", Utils.makeHead(SdkLogin.this));
					thirdLogin(message.toString());
				
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
	    	 
	    	return;
		}else if(nowwhich==3){
			// Bundle backBundle = new Bundle();
		  //   backBundle.putString("username:", ""+token.getUsername());
		  //   backBundle.putString("uid", token.getUid());
		 	
			    JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
					try {
						data.put("thirdId", ptoken.getUid()); 
						data.put("nickName", ""); 
						data.put("platform", SdkConfig.THIRD_PLATFORM.RENREN.ordinal());
						data.put("channel", SdkCommplatform.channelName);
						message.put("data", data);
						message.put("header", Utils.makeHead(SdkLogin.this));
						thirdLogin(message.toString());
					
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
	    	 
	    	return;
		}else if(nowwhich==4){
			// Bundle backBundle = new Bundle();
			  //   backBundle.putString("username:", ""+token.getUsername());
			  //   backBundle.putString("uid", token.getUid());
			 	
				    JSONObject message = new JSONObject();
					JSONObject data = new JSONObject(); 
						try {
							data.put("thirdId", ptoken.getUid()); 
							data.put("nickName", ""); 
							data.put("platform", SdkConfig.THIRD_PLATFORM.FACKBOOK.ordinal());
							data.put("channel", SdkCommplatform.channelName);
							message.put("data", data);
							message.put("header", Utils.makeHead(SdkLogin.this));
							thirdLogin(message.toString());
						
						} catch (JSONException e1) {
							e1.printStackTrace();
						}
		    	 
		    	return;
		}
	}
	
	 private class SessionStatusCallback implements Session.StatusCallback {
	        @Override
	        public void call(Session session, SessionState state, Exception exception) {
	        	 Session sessionget = Session.getActiveSession();
	 	        if (isFBloging) {
					return;
				}
	 	        
	 	        if (sessionget.isOpened()) {
	 	        	FB_URL_PREFIX_ME = FB_URL_TOKEN+ session.getAccessToken();
	 	        	//islogined; can logout
	 	        	nowwhich = 4;
	 	        	OAuthChina oauthChina = new OAuthChina(SdkLogin.this,mConfigs[nowwhich]);
	 	        	oauthChina.getToken();
					Token token = oauthChina.getToken();
					String _fbtoken = sessionget.getAccessToken();
		        	getFBUserInfo();
					
	 	        } else {
	 	        	//islogout; can login
	 	        }
	        }
	    }
	 
	 private void getFBUserInfo(){
		 mHandler.sendEmptyMessage(FBLoginStart);
		 new Thread(){
			 
			 public void run() {
				HttpGet poster = new HttpGet(FB_URL_PREFIX_ME);
				HttpClient client = new DefaultHttpClient();
				try {
					HttpResponse response = client.execute(poster);
					
					int statusCode = response.getStatusLine().getStatusCode(); 
					if(statusCode == HttpStatus.SC_OK)
			        {
						String responseJson = EntityUtils.toString(response.getEntity());	
						Message msg = new Message();
						msg.obj = responseJson;
						msg.what = FBLoginResultS;
						mHandler.sendMessage(msg);
						
			        }else{
			        	mHandler.sendEmptyMessage(FBLoginResultF);
			        }
					
				} catch (ClientProtocolException e) {
					mHandler.sendEmptyMessage(FBLoginResultF);
					e.printStackTrace();
				} catch (IOException e) {
					mHandler.sendEmptyMessage(FBLoginResultF);
					e.printStackTrace();
				}
				
			 }
			 
		 }.start();
	 }
	 
	 private void onClickLogin() {
	        Session session = Session.getActiveSession();
	        if (!session.isOpened() && !session.isClosed()) {
	            session.openForRead(new Session.OpenRequest(SdkLogin.this).setCallback(statusCallback));
	        } else {
	            Session.openActiveSession(SdkLogin.this, true, statusCallback);
	        }
	    }


	
	class LoginClickListen implements View.OnClickListener{

		@Override
		public void onClick(View v) {
			if (v.getId()==mLoginFB.getId()) {
				 Session session = Session.getActiveSession();
			        if (session!=null) {
			        	session.addCallback(statusCallback);	
					}
			        
				 Bundle savedInstanceState = SdkLogin.this.getIntent().getExtras();
			        if (session == null) {
			            if (savedInstanceState != null) {
			                session = Session.restoreSession(SdkLogin.this, null, statusCallback, savedInstanceState);
			            }
			            if (session == null) {
			                session = new Session(SdkLogin.this);
			            }
			            Session.setActiveSession(session);
			            if (session.getState().equals(SessionState.CREATED_TOKEN_LOADED)) {
			                session.openForRead(new Session.OpenRequest(SdkLogin.this).setCallback(statusCallback));
			            }
			        }
			        
			        
			        Session.getActiveSession().addCallback(statusCallback);
			        
				onClickLogin();
			        
			}
		}
	}

	private void onClickLogoutFB() {
	        Session session = Session.getActiveSession();
	        if (!session.isClosed()) {
	            session.closeAndClearTokenInformation();
	        }
	    }
	   
	
	
	 

}
