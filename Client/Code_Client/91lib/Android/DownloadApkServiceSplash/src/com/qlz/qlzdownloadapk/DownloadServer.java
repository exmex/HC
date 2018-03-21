package com.qlz.qlzdownloadapk;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.apache.http.util.EncodingUtils;
import android.annotation.SuppressLint;
import android.app.Activity;
import android.app.DownloadManager;
import android.app.ProgressDialog;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.AssetManager;
import android.database.ContentObserver;
import android.net.TrafficStats;
import android.net.Uri;
import android.os.Binder;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.text.format.Formatter;
import android.util.Log;
import android.widget.Toast;
import com.qlz.qlzdownloadapk.R;


public class DownloadServer extends Service{

	    static final DecimalFormat DOUBLE_DECIMAL_FORMAT = new DecimalFormat("0.##");
	    public static final int    MB_2_BYTE             = 1024 * 1024;
	    public static final int    KB_2_BYTE             = 1024;

		private  DownloadManager        downloadManager;
	    private  DownloadManagerPro     downloadManagerPro;
	    private  long                   downloadId           = 0l;
	    private  Activity                mFromActivity;
	    private  DownLoadHandler              mDownloadHandler;
	    private  DownloadChangeObserver downloadObserver;
	    private  CompleteReceiver       completeReceiver;
	    private  ProgressDialog mpDialog;
	    private static final String     DOWNLOAD_FOLDER_NAME = "Download";
	    static  String DOWNLOAD_FILE_NAME = "renyou.apk";
		private  File DownloadPathFile; 
		private String mDownloadlUrl;
		private int useChannelUrl = 0; 
//		private  String apkchannel;
		private ProgressDialog mIsExistDialog;
		private int appUidInt = 0 ;
		private PackageInfo mPackageInfo;
		
		private boolean mIsDownload = false;
		private static final int DownloadMsg = 10001;
		private static final int RESPONSE = 10000;
		
		Handler mResponseHandler = new Handler(){
			
			public void dispatchMessage(Message msg) {
				switch (msg.what) {
				case RESPONSE:
					if (mIsExistDialog != null && mIsExistDialog.isShowing()) {
						mIsExistDialog.dismiss();
					}
					int status = msg.arg1;
					if(status==200){
						startDownload(mDownloadlUrl);
					}else{
						useChannelUrl = 0;
						startDownload(mDownloadlUrl);
					}
					
					break;
				}
			}
		};
		
		
		
