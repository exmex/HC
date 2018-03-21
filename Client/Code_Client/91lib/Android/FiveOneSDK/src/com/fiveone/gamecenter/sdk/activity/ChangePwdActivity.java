package com.fiveone.gamecenter.sdk.activity;

import android.app.Activity;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Toast;
import com.fiveone.gamecenter.netconnect.NetConfig;
import com.fiveone.gamecenter.netconnect.NetConnectService;
import com.fiveone.gamecenter.netconnect.db.GameDBHelper;
import com.fiveone.gamecenter.sdk.R;
import com.fiveone.gamecenter.sdk.util.Util;

public class ChangePwdActivity extends Activity {
	private EditText mUserNameEdit;
	private EditText mOldPwdEdit;
	private EditText mNewPwdEdit;

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
		setContentView(R.layout.gamecenter_change_pwd);
		initChangePwdView();

	}

	private void initChangePwdView() {
		Button cancel_btn = (Button) findViewById(R.id.cancel_btn);
		cancel_btn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});

		mUserNameEdit = (EditText) findViewById(R.id.username_et);
		String _userName = this.getIntent().getStringExtra("USERNAME");
		mUserNameEdit.setText(_userName);
		mOldPwdEdit = (EditText) findViewById(R.id.old_pwd_et);
		mOldPwdEdit.setText(GameDBHelper.getInstance(this).queryPasswordByName(_userName));
		mNewPwdEdit = (EditText) findViewById(R.id.new_pwd_et);
		Button okBtn = (Button) findViewById(R.id.ok_btn);
		okBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				String userName = mUserNameEdit.getText().toString();
				String oldPwd = mOldPwdEdit.getText().toString();
				String newPwd = mNewPwdEdit.getText().toString();
				if (TextUtils.isEmpty(userName)) {
					Toast.makeText(getApplicationContext(), "账号必须填写", Toast.LENGTH_SHORT).show();
					return;
				}
				if (TextUtils.isEmpty(oldPwd) || TextUtils.isEmpty(newPwd)) {
					Toast.makeText(getApplicationContext(), "密码必须填写", Toast.LENGTH_SHORT).show();
					return;
				}
				if (!newPwd.matches("^.{6,16}$")) {
					Toast.makeText(getApplicationContext(), "密码长度必须在6~16位之间", Toast.LENGTH_SHORT).show();
					return;
				}
				NetConnectService.callChangePwd(getApplicationContext(), handler, oldPwd, newPwd, userName);
			}
		});
		Button cancelBtn = (Button) findViewById(R.id.cancel_btn);
		cancelBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				finish();
			}
		});
	}

	private Handler handler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (msg.what == NetConfig.TAG_CALLBACK_SUCCESS) {
				Util.ShowTips(getApplicationContext(), "密码修改成功");
				String _userName = mUserNameEdit.getText().toString();
				String _password = mNewPwdEdit.getText().toString();
				GameDBHelper.getInstance(ChangePwdActivity.this).insertOrUpdateLoginUserName(_userName, _password);
				finish();
			} else if (msg.what == NetConfig.TAG_CALLBACK_FAILED) {
				Toast.makeText(getApplicationContext(), msg.obj.toString(), Toast.LENGTH_SHORT).show();
			}
		}
	};

}
