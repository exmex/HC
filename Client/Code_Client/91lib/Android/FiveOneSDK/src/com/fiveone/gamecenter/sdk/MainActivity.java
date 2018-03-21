package com.fiveone.gamecenter.sdk;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.widget.Toast;
import com.fiveone.gamecenter.netconnect.bean.UserInfo;
import com.fiveone.gamecenter.netconnect.listener.AccountStatusListener;

public class MainActivity extends Activity {
	AccountStatusListener mListener;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		mListener = new AccountStatusListener() {
			@Override
			public void onFailed() {
				Toast.makeText(getApplicationContext(), "网络异常，请稍后重试",
						Toast.LENGTH_SHORT).show();
			}

			@Override
			public void onLoginSuccess(UserInfo info) {
				GameCenterService.SessionID = "";
				GameCenterService.callOnlineAccount(MainActivity.this);
				Toast.makeText(getApplicationContext(), "登录成功！",
						Toast.LENGTH_SHORT).show();
			}

			@Override
			public void onLoginPwdError() {
				Toast.makeText(getApplicationContext(), "账号或密码错误",
						Toast.LENGTH_SHORT).show();
			}

			@Override
			public void onRegisterSuccess(UserInfo info) {
				Toast.makeText(getApplicationContext(), "注册成功！",
						Toast.LENGTH_SHORT).show();
			}

			@Override
			public void onRegisterAccountExists() {
				Toast.makeText(getApplicationContext(), "该账号已被注册",
						Toast.LENGTH_SHORT).show();
			}

			@Override
			public boolean onLoginPageClose(Activity activity) {
				// 更具需求选择是否返回确认
				// if ((System.currentTimeMillis() - mExitTime) > 2000) {
				// Toast.makeText(activity, "再按一次退出程序",
				// Toast.LENGTH_SHORT).show();
				// mExitTime = System.currentTimeMillis();
				// } else {
				// activity.finish();
				// }
				// return true;
				Toast.makeText(getApplicationContext(), "登录页面关闭",
						Toast.LENGTH_SHORT).show();
				return false;
			}
		};

		GameCenterService.initSDK(MainActivity.this, "51001999", mListener);
		findViewById(R.id.gc_register).setOnClickListener(
				new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						GameCenterService
								.startRegisterActivity(MainActivity.this);

					}
				});
		findViewById(R.id.gc_login).setOnClickListener(
				new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						GameCenterService.startLoginActivity(MainActivity.this);

					}
				});
		findViewById(R.id.gc_paylist).setOnClickListener(
				new View.OnClickListener() {

					@Override
					public void onClick(View v) {
						// GameCenterService.startGamePayActivity(MainActivity.this);
						// GameCenterService.startGamePayActivity(MainActivity.this,"充值成功访问游戏服务器回调信息");
						GameCenterService.startGamePayActivity(
								MainActivity.this, "充值成功访问游戏服务器回调信息", "50");
					}
				});

		findViewById(R.id.gc_test).setOnClickListener(
				new View.OnClickListener() {
					@Override
					public void onClick(View v) {
						GameCenterService.setLoginServer(MainActivity.this,
								"游戏服务器ID必须是数字", "游戏服务器名称");
						// GameCenterService.setGameRoleName(MainActivity.this,"游戏中玩家名称");
						// GameCenterService.setGameLevel("游戏中玩家等级");
					}
				});
	}

	@Override
	protected void onPause() {
		super.onPause();
	}

	@Override
	protected void onResume() {
		super.onResume();
	}

}