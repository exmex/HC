package com.youai.sdk.webpay;

import com.youai.sdk.R;
import com.youai.sdk.net.SslError;

import android.annotation.SuppressLint;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.DialogInterface.OnKeyListener;
import android.content.IntentSender.SendIntentException;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.webkit.CookieSyncManager;
import android.webkit.HttpAuthHandler;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

@SuppressLint("SetJavaScriptEnabled")
public class TencentPayDialog extends Dialog {
	private static final int BACKMAIN = 1;
	
	private static final String TAG = TencentPayDialog.class.getSimpleName();

	private WebView mWebview;
	private String mUrl;

	private ProgressDialog mSpinner;
	private Button backBtn;
	private PayWebListen mWebListener;

	private Handler mMainHandler = new Handler(){

		@Override
		public void dispatchMessage(Message msg) {
			Log.i(TAG, "dispatchMessage"+msg.what);
			switch (msg.what) {
			case BACKMAIN:
				mWebListener.onSuccess("");
				break;
			}
		}
	};
	
	public void setWebListener(PayWebListen plisten) {
		mWebListener = plisten;
	}

	public TencentPayDialog(Context context, String pUrl) {
		super(context, R.style.u2_AppTheme);
		this.mUrl = pUrl;
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_oauth);
		
		mSpinner = new ProgressDialog(getContext());
		mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
		mSpinner.setMessage("加载中...");
		
		mSpinner.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
				//onBack();
				return false;
			}

		});
	 
		mWebview = (WebView) findViewById(R.id.webview);
		mWebview.getSettings().setJavaScriptEnabled(true);
		mWebview.setWebViewClient(new PayTencentWebViewClient());
		InJavaScriptLocalObj backGameJs = new InJavaScriptLocalObj();
		
		mWebview.addJavascriptInterface(backGameJs, "localjs");
		
		
		mWebview.loadUrl(mUrl);
		backBtn = (Button) findViewById(R.id.u2_back);
		backBtn.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				onBack();
			}
		});
	}

	final class InJavaScriptLocalObj {  
        
        public void goBackGame(){
        	mMainHandler.sendEmptyMessage(BACKMAIN);
        }
	}
	protected void onBack() {
		try {
			mSpinner.dismiss();
			if (null != mWebview) {
				mWebview.stopLoading();
				TencentPayDialog.this.cancel();
				mWebview.destroy();
			}
		} catch (Exception e) {
		}
		dismiss();
	}
	/*@Override
	public void onBackPressed() {
		mSpinner.dismiss();
		super.onBackPressed();
	}*/

	public class PayTencentWebViewClient extends WebViewClient {

		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			return super.shouldOverrideUrlLoading(view, url);
		}

		@Override
		public void onReceivedError(WebView view, int errorCode, String description,
				String failingUrl) {
			super.onReceivedError(view, errorCode, description, failingUrl);
			//mWebListener.onCancel();
			TencentPayDialog.this.dismiss();
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
		 
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			if(mSpinner.isShowing()){
				try {
					mSpinner.dismiss();
				} catch (Exception e) {
				}
			}
				
		}
		
		public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
			handler.proceed();
		}
		
	}

}
