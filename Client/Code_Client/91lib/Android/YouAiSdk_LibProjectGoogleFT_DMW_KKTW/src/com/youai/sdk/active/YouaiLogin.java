package com.youai.sdk.active;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.content.SharedPreferences;
import android.os.Bundle;
import android.service.textservice.SpellCheckerService.Session;
import android.text.Editable;
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

import com.youai.sdk.R;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.OAuthChina;
import com.youai.sdk.android.OAuthListener;
import com.youai.sdk.android.YouaiError;
import com.youai.sdk.android.api.IUserdApi;
import com.youai.sdk.android.api.UserApiSina;
import com.youai.sdk.android.api.UserApiTencent;
import com.youai.sdk.android.api.YouaiApi;
import com.youai.sdk.android.api.YouaiException;
import com.youai.sdk.android.config.DoubanConfig;
import com.youai.sdk.android.config.FacebookConfig;
import com.youai.sdk.android.config.FatherOAuthConfig;
import com.youai.sdk.android.config.QQConfig;
import com.youai.sdk.android.config.RenrenConfig;
import com.youai.sdk.android.config.SinaConfig;
import com.youai.sdk.android.config.YouaiConfig;
import com.youai.sdk.android.entry.YouaiUser;
import com.youai.sdk.android.token.Token;
import com.youai.sdk.android.utils.MD5;
import com.youai.sdk.android.utils.RSAUtil;
import com.youai.sdk.android.utils.ToolsUtil;
import com.youai.sdk.android.utils.Utils;
import com.youai.sdk.net.RequestListener;


