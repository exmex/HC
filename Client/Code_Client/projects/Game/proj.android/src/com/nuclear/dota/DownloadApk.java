package com.nuclear.dota;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import org.apache.http.util.EncodingUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.BasicHttpParams;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import android.annotation.SuppressLint;
import android.app.DownloadManager;
import android.app.ProgressDialog;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.IntentFilter;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.res.AssetManager;
import android.database.ContentObserver;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.qsds.ggg.dfgdfg.fvfvf.R;

public class DownloadApk {

	    static final DecimalFormat DOUBLE_DECIMAL_FORMAT = new DecimalFormat("0.##");
	    public static final int    MB_2_BYTE             = 1024 * 1024;
	    public static final int    KB_2_BYTE             = 1024;

		private  DownloadManager        downloadManager;
	    private  DownloadManagerPro     downloadManagerPro;
	    private  long                   downloadId           = 0l;
	    private  GameActivity                context;
	    private  DownLoadHandler              handler;
	    private  DownloadChangeObserver downloadObserver;
	    private  CompleteReceiver       completeReceiver;
	    private   ProgressDialog mpDialog;
	    private static final String     DOWNLOAD_FOLDER_NAME = "Download";
	    static  String     DOWNLOAD_FILE_NAME   = "League.apk";
		private  File DownloadPathFile ; 
		private String mOriginalUrl;
		private String mUrlChannel = "";
		private int useChannelUrl = 0; // 0:无  ； 1 ：有   ； 2 ：无转到有
		private  String channel;
		private ProgressDialog mIsExistDialog;
		
		private static final int RESPONSE = 10000;
		private static final String TAG = "DownloadApk";
		
		Handler mResponseHandler = new Handler(){
			
			public void dispatchMessage(Message msg) {
				switch (msg.what) {
				case RESPONSE:
					if (mIsExistDialog != null && mIsExistDialog.isShowing()) {
						mIsExistDialog.dismiss();
					}
					int status = msg.arg1;
					if(status==200){	
						onCreate(mUrlChannel);
					}else{
						useChannelUrl = 0;
						onCreate(mOriginalUrl);
					}
					
					break;

				default:
					break;
				}
			}
		};
		
		
		public DownloadApk(GameActivity mActivity,String pUrl){
			context = mActivity;
			String _url = pUrl.substring(0, pUrl.indexOf(".apk"));
			mOriginalUrl = pUrl;
			ApplicationInfo appInfo = null;
			 
			preCreate();//判断网络
			
			String content = "";
			
			AssetManager assetMgr = mActivity.getAssets();
			try {
				InputStream is = assetMgr.open("channel.properties");
				if(is!=null)
				{
					int lenght = is.available();  
	                byte[]  buffer = new byte[lenght];  
	                is.read(buffer);  
	                content = EncodingUtils.getString(buffer, "UTF-8");
				}
				

			} catch (IOException e1) {
				// TODO Auto-generated catch block
				Log.e("PROJECT_PROPERTIES", "project.properties is null");
				//e1.printStackTrace();
			}
			
			if(!content.equals("") && content!=null)
			{
				channel = content;
				Log.e("channel", channel);
				Onchannel(channel, _url);
				return;
			}
			
			try {
				appInfo = mActivity.getPackageManager().getApplicationInfo(mActivity.getPackageName(),PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
				//e.printStackTrace();
			}
			
			if(appInfo!=null && appInfo.metaData != null){
				int _id = appInfo.metaData.getInt("COMPANY_PACKAGE");
				if(_id!=0){
					channel = String.valueOf(_id);
				}else{
					String _str = appInfo.metaData.getString("COMPANY_PACKAGE");	
					channel = _str;
				}
				

				if(channel!=null&&!channel.equals("")){
					
					mUrlChannel = _url + "_" +channel + ".apk";
					DOWNLOAD_FILE_NAME = "OnePiece_"+context.getPlatformId()+ channel +".apk";
					useChannelUrl = 1;
					
					mIsExistDialog = new ProgressDialog(context);
					mIsExistDialog.setIndeterminate(true);
					mIsExistDialog.setMessage("Please wait for a while.....");
					mIsExistDialog.show();
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
			
			useChannelUrl = 0;
			onCreate(mOriginalUrl);
			
			
		}
		
		public void Onchannel(String strChannel,String _url)
		{
			if(channel!=null&&!channel.equals("")){
				
				mUrlChannel = _url + "_" +channel + ".apk";
				DOWNLOAD_FILE_NAME = "dota_"+context.getPlatformId()+ channel +".apk";
				useChannelUrl = 1;
				onCreate(mUrlChannel);
				return;
			}
		}
		
	    public void onDestroy(){
	    	context.getContentResolver().unregisterContentObserver(downloadObserver);
	    	context.unregisterReceiver(completeReceiver);
	    }
	    
	    @SuppressWarnings("deprecation")
		public void preCreate(){
	    	downloadObserver = new DownloadChangeObserver();
	        completeReceiver = new CompleteReceiver();
	    	handler = new DownLoadHandler();
	        context.getContentResolver().registerContentObserver(DownloadManagerPro.CONTENT_URI, true, downloadObserver);
	        context.registerReceiver(completeReceiver, new IntentFilter(DownloadManager.ACTION_DOWNLOAD_COMPLETE));
	        downloadManager = (DownloadManager)context.getSystemService(context.DOWNLOAD_SERVICE);
	        downloadManagerPro = new DownloadManagerPro(downloadManager);
	        
	        
	        mpDialog = new ProgressDialog(context);
	        mpDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);
	        mpDialog.setTitle("提示");  
            mpDialog.setMessage("Is to download the latest software, take a long time, whether to switch the background download ?");  
            mpDialog.setIndeterminate(false);  
            mpDialog.setCancelable(false);  
            mpDialog.setButton("Enter", new DialogInterface.OnClickListener(){  

                @Override  
                public void onClick(DialogInterface dialog, int which) {  
                  // GameActivity.this.onKeyDown( KeyEvent.KEYCODE_HOME,KeyEvent.);
                    Intent i= new Intent(Intent.ACTION_MAIN);
                    i.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK); 
                    i.addCategory(Intent.CATEGORY_HOME);
                    context.startActivity(i);
                }  
                  
            });  
			
	        
	    }
	    
		public void onCreate(String pDownloadUrl){
	    	
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
             if(DOWNLOAD_FILE.isFile()&DOWNLOAD_FILE.exists()& Build.VERSION.SDK_INT < Build.VERSION_CODES.HONEYCOMB)
             DOWNLOAD_FILE.delete();
			Log.i("DownloadApk path", DOWNLOAD_FILE.getAbsolutePath());
			
			
             
            DownloadManager.Request request = new DownloadManager.Request(Uri.parse(pDownloadUrl));
            request.setDestinationInExternalPublicDir(Environment.DIRECTORY_DOWNLOADS, DOWNLOAD_FILE_NAME);
          //  request.setDestinationUri(Uri.fromFile(DOWNLOAD_FILE));
            
            request.setTitle(context.getText(R.string.app_name));
            request.setDescription(context.getText(R.string.app_name));
            
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB)
            	request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_VISIBLE_NOTIFY_COMPLETED);
            
