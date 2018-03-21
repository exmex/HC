package com.nuclear.sdk.active;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.nuclear.sdk.android.api.SdkApi;
import com.nuclear.sdk.android.api.SdkException;
import com.nuclear.sdk.android.config.SdkConfig;
import com.nuclear.sdk.android.entry.SdkUser;
import com.nuclear.sdk.android.utils.MD5;
import com.nuclear.sdk.android.utils.RSAUtil;
import com.nuclear.sdk.android.utils.ToolsUtil;
import com.nuclear.sdk.android.utils.Utils;
import com.nuclear.sdk.net.RequestListener;
import com.nuclear.sdk.R;

public class SdkRegist extends Activity {
	private EditText regeditUsername;
	private EditText regeditPassword;
	private EditText regeditEmail;
	private Button regsignInBtn;
	private Button regsignUpBtn;
	private Button btnFacebook;
	private Button btnGoogle;
	private TextView mReg_protal;
	private ImageView mRegBack;
	private CheckBox mReg_cb_agree;
	private boolean mIschecked=true;

	// private ProgressBar progressbar;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if(VERSION.SDK_INT>=11){
			setFinishOnTouchOutside(false);  
		}
		// 设置无标题
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		// 设置全屏
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN);
		setContentView(R.layout.ya_login_main);
		setContentView(R.layout.ya_login_reg);
		SdkCommplatform.getInstance().addActivity(this);
		SdkCommplatform.getInstance().callOnCreate(this);
		init();
		setListener();

	}

	private void init() {
		regeditUsername = (EditText) findViewById(R.id.RegeditUsername);
		regeditPassword = (EditText) findViewById(R.id.RegeditPassword);
		regeditEmail = (EditText) findViewById(R.id.RegeditEmail);
		regsignInBtn = (Button) findViewById(R.id.RegsignInBtn);
		// progressbar = (ProgressBar)findViewById(R.id.loadingbar);
        mRegBack=(ImageView)findViewById(R.id.reg_iv_back);
		regsignUpBtn = (Button) findViewById(R.id.RegsignUpBtn);
		btnFacebook = (Button) findViewById(R.id.btnFacebook);
		btnGoogle = (Button) findViewById(R.id.btnGoogle);
		mReg_protal = (TextView) findViewById(R.id.reg_protal);
		mReg_cb_agree=(CheckBox)findViewById(R.id.reg_cb_agree);
		
	}

	private void setListener() {
		mReg_cb_agree.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			

			@Override
			public void onCheckedChanged(CompoundButton arg0, boolean arg1) {
				mIschecked=arg1;
			}
		});
		mRegBack.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				SdkRegist.this.finish();
			}
		});
		regsignInBtn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				Intent intent = new Intent(SdkRegist.this, SdkLoginMain.class);
				SdkRegist.this.startActivity(intent);
			}
		});
		mReg_protal.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				Uri uri=Uri.parse("http://203.90.239.206/Agreement.html");
				Intent intent  = new Intent(Intent.ACTION_VIEW,uri);
				startActivity(intent);
			}
		});
		regsignUpBtn.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
                if(!mIschecked){
                	Toast.makeText(SdkRegist.this, "Read and Agree to Agreement", Toast.LENGTH_SHORT).show();
                	return;
                }
				final String userName = SdkRegist.this.regeditUsername
						.getText().toString();
				final String passWord = SdkRegist.this.regeditPassword
						.getText().toString();
				String userEmail = SdkRegist.this.regeditEmail.getText()
						.toString();
				if (userName == null || userName.equals("")) {
					Toast.makeText(SdkRegist.this, R.string.namenull,
							Toast.LENGTH_SHORT).show();
					return;
				}
				if (passWord == null || passWord.equals("")) {
					Toast.makeText(SdkRegist.this, R.string.passwordnull,
							Toast.LENGTH_SHORT).show();
					return;
				}
				if (userEmail == null || userEmail.equals("")) {
					Toast.makeText(SdkRegist.this,
							getString(R.string.emailnull), Toast.LENGTH_SHORT)
							.show();
					return;
				}
				if (!ToolsUtil.checkAccount(userName)) {
					Toast.makeText(SdkRegist.this, R.string.nameerr,
							Toast.LENGTH_SHORT).show();
					return;
				} else if (!ToolsUtil.checkPassword(passWord)) {
					Toast.makeText(SdkRegist.this, R.string.passworderr,
							Toast.LENGTH_SHORT).show();
					return;
				} else if (userEmail != null && !userEmail.equals("")) {
					if (!ToolsUtil.checkEmail(userEmail)) {
						Toast.makeText(SdkRegist.this, R.string.mailerr,
								Toast.LENGTH_SHORT).show();
						return;
					}
				}
				// progressbar.setVisibility(View.VISIBLE);
				String md5sign = null;

				JSONObject message = new JSONObject();

				JSONObject data = new JSONObject();
				try {
					data.put("nuclearName", userName);
					data.put("password", passWord);
					data.put("channel", SdkCommplatform.channelName);
					data.put("email", userEmail != null ? userEmail : "");
					message.put("data", data);
					message.put("header", Utils.makeHead(SdkRegist.this));
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
				SdkApi.Register(md5sign, putmessage, new RequestListener() {

					@Override
					public void onIOException(IOException e) {
						// SdkRegist.this.progressbar
						// .setVisibility(View.INVISIBLE);
						Toast.makeText(SdkRegist.this, R.string.registererr,
								Toast.LENGTH_SHORT).show();
					}

					@Override
					public void onError(SdkException e) {
						// SdkRegist.this.progressbar
						// .setVisibility(View.INVISIBLE);
						Toast.makeText(SdkRegist.this, R.string.registererr,
								Toast.LENGTH_SHORT).show();
					}

					@Override
					public void onComplete(String response) {

						SdkLogin.listener.onNomalRegister();

						String backjson = null;
						try {
							backjson = RSAUtil.decryptByPubKey(response,
									RSAUtil.pub_key_hand);
							JSONObject jsonback = new JSONObject(backjson);

							if (jsonback.getString("error").equals("200")) {
								String nuclearId = jsonback.getJSONObject(
										"data").getString("nuclearId");

								SdkUser nuclearuser = new SdkUser();
								nuclearId = jsonback.getJSONObject("data")
										.getString("nuclearId");

								nuclearuser.setPassword(passWord);
								nuclearuser.setUsername(userName);
								jsonback.put("username", userName);
								nuclearuser.setUidStr(nuclearId);
								nuclearuser.setUserType("0");
								final String backjsontosdk = jsonback
										.toString();
								SdkCommplatform.getInstance().setLoginUser(
										nuclearuser);
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										// SdkRegist.this.progressbar
										// .setVisibility(View.INVISIBLE);
										Toast.makeText(SdkRegist.this,
												R.string.registeryes,
												Toast.LENGTH_SHORT).show();
										SdkLogin.listener
												.onLoginSuccess(backjsontosdk);
										SdkCommplatform.getInstance().finish();
									}
								});
							} else {
								final String errorMessage = jsonback
										.getString("errorMessage");
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										// SdkRegist.this.progressbar
										// .setVisibility(View.INVISIBLE);
										Toast.makeText(
												SdkRegist.this,
												getString(R.string.registererr)
														+ "：" + errorMessage,
												Toast.LENGTH_SHORT).show();
									}
								});
							}
						} catch (Exception e1) {
							// e1.printStackTrace();
							// SdkRegist.this.progressbar
							// .setVisibility(View.INVISIBLE);
						}
					}
				});

			}
		});
		// btnFacebook.setOnClickListener(new OnClickListener() {
		//
		// @Override
		// public void onClick(View arg0) {
		// SdkCommplatform.getInstance().facebookLogin(SdkRegist.this);
		// }
		// });
		// btnGoogle.setOnClickListener(new OnClickListener() {
		//
		// @Override
		// public void onClick(View arg0) {
		// SdkCommplatform.getInstance().googleLogin(SdkRegist.this);
		// }
		// });
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {

		SdkCommplatform.getInstance().onActivityResult(this, requestCode,
				resultCode, data);
		super.onActivityResult(requestCode, resultCode, data);
	}
}
