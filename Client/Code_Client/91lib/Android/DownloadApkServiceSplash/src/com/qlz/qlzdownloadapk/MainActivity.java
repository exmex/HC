package com.qlz.qlzdownloadapk;

import java.util.ArrayList;

import android.app.Activity;
import android.app.ActivityManager;
import android.app.ActivityManager.RunningServiceInfo;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.os.IBinder;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class MainActivity extends Activity {

	Button button_one;
	Button button_two;
	String downloadUrl = "http://hk.vipqlz.com/download/androidApk/1.2/";
	
	String packageName = "com.nuclear.dragonb.platform.google.googleftrzgamekktw";
	String className = "com.nuclear.dragonb.platform.google.googleftrzgamekktw.GoogleFTDMWActivity";
	
	DownloadClick mDownloadClick;
	DownloadServer updateApkone;
	public static ServiceConnection connection;// 得到ServiceConnection引用
	DownloadServer msgService;
	boolean  mIsBind = false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) 
	{
		super.onCreate(savedInstanceState);
		if (savedInstanceState!=null) {
			mIsBind = savedInstanceState.getBoolean("isbind",false);	
		}
		
		
		setContentView(R.layout.activity_main);
		mDownloadClick = new DownloadClick();
		connection = new ServiceConnection() 
		{
			public void onServiceDisconnected(ComponentName arg0) 
			{
				mIsBind = false;
			}

			@Override
			public void onServiceConnected(ComponentName name, IBinder service) 
			{
				//返回一个MsgService对象  
	            msgService = ((DownloadServer.MsgBinder)service).getService(); 
	            msgService.downloadCreate(MainActivity.this, downloadUrl);
				
	            mIsBind = true; 
				  
			}

		};
		
		
	}
	
	
	@Override
	protected void onResume() {
		super.onResume();
		openGameApp(this);
	}
	
	@Override
	protected void onSaveInstanceState(Bundle outState) {
		outState.putBoolean("isbind", mIsBind);
		super.onSaveInstanceState(outState);
		
	}
	@Override
	protected void onStop() {
		super.onStop();
	}
	
	@Override
	protected void onPause() {
		super.onPause();
	}
	
	@Override
	protected void onDestroy() {
		super.onDestroy();
	}
	
	//存在：打开程序 ，不存在：下载安装
	public  void openGameApp(Context pContext) {

			PackageInfo packageInfo;
			try {
				packageInfo = pContext.getPackageManager().getPackageInfo(packageName, 0);
			
			} catch (NameNotFoundException e) {
				packageInfo = null;
			}
			if (packageInfo == null) {
				
				Intent server = new Intent(MainActivity.this, DownloadServer.class);
				if (mIsBind==false) {
					bindService(server, connection, Context.BIND_AUTO_CREATE);
				}else{
					if (msgService.getIsDownload()) {
						
		                Toast.makeText(MainActivity.this, R.string.downloading, Toast.LENGTH_SHORT).show();
					}else{
						 msgService.downloadCreate(MainActivity.this, downloadUrl);
			             mIsBind = true; 
					}
				}
				
				}else {
					Intent intent = new Intent();
					intent.setComponent(new ComponentName(packageName,className));
					intent.setFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
					intent.setAction(Intent.ACTION_VIEW);
					Toast.makeText(pContext, R.string.startgame, Toast.LENGTH_SHORT).show();
					try {
							pContext.startActivity(intent);
					} catch (Exception e) {
							Log.i("MainActivity", e.toString());
					}
					System.exit(0);
			}
		}
		
	
	/** service是否已经启动 */
	public boolean isWorked() {
		ActivityManager myManager = (ActivityManager) MainActivity.this
				.getSystemService(Context.ACTIVITY_SERVICE);
		ArrayList<RunningServiceInfo> runningService = (ArrayList<RunningServiceInfo>) myManager
				.getRunningServices(Integer.MAX_VALUE);
		for (int i = 0; i < runningService.size(); i++) {
			if (runningService.get(i).service.getClassName().toString()
					.equals("com.qlz.qlzdownloadapk.DownloadServer")) {
				return true;
			}
		}
		return false;
	}
	
	
	class DownloadClick implements View.OnClickListener{

		@Override
		public void onClick(View v) {
			/*if (v.getId()==R.id.button_one) {
				
				DownloadApk updateApkone = new DownloadApk(MainActivity.this, downloadUrl);
				
			}else if (v.getId()==R.id.button_two) {
				
				DownloadApk updateApktwo = new DownloadApk(MainActivity.this, downloadUrl);
				
			}*/
		}
		
	}
	
	
	/*private void sendMsg(){
		HttpClient client = new DefaultHttpClient();
		HttpPost post= new HttpPost(Constant.);
		String result="";
		List<NameValuePair> paramList = new ArrayList<NameValuePair>();
        BasicNameValuePair param1 = new BasicNameValuePair("mOrderId","");
        paramList.add(param1);
        
        try {
			post.setEntity(new UrlEncodedFormEntity(paramList));
			HttpResponse httpResponse = null;
			httpResponse = client.execute(post);
			int statusCode = httpResponse.getStatusLine().getStatusCode();
			if(statusCode == 200)
	        { 
				result = EntityUtils.toString(httpResponse.getEntity());
				JSONObject resultObj = new JSONObject(result);
		        int returnCode =	resultObj.getInt("returnCode")	;
				 //json {returnCode:"1000",  returnDesc:""}
	        	
	        }else
	        {
	        	
	        }		
			
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}*/
}
