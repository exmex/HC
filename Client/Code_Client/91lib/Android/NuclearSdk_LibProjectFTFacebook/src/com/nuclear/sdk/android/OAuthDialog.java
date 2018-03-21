package com.nuclear.sdk.android;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.webkit.CookieManager;
import android.webkit.CookieSyncManager;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

import com.nuclear.sdk.android.config.FatherOAuthConfig;
import com.nuclear.sdk.android.token.Token;
import com.nuclear.sdk.net.SslError;
import com.nuclear.sdk.R;

class OAuthDialog extends Dialog {

	private static final String TAG = OAuthDialog.class.getSimpleName();

	private WebView mWebview;
	private String mUrl;
	private FatherOAuthConfig mConfig;

	private ProgressDialog mSpinner;
	
	private OAuthListener mOAuthListener;
	private Button backBtn;
	
	public void setOAuthListener(OAuthListener l) {
		mOAuthListener = l;
	}

	public OAuthDialog(Context context, FatherOAuthConfig config) {
		super(context, R.style.u2_AppTheme);
		mConfig = config;
		mUrl = mConfig.getCodeUrl();
	}

	@SuppressLint("SetJavaScriptEnabled")
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_oauth);

		backBtn = (Button) findViewById(R.id.u2_back);
		
		mSpinner = new ProgressDialog(getContext());
		mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
		mSpinner.setMessage("加载中...");
		
		mSpinner.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
				//OAuthDialog.this.onBackPressed();
				//OAuthDialog.this.cancel();
				onBack();
				return false;
			}

		});
		
		
		mWebview = (WebView) findViewById(R.id.webview);
		//mWebview.getSettings().setCacheMode(WebSettings.LOAD_NO_CACHE);
		CookieManager.getInstance().removeAllCookie(); 
	    //mWebview.getContext().deleteDatabase("webview.db"); 
		//mWebview.getContext().deleteDatabase("webviewCache.db");
		mWebview.getSettings().setJavaScriptEnabled(true);
		
		
		mWebview.setWebViewClient(new OAuthWebViewClient());
		
		mWebview.loadUrl(mUrl);
		backBtn.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				onBack();
			}
		});
	
	}
	
	 
	 
	/*@Override
	public void onBackPressed() {
		mOAuthListener.onCancel();
		mSpinner.dismiss();
		super.onBackPressed();
	}*/
	
	protected void onBack() {
		try {
			mSpinner.dismiss();
			if (null != mWebview) {
				mWebview.stopLoading();
				OAuthDialog.this.cancel();
				mWebview.destroy();
			}
		} catch (Exception e) {
		}
		dismiss();
	}
	

	public class OAuthWebViewClient extends WebViewClient {

		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			 return super.shouldOverrideUrlLoading(view, url);
		}

		
		@Override
		public void onReceivedError(WebView view, int errorCode, String description,
				String failingUrl) {
			super.onReceivedError(view, errorCode, description, failingUrl);
			mOAuthListener.onError(description);
			OAuthDialog.this.dismiss();
		}
		@Override
		public void onReceivedSslError(WebView view, SslErrorHandler handler,
				android.net.http.SslError error) {
			// TODO Auto-generated method stub
			handler.proceed();//接受证书
		}
		
		
		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
			
			mSpinner.show();
			Log.d(TAG, "url: " + url);
			if (url.startsWith(mConfig.redirectUrl)) {
				view.stopLoading();
				Uri uri = Uri.parse(url);
				String error = uri.getQueryParameter("error");
				if (error != null) {
					Log.d(TAG, "error: " + error);
					if (error.equals("access_denied")) {
						mOAuthListener.onCancel();
					} else {
						mOAuthListener.onError(error);
					}
				} else {
					mConfig.getAccessCode(uri, new OAuthListener() {
						@Override
						public void onSuccess(Token token) {
							mOAuthListener.onSuccess(token);
							OAuthDialog.this.dismiss();

						}

						@Override
						public void onError(String error) {
							
							new AlertDialog.Builder(getContext())  
								.setTitle(R.string.warning)
							    .setMessage(error)
							    .setPositiveButton(R.string.ensure, new OnClickListener() {
									
									@Override
									public void onClick(DialogInterface dialog, int which) {
										OAuthDialog.this.dismiss();										
									}
								})
							    .show();
						}

						@Override
						public void onCancel() {
						}
					});
				}
			}
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			CookieSyncManager.getInstance().sync();
			mSpinner.dismiss();
		}
		
		public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
			handler.proceed();
		}
		
	}

}
