package com.fiveone.gamecenter.sdk.activity;

import android.app.Activity;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;
import com.fiveone.gamecenter.netconnect.NetConnectService;
import com.fiveone.gamecenter.sdk.Config;
import com.fiveone.gamecenter.sdk.GameCenterService;
import com.fiveone.gamecenter.sdk.R;

public class GamePayActivity extends Activity {
	public GamePayActivity() {

	}

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
		initPayView();
	}

	private void initPayView() {
		if (GameCenterService.UserInfo == null || TextUtils.isEmpty(GameCenterService.UserInfo.getUsername())) { 
			Toast.makeText(getApplicationContext(), "请登录后查看", Toast.LENGTH_SHORT).show();
			finish();
			return;
		}
		String url = NetConnectService.getPayWebViewUrl(this, Config.GAME_CENTER_APP_KEY, Config.GAME_CENTER_PRIVATE_KEY, GameCenterService.ServerID, String.valueOf(GameCenterService.UserInfo.getUserId()),GameCenterService.GamePayCallBackInfo,GameCenterService.GamePayDefaultCash);
		setContentView(R.layout.gamecenter_pay_main);
		WebView webView = (WebView) findViewById(R.id.webview);
		webView.setWebViewClient(new MyWebViewClient());
		webView.getSettings().setJavaScriptEnabled(true);
		webView.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		webView.clearCache(true);
		webView.clearHistory();
		webView.loadUrl(url);
	}

	class MyWebViewClient extends WebViewClient {
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			Log.i("yangl","shouldoverid url:"+url);
			if (url.toLowerCase().equals("http://pay.gc.51.com/pay/finishclose")){
				Log.i("yangl","shouldoverid equal:");
				finish();
				return true;
			}else{
				Log.i("yangl","shouldoverid not equal:");
				view.loadUrl(url);	
			}
			return super.shouldOverrideUrlLoading(view, url);
		}
	}
}