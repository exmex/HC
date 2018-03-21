package com.example.gtvsdk;

import java.net.URI;
import java.net.URISyntaxException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.protocol.HTTP;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Message;
import android.util.Log;
import android.view.Window;
import android.view.ViewGroup.LayoutParams;
import android.webkit.JsResult;
import android.webkit.WebChromeClient;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;
import android.widget.Toast;

public class GTVAuthorizeView extends Activity {

	WebView web;
	// kGTVWebAuthLoginURL
	Intent intent;
	GTVSDKBean mGTVSDKBean;
	LinearLayout ll;
	ProgressDialog dialog;
	HashMap<String, Object> params;
	GTVAuthorizeViewInterface delegate;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		ll = new LinearLayout(this);
		ll.setOrientation(LinearLayout.VERTICAL);
		web = new WebView(this);

		intent = getIntent();
		mGTVSDKBean = (GTVSDKBean) intent.getSerializableExtra("bean");
		String requestUrl = mGTVSDKBean.getUrl();
		params = mGTVSDKBean.getMap();
		this.delegate = mGTVSDKBean.getmAuthorizeViewInterface();

		if (requestUrl.equals(GTVSDKConstants.kGTVWebAuthLoginURL)) {
			showLoginView();
		}
		if (requestUrl.equals(GTVSDKConstants.kGTVWebRechargeURL)) {
			showRechargeView();
		}
		web.setWebViewClient(new WebViewClient() {
			// 新开页面时用自己定义的webview来显示，不用系统自带的浏览器来显示
			@Override
			public boolean shouldOverrideUrlLoading(WebView view, String url) {
				//Log.e("----->", url);
				// 返回按钮
				if (url.equals("http://passport.gtv.com.cn/_sdk/close.php")) {
					finish();
				} else if (url // 登陆成功页面
						.contains("http://passport.gtv.com.cn/_sdk/login_su.php")) {
					// Log.e("----->", "请求登陆的网址是："+url);
					// Log.e("----->", "进入到了登陆成功界面");
					String _idStr = GTVRequest.getParamValueFromUrl(url, "id");
					// Log.e("----->", "id is " + _idStr);
					String _timeStr = GTVRequest.getParamValueFromUrl(url,
							"time");
					// Log.e("----->", "time is " + _timeStr);
					String _signStr = GTVRequest.getParamValueFromUrl(url,
							"sign");
					// Log.e("----->", "sign is " + _signStr);
					if (_idStr != null && _timeStr != null && _signStr != null) {
						int serverTime = Integer.parseInt(_timeStr);
						if ((System.currentTimeMillis() / 1000 - serverTime) > 300) {
							Toast.makeText(GTVAuthorizeView.this, "请求超时",
									Toast.LENGTH_SHORT).show();
							delegate.authorizeViewdidFailWithErrorInfo(
									GTVAuthorizeView.this, "请求超时");
							finish();
						} else {
							// [self hide];少操作一个函数
							delegate.authorizeViewdidRecieveAuthorizationID(
									GTVAuthorizeView.this, _idStr, _timeStr,
									_signStr);
						}
					}

				} else if (url// 注册成功
						.contains("http://passport.gtv.com.cn/_sdk/reg_su.php")) {
					// Log.e("----->", "进入到了注册成功的函数中");
					String _idStr = GTVRequest.getParamValueFromUrl(url, "id");
					// Log.e("----->", "进入到了注册成功的函数中id是：" + _idStr);
					String _timeStr = GTVRequest.getParamValueFromUrl(url,
							"time");
					// Log.e("----->", "进入到了注册成功的函数中time是：" + _timeStr);
					String _signStr = GTVRequest.getParamValueFromUrl(url,
							"sign");
					// Log.e("----->", "进入到了注册成功的函数中sign是：" + _signStr);
					if (_idStr != null && _timeStr != null && _signStr != null) {
						int serverTime = Integer.parseInt(_timeStr);
						if ((System.currentTimeMillis() / 1000 - serverTime) > 300) {
							delegate.authorizeViewdidFailWithErrorInfo(
									GTVAuthorizeView.this, "请求超时");

						} else {
							delegate.authorizeViewdidRecieveRegisterID(
									GTVAuthorizeView.this, _idStr, _timeStr,
									_signStr);

						}
					} else {
						delegate.authorizeViewdidFailWithErrorInfo(
								GTVAuthorizeView.this, "返回参数为空");

					}

				} else if (url// 兑换成功
						.contains("http://passport.gtv.com.cn/_sdk/assign_submit.php")) {
					String _moneyStr = GTVRequest.getParamValueFromUrl(url,
							"money");
					if (_moneyStr != null) {
						delegate.authorizeViewdidRecieveRechargeSumbitMoneyStr(
								GTVAuthorizeView.this, _moneyStr);
					} else {
						delegate.authorizeViewdidFailWithErrorInfo(
								GTVAuthorizeView.this, "返回参数为空");
					}
				} else {
					view.loadUrl(url);
				}
				return true;
			}

			// 开始加载网页时要做的工作
			@Override
			public void onPageStarted(WebView view, String url, Bitmap favicon) {
				// Log.e("----->", "开始加载网页");
				if (url.contains("http://passport.gtv.com.cn/_sdk/assign_submit.php")) {
					String _moneyStr = GTVRequest.getParamValueFromUrl(url,
							"money");
					if (_moneyStr != null) {
						delegate.authorizeViewdidRecieveRechargeSumbitMoneyStr(
								GTVAuthorizeView.this, _moneyStr);
						finish();
					} else {
						delegate.authorizeViewdidFailWithErrorInfo(
								GTVAuthorizeView.this, "返回参数为空");
						finish();
					}
				}
				dialog = new ProgressDialog(GTVAuthorizeView.this);
				dialog.setMessage("正在加载网页...");
				dialog.setProgressStyle(ProgressDialog.STYLE_SPINNER);
				dialog.show();
				super.onPageStarted(view, url, favicon);
			}

			// 加载完成时要做的工作
			@Override
			public void onPageFinished(WebView view, String url) {
				// Log.e("----->", "网页加载完了");
				if (dialog != null) {
					dialog.cancel();
				}
				super.onPageFinished(view, url);
			}

			// 加载错误时要做的工作
			@Override
			public void onReceivedError(WebView view, int errorCode,
					String description, String failingUrl) {
				// Log.e("----->", "onReceivedError");
				if (dialog != null) {
					dialog.cancel();
				}
				super.onReceivedError(view, errorCode, description, failingUrl);
			}

			@Override
			public void onFormResubmission(WebView view, Message dontResend,
					Message resend) {
				// Log.e("----->", "onFormResubmission");
				super.onFormResubmission(view, dontResend, resend);

			}

		});

		LayoutParams params = null;
		ll.addView(web);
		params = web.getLayoutParams();
		params.height = LayoutParams.MATCH_PARENT;
		params.width = LayoutParams.MATCH_PARENT;
		web.setLayoutParams(params);
		setContentView(ll);
	}

	/**
	 * 
	 * 函数名称：showLoginView</br>
	 * 功能描述：
	 * @author Administrator
	 * 修改日志:</br>
	 * <table>
	 * <tr><th>版本</th><th>日期</th><th>作者</th><th>描述</th>
	 * <tr><td>0.1</td><td>2013-8-26</td><td>Administrator</td><td>初始创建</td>      
	 * </table>
	 */
	private void showLoginView() {
		String url = GTVRequest.serializeURL(this.params,
				GTVSDKConstants.kGTVWebAuthLoginURL);
		// Log.e("----->", url);
		web.loadUrl(url);
		web.getSettings().setJavaScriptEnabled(true);
	}

	private void showRechargeView() {
		String url = GTVRequest.serializeURL(this.params,
				GTVSDKConstants.kGTVWebRechargeURL);
		// Log.e("----->", url);
		web.loadUrl(url);
		web.getSettings().setJavaScriptEnabled(true);
	}

}