		public void downloadCreate(Activity mActivity,String pUrl){
			mFromActivity = mActivity;
			//String _url = pUrl.substring(0, pUrl.indexOf(".apk"));
			ApplicationInfo appInfo = null;
			 
			PackageManager pm = mActivity.getPackageManager();
        	
        	// 获取�?��安装在手机上的应用软件的信息 ,并且获取这些软件里面的权限信�?
        	List<PackageInfo> packinfos = pm
        					.getInstalledPackages(PackageManager.GET_UNINSTALLED_PACKAGES
        							| PackageManager.GET_PERMISSIONS);
        	for (PackageInfo info : packinfos) {
        		if(info.packageName.equals(mFromActivity.getPackageName())){
        			appUidInt = info.applicationInfo.uid;
        			mPackageInfo = info;
        		}
        	}
			
			Create();
			
			try {
				appInfo = mActivity.getPackageManager().getApplicationInfo(mActivity.getPackageName(),PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
				//e.printStackTrace();
			}
			mDownloadlUrl = pUrl;
					
			if(appInfo!=null && appInfo.metaData != null)
			{
					String gameid = appInfo.metaData.getString("gameid");
					String apkchannel = appInfo.metaData.getString("apkchannel");
					
					if(apkchannel!=null&&!apkchannel.equals(""))
					{
						mDownloadlUrl = pUrl + gameid + "_"+ apkchannel +".apk";
						
						DOWNLOAD_FILE_NAME = gameid +".apk";
						useChannelUrl = 1;
						
						/*mIsExistDialog = new ProgressDialog(context);
						mIsExistDialog.setIndeterminate(true);
						mIsExistDialog.setMessage(context.getText(R.string.loading));
						mIsExistDialog.show();*/
						new Thread(){
							public void run() {
								HttpGet httpGet = new HttpGet();
					            HttpParams params = new BasicHttpParams();
					            HttpConnectionParams.setConnectionTimeout(params, 8000);
					            httpGet.setParams(params);
					            try {
					                HttpClient httpClient = new DefaultHttpClient();
					                HttpResponse httpResponse = httpClient.execute(httpGet);;
					                int statusCode = httpResponse.getStatusLine().getStatusCode();
					                Log.e("DownloadApk", "statusCode"+statusCode);
					                Message msg = new Message();
					                msg.what = RESPONSE;
					                msg.arg1 = statusCode;
					                mResponseHandler.sendMessage(msg);
					            } catch (Exception ex){
					                //ex.printStackTrace();
					                Message msg = new Message();
					                msg.what = RESPONSE;
					                msg.arg1 = 404;
					                mResponseHandler.sendMessage(msg);
					            }
								
							}
						}.start();
					return;
				}
			}
		}
		
		
	    public void onDestroy()
	    {
	    	mFromActivity.getContentResolver().unregisterContentObserver(downloadObserver);
	    	mFromActivity.unregisterReceiver(completeReceiver);
	    	super.onDestroy();
	    }
	    
	    
	    @SuppressWarnings("deprecation")
		public void Create(){
	    	downloadObserver = new DownloadChangeObserver();
	        completeReceiver = new CompleteReceiver();
	    	mDownloadHandler = new DownLoadHandler();
	        mFromActivity.getContentResolver().registerContentObserver(DownloadManagerPro.CONTENT_URI, true, downloadObserver);
	        mFromActivity.registerReceiver(completeReceiver, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
	        downloadManager = (DownloadManager)mFromActivity.getSystemService(mFromActivity.DOWNLOAD_SERVICE);
	        downloadManagerPro = new DownloadManagerPro(downloadManager);
	        
	        
	        mpDialog = new ProgressDialog(mFromActivity);
	        mpDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
	        mpDialog.setTitle(R.string.warning);  
            mpDialog.setMessage(mFromActivity.getText(R.string.downtxt));  
            mpDialog.setIndeterminate(false);
            mpDialog.setCancelable(false);
            mpDialog.setButton(mFromActivity.getString(R.string.ok), new DialogInterface.OnClickListener(){

                @Override  
                public void onClick(DialogInterface dialog, int which) {  
                  // GameActivity.this.onKeyDown( KeyEvent.KEYCODE_HOME,KeyEvent.);
                    Intent i= new Intent(Intent.ACTION_MAIN);
                    i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
                    i.addCategory(Intent.CATEGORY_HOME);
                    mFromActivity.startActivity(i);
                }
                  
            }); 
	    }
	    
		private void startDownload(String pDownloadUrl){
			Toast.makeText(mFromActivity, R.string.startdownload, Toast.LENGTH_SHORT).show();
			
	        String DownloadPath = Environment.getExternalStorageDirectory().getAbsolutePath();
		 
	        
			 DownloadPathFile = new File(DownloadPath+File.separator+DOWNLOAD_FOLDER_NAME);
             if (!DownloadPathFile.exists() || !DownloadPathFile.isDirectory()) {
            	 DownloadPathFile.mkdirs();
             }
             
             DownloadPathFile = new File(DownloadPath+File.separator+Environment.DIRECTORY_DOWNLOADS);
             if (!DownloadPathFile.exists() || !DownloadPathFile.isDirectory()) {
            	 DownloadPathFile.mkdirs();
             }
             
             File DOWNLOAD_FILE = new File(DownloadPathFile, DOWNLOAD_FILE_NAME);
             if(DOWNLOAD_FILE.isFile()&DOWNLOAD_FILE.exists()&Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB)
            	 DOWNLOAD_FILE.delete();
			 Log.i("DownloadApk path", DOWNLOAD_FILE.getAbsolutePath());
			
			
             
            DownloadManager.Request request = new DownloadManager.Request(Uri.parse(pDownloadUrl));
            request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, DOWNLOAD_FILE_NAME);
            //request.setDestinationUri(Uri.fromFile(DOWNLOAD_FILE));
            
            request.setTitle(mFromActivity.getText(R.string.app_name));
            request.setDescription(mFromActivity.getText(R.string.app_name));
            
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB)
            {
            	request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
            }
            request.setVisibleInDownloadsUi(true);
           
            // request.allowScanningByMediaScanner();
            // request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI);
            // request.setShowRunningNotification(false);
            // request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_HIDDEN);
            request.setMimeType("application/vnd.android.package-archive");
            downloadId = downloadManager.enqueue(request);
            
            mpDialog.show();
            
            updateView();
	    }
		
		
		public void updateView() {
	        int[] bytesAndStatus = downloadManagerPro.getBytesAndStatus(downloadId);
	        mDownloadHandler.sendMessage(mDownloadHandler.obtainMessage(DownloadMsg, bytesAndStatus[0], bytesAndStatus[1], bytesAndStatus[2]));
            
	    }
		
		
	public static CharSequence getAppSize(long size) {
        if (size <= 0) {
            return "0K";
        }

        if (size >= MB_2_BYTE) {
            return new StringBuilder(16).append(DOUBLE_DECIMAL_FORMAT.format((double)size / MB_2_BYTE)).append("M");
        } else if (size >= KB_2_BYTE) {
            return new StringBuilder(16).append(DOUBLE_DECIMAL_FORMAT.format((double)size / KB_2_BYTE)).append("K");
        } else {
            return size + "B";
        }
    }
	