            request.setVisibleInDownloadsUi(false);
           
            // request.allowScanningByMediaScanner();
            // request.setAllowedNetworkTypes(DownloadManager.Request.NETWORK_WIFI);
            // request.setShowRunningNotification(false);
            // request.setNotificationVisibility(DownloadManager.Request.VISIBILITY_HIDDEN);
            request.setMimeType("application/vnd.android.package-archive");
            try {
            	downloadId = downloadManager.enqueue(request);
			} catch (Exception e) {
				// TODO: handle exception
				Log.e(TAG, "downloderre"+e.getMessage());
			}
	        
            mpDialog.show();
            
            updateView();
	    }

		public void updateView() {
	        int[] bytesAndStatus = downloadManagerPro.getBytesAndStatus(downloadId);
	        handler.sendMessage(handler.obtainMessage(0, bytesAndStatus[0], bytesAndStatus[1], bytesAndStatus[2]));
	    }
		
		
	public static CharSequence getAppSize(long size) {
        if (size <= 0) {
            return "0M";
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
	            super(handler);
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
	                case 0:
	                    int status = (Integer)msg.obj;
	                  
	                     if (isDownloading(status)) {
	                    	 mpDialog.show();
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
	                        	mpDialog.setMax(max);
	                        	mpDialog.setProgress(progress);
	                        	mpDialog.setMessage("Is to download the latest version of the installation package, take a long time, whether to switch the background download ?"+"\r\n"+"downloading："+progressSize+"/"+maxSize);
	                        }
	                    } else {
	           			 
	                        if (status == DownloadManager.STATUS_FAILED) {
	                        	if(useChannelUrl==1){
	                        		if(progress==0){
	                        			mpDialog.dismiss();
			                        	downloadManager.remove(downloadId);
			                        	useChannelUrl = 0;
		                        		onCreate(mOriginalUrl);
		                        		}else{
		                        			mpDialog.dismiss();
		    	                        	downloadManager.remove(downloadId);
		    	                        	Toast.makeText(context, "Insufficient storage space in Download failed", Toast.LENGTH_SHORT).show();
		                        	}
	                        		return;
	                        	}else if(useChannelUrl == 0){
	                        		mpDialog.dismiss();
		                        	downloadManager.remove(downloadId);
		                        	Toast.makeText(context, "Insufficient storage space in Download failed ", Toast.LENGTH_SHORT).show();
		                        	return;
	                        	}
	                        	 
	                        } else if (status == DownloadManager.STATUS_SUCCESSFUL) {
	                        	
	                        	Toast.makeText(context, "Download successful", Toast.LENGTH_SHORT).show();
	                        	
	                        }
	                    }
	                    break;
	            }
	        }
	    }
	    
	    
}