package com.nuclear.sdk.android.utils;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.Properties;
import java.util.UUID;

import org.json.JSONException;
import org.json.JSONObject;

import com.nuclear.sdk.active.SdkCommplatform;
import com.nuclear.sdk.active.SdkLogin;
import com.nuclear.sdk.active.SdkPay;
import com.nuclear.sdk.android.config.SdkConfig;

import android.content.Context;
import android.os.Build;
import android.os.Environment;
import android.os.SystemClock;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.util.Log;

public class Utils {

	public static String getDeviceTrueId(Context context) {
		TelephonyManager telephonyManager = (TelephonyManager) context
				.getSystemService(Context.TELEPHONY_SERVICE);
		String imei = telephonyManager.getDeviceId();
		if (!TextUtils.isEmpty(imei)) {
			return imei;
		} else {
			String androidId = Secure.getString(context.getContentResolver(),
					Secure.ANDROID_ID);
			return androidId;
		}
	}
	
	/*
	 * 
	 * */
	public static String getDeviceId(Context context)
	{
		//Environment.getExternalStoragePublicDirectory(type)
		String uuid = "";//getExternalFilesDir(null)//不能用这个，在没有外部存储的设备会有问题！Android的外部存储不狭隘的指SD卡，设备厂商可内置部分存储时即为默认外部存储
		File uFile = new File(/*context.getFilesDir().getAbsolutePath()*/Environment.getExternalStorageDirectory().getAbsoluteFile()
				+ "/nuclear/uuid.properties");
		if (uFile.exists()) {
			Properties cfgIni = new Properties();
			try {
				cfgIni.load(new FileInputStream(uFile));
				uuid = cfgIni.getProperty("uuid", null);
			} catch (FileNotFoundException e) {
				
			} catch (IOException e) {
				
			}
			cfgIni = null;
			if(uuid!=null && !("".equals(uuid)))
			{
				uFile = null;
				Log.w("getDeviceUUID", uuid);
				return uuid;
			}
		}
		else
		{
			Properties cfgIni = new Properties();
			cfgIni.setProperty("uuid", "");
			try {
				cfgIni.store(new FileOutputStream(uFile), "auto save, default none str");
			} catch (FileNotFoundException e) {
				
			} catch (IOException e) {
				
			}
			//
			cfgIni = null;
		}
		try
		{
			TelephonyManager tmsvc = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
			if (tmsvc != null)
			{
				uuid = tmsvc.getDeviceId();
				if (uuid == null)
					uuid = tmsvc.getSubscriberId();
				if (uuid == null)
					//uuid = DeviceUtil.getDeviceProductName(context);
					uuid = null;
			}
		}
		catch(Exception e)
		{
			
		}
		if(uuid==null||"".equals(uuid)||"0".equals(uuid))
		{
			uuid = "uuid_"+generateUUID();
		}
		Properties cfgIni = new Properties();
		cfgIni.setProperty("uuid", uuid);
		try {
			cfgIni.store(new FileOutputStream(uFile), "auto save, generateUUID");
		} catch (FileNotFoundException e) {
			
		} catch (IOException e) {
			
		}
		uFile = null;
		cfgIni = null;
		Log.w("getDeviceUUID", uuid);
		return uuid;
	}
	
	/*
	 * 
	 * */
	public static String generateUUID()
	{
		return UUID.randomUUID().toString();//字符串带横杠字符-
	}
	
	public static String getDeviceProductName(Context context)
	{
		
		 String manufacturer = Build.MANUFACTURER;
		  String model = Build.MODEL.replaceAll(" ", "-");
		  if (model.startsWith(manufacturer)) {
		    return model;
		  } else {
		    return (manufacturer + " " + model).replaceAll(" ", "-");
		  }
	}
	
	public static JSONObject makeHead(Context context){
		
		JSONObject header = new JSONObject(); 
		try {
			header.put("gameId", SdkCommplatform.getInstance().getAppInfo().getAppKey());
			//header.put("gameId", "mxhzw");
			header.put("platform", SdkConfig.PlatformStr);
			header.put("deviceMacId", getDeviceId(context));
			header.put("timestamp", SdkConfig.timestamp+SystemClock.currentThreadTimeMillis());
			header.put("deviceName", getDeviceProductName(context));
			
		} catch (JSONException e1) {
			e1.printStackTrace();
		}
		
		return header;
	}
 

}