public class YouaiLogin extends Activity {
	private ImageButton buttonQQ;//QQ登录
	private ImageButton buttonWeibo;//微博登录
	//private LoginButton loginButtonFB;
	private Button backBtn;
	private IUserdApi userapi;
	private Button registerBtn;
	private Button loginBtn;
	private TextView findUserTv;
	private ImageView quickDeleteUser;//
	private ImageView quickDeletePass;
	private ImageView quickDeleteEmail;
	public static CallbackListener listener;
	private View thirdLoginLayout;
	private static final String TAG = YouaiLogin.class.toString();
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
	protected static YouaiUser mRecentYouaiUser;
	private loginViewOnClickListen ClickListen ;
	
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
			new FacebookConfig("","","https://graph.facebook.com/me/friends?access_token=", ""),
			};
	
	
	   /* private GraphUser fbUser;
	    private UiLifecycleHelper uiHelper;

	    private Session.StatusCallback callback = new Session.StatusCallback() {
	        @Override
	        public void call(Session session, SessionState state, Exception exception) {
	            onSessionStateChange(session, state, exception);
	            if (fbUser!=null) {
	            	 nowwhich = 5;
	 	            OAuthChina oauthChina = new OAuthChina(YouaiLogin.this,mConfigs[nowwhich]);
	 	            Token token = oauthChina.getToken();
	 	            if (fbUser != null&&null!=fbUser.getId()&&!"".equals(fbUser.getId())) {
	 	            	token.setUid(fbUser.getId());
	 	            	token.setUid(fbUser.getUsername());
	 	            	doThirdLogin(token);
	 	            }
				}
	           
	        }
	    };

	    private FacebookDialog.Callback dialogCallback = new FacebookDialog.Callback() {
	        @Override
	        public void onError(FacebookDialog.PendingCall pendingCall, Exception error, Bundle data) {
	            Log.d("HelloFacebook", String.format("Error: %s", error.toString()));
	            
	        }

	        @Override
	        public void onComplete(FacebookDialog.PendingCall pendingCall, Bundle data) {
	            Log.d("HelloFacebook", "Success!");
	            
	        }
	    };*/
	    
	@Override
	protected  void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		 //uiHelper = new UiLifecycleHelper(this, callback);
	    // uiHelper.onCreate(savedInstanceState);
	     
	        
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
		}
	  }
		
	
	 @Override
	    protected void onResume() {
	        super.onResume();
	        //uiHelper.onResume();

	        // Call the 'activateApp' method to log an app event for use in analytics and advertising reporting.  Do so in
	        // the onResume methods of the primary Activities that an app may be launched into.

	       // updateUI();
	    }

	    @Override
	    protected void onSaveInstanceState(Bundle outState) {
	        super.onSaveInstanceState(outState);
	       // uiHelper.onSaveInstanceState(outState);
	    }

	    @Override
	    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
	        super.onActivityResult(requestCode, resultCode, data);
	       // uiHelper.onActivityResult(requestCode, resultCode, data, dialogCallback);
	    }

	    @Override
	    public void onPause() {
	        super.onPause();
	        //uiHelper.onPause();
	    }

	    @Override
	    public void onDestroy() {
	        super.onDestroy();
	        //uiHelper.onDestroy();
	    }

	  /*  private void onSessionStateChange(Session session, SessionState state, Exception exception) {
	        updateUI();
	    }

	    private void updateUI() {
	        Session session = Session.getActiveSession();
	        boolean enableButtons = (session != null && session.isOpened());

	    }*/

	
	
	@Override
	public void onBackPressed() {
		if(!YouaiCommplatform.getInstance().isLogined())
		YouaiCommplatform.getInstance().LoginTry();
		super.onBackPressed();
		
	}

	public void showBindView(){
		YouaiLogin.this.setContentView(R.layout.youai_register_bind);
		bindViewOnClickListen	bindClickListen = new bindViewOnClickListen();
		
		usernameEd = (AutoCompleteTextView)YouaiLogin.this. findViewById(R.id.u2_account_login_account);
		passwordEd = (EditText)YouaiLogin.this.findViewById(R.id.u2_account_login_password);
		emailEd = (EditText)YouaiLogin.this.findViewById(R.id.u2_account_login_email);
		usernameEd.requestFocus();
		Button _loginBtn = (Button)YouaiLogin.this. findViewById(R.id.u2_account_login_log);
		Button _registerBtn = (Button)YouaiLogin.this. findViewById(R.id.u2_account_login_reg);
		_registerBtn.setVisibility(View.VISIBLE);
		
		Button _backBtn = (Button)YouaiLogin.this.findViewById(R.id.u2_title_bar_button_left);
		quickDeleteUser = (ImageView) YouaiLogin.this.findViewById(R.id.quickdelete);
		final ImageView quickDeleteEmail = (ImageView) YouaiLogin.this.findViewById(R.id.quickdelete_email);
		quickDeletePass = (ImageView) YouaiLogin.this.findViewById(R.id.quickdel_pass);
		ImageButton _btnClose = (ImageButton) YouaiLogin.this.findViewById(R.id.button_close);
		_btnClose.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				YouaiLogin.this.onBackPressed();
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
		_backBtn.setOnClickListener(new OnClickListener() {
			@Override
			public void onClick(View arg0) {
			 YouaiLogin.this.onBackPressed();
				 
			}
		});
		 
	}
	
	public void showLoginView(){
			
		YouaiLogin.this.setContentView(R.layout.youai_account_login);
		ClickListen = new loginViewOnClickListen();
		
		usernameEd = (AutoCompleteTextView)YouaiLogin.this. findViewById(R.id.u2_account_login_account);
		passwordEd = (EditText)YouaiLogin.this.findViewById(R.id.u2_account_login_password);
		loginBtn = (Button)YouaiLogin.this. findViewById(R.id.u2_account_login_log);
		buttonQQ = (ImageButton)YouaiLogin.this. findViewById(R.id.imageButtonqq);
		findUserTv =(TextView)YouaiLogin.this. findViewById(R.id.u2_account_forget_password);
		logineduser = (ImageView)YouaiLogin.this.findViewById(R.id.logineduser);//右键头按钮查看登录的用户
		buttonWeibo = (ImageButton)YouaiLogin.this. findViewById(R.id.imageButtonweibo);
		buttonRenren = (ImageButton)YouaiLogin.this.findViewById(R.id.imageButtonrenren);
		registerBtn = (Button)YouaiLogin.this. findViewById(R.id.u2_account_login_reg);
		//loginButtonFB = (LoginButton)YouaiLogin.this.findViewById(R.id.imageButtonfb);
		
		thirdLoginLayout = (View)YouaiLogin.this.findViewById(R.id.u2_account_login_other_layout);
		/*if(showRegister){
			thirdLoginLayout.setVisibility(View.VISIBLE);
		}else{
			thirdLoginLayout.setVisibility(View.INVISIBLE);
		}*/
		
		buttonDouban = (ImageButton)YouaiLogin.this.findViewById(R.id.imageButtondouban);
		backBtn = (Button)YouaiLogin.this.findViewById(R.id.u2_title_bar_button_left);
		quickDeleteUser = (ImageView) YouaiLogin.this.findViewById(R.id.quickdelete);
		quickDeletePass = (ImageView) YouaiLogin.this.findViewById(R.id.quickdel_pass);
		btnClose = (ImageButton) YouaiLogin.this.findViewById(R.id.button_close);
		btnClose.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				YouaiLogin.this.onBackPressed();
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
			 YouaiLogin.this.onBackPressed();
				 
			}
		});
		
		
		registerBtn.setOnClickListener(new OnClickListener(){

			@Override
			public void onClick(View arg0) {
			 Log.i(TAG,"quickBtn");
			 YouaiLogin.this.setContentView(R.layout.youai_account_register);
			 Button back = (Button) findViewById(R.id.u2_title_bar_button_left);
			 back.setOnClickListener(new OnClickListener() {
				
				@Override
				public void onClick(View arg0) {
					YouaiLogin.this.showLoginView();
				}
			});
			 reusernameEd = (EditText) findViewById(R.id.u2_account_register_nickname);
			 repasswordEd = (EditText)findViewById(R.id.u2_account_register_password);
			 emailEd = (AutoCompleteTextView)findViewById(R.id.u2_account_register_email);
			 progressbar = (ProgressBar)findViewById(R.id.precreatebar);
			 reusernameEd.requestFocus();
			/*YouaiApi.preCreate(YouaiLogin.this,new RequestListener() {
			
			@Override
			public void onIOException(IOException e) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						Toast.makeText(YouaiLogin.this, "网络异常登录失败", Toast.LENGTH_SHORT).show();
						progressbar.setVisibility(View.GONE);
					}
				});
			}
			
			@Override
			public void onError(final YouaiException e) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						//Toast.makeText(YouaiLogin.this, "登录失败："+e.toString(), Toast.LENGTH_SHORT).show();
						progressbar.setVisibility(View.GONE);
					}
				});
			}
			
			@Override
			public void onComplete(String response) {
				JSONObject json = null;
				 String youainame = null;
				 String password = null;
				try {
					json = new JSONObject(response);
					String error = json.getString("error");
					final String errorMsg = json.getString("errorMessage");
					if(error.equals("200")){
						youainame = json.getJSONObject("data").getString("youaiName");
						password =  json.getJSONObject("data").getString("password");
					}else {
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								Toast.makeText(YouaiLogin.this, "登录失败："+errorMsg, Toast.LENGTH_SHORT).show();
								progressbar.setVisibility(View.GONE);
								
							}
						});
						return;
					}
				
				} catch (JSONException e) {
					e.printStackTrace();
				}
				final String name = youainame;
				final String pass = password;
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						progressbar.setVisibility(View.GONE);
						reusernameEd.setText(name);
						repasswordEd.setText(pass);
					}
				});
				
			}
		});*/
			 
			 
			 final Button register = (Button) findViewById(R.id.u2_title_bar_button_right);
			
			 	register.setOnClickListener(new OnClickListener() {
					
					@Override
					public void onClick(View v) {
						
						final String userName  = YouaiLogin.this.reusernameEd.getText().toString();
						final String passWord  = YouaiLogin.this.repasswordEd.getText().toString();
						String userEmail  = YouaiLogin.this.emailEd.getText().toString();
						if(userName==null||userName.equals("")){
							Toast.makeText(YouaiLogin.this, R.string.namenull, Toast.LENGTH_SHORT).show();
							return;
						}
						if(passWord==null||passWord.equals("")){
							Toast.makeText(YouaiLogin.this, R.string.passwordnull, Toast.LENGTH_SHORT).show();
							return;
						}
						if(!ToolsUtil.checkAccount(userName)){
							Toast.makeText(YouaiLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
							return;
						}else if(!ToolsUtil.checkPassword(passWord)){
							Toast.makeText(YouaiLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
							return;
						}else if(userEmail!=null&&!userEmail.equals("")){
							if(!ToolsUtil.checkEmail(userEmail)){
							Toast.makeText(YouaiLogin.this, R.string.mailerr, Toast.LENGTH_SHORT).show();
							return;
							}
						}
						register.setClickable(false);
						progressbar.setVisibility(View.VISIBLE);
						String md5sign = null;
						
						JSONObject message = new JSONObject();
						
						
						JSONObject data = new JSONObject(); 
						try {
							data.put("youaiName", userName);
							data.put("password", passWord); 
							data.put("channel", YouaiCommplatform.channelName);
							data.put("email", userEmail!=null?userEmail:"");
							message.put("data", data);
							message.put("header", Utils.makeHead(YouaiLogin.this));
						} catch (JSONException e1) {
							e1.printStackTrace();
						}
						String putmessage = "";
						try {
							putmessage = RSAUtil.encryptByPubKey(message.toString(),RSAUtil.pub_key_hand);
						} catch (Exception e1) {
							e1.printStackTrace();
						}
						
						md5sign = MD5.sign(putmessage, YouaiConfig.md5key);
						YouaiApi.Register(md5sign, putmessage, new RequestListener() {
							
							@Override
							public void onIOException(IOException e) {
								register.setClickable(true);
								YouaiLogin.this.progressbar.setVisibility(View.INVISIBLE);
								Toast.makeText(YouaiLogin.this, R.string.registererr, Toast.LENGTH_SHORT).show();
							}
							
							@Override
							public void onError(YouaiException e) {
								register.setClickable(true);
								YouaiLogin.this.progressbar.setVisibility(View.INVISIBLE);
								Toast.makeText(YouaiLogin.this,  R.string.registererr, Toast.LENGTH_SHORT).show();
							}
							
							@Override
							public void onComplete(String response) {
								String backjson = null;
								try {
									backjson = RSAUtil.decryptByPubKey(response, RSAUtil.pub_key_hand);
									JSONObject jsonback = new JSONObject(backjson);
									
									if(jsonback.getString("error").equals("200")){
										String youaiId = jsonback.getJSONObject("data").getString("youaiId");
										
										YouaiUser youaiuser = new YouaiUser();
										youaiId = jsonback.getJSONObject("data").getString("youaiId");
										
										youaiuser.setPassword(passWord);
										youaiuser.setUsername(userName);
										jsonback.put("username", userName);
										youaiuser.setUidStr(youaiId);
										youaiuser.setUserType("0");
										final String backjsontosdk = jsonback.toString();
										YouaiCommplatform.getInstance().setLoginUser(youaiuser);
										runOnUiThread(new Runnable() {
											@Override
											public void run() {
											register.setClickable(true);
											YouaiLogin.this.progressbar.setVisibility(View.INVISIBLE);
											Toast.makeText(YouaiLogin.this, R.string.registeryes, Toast.LENGTH_SHORT).show();
											listener.onLoginSuccess(backjsontosdk);
											YouaiLogin.this.finish();
											}
											});
									}else{
										final String errorMessage = jsonback.getString("errorMessage");
										runOnUiThread(new Runnable() {
											@Override
											public void run() {
												register.setClickable(true);
												YouaiLogin.this.progressbar.setVisibility(View.INVISIBLE);
												Toast.makeText(YouaiLogin.this, getString(R.string.registeryes)+  "："+errorMessage, Toast.LENGTH_SHORT).show();
											}
										});
									}
								} catch (Exception e1) {
									//e1.printStackTrace();
									YouaiLogin.this.progressbar.setVisibility(View.INVISIBLE);
								}
							}
						});
					}
				});
			}
			
		});
		
		
		
		SharedPreferences cofigSharePre = getSharedPreferences("config", 0);
		autoLogin = cofigSharePre.getBoolean("autologin", false);
		
		if(mRecentYouaiUser!=null){
		usernameEd.setText(mRecentYouaiUser.getUsername());
		passwordEd.setText(mRecentYouaiUser.getPassword());
		}
		usernameEd.requestFocus();
		((InputMethodManager) getSystemService(INPUT_METHOD_SERVICE))
        .hideSoftInputFromWindow(this
                        .getCurrentFocus().getWindowToken(),
                        InputMethodManager.HIDE_NOT_ALWAYS);
	    	
		
	/*	loginButtonFB.setSessionStatusCallback(callback);
		
	    loginButtonFB.setUserInfoChangedCallback(new LoginButton.UserInfoChangedCallback() {
	            @Override
	            public void onUserInfoFetched(GraphUser user) {
	                YouaiLogin.this.fbUser = user;
	                updateUI();
	                // It's possible that we were waiting for this.user to be populated in order to post a
	                // status update.
	            }
	        });*/

	}
		
		
	class loginViewOnClickListen implements OnClickListener{

		@Override
		public void onClick(View clview) {
			 if(clview.getId()==R.id.u2_account_login_log){
				 
				final String userName  = YouaiLogin.this.usernameEd.getText().toString();
				final String passWord  = YouaiLogin.this.passwordEd.getText().toString();
				final ProgressBar loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
				
				if(userName==null||userName.equals("")){
					Toast.makeText(YouaiLogin.this, R.string.namenull, Toast.LENGTH_SHORT).show();
					return ;
				}else if(passWord==null||passWord.equals("")){
					Toast.makeText(YouaiLogin.this, R.string.passwordnull, Toast.LENGTH_SHORT).show();
					return;
				}
				else if(!ToolsUtil.checkAccount(userName)){
					Toast.makeText(YouaiLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
					return;
				}else if(!ToolsUtil.checkPassword(passWord)){
					Toast.makeText(YouaiLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
					return;
				}
			
				loginingbar.setVisibility(View.VISIBLE);
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
				try {
					data.put("youaiName", userName); 
					data.put("password", passWord); 
					message.put("data", data);
					message.put("header", Utils.makeHead(YouaiLogin.this));
				
				
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				
				YouaiApi.Login(message.toString(), new RequestListener() {
					
					@Override
					public void onIOException(IOException e) {
						
						runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(YouaiLogin.this, R.string.loginfailnet, Toast.LENGTH_SHORT).show();		
							}
						});
						
					}
					
					@Override
					public void onError(YouaiException e) {
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(YouaiLogin.this, R.string.loginfailnet, Toast.LENGTH_SHORT).show();		
							}
						});
					}
					
					@Override
					public void onComplete(String response) {
						
						
						JSONObject jsonback = null;
						String error = null;
						String youaiId = null;
						try {
							jsonback  = new JSONObject(response);
							error = jsonback.getString("error");
							if(error.equals("200")){
							YouaiUser youaiuser = new YouaiUser();
							youaiId = jsonback.getJSONObject("data").getString("youaiId");
							youaiuser.setIsLocalLogout("0");
							youaiuser.setPassword(passWord);
							youaiuser.setUsername(userName);
							jsonback.put("username", userName);
							youaiuser.setUidStr(youaiId);
							youaiuser.setUserType("0");
							final String backjsontosdk = jsonback.toString();
							YouaiCommplatform.getInstance().setLoginUser(youaiuser);
							runOnUiThread(new Runnable() {
								@Override
								public void run() {
								loginingbar.setVisibility(View.GONE);
								
								LayoutInflater inflater = LayoutInflater.from(YouaiLogin.this);
					            View view = inflater.inflate(R.layout.toast, (ViewGroup)findViewById(R.id.toast_layout_root));
					            TextView textView = (TextView) view.findViewById(R.id.welcome);
					            textView.setText(YouaiCommplatform.getInstance().getLoginNickName()+","+getString(R.string.welcome)+" ！");
					            Toast toast = new Toast(YouaiLogin.this);
					            toast.setDuration(Toast.LENGTH_LONG);
					            toast.setView(view);
					            toast.setGravity(Gravity.TOP, Gravity.CENTER, 50);
					            toast.show();
					            
								listener.onLoginSuccess(backjsontosdk);
								YouaiLogin.this.onBackPressed();
								}
								});
							}else{
								final String errorMessage = jsonback.getString("errorMessage");
								
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										loginingbar.setVisibility(View.GONE);
										listener.onLoginError(new YouaiError(errorMessage));
										Toast.makeText(YouaiLogin.this,getString(R.string.loginfail)+ "："+errorMessage, Toast.LENGTH_SHORT).show();
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
				 WebindexDialog findpass = new WebindexDialog(YouaiLogin.this, YouaiConfig.WebsiteIndex);
				 findpass.show();
				 findpass.setYouaiTitle("");
				 
				 return;
			 }else if(clview.getId()==R.id.logineduser){
				 new UserDialog(YouaiLogin.this,YouaiLogin.this.usernameEd,YouaiLogin.this.passwordEd).show();
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
			}
			 
			OAuthChina oauthChina = new OAuthChina(YouaiLogin.this,mConfigs[nowwhich]);
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
				 final String userName  = YouaiLogin.this.usernameEd.getText().toString();
				 final String passWord  = YouaiLogin.this.passwordEd.getText().toString();
				 final String emailstr = YouaiLogin.this.emailEd.getText().toString();
					final ProgressBar loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
					
					if(userName==null||userName.equals("")){
						Toast.makeText(YouaiLogin.this, getString(R.string.namenull), Toast.LENGTH_SHORT).show();
						return ;
					}else if(passWord==null||passWord.equals("")){
						Toast.makeText(YouaiLogin.this, getString(R.string.passwordnull), Toast.LENGTH_SHORT).show();
						return;
					}
					else if(!ToolsUtil.checkAccount(userName)){
						Toast.makeText(YouaiLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
						return;
					}else if(!ToolsUtil.checkPassword(passWord)){
						Toast.makeText(YouaiLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
						return;
					}else if((!emailstr.equals(""))&&!ToolsUtil.checkEmail(emailstr)){
						Toast.makeText(YouaiLogin.this, R.string.mailerr, Toast.LENGTH_SHORT).show();
						return;
					}
				
					loginingbar.setVisibility(View.VISIBLE);
					JSONObject message = new JSONObject();
					JSONObject data = new JSONObject(); 
					try {
						data.put("youaiId", YouaiCommplatform.getInstance().getLoginUin());
						data.put("youaiName", userName); 
						data.put("channel", YouaiCommplatform.channelName);
						data.put("oldPassword", "");
						data.put("password", passWord);
						data.put("email", emailstr);
						data.put("isGuestConversion", 1);
						data.put("isInitPassword", 1);
						message.put("data", data);
						message.put("header", Utils.makeHead(YouaiLogin.this));
					
					
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					
					YouaiUser _newBindUser = YouaiCommplatform.getInstance().getLoginUser();
					_newBindUser.setPassword(passWord);
					_newBindUser.setUsername(userName);
					_newBindUser.setEmail(emailstr);
					_newBindUser.setUserType("3");
					_newBindUser.setIsLocalLogout("0");
					final YouaiUser newBindUser = _newBindUser;
					
					//YouaiId - 游客账号的有爱Id	boundYouaiName - 被绑定的账号的userName  boundPassword - 被绑定的账号的密码
					YouaiApi.TryToOk(message.toString(), new RequestListener() {
						
						@Override
						public void onIOException(IOException e) {
							
							runOnUiThread(new Runnable() {
								
								@Override
								public void run() {
									loginingbar.setVisibility(View.GONE);
									Toast.makeText(YouaiLogin.this, R.string.registfailnet, Toast.LENGTH_SHORT).show();		
								}
							});
							
						}
						
						@Override
						public void onError(YouaiException e) {
							runOnUiThread(new Runnable() {
								@Override
								public void run() {
									loginingbar.setVisibility(View.GONE);
									Toast.makeText(YouaiLogin.this, R.string.registfailnet, Toast.LENGTH_SHORT).show();		
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
									
									YouaiCommplatform.getInstance().setLoginUser(newBindUser);
									YouaiLogin.this.onBackPressed();
									YouaiCommplatform.getInstance().notifyBind(true);
									}
									});
								}else{
									final String errorMessage = jsonback.getString("errorMessage");
									
									runOnUiThread(new Runnable() {
										@Override
										public void run() {
											loginingbar.setVisibility(View.GONE);
											listener.onLoginError(new YouaiError(errorMessage));
											Toast.makeText(YouaiLogin.this, getString(R.string.registererr)+"："+errorMessage, Toast.LENGTH_SHORT).show();
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
				 
				final String userName  = YouaiLogin.this.usernameEd.getText().toString();
				final String passWord  = YouaiLogin.this.passwordEd.getText().toString();
				final ProgressBar loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
				
				if(userName==null||userName.equals("")){
					Toast.makeText(YouaiLogin.this, R.string.namenull, Toast.LENGTH_SHORT).show();
					return ;
				}else if(passWord==null||passWord.equals("")){
					Toast.makeText(YouaiLogin.this, R.string.passwordnull, Toast.LENGTH_SHORT).show();
					return;
				}
				else if(!ToolsUtil.checkAccount(userName)){
					Toast.makeText(YouaiLogin.this, R.string.nameerr, Toast.LENGTH_SHORT).show();
					return;
				}else if(!ToolsUtil.checkPassword(passWord)){
					Toast.makeText(YouaiLogin.this, R.string.passworderr, Toast.LENGTH_SHORT).show();
					return;
				}
			
				loginingbar.setVisibility(View.VISIBLE);
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
				try {
					data.put("guestYouaiId", YouaiCommplatform.getInstance().getLoginUin());
					data.put("boundYouaiName", userName); 
					data.put("boundPassword", passWord); 
					message.put("data", data);
					message.put("header", Utils.makeHead(YouaiLogin.this));
				
				
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				//YouaiId - 游客账号的有爱Id	boundYouaiName - 被绑定的账号的userName  boundPassword - 被绑定的账号的密码
				YouaiApi.TryBinding(message.toString(), new RequestListener() {
					
					@Override
					public void onIOException(IOException e) {
						
						runOnUiThread(new Runnable() {
							
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(YouaiLogin.this, R.string.bindneterr, Toast.LENGTH_SHORT).show();		
							}
						});
						
					}
					
					@Override
					public void onError(YouaiException e) {
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								Toast.makeText(YouaiLogin.this, R.string.bindneterr, Toast.LENGTH_SHORT).show();		
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
								Toast.makeText(YouaiLogin.this, getString(R.string.bindsuccess)+"："+backjsontosdk,Toast.LENGTH_SHORT).show();
								listener.onLoginSuccess(backjsontosdk);
								YouaiLogin.this.onBackPressed();
								}
								});
							}else{
								final String errorMessage = jsonback.getString("errorMessage");
								
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										loginingbar.setVisibility(View.GONE);
										listener.onLoginError(new YouaiError(errorMessage));
										Toast.makeText(YouaiLogin.this, getString(R.string.binderr)+"："+errorMessage, Toast.LENGTH_SHORT).show();
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
				 WebindexDialog findpass = new WebindexDialog(YouaiLogin.this, YouaiConfig.WebsiteIndex);
				 findpass.show();
				 findpass.setYouaiTitle("");
				 
				 return;
			 }else if(clview.getId()==R.id.logineduser){
				 new UserDialog(YouaiLogin.this,YouaiLogin.this.usernameEd,YouaiLogin.this.passwordEd).show();
				 
				 return;
			 }
			 
		}
		
	}
	
	public void thirdLogin(String message){
		final ProgressBar	loginingbar = (ProgressBar) findViewById(R.id.loadingbar);
		loginingbar.setVisibility(View.VISIBLE);
		
		YouaiApi.thirdLogin(message, new RequestListener() {
			
			@Override
			public void onIOException(IOException e) {
				
				runOnUiThread(new Runnable() {
					
					@Override
					public void run() {
						loginingbar.setVisibility(View.GONE);
						Toast.makeText(YouaiLogin.this, R.string.loginfail, Toast.LENGTH_SHORT).show();		
					}
				});
				
			}
			
			@Override
			public void onError(YouaiException e) {
				runOnUiThread(new Runnable() {
					@Override
					public void run() {
						loginingbar.setVisibility(View.GONE);
						Toast.makeText(YouaiLogin.this, R.string.loginfail, Toast.LENGTH_SHORT).show();
					}
				});
			}
			
			@Override
			public void onComplete(String response) {
				
				
				JSONObject jsonback = null;
				String error = null;
				String youaiId = null;
				String username = null;
				String password = null;
				try {
					jsonback  = new JSONObject(response);
					error = jsonback.getString("error");
					if(error.equals("200")){
					YouaiUser youaiuser = new YouaiUser();
					youaiId = jsonback.getJSONObject("data").getString("youaiId");
					username = jsonback.getJSONObject("data").getString("youaiName");
					password = jsonback.getJSONObject("data").getString("password");
					youaiuser.setUserType("1");
					youaiuser.setPassword(password);
					youaiuser.setIsLocalLogout("0");
					youaiuser.setUsername(username);
					jsonback.put("username", username);                                 
					youaiuser.setUidStr(youaiId);
					final String backjsontosdk = jsonback.toString();
					
					if(!password.equals("")&&password!=null){
						youaiuser.setIsFirstThird("1");
						YouaiCommplatform.getInstance().setThirdLoginUser(youaiuser);
						YouaiCommplatform.getInstance().setLoginUser(youaiuser);
						YouaiControlCenter.thirdLoginFirst = true;
					}else{
						YouaiControlCenter.thirdLoginFirst = false;
						
						YouaiCommplatform.getInstance().setLoginUser(youaiuser);
						YouaiCommplatform.getInstance().setThirdLoginUser(youaiuser);
					}
					final String pasword = password;
					final String userName = username;
					runOnUiThread(new Runnable() {
						@Override
						public void run() {
						usernameEd.setText(userName);
						passwordEd.setText(pasword);
						loginingbar.setVisibility(View.GONE);
						LayoutInflater inflater = LayoutInflater.from(YouaiLogin.this);
			            View view = inflater.inflate(R.layout.toast, (ViewGroup)findViewById(R.id.toast_layout_root));
			            TextView textView = (TextView) view.findViewById(R.id.welcome);
			            textView.setText(YouaiCommplatform.getInstance().getLoginNickName()+","+getString(R.string.welcome)+" ！");
			            Toast toast = new Toast(YouaiLogin.this);
			            toast.setDuration(Toast.LENGTH_LONG);
			            toast.setView(view);
			            toast.setGravity(Gravity.TOP, Gravity.CENTER, 50);
			            toast.show();
			            YouaiCommplatform.getInstance().OnSuccesBackJsonStr = backjsontosdk;
			            listener.onLoginSuccess(backjsontosdk);
			            YouaiLogin.this.finish();
						}
						});
					}else{
						final String errorMessage = jsonback.getString("errorMessage");
						
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								loginingbar.setVisibility(View.GONE);
								listener.onLoginError(new YouaiError(errorMessage));
								Toast.makeText(YouaiLogin.this, getString(R.string.loginfail)+":"+errorMessage, Toast.LENGTH_SHORT).show();
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
			public void onError(YouaiException e) {
				// TODO Auto-generated method stub
				
				listener.onLoginError(new YouaiError(e.getStatusCode(), e.toString()));
		    	
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
				    	//YouaiLogin.this.finish();
				    	
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
				    	 //YouaiLogin.this.finish();
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
						data.put("platform", YouaiConfig.THIRD_PLATFORM.QQ.ordinal());
						data.put("nickName", ""); 
						data.put("channel", YouaiCommplatform.channelName);
						message.put("data", data);
						message.put("header", Utils.makeHead(YouaiLogin.this));
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
						data.put("platform", YouaiConfig.THIRD_PLATFORM.SINA.ordinal());
						data.put("channel", YouaiCommplatform.channelName);
						message.put("data", data);
						data.put("nickName", "");
						message.put("header", Utils.makeHead(YouaiLogin.this));
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
					data.put("platform", YouaiConfig.THIRD_PLATFORM.DOUBAN.ordinal());
					data.put("channel", YouaiCommplatform.channelName);
					message.put("data", data);
					message.put("header", Utils.makeHead(YouaiLogin.this));
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
						data.put("platform", YouaiConfig.THIRD_PLATFORM.RENREN.ordinal());
						data.put("channel", YouaiCommplatform.channelName);
						message.put("data", data);
						message.put("header", Utils.makeHead(YouaiLogin.this));
						thirdLogin(message.toString());
					
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
	    	 
	    	return;
		}else if(nowwhich==5){
			// Bundle backBundle = new Bundle();
			  //   backBundle.putString("username:", ""+token.getUsername());
			  //   backBundle.putString("uid", token.getUid());
			 	
				    JSONObject message = new JSONObject();
					JSONObject data = new JSONObject(); 
						try {
							data.put("thirdId", ptoken.getUid()); 
							data.put("nickName", ""); 
							data.put("platform", YouaiConfig.THIRD_PLATFORM.FACKBOOK.ordinal());
							data.put("channel", YouaiCommplatform.channelName);
							message.put("data", data);
							message.put("header", Utils.makeHead(YouaiLogin.this));
							thirdLogin(message.toString());
						
						} catch (JSONException e1) {
							e1.printStackTrace();
						}
		    	 
		    	return;
		}
	}
	
	 

}
