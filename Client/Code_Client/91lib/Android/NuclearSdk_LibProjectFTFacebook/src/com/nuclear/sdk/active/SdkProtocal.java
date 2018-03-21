package com.nuclear.sdk.active;

import android.app.Activity;
import android.os.Bundle;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.view.WindowManager;
import android.webkit.WebView;
import android.widget.Button;

import com.nuclear.sdk.R;

public class SdkProtocal extends Activity{
	private WebView mLoad_Proto;
	private Button mAgree;
	private Button mBack;
	public static boolean mIsAgree;
@Override
protected void onCreate(Bundle savedInstanceState) {
	// TODO Auto-generated method stub
	super.onCreate(savedInstanceState);
	setFinishOnTouchOutside(false);
	 //设置无标题  
    requestWindowFeature(Window.FEATURE_NO_TITLE);  
    //设置全屏  
    getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,   
           WindowManager.LayoutParams.FLAG_FULLSCREEN);  
	setContentView(R.layout.ya_protocal);
	mBack = (Button) findViewById(R.id.prpto_button_left);
	mAgree = (Button) findViewById(R.id.prpto_button_right);
	mLoad_Proto=(WebView)findViewById(R.id.u2_proto_show);
	mLoad_Proto.loadUrl("http://203.90.239.206/Agreement.html");
	mBack.setOnClickListener(new OnClickListener() {
		
		@Override
		public void onClick(View arg0) {
			finish();
		}
	});
	mAgree.setOnClickListener(new OnClickListener() {
		
		

		@Override
		public void onClick(View arg0) {
			mIsAgree=true;
			finish();
		}
	});
}

}
