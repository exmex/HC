package com.nuclear.dota;

import java.util.Calendar;
import java.util.Locale;
import java.util.TimeZone;

import com.igexin.sdk.aidl.Tag;
import com.igexin.slavesdk.MessageManager;
import com.nuclear.PlatformAndGameInfo.GameInfo;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Build;
import android.util.Log;


public class LastLoginHelp {
	
	
	static GameActivity mGameActivity;
	public static String mGameid;
	public static String mPuid;
	public static int mServerID;
	
	public static int mPlayerId;
	public static String mPlayerName;
	public static  int mVipLvl;
	public static  int mlv;
	public static String mPlatform;
	public static int mPlayervl;
	
	public static void setActivity(GameActivity pGameActivity) {
		
		mGameActivity = pGameActivity;
		PushLastLoginHelp.setPushLastLoginHelp(mGameActivity);
		
	}

	public static void updateServerInfo(int serverID, 
		String playerName, int playerID, int lvl, int vipLvl, int coin1, int coin2, boolean pushSvr) {
		mServerID = serverID;
		mPlayerId = playerID;
		mPlayerName = playerName;
		mVipLvl = vipLvl;
		mPlayervl = vipLvl;
		mlv = lvl;
		ServerInfo _ServerInfo = new ServerInfo();
		Log.i("updateServerInfo", _ServerInfo.toString());
		if (mPlatform == null)
			mPlatform = mGameActivity.getClientChannel();
		_ServerInfo.setPlatform(mPlatform);
		_ServerInfo.setPlayerName(playerName);
		_ServerInfo.setPlayerId(playerID);
		_ServerInfo.setVipLv1(vipLvl);
		_ServerInfo.setPlayerLv1(lvl);
		_ServerInfo.setGameCoin1(coin1);
		_ServerInfo.setGameCoin2(coin2);
		//
	    if(_ServerInfo.getGameId().equals("")||_ServerInfo.getGameId()==null){
	    	return;
	    }
		//gexinclientid string
		//gexintags string, "tag1 tag2 tag3" 
		//
		
		//
		mGameActivity.getMainThreadHandler().post(new Runnable() {
			@Override
			public void run() {
				mGameActivity.getPlatformSDK().onLoginGame();
			}
		});
		//--begin
		if (GexinSdkMsgReceiver.stStrGexinClientId != null && 
				!GexinSdkMsgReceiver.stStrGexinClientId.isEmpty() && 
				mPlatform != null && !mPlatform.isEmpty() && 
				mPuid != null && !mPuid.isEmpty() && 
				playerName != null && !playerName.isEmpty() /*&& !playerName.equals("aaa")*/)
		{
			GameInfo gameInfo = mGameActivity.getGameInfo();
			Context ctx = GameActivity.mContext;
			//
			StringBuffer strTags = new StringBuffer();
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
			Tag tags[] = new Tag[16];//tags' count
			//
			tags[0] =  new Tag();
			tags[0].setName(gameInfo.platform_type_str);
			strTags.append(gameInfo.platform_type_str + " ");
			Log.d("GeXinTag0_platform:	", gameInfo.platform_type_str);
			//
			tags[1] =  new Tag();
			tags[1].setName(channelName);
			strTags.append(channelName + " ");
			Log.d("GeXinTag1_channelName:	", channelName);
			//
			Calendar now = Calendar.getInstance();
		    TimeZone timeZone = now.getTimeZone();
		    tags[2] =  new Tag();
			tags[2].setName(timeZone.getDisplayName(false,TimeZone.SHORT,Locale.US));
			strTags.append(timeZone.getDisplayName(false,TimeZone.SHORT,Locale.US) + " ");
			Log.d("GeXinTag2_timeZone:	", timeZone.getDisplayName(false,TimeZone.SHORT,Locale.US));
			//
			String manufacturer = Build.MANUFACTURER.replaceAll(" ", "-");
			String model = Build.MODEL.replaceAll(" ", "-");
			String sdkversion = "" + Build.VERSION.SDK_INT;
			//
			tags[3] =  new Tag();
			tags[3].setName(manufacturer);
			strTags.append(manufacturer + " ");
			Log.d("GeXinTag3_manufacturer:	", manufacturer);
			//
			tags[4] =  new Tag();
			tags[4].setName(model);
			strTags.append(model + " ");
			Log.d("GeXinTag4_model:	", model);
			//
			tags[5] =  new Tag();
			tags[5].setName(manufacturer+"-"+model);
			strTags.append(manufacturer+"-"+model + " ");
			Log.d("GeXinTag5_manufacturer-model:	", manufacturer+"-"+model);
			//
			tags[6] =  new Tag();
			tags[6].setName("sdklvl-"+sdkversion);
			strTags.append("sdklvl-"+sdkversion + " ");
			Log.d("GeXinTag6_sdklvl:	", "sdklvl-"+sdkversion);
			//
			tags[7] =  new Tag();
			tags[7].setName("android-"+gameInfo.platform_type);
			strTags.append("android-"+gameInfo.platform_type + " ");
			Log.d("GeXinTag7_android:	", "android-"+gameInfo.platform_type);
			//
			//Tag tags[] = new Tag[7];//tags' count
			//
			tags[8] =  new Tag();//format:platformidnum-serverID-playerID
			tags[8].setName("" + gameInfo.platform_type + "-" + serverID + "-" + playerID);
			strTags.append("" + gameInfo.platform_type + "-" + serverID + "-" + playerID + " ");
			Log.d("GeXinTag8_platformidnum-serverID-playerID:	", "" + gameInfo.platform_type + "-" + serverID + "-" + playerID);
			//
			tags[9] =  new Tag();//format:platformidnum-serverID-playerName
			tags[9].setName("" + gameInfo.platform_type + "-" + serverID + "-" + playerName);
			strTags.append("" + gameInfo.platform_type + "-" + serverID + "-" + playerName + " ");
			Log.d("GeXinTag9_platformidnum-serverID-playerName:	", "" + gameInfo.platform_type + "-" + serverID + "-" + playerName);
			//
			tags[10] =  new Tag();//format:puid-serverID-playerID
			tags[10].setName(mPuid + "-" + serverID + "-" + playerID);
			strTags.append(mPuid + "-" + serverID + "-" + playerID + " ");
			Log.d("GeXinTag10_puid-serverID-playerID:	", mPuid + "-" + serverID + "-" + playerID);
			//
			tags[11] =  new Tag();//format:puid-serverID-playerName
			tags[11].setName(mPuid + "-" + serverID + "-" + playerName);
			strTags.append(mPuid + "-" + serverID + "-" + playerName + " ");
			Log.d("GeXinTag11_puid-serverID-playerName:	", mPuid + "-" + serverID + "-" + playerName);
			//
			tags[12] =  new Tag();//format:puid
			tags[12].setName(mPuid);
			strTags.append(mPuid + " ");
			Log.d("GeXinTag12_puid:	", mPuid);
			//
			tags[13] =  new Tag();//format:lvl-lvlnum
			tags[13].setName("lvl-" + lvl);
			strTags.append("lvl-" + lvl + " ");
			Log.d("GeXinTag13_lvl-lvlnum:	", "lvl-" + lvl);
			//
			tags[14] =  new Tag();//format:viplvl-viplvlnum
			tags[14].setName("viplvl-" + vipLvl);
			strTags.append("viplvl-" + vipLvl + " ");
			Log.d("GeXinTag14_viplvl-viplvlnum:	", "viplvl-" + vipLvl);
			//
			tags[15] =  new Tag();//format:puid-serverID
			tags[15].setName(mPuid+"-"+serverID);
			strTags.append(mPuid+"-"+serverID + " ");
			Log.d("GeXinTag15_puid-serverID:	", mPuid+"-"+serverID);
			//
			int ret = MessageManager.getInstance().setTag(GameActivity.mContext, tags);
			Log.d("GeXinSetTag2 ret code:	", ""+ret);
			Log.e("GeXinTags:	", strTags.toString());
			
			PushLastLoginHelp.setGexingClientId(GexinSdkMsgReceiver.stStrGexinClientId);
			PushLastLoginHelp.setGexingTags(strTags.toString());
		}
		//--end
		
		PushLastLoginHelp.updateServerInfo(serverID, _ServerInfo, pushSvr);
	}

	public static void refreshServerInfo(String gameid, String puid, boolean getSvr) {
		mGameid = gameid;
		mPuid = puid;
		ServerInfo _ServerInfo = new ServerInfo();
		Log.i("updateServerInfo", _ServerInfo.toString());
		_ServerInfo.setPlatform(mGameActivity.getClientChannel());
		_ServerInfo.setGameId(gameid);
		_ServerInfo.setPuid(puid);
		PushLastLoginHelp.refreshServerInfo(gameid, puid,_ServerInfo, getSvr);
	}

	public static int getServerInfoCount() {
		return PushLastLoginHelp.getServerInfoCount();
	}

	public static int getServerUserByIndex(int index) {
		return PushLastLoginHelp.getServerUserByIndex(index);

	}

}
