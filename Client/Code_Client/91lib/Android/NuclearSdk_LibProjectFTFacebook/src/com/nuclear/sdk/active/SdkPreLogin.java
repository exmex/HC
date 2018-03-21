package com.nuclear.sdk.active;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;

import com.nuclear.sdk.android.entry.SdkUser;
import com.nuclear.sdk.R;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.os.Build.VERSION;
import android.os.Bundle;
import android.util.Base64;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.View;
import android.view.ViewGroup;
import android.view.WindowManager;
import android.view.WindowManager.LayoutParams;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.Toast;

public class SdkPreLogin extends Activity {
	private ArrayList<SdkUser> allUserList;
	private ArrayList<SdkUser> tryUserList;
	private int oritention;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if(VERSION.SDK_INT>=11){
			setFinishOnTouchOutside(false);  
		}
		try {
			PackageInfo info = getPackageManager().getPackageInfo(
					this.getPackageName(), PackageManager.GET_SIGNATURES);
			for (Signature signature : info.signatures) {
				MessageDigest md = MessageDigest.getInstance("SHA");
				md.update(signature.toByteArray());
				Log.d("KeyHash:",
						Base64.encodeToString(md.digest(), Base64.DEFAULT));
			}
		} catch (NameNotFoundException e) {

		} catch (NoSuchAlgorithmException e) {

		}

		SdkCommplatform.getInstance().addActivity(this);
		requestWindowFeature(1);
		getWindow().setFlags(1024, 1024);
		oritention = getIntent().getExtras().getInt("oritention");
		if(oritention==SdkCommplatform.LANDSCAPE){
			setContentView(R.layout.ya_login_splash_land);
		}else if(oritention==SdkCommplatform.PROTRIT){
			setContentView(R.layout.ya_login_splash);
		}

		DisplayMetrics localDisplayMetrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(localDisplayMetrics);

		allUserList = SdkCommplatform.getInstance().allUserList;
		tryUserList = new ArrayList<SdkUser>();

		SdkCommplatform.getInstance().callOnCreate(this);

//		if (localDisplayMetrics.widthPixels > localDisplayMetrics.heightPixels) {
//			landView();
//			return;
//		}
//		portView();

	}

	private void landView() {
		DisplayMetrics localDisplayMetrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(localDisplayMetrics);
		Button localButton1 = (Button) findView("btnFBLogin", "id");
		Button localButton2 = (Button) findView("btnGoogleLogin", "id");
		Button localButton3 = (Button) findView("btnTxwyLogin", "id");
		Button localButton4 = (Button) findView("btnTxwyGuest", "id");
		Button localButton5 = (Button) findView("btnQQLogin", "id");
		ImageView localImageView1 = (ImageView) findView("SplashLine", "id");
		ImageView localImageView2 = (ImageView) findView("imageViewBack", "id");
		localImageView2.getDrawable();
		float f1 = localDisplayMetrics.widthPixels / 3408.0F;
		float f2 = localDisplayMetrics.heightPixels / 2556.0F;
		if (f2 > f1) {
			localImageView2.getLayoutParams().width = ((int) (3408.0F * f2));
		}

		int i = 300 * localDisplayMetrics.widthPixels / 1008;
		int j = 334 * localDisplayMetrics.widthPixels / 1008;
		int k = 302 * localDisplayMetrics.widthPixels / 1008;
		int m = 30 * localDisplayMetrics.heightPixels / 756;
		int n = 10 * localDisplayMetrics.heightPixels / 756;
		int i1 = 25 * localDisplayMetrics.heightPixels / 756;
		localButton1.getLayoutParams().width = (468 * localDisplayMetrics.widthPixels / 1008);
		localButton1.getLayoutParams().height = (137 * localDisplayMetrics.heightPixels / 756);
		localButton2.getLayoutParams().width = (468 * localDisplayMetrics.widthPixels / 1008);
		localButton2.getLayoutParams().height = (137 * localDisplayMetrics.heightPixels / 756);
		localButton5.getLayoutParams().width = (468 * localDisplayMetrics.widthPixels / 1008);
		localButton5.getLayoutParams().height = (137 * localDisplayMetrics.heightPixels / 756);
		localButton3.getLayoutParams().width = (382 * localDisplayMetrics.widthPixels / 1008);
		localButton3.getLayoutParams().height = (65 * localDisplayMetrics.heightPixels / 756);
		localButton4.getLayoutParams().width = (382 * localDisplayMetrics.widthPixels / 1008);
		localButton4.getLayoutParams().height = (65 * localDisplayMetrics.heightPixels / 756);
		localImageView1.getLayoutParams().width = (464 * localDisplayMetrics.widthPixels / 1008);
		localImageView1.getLayoutParams().height = (14 * localDisplayMetrics.heightPixels / 756);
		((ViewGroup.MarginLayoutParams) localButton1.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) localButton1.getLayoutParams()).topMargin = m;
		((ViewGroup.MarginLayoutParams) localButton5.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) localButton5.getLayoutParams()).topMargin = m;
		((ViewGroup.MarginLayoutParams) localButton2.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) localButton2.getLayoutParams()).topMargin = (m + n);
		((ViewGroup.MarginLayoutParams) localImageView1.getLayoutParams()).leftMargin = k;
		((ViewGroup.MarginLayoutParams) localImageView1.getLayoutParams()).topMargin = (m + n);
		((ViewGroup.MarginLayoutParams) localButton3.getLayoutParams()).leftMargin = j;
		((ViewGroup.MarginLayoutParams) localButton3.getLayoutParams()).topMargin = (n + (m
				+ 2
				* localButton1.getLayoutParams().height
				+ n
				* 4
				+ localImageView1.getLayoutParams().height + i1 * 2));
		((ViewGroup.MarginLayoutParams) localButton4.getLayoutParams()).leftMargin = j;
		((ViewGroup.MarginLayoutParams) localButton4.getLayoutParams()).topMargin = (m + n);
