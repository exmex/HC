package com.nuclear;

import java.util.List;

import android.app.AlarmManager;
import android.app.AlertDialog;
import android.app.PendingIntent;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Handler;
import android.util.Log;

public class GameActivityHelper {

	static Context mContext ;

	// 重启Activity程序
	public static void requestRestart(final Context context,Handler pManHandler) {
		
		pManHandler.post(new Runnable() {
			@Override
			public void run() {
				AlarmManager alm = (AlarmManager) context
						.getSystemService(Context.ALARM_SERVICE);
				alm.set(AlarmManager.RTC, System.currentTimeMillis() + 1000,
						PendingIntent.getActivity(context, 0, new Intent(context,
								context.getClass()), 0));
				android.os.Process.killProcess(android.os.Process.myPid());
			}
		});
	
	}

	public static void openCLD(String packageName,Context context) { 
        PackageManager packageManager = context.getPackageManager(); 
        PackageInfo pi = null;
         
            try { 
                 
                pi = packageManager.getPackageInfo(packageName, 0); 
            } catch (NameNotFoundException e) { 
                 
            } 
            Intent resolveIntent = new Intent(Intent.ACTION_MAIN, null); 
            resolveIntent.addCategory(Intent.CATEGORY_LAUNCHER); 
            resolveIntent.setPackage(pi.packageName); 
 
            List<ResolveInfo> apps = packageManager.queryIntentActivities(resolveIntent, 0); 
 
            ResolveInfo ri = apps.iterator().next(); 
            if (ri != null ) { 
                String className = ri.activityInfo.name; 
                Intent intent = new Intent(Intent.ACTION_MAIN); 
                intent.addCategory(Intent.CATEGORY_LAUNCHER); 
                ComponentName cn = new ComponentName(packageName, className); 
                intent.setComponent(cn); 
                intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				intent.setAction(Intent.ACTION_VIEW);
				try {
					context.startActivity(intent); 
				} catch (Exception e) {
					Log.i("GameActivityHelp", e.toString());
				}
                
            } 
    } 
	
	// 存在：打开微信程序 ，不存在：弹出安装微信
	public static void openWeChat(final Context pContext,Handler pMainHandler) {

		PackageInfo packageInfo;
		try {
			packageInfo = pContext.getPackageManager().getPackageInfo(
					"com.tencent.mm", 0);
		} catch (NameNotFoundException e) {
			packageInfo = null;
		}
		
		if (packageInfo == null) {
			pMainHandler.post(new Runnable() {
				
				@Override
				public void run() {
					mContext = pContext;
					new AlertDialog.Builder(mContext)
					.setTitle("提示")
					.setMessage("您还没有安装微信\n")
					.setPositiveButton("确定", null)
					.setNegativeButton(
							"下载",
							new android.content.DialogInterface.OnClickListener() {

								@Override
								public void onClick(DialogInterface dialog,
										int which) {
									String str = "market://details?id="+ "com.tencent.mm";
									Intent localIntent = new Intent("android.intent.action.VIEW");
									localIntent.setData(Uri.parse(str));
									try{
									mContext.startActivity(localIntent);
									}catch (Exception e) {
										Uri uri = Uri.parse("https://market.android.com/details?id=com.tencent.mm");   
						                Intent intent=new Intent(Intent.ACTION_VIEW, uri);  
						                mContext.startActivity(intent);
									}
								}

							}).show();
				}
			});
		}else {
			pMainHandler.post(new Runnable() {
				@Override
				public void run() {
					/*Intent localIntent = new Intent("android.intent.action.VIEW", Uri.parse("weixin://qr/e3R_Zt-EtoLJrZsF9yFp"));
					try {
						pContext.startActivity(localIntent);
					} catch (Exception e) {
						Log.i("GameActivityHelp", e.toString());
					}*/
					Intent intent = new Intent();
					intent.setComponent(new ComponentName("com.tencent.mm",
							"com.tencent.mm.ui.LauncherUI"));
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					intent.setAction(Intent.ACTION_VIEW);
					try {
						pContext.startActivity(intent);
					} catch (Exception e) {
						Log.i("GameActivityHelp", e.toString());
					}
				}
			});
		}
	}
	
	public static boolean isInstallWeChat(final Context pContext,Handler pMainHandler){
		PackageInfo packageInfo;
		try {
			packageInfo = pContext.getPackageManager().getPackageInfo(
					"com.tencent.mm", 0);
		} catch (NameNotFoundException e) {
			packageInfo = null;
		}
		
		if (packageInfo == null) {
			return false;
		}else{
			return true;
		}
	}
	
	public static void noWeChatDialog(final Context context,Handler pMainHandler){
		pMainHandler.post(new Runnable() {
			@Override
			public void run() {
				new AlertDialog.Builder(context)
				.setTitle("提示")
				.setMessage("您还没有安装微信\n")
				.setPositiveButton("确定", null)
				.setNegativeButton(
						"下载",
						new android.content.DialogInterface.OnClickListener() {

							@Override
							public void onClick(DialogInterface dialog,
									int which) {
								String str = "market://details?id="+ "com.tencent.mm";
								Intent localIntent = new Intent("android.intent.action.VIEW");
								localIntent.setData(Uri.parse(str));
								try{
									context.startActivity(localIntent);
								}catch (Exception e) {
									Uri uri = Uri.parse("https://market.android.com/details?id=com.tencent.mm");   
					                Intent intent=new Intent(Intent.ACTION_VIEW, uri);  
					                context.startActivity(intent);
								}
							}



						}).show();
			}
	
		});
	}
	
}
