package com.fiveone.gamecenter.sdk.util;

import java.util.Random;

import com.fiveone.gamecenter.sdk.activity.RegisterActivity;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.widget.Toast;

public class Util {

	private static final String SHARE_DB_NAME = "gameCenterSDK";

	public static void ShowTips(Context context, String strText) {
		Toast toast = Toast.makeText(context, strText, 5000);
		toast.show();
	}

	public static ProgressDialog showProgress(Context context, CharSequence title, CharSequence message, boolean indeterminate, boolean cancelable) {
		ProgressDialog dialog = new ProgressDialog(context);
		dialog.setTitle(title);
		dialog.setMessage(message);
		dialog.setIndeterminate(indeterminate);
		dialog.setCancelable(cancelable);
		dialog.show();
		return dialog;
	}
	
//	public static boolean isServiceRunning(Context mContext, String className) {
//		boolean isRunning = false;
//		ActivityManager activityManager = (ActivityManager) mContext.getSystemService(Context.ACTIVITY_SERVICE);
//		List<ActivityManager.RunningServiceInfo> serviceList = activityManager.getRunningServices(30);
//		if (!(serviceList.size() > 0)) {
//			return false;
//		}
//		for (int i = 0; i < serviceList.size(); i++) {
//			if (serviceList.get(i).service.getClassName().equals(className) == true) {
//				isRunning = true;
//				break;
//			}
//		}
//		return isRunning;
//	}

	// 流水号
	public static String getSerialNo() {
		int intCount = 0;
		intCount = (new Random()).nextInt(999999);//
		if (intCount < 100000) {
			intCount += 100000;
		}
		return String.valueOf(intCount);
	}

//	public static void savePassword(Context context, String pwd) {
//		SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
//		Editor editor = sp.edit();
//		editor.putString("password", pwd);
//		editor.commit();
//	}

	public static void saveGameEName(Context context, String userid) {
		SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
		Editor editor = sp.edit();
		editor.putString("GameEName", userid);
		editor.commit();
	}

	public static String getGameEName(Context context) {
		SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
		return sp.getString("GameEName", "gc");
	}
	
	public static void saveSessionID(Context context, String sessionID) {
		SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
		Editor editor = sp.edit();
		editor.putString("GameSessionID", sessionID);
		editor.commit();
	}

	public static String getSessionID(Context context) {
		SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
		return sp.getString("GameSessionID", "");
	}

//	public static void saveUserID(Context context, String userid) {
//		SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
//		Editor editor = sp.edit();
//		editor.putString("userid", userid);
//		editor.commit();
//	}
//
//	public static String getUserID(Context context) {
//		SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
//		return sp.getString("userid", "");
//	}

	// public static String getUserName(Context context) {
	// SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
	// return sp.getString("username", "");
	// }
	//
	// public static String getPassword(Context context) {
	// SharedPreferences sp = context.getSharedPreferences(SHARE_DB_NAME, 0);
	// return sp.getString("password", "");
	// }
}