	 public static boolean isDownloading(int downloadManagerStatus) {
	        return downloadManagerStatus == DownloadManager.STATUS_RUNNING
	               || downloadManagerStatus == DownloadManager.STATUS_PAUSED
	               || downloadManagerStatus == DownloadManager.STATUS_PENDING;
	    }
	    
	
	 /***/
	    public static boolean install(Context context, File filePath) {
	        Intent i = new Intent(Intent.ACTION_VIEW);
	        if (filePath != null && filePath.length() > 0 && filePath.exists() && filePath.isFile()) {
	            i.setDataAndType(Uri.fromFile(filePath), "application/vnd.android.package-archive");
	            i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
	            context.startActivity(i);
	            return true;
	        }
	        return false;
	    }

	    
	    
	    class DownloadChangeObserver extends ContentObserver {

	        public DownloadChangeObserver(){
	            super(mDownloadHandler);
	        }

	        @Override
	        public void onChange(boolean selfChange) {
	        	updateView();
	        }

	    }


	    class CompleteReceiver extends BroadcastReceiver {

	        @Override
	        public void onReceive(Context context, Intent intent) {
	            /**
	             * get the id of download which have download success, if the id is my id and it's status is successful,
	             * then install it
	             **/
	            long completeDownloadId = intent.getLongExtra(DownloadManager.EXTRA_DOWNLOAD_ID, 0);
	            if (completeDownloadId == downloadId&completeDownloadId!=0) {
	            	mpDialog.dismiss();
	            	
	                // if download successful, install apk
	                if (downloadManagerPro.getStatusById(downloadId) == DownloadManager.STATUS_SUCCESSFUL) {
	                	
	                	String path  = downloadManagerPro.getFileName(downloadId);
	                    Log.i("path", path);
	                	install(context, new File(path));
	                	DownloadServer.this.onDestroy();
	                }
	            }
	        }
	    };



