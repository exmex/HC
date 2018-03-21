package com.nuclear.dota.platform.googleplayeng;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.RelativeLayout;

import com.nuclear.NetworkUtil;
import com.qsds.ggg.dfgdfg.fvfvf.R;
/**
 */
public class PayWebDialog extends Dialog {
    
 
	private static String mRequestUrl;
	private ProgressDialog mSpinner;
	private WebView mWebView;
	private final static String TAG = PayWebDialog.class.toString();
	private static final int BACKMAIN = 1;
	private static int theme=android.R.style.Theme_Translucent_NoTitleBar;
	private static Resources mRes;
	private Button mBtnOk;
	
	RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(LayoutParams.MATCH_PARENT,
			LayoutParams.MATCH_PARENT);
	private RelativeLayout boxRl;
	private Context mContext;
	private static byte[] mPostData;
	private static String method = "GET";
	
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
	
	private PayWebDialog(Activity context, String url) {
		super(context,theme);
		mRes = context.getResources();
		mContext = context;
		if (!url.equalsIgnoreCase("")&&url!=null) {
			mRequestUrl = url;
		}
	}
	
	private static PayWebDialog AInstance = null;
	
	public static PayWebDialog getInstance(Activity pContext,String url) {
		if(pContext==null)return null;
		mRes = pContext.getResources();
		if (AInstance == null&&mRequestUrl!=url&&!url.equalsIgnoreCase("")&&url!=null) {
			AInstance = new PayWebDialog(pContext,url);
		}else {
			mRequestUrl = url;
			AInstance = null;
			AInstance = new PayWebDialog(pContext,url);
		}
		
		method = "GET";
		return AInstance;
	}
	
	public static PayWebDialog getInstance(Activity pContext,String url,byte[] postData) {
		if(pContext==null)return null;
		mRes = pContext.getResources();
		mPostData = postData;
		method = "POST";
		if (AInstance == null&&mRequestUrl!=url&&!url.equalsIgnoreCase("")&&url!=null) {
			AInstance = new PayWebDialog(pContext,url);
		}else {
			mRequestUrl = url;
			AInstance = null;
			AInstance = new PayWebDialog(pContext,url);
		}
		
		
		return AInstance;
	}
	
	private  PayWebDialog(Activity context) {
		super(context,theme);
	}
	

	@Override
	public void onBackPressed() {
		//super.onBackPressed();
		onBack();
	}
	
	
	@Override 
	public void dismiss() {
		super.dismiss();
		
	}
	
	@Override
	public void show() {
		super.show();
		if(!NetworkUtil.detect(mContext)){
			this.dismiss();
			return;
		}
		mSpinner = new ProgressDialog(getContext());
		mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
		mSpinner.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(DialogInterface dialog, int keyCode,
					KeyEvent event) {
				
				if (keyCode == KeyEvent.KEYCODE_BACK)
				{
					onBack();
					return true;
				}
				return false;
			}

		});
		

		setUpWebView();
		
		
	}
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.getWindow().setFeatureDrawableAlpha(Window.FEATURE_OPTIONS_PANEL, 0);  
		setContentView(R.layout.feedback_dialog);
	
		mBtnOk = (Button)findViewById(R.id.u2_back);
		
		mBtnOk.setOnClickListener( new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				try {
					mSpinner.dismiss();
					if (null != mWebView) {
						mWebView.stopLoading();						
					}
				} catch (Exception e) {
				}
				
				PayWebDialog.this.dismiss();
			}
		});
	}

	protected void onBack() {
		try {
			mSpinner.dismiss();
			if (null != mWebView) {
				mWebView.stopLoading();
			 
			}
		} catch (Exception e) {
		}
		this.cancel();
	}

	
	@SuppressWarnings("SetJavaScriptEnabled")
	private void setUpWebView() {
		boxRl = (RelativeLayout) findViewById(R.id.feedback_webrl);
		mWebView = (WebView) findViewById(R.id.webView1);
		/*mWebView = new WebView(getContext());*/
		mWebView.setWebViewClient(new WeiboWebViewClient());
		WebSettings webSettings = mWebView.getSettings();
	    webSettings.setDomStorageEnabled(true);
	    webSettings.setJavaScriptEnabled(true);
	    webSettings.setSupportMultipleWindows(true);
	    webSettings.setJavaScriptCanOpenWindowsAutomatically(true);
	    webSettings.setAppCacheMaxSize(1024*1024*16);
	    webSettings.setAppCacheEnabled(true);
	    String appCachePath = mContext.getApplicationContext().getCacheDir().getAbsolutePath();
	    webSettings.setAppCachePath(appCachePath);
	    webSettings.setAllowFileAccess(true);
	    webSettings.setCacheMode(WebSettings.LOAD_DEFAULT);
	    webSettings.setDatabaseEnabled(false);
	    String databasePath = "/data/data/" + mContext.getPackageName() + "/databases/";
	    webSettings.setDatabasePath(databasePath);
	    webSettings.setGeolocationEnabled(true);
	    webSettings.setSaveFormData(true);
	    InJavaScriptLocalObj backGameJs = new InJavaScriptLocalObj();
	    mWebView.addJavascriptInterface(backGameJs, "localjs");
		if (method.equals("POST")) {
			mWebView.postUrl(mRequestUrl, mPostData);	
		} else {
			mWebView.loadUrl(mRequestUrl);
		}
	    
	}

	final class InJavaScriptLocalObj {  
        
        public void goBackGame(){
        	mMainHandler.sendEmptyMessage(BACKMAIN);
        }
	}
	
	private class WeiboWebViewClient extends WebViewClient {
		boolean haveErr = false;
		
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			Log.d(TAG, "shouldOverrideUrlLoading URL: " + url);
			 
			return super.shouldOverrideUrlLoading(view, url);
		}

		@Override
		public void onReceivedError(WebView view, int errorCode, String description,
				String failingUrl) {
			super.onReceivedError(view, errorCode, description, failingUrl);
			haveErr = true;
			Log.i("error", "error+"+errorCode+description);
			//GameOperateDialog.this.dismiss();
		}

		@Override
		public void onPageStarted(WebView view, String url, Bitmap favicon) {
			
			super.onPageStarted(view, url, favicon);
			mSpinner.show();
		}

		@Override
		public void onPageFinished(WebView view, String url) {
			Log.d(TAG, "onPageFinished URL: " + url);
			super.onPageFinished(view, url);
			if (mSpinner.isShowing()) {
				mSpinner.dismiss();
			}
			
			if(haveErr){
				onBack();
				boxRl.setVisibility(View.INVISIBLE);
				mWebView.setVisibility(View.INVISIBLE);
				
			}else {
				boxRl.setVisibility(View.VISIBLE);
				mWebView.setVisibility(View.VISIBLE);
				
			}
			
			haveErr = false;
			
		}

	}
	
}
