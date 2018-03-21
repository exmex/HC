package com.nuclear.sdk.active;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.os.Build.VERSION;
import android.util.DisplayMetrics;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

import com.nuclear.sdk.R;

public class SdkRegistBindPre extends Activity {
	private Button btnBind;
	private Button btnLater;
	private ImageView localImageView;

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
		setContentView(R.layout.ya_guestnotice);
		SdkCommplatform.getInstance().addActivity(this);
		init();
		setListener();

		DisplayMetrics localDisplayMetrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(localDisplayMetrics);

		if (localDisplayMetrics.widthPixels > localDisplayMetrics.heightPixels) {
			landView();
			return;
		}
		portView();

	}

	private void landView() {
		DisplayMetrics localDisplayMetrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(localDisplayMetrics);
		int i = 270 * localDisplayMetrics.widthPixels / 1008;
		int j = 40 * localDisplayMetrics.heightPixels / 756;
		btnBind.getLayoutParams().width = (332 * localDisplayMetrics.widthPixels / 1008);
		btnBind.getLayoutParams().height = (79 * localDisplayMetrics.heightPixels / 756);
		btnLater.getLayoutParams().width = (332 * localDisplayMetrics.widthPixels / 1008);
		btnLater.getLayoutParams().height = (79 * localDisplayMetrics.heightPixels / 756);
		localImageView.getLayoutParams().width = (553 * localDisplayMetrics.widthPixels / 1008);
		localImageView.getLayoutParams().height = (220 * localDisplayMetrics.heightPixels / 756);
		((ViewGroup.MarginLayoutParams) btnBind.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) btnBind.getLayoutParams()).topMargin = (j + btnLater
				.getLayoutParams().height);
		((ViewGroup.MarginLayoutParams) btnLater.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) btnLater.getLayoutParams()).topMargin = j;
	}

	private void portView() {
		DisplayMetrics localDisplayMetrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(localDisplayMetrics);
		int i = 65 * localDisplayMetrics.widthPixels / 720;
		int j = 420 * localDisplayMetrics.heightPixels / 1184;
		int k = 40 * localDisplayMetrics.heightPixels / 1184;
		btnBind.getLayoutParams().width = (332 * localDisplayMetrics.widthPixels / 720);
		btnBind.getLayoutParams().height = (79 * localDisplayMetrics.heightPixels / 1184);
		btnLater.getLayoutParams().width = (332 * localDisplayMetrics.widthPixels / 720);
		btnLater.getLayoutParams().height = (79 * localDisplayMetrics.heightPixels / 1184);
		localImageView.getLayoutParams().width = (553 * localDisplayMetrics.widthPixels / 720);
		localImageView.getLayoutParams().height = (220 * localDisplayMetrics.heightPixels / 1184);
		((ViewGroup.MarginLayoutParams) localImageView.getLayoutParams()).topMargin = j;
		((ViewGroup.MarginLayoutParams) btnBind.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) btnBind.getLayoutParams()).topMargin = (j
				+ localImageView.getLayoutParams().height - k);
		((ViewGroup.MarginLayoutParams) btnLater.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) btnLater.getLayoutParams()).topMargin = k;
	}

	private void init() {
		btnBind = (Button) findViewById(R.id.btnBind);

		btnLater = (Button) findViewById(R.id.btnLater);
		localImageView = (ImageView) findViewById(R.id.imageNotice);
	}

	private void setListener() {
		btnBind.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				SdkRegistBindPre.this.finish();
				Intent intent = new Intent(SdkRegistBindPre.this,
						SdkRegistBind.class);
				startActivity(intent);
			}
		});

		btnLater.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {

				SdkCommplatform.getInstance().doByUser(2);

				SdkCommplatform.getInstance().finish();
			}

		});
	}

	@Override
	public void onBackPressed() {
		if (!SdkCommplatform.getInstance().isLogined()) {
			if (SdkCommplatform.getInstance().mUserCallback != null) {
				SdkCommplatform.getInstance().mUserCallback.onLoginSuccess("");
			} else {
				Toast.makeText(getApplicationContext(), "內存不足，請關閉其他應用再進入本遊戲",
						Toast.LENGTH_SHORT);
			}
		}
		super.onBackPressed();

	}
}
