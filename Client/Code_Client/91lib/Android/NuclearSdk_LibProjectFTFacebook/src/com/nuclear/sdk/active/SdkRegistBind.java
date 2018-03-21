package com.nuclear.sdk.active;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.util.Log;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.widget.AutoCompleteTextView;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.CompoundButton.OnCheckedChangeListener;

import com.nuclear.sdk.android.SdkError;
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

public class SdkRegistBind extends Activity {
	private EditText regeditUsername;
	private EditText regeditPassword;
	private EditText regeditEmail;
	private ImageView top_btn;
	private Button regsignUpBtn;
	private ProgressBar progressbar;
	private SdkUser tryUser;
	private ImageView mImageView;
	private TextView mGuest_tv_protocal;
	private boolean mIschecked=true;
	private CheckBox mRegbind_cb_agree;

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
		setContentView(R.layout.ya_guestbind);
		SdkCommplatform.getInstance().addActivity(this);
		init();
		setListener();

	}

	private void init() {
		regeditUsername = (EditText) findViewById(R.id.RegeditUsername);
		regeditPassword = (EditText) findViewById(R.id.RegeditPassword);
		regeditEmail = (EditText) findViewById(R.id.RegeditEmail);
		// top_btn = (ImageView) findViewById(R.id.top_btn);
		progressbar = (ProgressBar) findViewById(R.id.loadingbar);
        mImageView = (ImageView)findViewById(R.id.iv_guest_back);
		regsignUpBtn = (Button) findViewById(R.id.RegsignUpBtn);
		mGuest_tv_protocal=(TextView)findViewById(R.id.guest_tv_protocal);
		mRegbind_cb_agree =(CheckBox)findViewById(R.id.regbind_cb_agree);
		tryUser = SdkCommplatform.getInstance().getTryLoginUser();
	}

	private void setListener() {
	mRegbind_cb_agree.setOnCheckedChangeListener(new OnCheckedChangeListener() {
			

			@Override
			public void onCheckedChanged(CompoundButton arg0, boolean arg1) {
				mIschecked=arg1;
			}
		});
		mGuest_tv_protocal.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				Uri uri=Uri.parse("http://203.90.239.206/Agreement.html");
				Intent intent  = new Intent(Intent.ACTION_VIEW,uri);
				startActivity(intent);
			}
		});
		mImageView.setOnClickListener(new OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				SdkRegistBind.this.finish();
			}
		});
		regsignUpBtn.setOnClickListener(new OnClickListener() {

			

			@Override
			public void onClick(View arg0) {
				 if(!mIschecked){
	                	Toast.makeText(SdkRegistBind.this, "Read and Agree to Agreement", Toast.LENGTH_SHORT).show();
	                	return;
	                }
				final String userName = SdkRegistBind.this.regeditUsername
						.getText().toString();
				final String passWord = SdkRegistBind.this.regeditPassword
						.getText().toString();
				final String emailstr = SdkRegistBind.this.regeditEmail
						.getText().toString();
				// final ProgressBar loginingbar = (ProgressBar)
				// findViewById(R.id.loadingbar);

				if (userName == null || userName.equals("")) {
					Toast.makeText(SdkRegistBind.this,
							getString(R.string.namenull), Toast.LENGTH_SHORT)
							.show();
					return;
				} else if (passWord == null || passWord.equals("")) {
					Toast.makeText(SdkRegistBind.this,
							getString(R.string.passwordnull),
							Toast.LENGTH_SHORT).show();
					return;
				} else if (emailstr == null || emailstr.equals("")) {
					Toast.makeText(SdkRegistBind.this,
							getString(R.string.emailnull), Toast.LENGTH_SHORT)
							.show();
					return;
				} else if (!ToolsUtil.checkAccount(userName)) {
					Toast.makeText(SdkRegistBind.this, R.string.nameerr,
							Toast.LENGTH_SHORT).show();
					return;
				} else if (!ToolsUtil.checkPassword(passWord)) {
					Toast.makeText(SdkRegistBind.this, R.string.passworderr,
							Toast.LENGTH_SHORT).show();
					return;
				} else if ((!emailstr.equals(""))
						&& !ToolsUtil.checkEmail(emailstr)) {
					Toast.makeText(SdkRegistBind.this, R.string.mailerr,
							Toast.LENGTH_SHORT).show();
					return;
				}

				// loginingbar.setVisibility(View.VISIBLE)C;
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject();
				try {
					data.put("nuclearId", tryUser.getUidStr());
					data.put("nuclearName", userName);
					data.put("channel", SdkCommplatform.channelName);
					data.put("oldPassword", "");
					data.put("password", passWord);
					data.put("email", emailstr);
					data.put("isGuestConversion", 1);
					data.put("isInitPassword", 1);
					message.put("data", data);
					message.put("header", Utils.makeHead(SdkRegistBind.this));

				} catch (JSONException e1) {
					e1.printStackTrace();
				}

				tryUser.setPassword(passWord);
				tryUser.setUsername(userName);
				tryUser.setEmail(emailstr);
				tryUser.setUserType("3");
				tryUser.setIsLocalLogout("0");

				// nuclearId - 游客账号的Id boundnuclearName - 被绑定的账号的userName
				// boundPassword - 被绑定的账号的密码
				SdkApi.TryToOk(message.toString(), new RequestListener() {

					@Override
					public void onIOException(IOException e) {

						runOnUiThread(new Runnable() {

							@Override
							public void run() {
								// loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkRegistBind.this,
										R.string.registfailnet,
										Toast.LENGTH_SHORT).show();
							}
						});

					}

					@Override
					public void onError(SdkException e) {
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								// loginingbar.setVisibility(View.GONE);
								Toast.makeText(SdkRegistBind.this,
										R.string.registfailnet,
										Toast.LENGTH_SHORT).show();
							}
						});
					}

					@Override
					public void onComplete(String response) {

						JSONObject jsonback = null;
						String error = null;
						try {
							jsonback = new JSONObject(response);
							error = jsonback.getString("error");
							if (error.equals("200")) {
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										// loginingbar.setVisibility(View.GONE);

										SdkCommplatform.getInstance()
												.setLoginUser(tryUser);
										SdkRegistBind.this
												.getSharedPreferences("config",
														Context.MODE_PRIVATE)
												.edit()
												.putBoolean("autologin", false)
												.commit();

										SdkCommplatform.getInstance()
												.notifyBind(true);
										SdkCommplatform.getInstance().finish();
									}
								});
							} else {
								final String errorMessage = jsonback
										.getString("errorMessage");

								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										// loginingbar.setVisibility(View.GONE);
										SdkLogin.listener
												.onLoginError(new SdkError(
														errorMessage));
										Toast.makeText(
												SdkRegistBind.this,
												getString(R.string.registererr)
														+ "：" + errorMessage,
												Toast.LENGTH_SHORT).show();
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

		// top_btn.setOnClickListener(new OnClickListener() {
		//
		// @Override
		// public void onClick(View arg0) {
		// SdkCommplatform.getInstance().doByUser(2);
		// SdkCommplatform.getInstance().finish();
		// }
		// });
	}

}
