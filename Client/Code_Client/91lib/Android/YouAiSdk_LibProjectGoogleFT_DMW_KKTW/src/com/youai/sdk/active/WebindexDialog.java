package com.youai.sdk.active;

import android.annotation.SuppressLint;
import android.app.AlertDialog;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.Window;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.TextView;

import com.youai.sdk.R;
import com.youai.sdk.net.SslError;

@SuppressLint("SetJavaScriptEnabled")
public class WebindexDialog extends Dialog {

	private static final String TAG = WebindexDialog.class.getSimpleName();

	private WebView mWebview;
	private String mUrl;

	private ProgressDialog mSpinner;
	private Button backBtn;
	private TextView webTitle;
	private static final int BACKMAIN = 1;
	 
	private Handler mMainHandler = new Handler(){

		@Override
		public void dispatchMessage(Message msg) {
			Log.i(TAG, "dispatchMessage"+msg.what);
			switch (msg.what) {
			case BACKMAIN:
				onBack();
				break;
			}
		}
	};
	
	public void setYouaiTitle(String pText){
		webTitle.setText(pText);
	}
	public WebindexDialog(Context context, String pUrl) {
		super(context, R.style.u2_AppTheme);
		this.mUrl = pUrl;
		
	}
	
	@Override
	public void show() {
		super.show();
		backBtn = (Button) findViewById(R.id.u2_back);
		mSpinner = new ProgressDialog(getContext());
		mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
		mSpinner.setMessage(getContext().getText(R.string.loading));
		
		mSpinner.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
				onBack();
				return false;
			}

		});
		setupWeb();
	}
	
	private void setupWeb(){
		
		mWebview = (WebView) findViewById(R.id.webview);
		mWebview.getSettings().setJavaScriptEnabled(true);
		InJavaScriptLocalObj backGameJs = new InJavaScriptLocalObj();
		mWebview.addJavascriptInterface(backGameJs, "localjs");
		mWebview.setWebViewClient(new PayTencentWebViewClient());
		webTitle = (TextView) findViewById(R.id.webtitle);
		mWebview.loadUrl(mUrl);
		backBtn.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				onBack();
			}
		});
 
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.activity_oauth);
		
		
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
				WebindexDialog.this.cancel();
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
			/*new AlertDialog.Builder(getContext())  
            .setTitle("提示")
            .setMessage("访问出现错误")
            .setPositiveButton("确定", new OnClickListener() {
				
				@Override
				public void onClick(DialogInterface dialog, int which) {
					dialog.dismiss();
					WebindexDialog.this.cancel();
				}
			})
            .show();*/
			
		}
		
		
		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			super.onPageStarted(view, url, favicon);
			
			mSpinner.show();
		 
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			super.onPageFinished(view, url);
			//CookieSyncManager.getInstance().sync();
			mSpinner.dismiss();
			
		}
		
		public void onReceivedSslError(WebView view, SslErrorHandler handler, SslError error) {
			handler.proceed();
		}
		
	}

}
