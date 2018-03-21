package com.douban.sdk.android;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.util.LinkedList;

import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.util.EntityUtils;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.res.Resources;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.net.Uri;
import android.os.Bundle;
import android.os.Looper;
import android.util.Log;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.LayoutParams;
import android.view.Window;
import android.webkit.SslErrorHandler;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.FrameLayout;
import android.widget.RelativeLayout;

import com.douban.sdk.android.demo.R;
import com.douban.sdk.android.net.DoubanSslError;
import com.douban.sdk.android.util.Utility;
/**
 * 用来显示用户认证界面的dialog，封装了一个webview，通过redirect地址中的参数来获取accesstoken
 * @author xiaowei6@staff.sina.com.cn
 *
 */
public class DoubanDialog extends Dialog {
    
	static  FrameLayout.LayoutParams FILL = new FrameLayout.LayoutParams(
			ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
	private String mUrl;
	private DoubanAuthListener mListener;
	private ProgressDialog mSpinner;
	private WebView mWebView;
	private RelativeLayout webViewContainer;
	private RelativeLayout mContent;

	private final static String TAG = "Weibo-WebView";
	
	private static int theme=android.R.style.Theme_Translucent_NoTitleBar;
	private  static int left_margin=0;
    private  static int top_margin=0;
    private  static int right_margin=0;
    private  static int bottom_margin=0;
    
    public static String URL_OAUTH2_ACCESS_TOKEN = "https://www.douban.com/service/auth2/token";
    
    
	public DoubanDialog(Context context, String url, DoubanAuthListener listener) {
		super(context,theme);
		mUrl = url;
		mListener = listener;
		
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		mSpinner = new ProgressDialog(getContext());
		mSpinner.requestWindowFeature(Window.FEATURE_NO_TITLE);
		mSpinner.setMessage("Loading...");
		mSpinner.setOnKeyListener(new OnKeyListener() {

			@Override
			public boolean onKey(DialogInterface dialog, int keyCode, KeyEvent event) {
				onBack();
				return false;
			}

		});
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.getWindow().setFeatureDrawableAlpha(Window.FEATURE_OPTIONS_PANEL, 0);  
		mContent = new RelativeLayout(getContext());
		setUpWebView();

		addContentView(mContent, new LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.FILL_PARENT));
	}

	protected void onBack() {
		try {
			mSpinner.dismiss();
			if (null != mWebView) {
				mWebView.stopLoading();
				mWebView.destroy();
			}
		} catch (Exception e) {
		}
		dismiss();
	}

	private void setUpWebView() {
		webViewContainer = new RelativeLayout(getContext());
		mWebView = new WebView(getContext());
		mWebView.setVerticalScrollBarEnabled(false);
		mWebView.setHorizontalScrollBarEnabled(false);
		mWebView.getSettings().setJavaScriptEnabled(true);
		mWebView.setWebViewClient(new DoubanDialog.WeiboWebViewClient());
		mWebView.loadUrl(mUrl);
		mWebView.setLayoutParams(FILL);
		mWebView.setVisibility(View.INVISIBLE);
		
		RelativeLayout.LayoutParams lp = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT,
				LayoutParams.FILL_PARENT);
		
		RelativeLayout.LayoutParams lp0 = new RelativeLayout.LayoutParams(LayoutParams.FILL_PARENT,
                LayoutParams.FILL_PARENT);
		
