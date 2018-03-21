package com.nuclear.dota;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;
import android.widget.RelativeLayout;

import com.nuclear.NetworkUtil;
import com.qsds.ggg.dfgdfg.fvfvf.R;
/**
 */
public class GameAnnounceDialog extends Dialog {
    
 
	private static final String mDefaultUrl = "http://baidu.com/";
	private static String mRequestUrl;
	private ProgressDialog mSpinner;
	private WebView mWebView;
	private ImageButton mBtnOk;
	private final static String TAG = GameAnnounceDialog.class.toString();
	
	private static int theme=android.R.style.Theme_Translucent_NoTitleBar;
	private RelativeLayout mWebRl ; 
	private static Resources mRes;
	RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(LayoutParams.MATCH_PARENT,
			LayoutParams.MATCH_PARENT);
	
	private Context mContext;
	public GameAnnounceDialog(Activity context, String url) {
		super(context,theme);
		mRes = context.getResources();
		mContext = context;
		if (!url.equalsIgnoreCase("")&&url!=null) {
			mRequestUrl = url;
			this.show();
		}else {
			this.cancel();
			mRequestUrl = mDefaultUrl;
		}
		
	
	}
	
	/*private static GameAnnounceDialog AInstance = null;
	public static GameAnnounceDialog getInstance(Activity pContext,String url) {
		if(pContext==null)return null;
		mRes = pContext.getResources();
		if (AInstance == null&&mRequestUrl!=url&&!url.equalsIgnoreCase("")&&url!=null) {
			AInstance = new GameAnnounceDialog(pContext,url);
		}else {
			mRequestUrl = url;
		}
		
		return AInstance;
	}*/
	
	private  GameAnnounceDialog(Activity context) {
		super(context,theme);
	}
	

	@Override
	public void onBackPressed() {
		//	super.onBackPressed();
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
		mSpinner.setMessage("loading...");

		mSpinner.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(DialogInterface dialog, int keyCode,
					KeyEvent event) {
				onBack();
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
		setContentView(R.layout.announce_dialog);

		mBtnOk = (ImageButton)findViewById(R.id.announce_btnok);
		
		mBtnOk.setOnClickListener( new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				// TODO Auto-generated method stub
				try {
					mSpinner.dismiss();
					if (null != mWebView) {
						mWebView.stopLoading();						
						mWebRl.removeAllViews();
						//mWebView.destroy();
					}
				} catch (Exception e) {
				}
				
				GameAnnounceDialog.this.dismiss();
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

	private RelativeLayout boxRl;
	@SuppressWarnings("deprecation")
	private void setUpWebView() {
		mWebRl =(RelativeLayout) findViewById(R.id.announce_webview);
		boxRl = (RelativeLayout) findViewById(R.id.announce_webrl);
		//mWebView = (WebView)(findViewById(R.id.webViewurl));
		mWebView = new WebView(getContext());
		//mWebView.setVerticalScrollBarEnabled(false);
		//mWebView.setHorizontalScrollBarEnabled(false);
		//mWebView.setScrollBarStyle(View.SCROLLBARS_OUTSIDE_OVERLAY);
		//mWebView.getSettings().setJavaScriptEnabled(true);
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
		mWebView.setOverScrollMode(View.OVER_SCROLL_NEVER);
		if(null!=mRequestUrl){
			mWebView.loadUrl(mRequestUrl);
			mRequestUrl = null;
		}else{
		mWebView.loadUrl(mDefaultUrl);
		}

		//WebSettings settings = mWebView.getSettings();
		//settings.setTextSize(WebSettings.TextSize.NORMAL);
		
		int screenDensity = mRes.getDisplayMetrics().densityDpi;
		Log.i(TAG, "screenDensity"+screenDensity);

		switch (screenDensity) {

		case DisplayMetrics.DENSITY_LOW:
			//zoomDensity = WebSettings.ZoomDensity.CLOSE;
			//settings.setDefaultZoom(zoomDensity);
			mWebView.setInitialScale(30);
			break;
		case DisplayMetrics.DENSITY_MEDIUM:
			mWebView.setInitialScale(35);
			break;
		case DisplayMetrics.DENSITY_HIGH:
			mWebView.setInitialScale(40);
			break;
		case DisplayMetrics.DENSITY_XHIGH:
			mWebView.setInitialScale(45);
			break;
		case DisplayMetrics.DENSITY_XXHIGH:
			mWebView.setInitialScale(50);
			break;
		default:
			mWebView.setInitialScale(45);
			break;
		}
		
		mWebRl.addView(mWebView, lp);

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
				mBtnOk.setVisibility(View.INVISIBLE);
				mWebRl.setVisibility(View.INVISIBLE);
				
			}else {
				boxRl.setVisibility(View.VISIBLE);
				mWebView.setVisibility(View.VISIBLE);
				mBtnOk.setVisibility(View.VISIBLE);
				mWebRl.setVisibility(View.VISIBLE);
				mWebView.setBackgroundColor(0); // 设置背景色
				try {
					if(Build.VERSION.SDK_INT >= 11)
					{
						mWebRl.getBackground().setAlpha(0); // 设置填充透明度 范围：0-255
						mWebView.setLayerType(View.LAYER_TYPE_SOFTWARE, null);
					}
				} catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
				}
				
				
				
			}
			haveErr = false;
			
			
		}

	}
	
}