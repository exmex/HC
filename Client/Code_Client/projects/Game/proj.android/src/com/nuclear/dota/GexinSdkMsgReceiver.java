package com.nuclear.dota;

import java.util.Calendar;
import java.util.Locale;
import java.util.TimeZone;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Build;
import android.os.Bundle;
import android.util.Log;

import com.igexin.sdk.Consts;
import com.igexin.sdk.aidl.Tag;
import com.igexin.slavesdk.MessageManager;
import com.nuclear.PlatformAndGameInfo.GameInfo;

public class GexinSdkMsgReceiver extends BroadcastReceiver {
	
	public static String stStrGexinClientId = null;

	@Override
	public void onReceive(Context context, Intent intent) {
		Bundle bundle = intent.getExtras();
		Log.d("GexinSdkDemo", "onReceive() action=" + bundle.getInt("action"));
		switch (bundle.getInt(Consts.CMD_ACTION)) {

		case Consts.GET_MSG_DATA:
			// 获取透传数据
			// String appid = bundle.getString("appid");
			byte[] payload = bundle.getByteArray("payload");

			if (payload != null) {
				String data = new String(payload);

				Log.d("GexinSdkDemo", "Got Payload:" + data);
				

			}
			break;
		case Consts.GET_CLIENTID:
			// 获取ClientID(CID)
			// 第三方应用需要将CID上传到第三方服务器，并且将当前用户帐号和CID进行关联，以便日后通过用户帐号查找CID进行消息推送
			stStrGexinClientId = bundle.getString("clientid");
			//
			//--begin
			if (GameActivity.mContext != null && GameActivity.mGameApp != null)
			{
				Context ctx = GameActivity.mContext;
				GameInfo gameInfo = GameActivity.mGameApp.getGameInfo();
				//
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
				//
				Tag tags[] = new Tag[6];//tags' count
				//
				tags[0] =  new Tag();
				tags[0].setName(gameInfo.platform_type_str);
				Log.d("GeXinTag0_platform:	", gameInfo.platform_type_str);
				//
				tags[1] =  new Tag();
				tags[1].setName(channelName);
				Log.d("GeXinTag1_channelName:	", channelName);
				//
				Calendar now = Calendar.getInstance();
			    TimeZone timeZone = now.getTimeZone();
			    tags[2] =  new Tag();
				tags[2].setName(timeZone.getDisplayName(false,TimeZone.SHORT,Locale.US));
				Log.d("GeXinTag2_timeZone:	", timeZone.getDisplayName(false,TimeZone.SHORT,Locale.US));
				//
				String manufacturer = Build.MANUFACTURER.replaceAll(" ", "-");
				String model = Build.MODEL.replaceAll(" ", "-");
				String sdkversion = "" + Build.VERSION.SDK_INT;
				//
				tags[3] =  new Tag();
				tags[3].setName(manufacturer);
				Log.d("GeXinTag3_manufacturer:	", manufacturer);
				//
				tags[4] =  new Tag();
				tags[4].setName(model);
				Log.d("GeXinTag4_model:	", model);
				//
				tags[5] =  new Tag();
				tags[5].setName(sdkversion);
				Log.d("GeXinTag5_sdkversion:	", sdkversion);
				//
				/*
				 * LastLoginHelp 那setTag，因为第二次调用setTag必须间隔1小时后，所以只在后面调一次
				 * */
				//int ret = MessageManager.getInstance().setTag(ctx, tags);
				//Log.d("GeXinSetTag ret code:	", ""+ret);
			}
			//--end
			break;

		case Consts.BIND_CELL_STATUS:
			String cell = bundle.getString("cell");

			Log.d("GexinSdkDemo", "BIND_CELL_STATUS:" + cell);
			//
			break;
		case Consts.THIRDPART_FEEDBACK:
			// sendMessage接口调用回执
			String appid = bundle.getString("appid");
			String taskid = bundle.getString("taskid");
			String actionid = bundle.getString("actionid");
			String result = bundle.getString("result");
			long timestamp = bundle.getLong("timestamp");

			Log.d("GexinSdkDemo", "appid:" + appid);
			Log.d("GexinSdkDemo", "taskid:" + taskid);
			Log.d("GexinSdkDemo", "actionid:" + actionid);
			Log.d("GexinSdkDemo", "result:" + result);
			Log.d("GexinSdkDemo", "timestamp:" + timestamp);
			break;
		default:
			break;
		}
	}
}
