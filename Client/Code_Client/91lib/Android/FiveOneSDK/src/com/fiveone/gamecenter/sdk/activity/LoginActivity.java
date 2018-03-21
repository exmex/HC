package com.fiveone.gamecenter.sdk.activity;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.TextUtils;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.SimpleAdapter;
import android.widget.TextView;
import android.widget.Toast;
import com.fiveone.gamecenter.netconnect.NetConfig;
import com.fiveone.gamecenter.netconnect.NetConnectService;
import com.fiveone.gamecenter.netconnect.bean.UserInfo;
import com.fiveone.gamecenter.netconnect.db.GameDBHelper;
import com.fiveone.gamecenter.sdk.GameCenterService;
import com.fiveone.gamecenter.sdk.R;
import com.fiveone.gamecenter.sdk.util.Util;

public class LoginActivity extends Activity {
	private ProgressDialog mProgress;
	private EditText mUserName;
	private EditText mPassword;
	private PopupWindow mPopView;

	@Override
	protected void onPause() {
		super.onPause();
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.gamecenter_login);
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

	private void initPopView(String[] usernames) {
		List<HashMap<String, Object>> list = new ArrayList<HashMap<String, Object>>();
		for (int i = 0; i < usernames.length; i++) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("name", usernames[i]);
			map.put("drawable", R.drawable.gamecenter_del_acount);
			list.add(map);
		}
		MyAdapter dropDownAdapter = new MyAdapter(this, list, R.layout.gamecenter_dropdown_item, new String[] { "name", "drawable" }, new int[] { R.id.textview, R.id.delete });
		ListView listView = new ListView(this);
		listView.setAdapter(dropDownAdapter);
		listView.setDivider(getResources().getDrawable(R.color.PopViewDividerColor));
		listView.setDividerHeight(1);
		listView.setCacheColorHint(0x00000000);
		mPopView = new PopupWindow(listView, mUserName.getWidth(), ViewGroup.LayoutParams.WRAP_CONTENT, true);
		mPopView.setFocusable(true);
		mPopView.setOutsideTouchable(true);
		mPopView.setBackgroundDrawable(getResources().getDrawable(R.drawable.gamecenter_popview_bg));
	}

	private void initLoginPage() {
		mUserName = (EditText) findViewById(R.id.login_account_et);
		mPassword = (EditText) findViewById(R.id.login_password_et);

	
		final Button mArrowBtn = (Button) findViewById(R.id.login_arrow_btn);

		 // 清除帐号框内的输入
		mArrowBtn.setOnClickListener(new Button.OnClickListener() {
			public void onClick(View arg0) {
				if (mPopView != null) {
					if (!mPopView.isShowing()) {
						mPopView.showAsDropDown(mUserName);
					} else {
						mPopView.dismiss();
					}
				} else {
					// 如果有已经登录过账号
					if (GameDBHelper.getInstance(LoginActivity.this).queryAllUserName().length > 0) {
						initPopView(GameDBHelper.getInstance(LoginActivity.this).queryAllUserName());
						if (!mPopView.isShowing()) {
							mPopView.showAsDropDown(mUserName);
						} else {
							mPopView.dismiss();
						}
					} else {
					}
				}
			}
		});

		// 登录
		Button loginButton = (Button) findViewById(R.id.login_login_btn);
		loginButton.setOnClickListener(new Button.OnClickListener() {
			public void onClick(View arg0) {
				// 隐藏虚拟键盘
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(mPassword.getWindowToken(), 0);
				checkLoginInputPrams(LoginActivity.this, mUserName, mPassword);
			}
		});
		// 修改密码
		Button changepwdBtn = (Button) findViewById(R.id.login_changepwd_btn);

		changepwdBtn.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View v) {
				// 隐藏虚拟键盘
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(mPassword.getWindowToken(), 0);

				Intent intent = new Intent(getApplicationContext(), ChangePwdActivity.class);
				String _userName = mUserName.getText().toString();
				intent.putExtra("USERNAME", _userName);
				startActivity(intent);
			}
		});

		// 注册
		Button registerButton = (Button) findViewById(R.id.login_register_btn);
		registerButton.setOnClickListener(new Button.OnClickListener() {
			public void onClick(View arg0) {
				// 隐藏虚拟键盘
				InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
				imm.hideSoftInputFromWindow(mPassword.getWindowToken(), 0);
				GameCenterService.startRegisterActivityForResult(LoginActivity.this);
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
		mProgress = showProgress(context, "51游戏中心", "登录中…", false, true);
		doLoginAccount(username, password);
	}

	private ProgressDialog showProgress(Context context, CharSequence title, CharSequence message, boolean indeterminate, boolean cancelable) {
		ProgressDialog dialog = new ProgressDialog(context);
		dialog.setTitle(title);
		dialog.setMessage(message);
		dialog.setIndeterminate(indeterminate);
		dialog.setCancelable(cancelable);
		dialog.show();
		return dialog;
	}

	private void doLoginAccount(String username, String password) {
		NetConnectService.doLoginAccount(getApplicationContext(), mHandler, username, password);
	}

	private Handler mHandler = new Handler() {
		@Override
		public void handleMessage(Message msg) {
			if (mProgress != null) {
				mProgress.dismiss();
			}
			if (msg.what == NetConfig.TAG_CALLBACK_FAILED) {
				GameCenterService.mListiner.onFailed();
			} else if (msg.what == NetConfig.TAG_CALLBACK_FAILED_PWD) {
				GameCenterService.mListiner.onLoginPwdError();
			} else if (msg.what ==  NetConfig.TAG_CALLBACK_SUCCESS) {
				UserInfo info = (UserInfo) msg.obj;
				GameCenterService.setUserInfo(info);
				GameCenterService.mListiner.onLoginSuccess(info);
				finish();
				
//				GameCenterService.setLoginServer("游戏服务器ID", "游戏服务器名称");
//				GameCenterService.setGameRoleName("游戏中玩家名称");
//				GameCenterService.setGameLevel("游戏中玩家等级");
//				GameCenterService.callOnlineAccount(LoginActivity.this);
			} 
		}
	};
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);
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

	class MyAdapter extends SimpleAdapter {

		private List<HashMap<String, Object>> data;

		public MyAdapter(Context context, List<HashMap<String, Object>> data, int resource, String[] from, int[] to) {
			super(context, data, resource, from, to);
			this.data = data;
		}

		@Override
		public int getCount() {
			return data.size();
		}

		@Override
		public Object getItem(int position) {
			return position;
		}

		@Override
		public long getItemId(int position) {
			return position;
		}

		@Override
		public View getView(final int position, View convertView, ViewGroup parent) {
			ViewHolder holder;
			if (convertView == null) {
				holder = new ViewHolder();
				convertView = LayoutInflater.from(LoginActivity.this).inflate(R.layout.gamecenter_dropdown_item, null);
				holder.btn = (ImageButton) convertView.findViewById(R.id.delete);
				holder.tv = (TextView) convertView.findViewById(R.id.textview);
				convertView.setTag(holder);
			} else {
				holder = (ViewHolder) convertView.getTag();
			}
			holder.tv.setText(data.get(position).get("name").toString());
			holder.tv.setOnClickListener(new View.OnClickListener() {

				@Override
				public void onClick(View v) {
					String[] usernames = GameDBHelper.getInstance(LoginActivity.this).queryAllUserName();
					mUserName.setText(usernames[position]);
					mPassword.setText(GameDBHelper.getInstance(LoginActivity.this).queryPasswordByName(usernames[position]));
					mPopView.dismiss();
				}
			});
			holder.btn.setOnClickListener(new View.OnClickListener() {
				@Override
				public void onClick(View v) {
					 mPopView.dismiss();
					String[] usernames = GameDBHelper.getInstance(LoginActivity.this).queryAllUserName();
					 if (usernames.length > 0) {
						long returnId = GameDBHelper.getInstance(LoginActivity.this).delete(usernames[position]);
						if (returnId == -1){
							Util.ShowTips(LoginActivity.this, "账号删除失败");
						}else{
							String[] newUserNames = GameDBHelper.getInstance(LoginActivity.this).queryAllUserName(); 
							initPopView(newUserNames);
							Util.ShowTips(LoginActivity.this, "账号删除成功");
							if (newUserNames.length == 0){
								//删到最后一条记录
								mUserName.setText("");
								mPassword.setText("");
							}else if (usernames[position].equals(mUserName.getText().toString())){
								//删到当前选中记录
								mUserName.setText(newUserNames[0]);
								mPassword.setText(GameDBHelper.getInstance(LoginActivity.this).queryPasswordByName(newUserNames[0]));
							}else{
								
							}
						}
					 }
				}
			});
			return convertView;
		}
	}

	class ViewHolder {
		private TextView tv;
		private ImageButton btn;
	}
}