        mContent.setBackgroundColor(Color.TRANSPARENT);
        webViewContainer.setBackgroundResource(R.drawable.dialog_bg);
        
       
        webViewContainer.addView(mWebView,lp0);
		webViewContainer.setGravity(Gravity.CENTER);
		    Resources resources = getContext().getResources();
		    lp.leftMargin=10;//resources.getDimensionPixelSize(R.dimen.doubansdk_dialog_left_margin);
		    lp.rightMargin=10;//resources.getDimensionPixelSize(R.dimen.doubansdk_dialog_right_margin);
		    lp.topMargin=10;//resources.getDimensionPixelSize(R.dimen.doubansdk_dialog_top_margin);
		    lp.bottomMargin=10;//resources.getDimensionPixelSize(R.dimen.doubansdk_dialog_bottom_margin);
		    mContent.addView(webViewContainer, lp);
	}

	private class WeiboWebViewClient extends WebViewClient {
		
		
		
		@Override
		public boolean shouldOverrideUrlLoading(WebView view, String url) {
			Log.d(TAG, "Redirect URL: " + url);
			 if (url.startsWith("sms:")) {  //针对webview里的短信注册流程，需要在此单独处理sms协议
	                Intent sendIntent = new Intent(Intent.ACTION_VIEW);  
	                sendIntent.putExtra("address", url.replace("sms:", ""));  
	                sendIntent.setType("vnd.android-dir/mms-sms");  
	                DoubanDialog.this.getContext().startActivity(sendIntent);  
	                return true;  
	            }  
			return super.shouldOverrideUrlLoading(view, url);
		}

		@Override
		public void onReceivedError(WebView view, int errorCode, String description,
				String failingUrl) {
			super.onReceivedError(view, errorCode, description, failingUrl);
			mListener.onError(new DoubanDialogError(description, errorCode, failingUrl));
			DoubanDialog.this.dismiss();
		}

		@Override
		public void onPageStarted(final WebView view, final String url, Bitmap favicon) {
			Log.d(TAG, "onPageStarted URL: " + url);
			if (url.startsWith(Douban.redirecturl)) {
				Uri uri = Uri.parse(url);
				final String code = uri.getQueryParameter("code");
				view.stopLoading();
				//String postData = "client_id="+Weibo.app_key+"&client_secret="+Weibo.Secret+"&" +
				//		"redirect_uri=http://www.7g8g.cn&grant_type=authorization_code&code="+code;
				
				//view.postUrl(URL_OAUTH2_ACCESS_TOKEN,EncodingUtils.getBytes(postData, "BASE64"));
				 
				
				new Thread(){
					String tokenBack;
					public void run() {
						
						//和GET方式一样，先将参数放入List
						 LinkedList<BasicNameValuePair> params = new LinkedList<BasicNameValuePair>();
						 
						 int REQUEST_TIMEOUT = 10*1000;//设置请求超时10秒钟
						 int SO_TIMEOUT = 10*1000;  //设置等待数据超时时间10秒钟
						   
						BasicHttpParams httpParams = new BasicHttpParams();
						HttpConnectionParams.setConnectionTimeout(httpParams, REQUEST_TIMEOUT);
						HttpConnectionParams.setSoTimeout(httpParams, SO_TIMEOUT);
						HttpClient httpClient = new DefaultHttpClient(httpParams);
						
						//和GET方式一样，先将参数放入List
						params = new LinkedList<BasicNameValuePair>();
						params.add(new BasicNameValuePair("client_id", Douban.app_key));
						params.add(new BasicNameValuePair("client_secret", Douban.Secret));
						params.add(new BasicNameValuePair("redirect_uri", "http://www.7g8g.cn"));
						params.add(new BasicNameValuePair("grant_type", "authorization_code"));
						params.add(new BasicNameValuePair("code", code));
						try {
						    HttpPost postMethod = new HttpPost(URL_OAUTH2_ACCESS_TOKEN);
						    postMethod.setEntity(new UrlEncodedFormEntity(params, "utf-8")); //将参数填入POST Entity中
										
						    HttpResponse response = httpClient.execute(postMethod); //执行POST方法
						    if(response.getStatusLine().getStatusCode()==200){
						  
						    tokenBack = EntityUtils.toString(response.getEntity(), "utf-8");
						    Log.i(TAG, "result =" + tokenBack); //获取响应内容
						    mListener.onGetbackInfo(tokenBack);
						    DoubanDialog.this.dismiss();
						   
						    }
						    
						} catch (UnsupportedEncodingException e) {
						    // TODO Auto-generated catch block
						    e.printStackTrace();
						} catch (ClientProtocolException e) {
						    // TODO Auto-generated catch block
						    e.printStackTrace();
						} catch (IOException e) {
						    // TODO Auto-generated catch block
						    e.printStackTrace();
						}
						
						if(null!=tokenBack){
							Looper.prepare();
						handleRedirectString(tokenBack);
						Looper.myLooper();
						}
						
						
					}
					
					
				}.start();
				
				
				return;
				
			}else if(url.startsWith(Douban.redirecturl)){
				handleRedirectUrl(view, url);
				view.stopLoading();
				
				DoubanDialog.this.dismiss();
			}
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
			
			mWebView.setVisibility(View.VISIBLE);
		}

		public void onReceivedSslError(WebView view, SslErrorHandler handler, DoubanSslError error) {
			handler.proceed();
		}

	}

	private void handleRedirectString(String tokenBack2) {
		JSONObject values = null;
		String error = null;
		String error_code = null;
		try {
			values = new JSONObject(tokenBack2);
			error = values.getString("msg");
			error_code = values.getString("code");
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		if (error == null && error_code == null) {
			mListener.onComplete(values);
		} else if (error.equals("access_denied")) {
			mListener.onCancel();
		} else {
			if(error_code==null){
				mListener.onDoubanException(new DoubanException(error, 0));
			}
			else{
				mListener.onDoubanException(new DoubanException(error, Integer.parseInt(error_code)));
			}
			
		}
	}
	private void handleRedirectUrl(WebView view, String url) {
		Bundle values = Utility.parseUrl(url);

		String error = values.getString("error");
		String error_code = values.getString("error_code");

		if (error == null && error_code == null) {
			mListener.onComplete(values);
		} else if (error.equals("access_denied")) {
			// 用户或授权服务器拒绝授予数据访问权限
			mListener.onCancel();
		} else {
			if(error_code==null){
				mListener.onDoubanException(new DoubanException(error, 0));
			}
			else{
				mListener.onDoubanException(new DoubanException(error, Integer.parseInt(error_code)));
			}
			
		}
	}
	 
	
}
