package com.fiveone.gamecenter.sdk.activity;

import java.util.Random;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import com.fiveone.gamecenter.netconnect.NetConfig;
import com.fiveone.gamecenter.netconnect.NetConnectService;
import com.fiveone.gamecenter.netconnect.bean.UserInfo;
import com.fiveone.gamecenter.netconnect.db.GameDBHelper;
import com.fiveone.gamecenter.sdk.GameCenterService;
import com.fiveone.gamecenter.sdk.R;
import com.fiveone.gamecenter.sdk.util.Util;

public class FirstLoginActivity extends Activity {
	private ProgressDialog mProgress;

	public static String userName;
	private EditText mUserName;
	private EditText mPassword;

	@Override
	protected void onPause() {
		super.onPause();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.gamecenter_first_login);
		initLoginPage();
	}

	@Override
	protected void onResume() {
		super.onResume();
		String _users[] = GameDBHelper.getInstance(this).queryAllUserName();
		if (_users.length != 0) {
			String _userName = _users[0];
			String _password = GameDBHelper.getInstance(this).queryPasswordByName(_userName);
			mUserName.setText(_userName);
			mPassword.setText(_password);
		}
	}

	private void initLoginPage() {
		mUserName = (EditText) findViewById(R.id.login_account_et);
		mPassword = (EditText) findViewById(R.id.login_password_et);

		// 登录
		Button loginButton = (Button) findViewById(R.id.login_login_btn);
		loginButton.setOnClickListener(new Button.OnClickListener() {
			public void onClick(View arg0) {
				// 隐藏虚拟键盘
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(mPassword.getWindowToken(), 0);
				checkLoginInputPrams(FirstLoginActivity.this, mUserName, mPassword);
			}
		});

		// 注册
		Button registerButton = (Button) findViewById(R.id.login_register_btn);
		registerButton.setOnClickListener(new Button.OnClickListener() {
			public void onClick(View arg0) {
				// 隐藏虚拟键盘
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);

				imm.hideSoftInputFromWindow(mPassword.getWindowToken(), 0);
				GameCenterService.startRegisterActivityForResult(FirstLoginActivity.this);
			
			}
		});

		Button mRegisterLoginButton = (Button) findViewById(R.id.login_register_login_btn);
		mRegisterLoginButton.setOnClickListener(new Button.OnClickListener() {

			@Override
			public void onClick(View v) {
				mProgress = Util.showProgress(FirstLoginActivity.this,"51游戏中心", "注册中…", false, true);
				String timeStr = String.valueOf(System.currentTimeMillis());
				String username = Util.getGameEName(FirstLoginActivity.this) + timeStr.substring(timeStr.length() - 7, timeStr.length());
				String password = String.valueOf(new Random().nextInt(900000) + 100000);
				doRegisterAccount(username, password);
			}
		});
		GameCenterService.callPhoneAnalytics(this);
	}

	private void checkLoginInputPrams(Context context, EditText mUsername, EditText mPassword) {
		String username = mUsername.getText().toString();
		if (TextUtils.isEmpty(username)) {
			Toast.makeText(context, "账号必须填写", Toast.LENGTH_SHORT).show();
			return;
		}
		String password = mPassword.getText().toString();
		if (TextUtils.isEmpty(password)) {
			Toast.makeText(context, "密码必须填写", Toast.LENGTH_SHORT).show();
			return;
		}
		mProgress = Util.showProgress(context, "51游戏中心", "登录中…", false, true);
		doLoginAccount(username, password);
	}

//	private ProgressDialog showProgress(Context context, CharSequence title, CharSequence message, boolean indeterminate, boolean cancelable) {
//		ProgressDialog dialog = new ProgressDialog(context);
//		dialog.setTitle(title);
//		dialog.setMessage(message);
//		dialog.setIndeterminate(indeterminate);
//		dialog.setCancelable(cancelable);
//		dialog.show();
//		return dialog;
//	}

	private void doLoginAccount(String username, String password) {
		NetConnectService.doLoginAccount(getApplicationContext(), handler, username, password);
	}

	private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (mProgress != null) {
				mProgress.dismiss();
			}
			if (msg.what == NetConfig.TAG_CALLBACK_FAILED_PWD) {
				//密码错误
				GameCenterService.mListiner.onLoginPwdError();
			} else if (msg.what == NetConfig.TAG_CALLBACK_SUCCESS) {
				//登录
				UserInfo info = (UserInfo) msg.obj;
				GameCenterService.setUserInfo(info);
				GameCenterService.mListiner.onLoginSuccess(info);
				finish();
			} else if (msg.what == NetConfig.TAG_CALLBACK_FAILED) {
				GameCenterService.mListiner.onFailed();
			} else if (msg.what == NetConfig.TAG_CALLBACK_SUCCESS_REG) {
				// 注册
				UserInfo info = (UserInfo) msg.obj;
				GameCenterService.setUserInfo(info);
				GameCenterService.mListiner.onRegisterSuccess(info);
				GameCenterService.mListiner.onLoginSuccess(info);
				finish();
			}
		}
	};

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
	}

	private void doRegisterAccount(String username, String password) {
		NetConnectService.doRegisterAccount(getApplicationContext(), handler, username, password);
	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		if ((keyCode == KeyEvent.KEYCODE_BACK)) {
			boolean bReturn = GameCenterService.mListiner.onLoginPageClose(this);
			if (bReturn) {
				return true;
			}
		}
		return super.onKeyDown(keyCode, event);
	}
}
