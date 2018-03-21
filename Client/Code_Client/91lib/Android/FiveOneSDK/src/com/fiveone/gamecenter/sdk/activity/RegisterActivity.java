package com.fiveone.gamecenter.sdk.activity;

import java.util.Random;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.MotionEvent;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import com.fiveone.gamecenter.netconnect.NetConfig;
import com.fiveone.gamecenter.netconnect.NetConnectService;
import com.fiveone.gamecenter.netconnect.bean.UserInfo;
import com.fiveone.gamecenter.sdk.GameCenterService;
import com.fiveone.gamecenter.sdk.R;
import com.fiveone.gamecenter.sdk.util.Util;

public class RegisterActivity extends Activity {
	private ProgressDialog mProgress;
	private Handler mRegisterHandler;
	@Override
	protected void onPause() {
		super.onPause();
	}

	@Override
	protected void onResume() {
		super.onResume();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.gamecenter_register);
		mRegisterHandler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				mProgress.dismiss();
				if (msg.what ==  NetConfig.TAG_CALLBACK_FAILED) {
					GameCenterService.mListiner.onFailed();
				}
				if (msg.what == NetConfig.TAG_CALLBACK_FAILED_REGEXIST) {
					GameCenterService.mListiner.onRegisterAccountExists();
				} else if (msg.what == NetConfig.TAG_CALLBACK_SUCCESS_REG) {
					UserInfo info = (UserInfo)msg.obj;
//					com.fiveone.gamecenter.sdk.util.Util.saveUserID(getApplicationContext(), String.valueOf(info.getUserId()));
					GameCenterService.setUserInfo(info);
					GameCenterService.mListiner.onRegisterSuccess(info);
					
					finish();
				}
			}
		};

		initRegisterPage();
	}

	private void initRegisterPage() {
		Button leftBtn = (Button) findViewById(R.id.register_back_btn);
		leftBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});

		final EditText userName = (EditText) findViewById(R.id.login_username_et);
		String timeStr = String.valueOf(System.currentTimeMillis());
		userName.setText(Util.getGameEName(this) + timeStr.substring(timeStr.length() - 7, timeStr.length()));
		final EditText loginPassworded = (EditText) findViewById(R.id.login_password_et);
		loginPassworded.setText("" + (new Random().nextInt(900000) + 100000));
		Button mLogin = (Button) findViewById(R.id.register_login_btn);
		loginPassworded.setOnTouchListener(new EditText.OnTouchListener() {
			@Override
			public boolean onTouch(View v, MotionEvent event) {
				loginPassworded.setCursorVisible(true);
				return false;
			}
		});

		mLogin.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// 隐藏虚拟键盘
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(loginPassworded.getWindowToken(), 0);
				checkRegisterInputPrams(userName, loginPassworded, getApplicationContext());
			}
		});
	}

	private void checkRegisterInputPrams(EditText emailAutoCompletatv, EditText loginPassworded, Context context) {
		String username = emailAutoCompletatv.getText().toString();
		String password = loginPassworded.getText().toString();
		if (TextUtils.isEmpty(username)) {

			com.fiveone.gamecenter.sdk.util.Util.ShowTips(context, "账号不能为空");

			return;
		}
		if (TextUtils.isEmpty(password)) {
			com.fiveone.gamecenter.sdk.util.Util.ShowTips(context, "密码必须填写");
			return;
		}

		if (!username.matches("^[a-z|A-Z]{1}.{0,}$")) {
			com.fiveone.gamecenter.sdk.util.Util.ShowTips(context, "账号必须以字母开头");
			return;
		}
		

		if (!username.matches("^[a-z|A-Z|0-9|_|.|-]{1,}$")) {
			com.fiveone.gamecenter.sdk.util.Util.ShowTips(context, "账号须由字母和数字组成");
			return;
		}

		if (!username.matches("^.{4,16}$")) {
			com.fiveone.gamecenter.sdk.util.Util.ShowTips(context, "账号长度必须在4~16位");
			return;
		}
	

		if (!password.matches("^.{6,16}$")) {
			com.fiveone.gamecenter.sdk.util.Util.ShowTips(context, "密码长度必须在6~16位");
			return;
		}
		;

		mProgress = showProgress("51游戏中心", "注册中…", false, true);
//		mProgress =Util.showProgress(context,"51游戏中心", "注册中…", false, true);

		doRegisterAccount(username, password);
	}

	private ProgressDialog showProgress(CharSequence title, CharSequence message, boolean indeterminate, boolean cancelable) {
		ProgressDialog dialog = new ProgressDialog(RegisterActivity.this);
		dialog.setTitle(title);
		dialog.setMessage(message);
		dialog.setIndeterminate(indeterminate);
		dialog.setCancelable(cancelable);
		dialog.show();
		return dialog;
	}


	private void doRegisterAccount(String username, String password) {
		NetConnectService.doRegisterAccount(getApplicationContext(), mRegisterHandler, username, password);
	}
}
