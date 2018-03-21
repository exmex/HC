package com.nuclear.dota.oversea;

import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences.Editor;
import android.util.Log;

import com.appsflyer.AppsFlyerLib;
import com.appsflyer.ConversionDataListener;
import com.nuclear.PlatformAndGameInfo.GameInfo;

public class AppsFlyerAnalytics {

	private static String devKey = "xTe4FqvHxdVJTTVj8xQPKa";
	private static final String CollectDataUrl ="http://203.90.236.18/index.php?g=home&m=apiRequest&a=collectData";
	/**
	 * 
	 * @param context
	 */
	public static void onCreate(Context context) {
		AppsFlyerLib.sendTracking(context.getApplicationContext());
	}

	/**
	 * 初始化dev key、支付币种
	 */
	public static void init() {
		AppsFlyerLib.setAppsFlyerKey(devKey);
		AppsFlyerLib.setCurrencyCode(CurrencyCode.AMERICA);
	}

	public static void register(Context context,String type) {
		AppsFlyerLib.sendTrackingWithEvent(context.getApplicationContext(),type, "");
		
	}

	public static void login(Context context) {
		AppsFlyerLib.sendTrackingWithEvent(context.getApplicationContext(),
				"login", "");
	}
	
	public static void purchase(Context context, float price) {
		AppsFlyerLib.sendTrackingWithEvent(context.getApplicationContext(),
				"purchase", price + "");
	}

	public static void converData(final Activity context,final GameInfo gameInfo,final String sdkVersion) {
		/*AppsFlyerLib.registerConversionListener(context, new AppsFlyerConversionListener(){

			@Override
			public void onAppOpenAttribution(Map<String, String> conversionData) {

				for (String attrName : conversionData.keySet()) {
					Log.d("AppsFlyerTest", "attribute: " + attrName + " = " + conversionData.get(attrName));
				}
				final String click_time = conversionData.get("click_time");//Click date & time (milliseconds)  2014-01-08 00:07:53.233 
				final String install_time = conversionData.get("install_time");
				final String media_source = conversionData.get("media_source");
				final String click_url = conversionData.get("click_time");
				final String is_paid = conversionData.get("is_paid");//Click time in millis 
				
				new Thread(){
					public void run() 
					{
						String postData = com.nuclear.Util.makeAppsFlyerMsg(context, gameInfo, install_time, media_source,
								sdkVersion, click_url, click_time,is_paid);
						
						
						String retData = com.nuclear.Util.doPost(CollectDataUrl, postData);
						JSONObject retJson;
						try {
							retJson = new JSONObject(retData);
							int status = retJson.optInt("status");
							if(status!=0) 
							{
								Editor appsEditor = context.getSharedPreferences("appsflyer",Context.MODE_PRIVATE).edit();
								appsEditor.putBoolean("sendCollectData", true);
								appsEditor.commit(); 
							}
						} catch (JSONException e) {
							e.printStackTrace();
						}
						
					}
				}.start();
			}

			@Override
			public void onInstallConversionDataLoaded(Map<String, String> conversionData) {

				for (String attrName : conversionData.keySet()) {
					Log.d("AppsFlyerTest", "attribute: " + attrName + " = " + conversionData.get(attrName));
				}
				final String click_time = conversionData.get("click_time");//Click date & time (milliseconds)  2014-01-08 00:07:53.233 
				final String install_time = conversionData.get("install_time");
				final String media_source = conversionData.get("media_source");
				final String click_url = conversionData.get("click_time");
				final String is_paid = conversionData.get("is_paid");//Click time in millis 
				
				new Thread(){
					public void run() 
					{
						String postData = com.nuclear.Util.makeAppsFlyerMsg(context, gameInfo, install_time, media_source,
								sdkVersion, click_url, click_time,is_paid);
						
						
						String retData = com.nuclear.Util.doPost(CollectDataUrl, postData);
						JSONObject retJson;
						try {
							retJson = new JSONObject(retData);
							int status = retJson.optInt("status");
							if(status!=0) 
							{
								Editor appsEditor = context.getSharedPreferences("appsflyer",Context.MODE_PRIVATE).edit();
								appsEditor.putBoolean("sendCollectData", true);
								appsEditor.commit(); 
							}
						} catch (JSONException e) {
							e.printStackTrace();
						}
						
					}
				}.start();
			}

			@Override
			public void onInstallConversionFailure(String arg0) {
				// TODO Auto-generated method stub
				Log.d("AppsFlyerTest", "failure"+arg0);
			}});*/
		
		AppsFlyerLib.getConversionData(context, new ConversionDataListener() {
			public void onConversionDataLoaded(Map<String, String> conversionData) {
				for (String attrName : conversionData.keySet()) {
					Log.d("AppsFlyerTest", "attribute: " + attrName + " = " + conversionData.get(attrName));
				}
				final String click_time = conversionData.get("click_time");//Click date & time (milliseconds)  2014-01-08 00:07:53.233 
				final String install_time = conversionData.get("install_time");
				final String media_source = conversionData.get("media_source");
				final String click_url = conversionData.get("click_time");
				final String is_paid = conversionData.get("is_paid");//Click time in millis 
				
				new Thread(){
					public void run() 
					{
						String postData = com.nuclear.Util.makeAppsFlyerMsg(context, gameInfo, install_time, media_source,
								sdkVersion, click_url, click_time,is_paid);
						
						
						String retData = com.nuclear.Util.doPost(CollectDataUrl, postData);
						JSONObject retJson;
						try {
							retJson = new JSONObject(retData);
							int status = retJson.optInt("status");
							if(status!=0) 
							{
								Editor appsEditor = context.getSharedPreferences("appsflyer",Context.MODE_PRIVATE).edit();
								appsEditor.putBoolean("sendCollectData", true);
								appsEditor.commit(); 
							}
						} catch (JSONException e) {
							e.printStackTrace();
						}
						
					}
				}.start();
			}

			public void onConversionFailure(String errorMessage) {
				Log.d("AppsFlyerTest", "error getting conversion data: " + errorMessage);
			}
		});
	}
	
	public static void setDeviceTrackingDisabled(boolean boo){
		AppsFlyerLib.setDeviceTrackingDisabled(boo);
	}
}

class CurrencyCode {
	public static final String AMERICA = "USD";
	public static final String CHINA = "CNY";
	public static final String TAIWAN = "TWD";
}