package com.nuclear;

import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.telephony.TelephonyManager;

public class NetworkUtil {
	
	// 一、判断网络连接是否可用
	public static boolean detect(Context act) {

		ConnectivityManager manager = (ConnectivityManager) act
				.getApplicationContext().getSystemService(
						Context.CONNECTIVITY_SERVICE);

		if (manager == null) {
			return false;
		}

		NetworkInfo networkinfo = manager.getActiveNetworkInfo();

		if (networkinfo == null || !networkinfo.isAvailable()) {
			return false;
		}

		return true;
	}

	public static boolean isNetworkAvailable(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cm == null) {
		} else {
			// 如果仅仅是用来判断网络连接　　　　　　
			// 则可以使用 cm.getActiveNetworkInfo().isAvailable();
			NetworkInfo[] info = cm.getAllNetworkInfo();
			if (info != null) {
				for (int i = 0; i < info.length; i++) {
					if (info[i].getState() == NetworkInfo.State.CONNECTED) {
						return true;
					}
				}
			}
		}
		return false;
	}

	// 下面的不仅可以判断，如果没有开启网络的话，就进入到网络开启那个界面，具体代码如下：
	protected boolean CheckNetwork(final Context pContext) {
		// TODO Auto-generated method stub
		boolean flag = false;
		ConnectivityManager cwjManager = (ConnectivityManager) pContext
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		if (cwjManager.getActiveNetworkInfo() != null)
			flag = cwjManager.getActiveNetworkInfo().isAvailable();
		if (!flag) {
			Builder b = new AlertDialog.Builder(pContext).setTitle("没有可用的网络")
					.setMessage("请开启GPRS或WIFI网路连接");
			b.setPositiveButton("确定", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub
					Intent mIntent = new Intent("/");
					ComponentName comp = new ComponentName(
							"com.android.settings",
							"com.android.settings.WirelessSettings");
					mIntent.setComponent(comp);
					mIntent.setAction("android.intent.action.VIEW");
					pContext.startActivity(mIntent);
				}
			}).setNegativeButton("取消", new DialogInterface.OnClickListener() {
				public void onClick(DialogInterface dialog, int which) {
					// TODO Auto-generated method stub dialog.cancel();
				}
			}).create();
			b.show();
		}
		return flag;
	}

	// 三、判断WIFI是否打开
	public static boolean isWifiEnabled(Context context) {
		ConnectivityManager mgrConn = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		TelephonyManager mgrTel = (TelephonyManager) context
				.getSystemService(Context.TELEPHONY_SERVICE);
		return ((mgrConn.getActiveNetworkInfo() != null && mgrConn
				.getActiveNetworkInfo().getState() == NetworkInfo.State.CONNECTED) || mgrTel
				.getNetworkType() == TelephonyManager.NETWORK_TYPE_UMTS);
	}

	// 四、判断是否是3G网络
	public static boolean is3rd(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkINfo = cm.getActiveNetworkInfo();
		if (networkINfo != null
				&& networkINfo.getType() == ConnectivityManager.TYPE_MOBILE) {
			return true;
		}
		return false;
	}

	// 五、判断是wifi还是3g网络,用户的体现性在这里了，wifi就可以建议下载或者在线播放。
	public static boolean isWifi(Context context) {
		ConnectivityManager cm = (ConnectivityManager) context
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo networkINfo = cm.getActiveNetworkInfo();
		if (networkINfo != null
				&& networkINfo.getType() == ConnectivityManager.TYPE_WIFI) {
			return true;
		}
		return false;
	}
	
	public static int getMobileNetISP(Context context) {
	
		if (!NetworkUtil.is3rd(context))
			return 0;//unknown
		//
		TelephonyManager telManager = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);   
		String operator = telManager.getSubscriberId();  
		if(null!=operator){
			
			if (operator.startsWith("46000") || operator.startsWith("46002")
					|| operator.startsWith("46007")) {
				return 4;
			} else if (operator.startsWith("46001")) {
				return 2;
			} else if (operator.startsWith("46003")) {
				return 1;
			} else {
				return 0;
			}
		 }else 
		 {	 //Null
			 return 0;
		 }
	
	}
	
	public static int getMobileNetType(Context context) {
		if (NetworkUtil.isWifi(context))
			return 1;
			
		TelephonyManager telephonyManager = (TelephonyManager) context  
                .getSystemService(Context.TELEPHONY_SERVICE);  
  
        switch (telephonyManager.getNetworkType()) {  
        case TelephonyManager.NETWORK_TYPE_UNKNOWN:  //0
            return 2;  
        case TelephonyManager.NETWORK_TYPE_1xRTT:  //7
            return 2; // ~ 50-100 kbps  
        case TelephonyManager.NETWORK_TYPE_CDMA:  //4
            return 2; // ~ 14-64 kbps  
        case TelephonyManager.NETWORK_TYPE_EDGE:  //2
            return 2; // ~ 50-100 kbps  
        case TelephonyManager.NETWORK_TYPE_EVDO_0:  //5
            return 3; // ~ 400-1000 kbps  
        case TelephonyManager.NETWORK_TYPE_EVDO_A:  //6
            return 3; // ~ 600-1400 kbps  
        case TelephonyManager.NETWORK_TYPE_GPRS:  //1
            return 2; // ~ 100 kbps  
        case TelephonyManager.NETWORK_TYPE_HSDPA:  //8
            return 3; // ~ 2-14 Mbps  
        case TelephonyManager.NETWORK_TYPE_HSPA:  //10
            return 3; // ~ 700-1700 kbps  
        case TelephonyManager.NETWORK_TYPE_HSUPA: //9  
            return 3; // ~ 1-23 Mbps  
        case TelephonyManager.NETWORK_TYPE_UMTS:  //3
            return 3; // ~ 400-7000 kbps  
        case TelephonyManager.NETWORK_TYPE_EHRPD:  //14
            return 3; // ~ 1-2 Mbps  
        case TelephonyManager.NETWORK_TYPE_EVDO_B:  //12
            return 3; // ~ 5 Mbps  
        case TelephonyManager.NETWORK_TYPE_IDEN:  //11
            return 2; // ~25 kbps  
        case TelephonyManager.NETWORK_TYPE_LTE:  //13
            return 4; // ~ 10+ Mbps  
        case TelephonyManager.NETWORK_TYPE_HSPAP:  //15
            return 4; // ~ 10-20 Mbps  
        default:  
            return 2; 
            }
	}
	
}