	    @SuppressLint("HandlerLeak")
		class DownLoadHandler extends Handler {
	    	int progress = 0;
	        @Override
	        public void handleMessage(Message msg) {
	            super.handleMessage(msg);
	            
	            switch (msg.what) {
	                case DownloadMsg:
	                    int status = (Integer)msg.obj;
	                  
	                     if (isDownloading(status)) {
	                    	 mIsDownload = true;
	                    	//mpDialog.show();
	                    	Log.i("isDownloading", "isDownloading"+status);
	                        if (msg.arg2 < 0) {
	                        } else {
	                        	int max;
	                        	
	                        	String maxSize = "";
	                        	String progressSize ="";
	                        	 if (msg.arg2 <= 0) {
	                        		 max = 0;
	                        		 progress = 0;
	                             }
	                             if (msg.arg2 >= MB_2_BYTE) {
	                            	 max = msg.arg2/MB_2_BYTE;
	                        		 progress = msg.arg1/MB_2_BYTE;
	                        		 maxSize = max+"MB";
	                            	 progressSize = progress+"MB";
	                        		 
	                             } else if (msg.arg2 >= KB_2_BYTE) {
	                            	 max = msg.arg2/KB_2_BYTE;
	                        		 progress = msg.arg1/KB_2_BYTE;
	                        		 maxSize = max+"KB";
	                            	 progressSize = progress+"KB";
	                             } else {
	                            	 max = msg.arg2;
	                        		 progress = msg.arg1;
	                        		 maxSize = max+"B";
	                            	 progressSize = progress+"B";
	                             }
	                        	mpDialog.setMax(100);
	                        	mpDialog.setProgress(progress*100/max);
	                            
	                        	
	                        	long rx = TrafficStats.getUidRxBytes(appUidInt);
	                        	long tx = TrafficStats.getUidTxBytes(appUidInt);
	                        	if(rx<0||tx<0){
	                        		mpDialog.setMessage(mFromActivity.getString(R.string.downtxt)+"\r\n"+mFromActivity.getString(R.string.downprogress)+"："+progressSize+"/"+maxSize);
	                        	}
	                        	else if(mPackageInfo.packageName.equals(mFromActivity.getPackageName())){
	                        		
	                        		mpDialog.setMessage(mFromActivity.getString(R.string.downtxt)+"\r\n"+mFromActivity.getString(R.string.downspeed)
	                        		+"："+Formatter.formatFileSize(mFromActivity, rx)+"/s"+"\r\n"+mFromActivity.getString(R.string.downprogress)
	                        		+"："+progressSize+"/"+maxSize);
	                        	}
	                        			
	                        }
	                    } else {
	                    	mIsDownload = false;
	                        if (status == DownloadManager.STATUS_FAILED) {
	                        	if(useChannelUrl==1){
	                        		if(progress==0){
	                        			mpDialog.dismiss();
			                        	downloadManager.remove(downloadId);
			                        	useChannelUrl = 0;
		                        		startDownload(mDownloadlUrl);
		                        		}else{
		                        			mpDialog.dismiss();
		    	                        	downloadManager.remove(downloadId);
		    	                        	Toast.makeText(mFromActivity, R.string.downfail, Toast.LENGTH_SHORT).show();
		                        		}
	                        		return;
	                        	}else if(useChannelUrl == 0){
	                        		mpDialog.dismiss();
		                        	downloadManager.remove(downloadId);
		                        	Toast.makeText(mFromActivity, R.string.downfail, Toast.LENGTH_SHORT).show();
		                        	return;
	                        	}
	                        	 
	                        } else if (status == DownloadManager.STATUS_SUCCESSFUL) {
	                        	
	                        	Toast.makeText(mFromActivity, R.string.downsuccess, Toast.LENGTH_SHORT).show();
	                        	
	                        }
	                    }
	                    break;
	            }
	        }
	    }
	    
	    public boolean getIsDownload()
	    {
	    	if (mIsDownload) {
				
	    		mpDialog.show();
			}
	    	return mIsDownload;
	    }


		@Override
		public IBinder onBind(Intent arg0) {
		    return new MsgBinder();  
	    }  
	      
	    public class MsgBinder extends Binder{  
	        /** 
	         * 获取当前Service的实例 
	         * @return 
	         */  
	        public DownloadServer getService(){  
	            return DownloadServer.this;  
	        }  
	    }  

		@Override
		public void onCreate() {
			super.onCreate();
		
		}
		
		public DownloadServer() {

		}
		
	    
	    
}