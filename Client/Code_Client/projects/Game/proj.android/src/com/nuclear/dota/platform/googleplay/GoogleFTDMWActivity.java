package com.nuclear.dota.platform.googleplay;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.Signature;
import android.net.Uri;
import android.os.Bundle;
import android.util.Base64;
import android.util.Log;
import android.widget.Toast;

import com.chartboost.sdk.Chartboost;
import com.chartboost.sdk.ChartboostDelegate;
import com.chartboost.sdk.Libraries.CBLogging.Level;
import com.chartboost.sdk.Model.CBError.CBClickError;
import com.chartboost.sdk.Model.CBError.CBImpressionError;
import com.facebook.AppEventsLogger;
import com.inmobi.commons.InMobi;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.ZipObbUtil;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.qsds.ggg.dfgdfg.fvfvf.R;

public class GoogleFTDMWActivity extends GameActivity {

	private static final String TAG = "GoogleFTDMWActivity";
	/*
	 * 
	 * */
	public GoogleFTDMWActivity() {
		/*
		 * */
		super.mGameCfg = new GameConfig(this,
				PlatformAndGameInfo.enPlatform_GoogleFT);

	}

	@Override
	protected void onStart() {
		super.onStart();
		Chartboost.onStart(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
		Chartboost.onPause(this);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		PlatformGpftLoginAndPay instantce = PlatformGpftLoginAndPay
				.getInstance();
		InMobi.initialize(this, getResources().getString(R.string.inmobiId));
		Chartboost.startWithAppId(this, getResources()
				.getString(R.string.charboostId),
				getResources().getString(R.string.charboostSign));
		Chartboost.setLoggingLevel(Level.ALL);
		Chartboost.setDelegate(delegate);
		Chartboost.onCreate(this);
		instantce.initAppsFlyer(this);
		instantce.logger = AppEventsLogger.newLogger(this);

		Intent intent = getIntent();
		Uri data = intent.getData();
		Log.e("GoogleFTDMWActivity", "intent.getData()==>" + data);
		String scheme = intent.getScheme();
		if ((null != scheme) && scheme.contains("http")) {
			instantce.logger.logEvent("fb_deeplink");
		}

		instantce.logger.logEvent("fb_launcher");
		try {

			PackageInfo info = getPackageManager().getPackageInfo(

			this.getPackageName(),

			PackageManager.GET_SIGNATURES);

			for (Signature signature : info.signatures) {

				MessageDigest md = MessageDigest.getInstance("SHA");

				md.update(signature.toByteArray());

				String KeyHash = Base64.encodeToString(md.digest(),
						Base64.DEFAULT);

				Log.d("KeyHash:", "KeyHash:" + KeyHash);// 两次获取的不一样 此处取第一个的值

				// Toast.makeText(this, "FaceBook HashKey:"+KeyHash,
				// Toast.LENGTH_SHORT).show();

			}

		} catch (NameNotFoundException e) {

		} catch (NoSuchAlgorithmException e) {

		}

	}


	@Override
	protected void onResume() {
		super.onResume();
		Chartboost.onResume(this);
		ZipObbUtil.getInstance().onResume(this);
		AppEventsLogger.activateApp(this, getString(R.string.xm_app_id));
	}

	@Override
	protected void onStop() {
		ZipObbUtil.getInstance().onStop(this);
		super.onStop();
		Chartboost.onStop(this);
	}

	@Override
	protected void onDestroy() {
		super.onDestroy();
		Chartboost.onDestroy(this);
	}

	@Override
	public void onBackPressed() {
		// 如屏上有插页式广告则关闭。
		if (Chartboost.onBackPressed())
			return;
		else
			super.onBackPressed();
	}

	@Override
	protected void onSaveInstanceState(Bundle outState) {
		super.onSaveInstanceState(outState);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		if (PlatformGpftLoginAndPay.getInstance().onActivityResult(requestCode,
				resultCode, data)) {
			super.onActivityResult(requestCode, resultCode, data);
			return;
		}
	}

	private ChartboostDelegate delegate = new ChartboostDelegate() {

		@Override
		public boolean shouldRequestInterstitial(String location) {
			Log.i(TAG, "SHOULD REQUEST INTERSTITIAL '"
					+ (location != null ? location : "null"));
			return true;
		}

		@Override
		public boolean shouldDisplayInterstitial(String location) {
			Log.i(TAG, "SHOULD DISPLAY INTERSTITIAL '"
					+ (location != null ? location : "null"));
			return true;
		}

		@Override
		public void didCacheInterstitial(String location) {
			Log.i(TAG, "DID CACHE INTERSTITIAL '"
					+ (location != null ? location : "null"));
		}

		@Override
		public void didFailToLoadInterstitial(String location,
				CBImpressionError error) {
			Log.i(TAG, "DID FAIL TO LOAD INTERSTITIAL '"
					+ (location != null ? location : "null") + " Error: "
					+ error.name());
			Toast.makeText(
					getApplicationContext(),
					"INTERSTITIAL '" + location + "' REQUEST FAILED - "
							+ error.name(), Toast.LENGTH_SHORT).show();
		}

		@Override
		public void didDismissInterstitial(String location) {
			Log.i(TAG, "DID DISMISS INTERSTITIAL: "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didCloseInterstitial(String location) {
			Log.i(TAG, "DID CLOSE INTERSTITIAL: "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didClickInterstitial(String location) {
			Log.i(TAG, "DID CLICK INTERSTITIAL: "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didDisplayInterstitial(String location) {
			Log.i(TAG, "DID DISPLAY INTERSTITIAL: "
					+ (location != null ? location : "null"));
		}

		@Override
		public boolean shouldRequestMoreApps(String location) {
			Log.i(TAG, "SHOULD REQUEST MORE APPS: "
					+ (location != null ? location : "null"));
			return true;
		}

		@Override
		public boolean shouldDisplayMoreApps(String location) {
			Log.i(TAG, "SHOULD DISPLAY MORE APPS: "
					+ (location != null ? location : "null"));
			return true;
		}

		@Override
		public void didFailToLoadMoreApps(String location,
				CBImpressionError error) {
			Log.i(TAG, "DID FAIL TO LOAD MOREAPPS "
					+ (location != null ? location : "null") + " Error: "
					+ error.name());
			Toast.makeText(getApplicationContext(),
					"MORE APPS REQUEST FAILED - " + error.name(),
					Toast.LENGTH_SHORT).show();
		}

		@Override
		public void didCacheMoreApps(String location) {
			Log.i(TAG, "DID CACHE MORE APPS: "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didDismissMoreApps(String location) {
			Log.i(TAG, "DID DISMISS MORE APPS "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didCloseMoreApps(String location) {
			Log.i(TAG, "DID CLOSE MORE APPS: "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didClickMoreApps(String location) {
			Log.i(TAG, "DID CLICK MORE APPS: "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didDisplayMoreApps(String location) {
			Log.i(TAG, "DID DISPLAY MORE APPS: "
					+ (location != null ? location : "null"));
		}

		@Override
		public void didFailToRecordClick(String uri, CBClickError error) {
			Log.i(TAG, "DID FAILED TO RECORD CLICK "
					+ (uri != null ? uri : "null") + ", error: " + error.name());
			Toast.makeText(
					getApplicationContext(),
					"FAILED TO RECORD CLICK " + (uri != null ? uri : "null")
							+ ", error: " + error.name(), Toast.LENGTH_SHORT)
					.show();
		}

		@Override
		public boolean shouldDisplayRewardedVideo(String location) {
			Log.i(TAG, String.format("SHOULD DISPLAY REWARDED VIDEO: '%s'",
					(location != null ? location : "null")));
			return true;
		}

		@Override
		public void didCacheRewardedVideo(String location) {
			Log.i(TAG, String.format("DID CACHE REWARDED VIDEO: '%s'",
					(location != null ? location : "null")));
		}

		@Override
		public void didFailToLoadRewardedVideo(String location,
				CBImpressionError error) {
			Log.i(TAG, String.format(
					"DID FAIL TO LOAD REWARDED VIDEO: '%s', Error:  %s",
					(location != null ? location : "null"), error.name()));
			Toast.makeText(
					getApplicationContext(),
					String.format(
							"DID FAIL TO LOAD REWARDED VIDEO '%s' because %s",
							location, error.name()), Toast.LENGTH_SHORT).show();
		}

		@Override
		public void didDismissRewardedVideo(String location) {
			Log.i(TAG, String.format("DID DISMISS REWARDED VIDEO '%s'",
					(location != null ? location : "null")));
		}

		@Override
		public void didCloseRewardedVideo(String location) {
			Log.i(TAG, String.format("DID CLOSE REWARDED VIDEO '%s'",
					(location != null ? location : "null")));
		}

		@Override
		public void didClickRewardedVideo(String location) {
			Log.i(TAG, String.format("DID CLICK REWARDED VIDEO '%s'",
					(location != null ? location : "null")));
		}

		@Override
		public void didCompleteRewardedVideo(String location, int reward) {
			Log.i(TAG, String.format(
					"DID COMPLETE REWARDED VIDEO '%s' FOR REWARD %d",
					(location != null ? location : "null"), reward));
		}

		@Override
		public void didDisplayRewardedVideo(String location) {
			Log.i(TAG, String.format(
					"DID DISPLAY REWARDED VIDEO '%s' FOR REWARD", location));
		}

		@Override
		public void willDisplayVideo(String location) {
			Log.i(TAG, String.format("WILL DISPLAY VIDEO '%s", location));
		}

	};
}