//		return;
		// localImageView2.getLayoutParams().width = ((int) (3408.0F * f1));

	}

	private void portView() {
		DisplayMetrics localDisplayMetrics = new DisplayMetrics();
		getWindowManager().getDefaultDisplay().getMetrics(localDisplayMetrics);
		Button localButton1 = (Button) findView("btnFBLogin", "id");
		Button localButton2 = (Button) findView("btnQQLogin", "id");
		Button localButton3 = (Button) findView("btnGoogleLogin", "id");
		Button localButton4 = (Button) findView("btnTxwyLogin", "id");
		Button localButton5 = (Button) findView("btnTxwyGuest", "id");
		ImageView localImageView1 = (ImageView) findView("SplashLine", "id");
		ImageView localImageView2 = (ImageView) findView("imageLogo", "id");
		int i = 200 * localDisplayMetrics.widthPixels / 720;
		int j = 234 * localDisplayMetrics.widthPixels / 720;
		int k = 202 * localDisplayMetrics.widthPixels / 720;
		int m = 5 * localDisplayMetrics.heightPixels / 1184;
		int n = 10 * localDisplayMetrics.heightPixels / 1184;
		localImageView2.getLayoutParams().width = (240 * localDisplayMetrics.widthPixels / 720);
		localImageView2.getLayoutParams().height = (240 * localDisplayMetrics.heightPixels / 1184);
		localButton1.getLayoutParams().width = ((int) (0.85D * (550 * localDisplayMetrics.widthPixels) / 720));
		localButton1.getLayoutParams().height = ((int) (0.85D * (121 * localDisplayMetrics.heightPixels) / 1184));
		localButton2.getLayoutParams().width = ((int) (0.85D * (550 * localDisplayMetrics.widthPixels) / 720));
		localButton2.getLayoutParams().height = ((int) (0.85D * (121 * localDisplayMetrics.heightPixels) / 1184));
		localButton3.getLayoutParams().width = ((int) (0.85D * (550 * localDisplayMetrics.widthPixels) / 720));
		localButton3.getLayoutParams().height = ((int) (0.85D * (121 * localDisplayMetrics.heightPixels) / 1184));
		localButton4.getLayoutParams().width = ((int) (0.85D * (449 * localDisplayMetrics.widthPixels) / 720));
		localButton4.getLayoutParams().height = ((int) (0.85D * (76 * localDisplayMetrics.heightPixels) / 1184));
		localButton5.getLayoutParams().width = ((int) (0.85D * (449 * localDisplayMetrics.widthPixels) / 720));
		localButton5.getLayoutParams().height = ((int) (0.85D * (76 * localDisplayMetrics.heightPixels) / 1184));
		localImageView1.getLayoutParams().width = ((int) (0.85D * (546 * localDisplayMetrics.widthPixels) / 720));
		localImageView1.getLayoutParams().height = ((int) (0.85D * (16 * localDisplayMetrics.heightPixels) / 1184));
		((ViewGroup.MarginLayoutParams) localImageView2.getLayoutParams()).topMargin = m;
		((ViewGroup.MarginLayoutParams) localButton1.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) localButton1.getLayoutParams()).topMargin = m;
		((ViewGroup.MarginLayoutParams) localButton2.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) localButton2.getLayoutParams()).topMargin = m;
		((ViewGroup.MarginLayoutParams) localButton3.getLayoutParams()).leftMargin = i;
		((ViewGroup.MarginLayoutParams) localButton3.getLayoutParams()).topMargin = (m + n);
		((ViewGroup.MarginLayoutParams) localImageView1.getLayoutParams()).leftMargin = k;
		((ViewGroup.MarginLayoutParams) localImageView1.getLayoutParams()).topMargin = (m + n);
		((ViewGroup.MarginLayoutParams) localButton4.getLayoutParams()).leftMargin = j;
		((ViewGroup.MarginLayoutParams) localButton4.getLayoutParams()).topMargin = (m
				+ n * 5 + localImageView1.getLayoutParams().height);
		((ViewGroup.MarginLayoutParams) localButton5.getLayoutParams()).leftMargin = j;
		((ViewGroup.MarginLayoutParams) localButton5.getLayoutParams()).topMargin = (m + n);
	};

	private View findView(String paramString1, String paramString2) {
		return findViewById(getIdentifier(paramString1, paramString2));
	}

	private int getIdentifier(String paramString1, String paramString2) {
		return getApplicationContext().getResources().getIdentifier(
				paramString1, paramString2, getPackageName());
	}

	public void onTxwyLoginClick(View view) {
		// Intent intent = new Intent(this, nuclearLogin.class);
		// intent.putExtra("KEY_POSITION", 1);
		// startActivity(intent);

		Intent intent = new Intent(this, SdkLoginMain.class);
		intent.putExtra("KEY_POSITION", 1);
		startActivityForResult(intent, 1);
	}

	public void onTxwyGuestClick(View view) {
		for (SdkUser pUser : allUserList) {
			if ("2".equals(pUser.getUserType())) {
				tryUserList.add(pUser);
			}
		}
		if (tryUserList.size() == 0) {
			SdkCommplatform.getInstance().doByUser(0);
		} else {
			SdkCommplatform.getInstance().doByUser(2);
		}
		finish();
	}

	public void onGoogleLoginClick(View v) {
		SdkCommplatform.getInstance().googleLogin(this);
	}

	public void onFBLoginClick(View v) {
		SdkCommplatform.getInstance().facebookLogin(this);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		SdkCommplatform.getInstance().onActivityResult(this, requestCode,
				resultCode, data);

	}

	@Override
	protected void onStart() {
		super.onStart();
		// nuclearCommplatform.getInstance().callOnStart();
	}

	@Override
	protected void onStop() {
		super.onStart();
		SdkCommplatform.getInstance().callOnStop();
	}

	@Override
	public void onBackPressed() {
		if (!SdkCommplatform.getInstance().isLogined()) {
			if (SdkCommplatform.getInstance().mUserCallback != null) {
				SdkCommplatform.getInstance().mUserCallback.onLoginSuccess("");
			} else {
				Toast.makeText(getApplicationContext(), "",
						Toast.LENGTH_SHORT);
			}
		}

		super.onBackPressed();

	}
}
