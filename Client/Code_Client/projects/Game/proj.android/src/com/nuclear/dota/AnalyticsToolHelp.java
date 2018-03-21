package com.nuclear.dota;

import java.util.HashMap;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.util.Log;
import android.widget.Toast;

import com.igexin.slavesdk.MessageManager;
import com.tencent.stat.StatConfig;
import com.tencent.stat.StatReportStrategy;
import com.tencent.stat.StatService;
import com.nuclear.PlatformAndGameInfo.GameInfo;

public class AnalyticsToolHelp {
//	 private static final String AppId_Tencent="A1JFZ25CM2YH"; //测试腾讯移动统计appId
	private static final String AppId_Tencent = "A1HGLES644LU";//正式腾讯移动统计appId
	// 正常包应为false
	private static final boolean isStatisticsOpen = true;

	private static final boolean isDebugTencent = false;// 正式发布设为false

	private static Context activityCtx = null;

	private static String appId = null;

	private static String userId = null;

	private static boolean bpair = false;

	private static HashMap<String, String> paramsMap = new HashMap<String, String>();

	/*
	 * GameActivity.onCreate
	 */
	public static void onCreate(Context ctx, GameInfo gameInfo) {
		activityCtx = ctx;
		//
		// FlurryAgent.setCaptureUncaughtExceptions(true);

		ApplicationInfo appInfo = null;
		try {
			appInfo = ctx.getPackageManager().getApplicationInfo(
					ctx.getPackageName(), PackageManager.GET_META_DATA);
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		String channelName = "";
		if (appInfo != null && appInfo.metaData != null
				&& appInfo.metaData.getInt("company_channel") != 0) {
			channelName = gameInfo.platform_type_str + "_"
					+ appInfo.metaData.getInt("company_channel");
		} else {
			channelName = gameInfo.platform_type_str;
		}
		// Toast.makeText(ctx, channelName, Toast.LENGTH_SHORT).show();
		if (isStatisticsOpen) {
			StatConfig.setAppKey(AppId_Tencent);
			StatConfig.setInstallChannel(channelName);
			if (isDebugTencent) {
				StatConfig.setDebugEnable(true);
				// 调试时，使用实时发送
				StatConfig.setStatSendStrategy(StatReportStrategy.INSTANT);
			} else {
				StatConfig.setDebugEnable(false);
				// 根据情况，决定是否开启MTA对app未处理异常的捕获
				StatConfig.setAutoExceptionCaught(true);
				StatConfig.setStatSendStrategy(StatReportStrategy.APP_LAUNCH);
			}

			//StatService.trackCustomEvent(ctx, "onCreate", "");
		}
		//--begin
		MessageManager.getInstance().initialize(ctx);
		//
		//--end
	}

	public static void onStart() {
		if (bpair)
			return;
		if (appId != null && !appId.isEmpty()) {
			bpair = true;
			// FlurryAgent.onStartSession(activityCtx, appId);
		}
		// if(isStatisticsOpen)
		// StatService.startNewSession(activityCtx);
	}

	public static void onResume() {
		if (isStatisticsOpen)
			StatService.onResume(activityCtx);
	}

	public static void onPause() {
		if (isStatisticsOpen)
			StatService.onPause(activityCtx);
	}

	public static void onStop() {
		if (!bpair)
			return;
		if (appId != null && !appId.isEmpty()) {
			bpair = false;
			// FlurryAgent.onEndSession(activityCtx);
		}
		// if(isStatisticsOpen)
		// StatService.stopSession();
	}

	/*
	 * initAnalyticsJni
	 */
	public static void initAnalytics(String appid) {

		appId = appid;
		onStart();

	}

	/*
	 * initAnalyticsUserIDJni
	 */
	public static void initAnalyticsUserID(String userid) {
		userId = userid;
		//
		// FlurryAgent.setUserId(userid);
	}

	/*
	 * 
	 * */
	public static void analyticsLogEvent(String event) {
		StatService.trackCustomEvent(activityCtx, event, event);
//		Toast.makeText(activityCtx, event, Toast.LENGTH_SHORT).show();
//		Log.v("mta", event);
		if (!bpair)
			return;
		if (appId != null && userId != null && !appId.isEmpty()
				&& !userId.isEmpty() && !event.isEmpty()) {
			// FlurryAgent.logEvent(event);

			if (isStatisticsOpen) {
				//Properties prop = new Properties();
				//prop.putAll(paramsMap);
				//StatService.trackCustomKVEvent(activityCtx, event, prop);
			}
		}

	}

	/*
	 * 
	 * */
	public static void clearParamsMap() {
		paramsMap.clear();
	}

	/*
	 * 
	 * */
	public static void addParamsMapOnePair(String key, String value) {
		paramsMap.put(key, value);
	}

	/*
	 * 
	 * */
	public static void analyticsLogMapParamsEvent(String event, boolean timed) {
		if (!bpair)
			return;
		//
		paramsMap.put("userId", userId);
		//
		if (appId != null && userId != null && !appId.isEmpty()
				&& !userId.isEmpty() && !event.isEmpty()) {
			// FlurryAgent.logEvent(event, paramsMap, timed);

			if (isStatisticsOpen) {
				//Properties prop = new Properties();
				//prop.putAll(paramsMap);
				//StatService.trackCustomBeginKVEvent(activityCtx, event, prop);
			}

		}
	}

	/**
	 * 
	 * */
	public static void analyticsLogEndTimeEvent(String event) {
		if (!bpair)
			return;
		if (appId != null && userId != null && !appId.isEmpty()
				&& !userId.isEmpty() && !event.isEmpty()) {
			// FlurryAgent.endTimedEvent(event);
			if (isStatisticsOpen) {
				//Properties prop = new Properties();
				//prop.putAll(paramsMap);
				//StatService.trackCustomEndKVEvent(activityCtx,
				//		"trackCustomEvent", prop);
			}
		}
	}
}
