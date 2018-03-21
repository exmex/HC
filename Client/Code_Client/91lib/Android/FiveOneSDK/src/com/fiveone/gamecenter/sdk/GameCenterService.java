package com.fiveone.gamecenter.sdk;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.util.DisplayMetrics;
import android.util.Log;
import com.fiveone.gamecenter.netconnect.NetConfig;
import com.fiveone.gamecenter.netconnect.NetConnectService;
import com.fiveone.gamecenter.netconnect.bean.GameInfo;
import com.fiveone.gamecenter.netconnect.bean.UserInfo;
import com.fiveone.gamecenter.netconnect.db.GameDBHelper;
import com.fiveone.gamecenter.netconnect.listener.AccountStatusListener;
import com.fiveone.gamecenter.netconnect.openudid.OpenUDID_manager;
import com.fiveone.gamecenter.sdk.activity.FirstLoginActivity;
import com.fiveone.gamecenter.sdk.activity.GamePayActivity;
import com.fiveone.gamecenter.sdk.activity.LoginActivity;
import com.fiveone.gamecenter.sdk.activity.RegisterActivity;
import com.fiveone.gamecenter.sdk.util.Util;

public class GameCenterService {
	public static UserInfo UserInfo = null;
	public static String ServerID = "";
	public static String ServerName = "";
	public static String SessionID = "";
	public static String GameLevel = "";
	public static String GameRoleName = "";
	public static String OrderNum51 = "";
	public static String appKey = "";
	public static String GamePayCallBackInfo = "";
	public static String GamePayDefaultCash = "0";
	private static final long DELAY_TIME = 5 * 60 * 1000;

	public static AccountStatusListener mListiner;
	private static Handler mOnlineHandler;

	public static void initSDK(final Context context, String channelId, AccountStatusListener aListiner) {
		GameCenterService.appKey = Config.GAME_CENTER_APP_KEY;
		GameCenterService.mListiner = aListiner;
		NetConnectService.initParams(appKey, Config.GAME_CENTER_PRIVATE_KEY, channelId);
		OpenUDID_manager.sync(context);
		OpenUDID_manager.isInitialized();
		doGameInfo(context);
	}

	public static void setUserInfo(UserInfo aUserInfo) {
		GameCenterService.UserInfo = aUserInfo;
	}
	
	public static void setGameRoleNameAndGameLevel(Context aContext, String aGameRoleName,String aGameLevel) {
		GameCenterService.GameRoleName = aGameRoleName;
		GameCenterService.GameLevel = aGameLevel;
		GameCenterService.callOnlineAccount(aContext);
	} 

	// 登录接口统计
	public static void setLoginServer(Context aContext, String aServerId, String aServerName) {
		GameCenterService.ServerID = aServerId;
		GameCenterService.ServerName = aServerName;
	}

	// 跳转注册页
	public static void startRegisterActivity(Activity activity) {
		activity.startActivity(new Intent(activity.getApplicationContext(), RegisterActivity.class));
	}

	// 跳转注册页
	public static void startRegisterActivityForResult(Activity activity) {
		activity.startActivity(new Intent(activity.getApplicationContext(), RegisterActivity.class));
	}

	// 跳转登录页
	public static void startLoginActivity(Activity activity) {
		String[] usernames = GameDBHelper.getInstance(activity.getBaseContext()).queryAllUserName();
		if (usernames.length == 0) {
			Intent intent = new Intent(activity.getApplicationContext(), FirstLoginActivity.class);
			activity.startActivity(intent);
		} else {
			Intent intent = new Intent(activity.getApplicationContext(), LoginActivity.class);
			activity.startActivity(intent);
		}
	}

	// 充值
	public static void startGamePayActivity(Activity activity) {
		activity.startActivity(new Intent(activity.getApplicationContext(), GamePayActivity.class));
	}

	// 充值
	public static void startGamePayActivity(Activity activity, String aGamePayCallBackInfo) {
		GameCenterService.GamePayCallBackInfo = aGamePayCallBackInfo;
		activity.startActivity(new Intent(activity.getApplicationContext(), GamePayActivity.class));
	}
	
	// 充值
	public static void startGamePayActivity(Activity activity, String aGamePayCallBackInfo,String aDefaultCash) {
		GameCenterService.GamePayCallBackInfo = aGamePayCallBackInfo;
		GameCenterService.GamePayDefaultCash = aDefaultCash;
		activity.startActivity(new Intent(activity.getApplicationContext(), GamePayActivity.class));
	}
	

	// 统计 - 联网激活
	public static void callPhoneAnalytics(Activity aActivity) {
		DisplayMetrics dm = new DisplayMetrics();
		aActivity.getWindowManager().getDefaultDisplay().getMetrics(dm);
		NetConnectService.callGameAnalytics(aActivity.getApplicationContext(), Config.SDK_VERSION, dm);
	}

	// 每5分钟提交一次用于统计在线人数
	public static void callOnlineAccount(final Context context) {
		if (mOnlineHandler == null) {
			mOnlineHandler = new Handler() {
				public void handleMessage(Message msg) {
					if (UserInfo == null){
						return ;
					}
				
					String tSessionID = Util.getSessionID(context);
					String isfirst = "1";
					if (SessionID.equals("")||!tSessionID.equals(SessionID)) {
						SessionID = Util.getSerialNo();
						isfirst = "1";
					} else {
						isfirst = "0";
					}
					Util.saveSessionID(context, SessionID);
					String uid = String.valueOf(UserInfo.getUserId());
					String psid = ServerID;
					String role = GameRoleName;
					String level = GameLevel;
					NetConnectService.doOnlinePNum(context, uid, psid, role, level, isfirst, SessionID);
					Log.i("yangl","mOnlineHandler:" + (System.currentTimeMillis() / 1000)+" SessionID:"+SessionID);
					Log.i("yangl","mOnlineHandler:" + (System.currentTimeMillis() / 1000)+" tSessionID:"+tSessionID);
					Log.i("yangl","mOnlineHandler:" + (System.currentTimeMillis() / 1000)+" bFirst:"+isfirst);
					 Log.i("yangl","mOnlineHandler:" + (System.currentTimeMillis() / 1000)+" ServerID:"+ServerID);
				    Log.i("yangl","mOnlineHandler:" + (System.currentTimeMillis() / 1000)+" GameRoleName:"+GameRoleName);   
					Log.i("yangl","mOnlineHandler:" + (System.currentTimeMillis() / 1000)+" GameLevel:"+GameLevel);                                                              
				    
				    mOnlineHandler.sendEmptyMessageDelayed(0, DELAY_TIME);
				}
			};
			mOnlineHandler.sendEmptyMessage(0);
		} else {
			mOnlineHandler.removeMessages(0);
			mOnlineHandler.sendEmptyMessage(0);
		}
	}

	public static void doGameInfo(final Context context) {
		if (!Util.getGameEName(context).equals("gc")) {
			Util.ShowTips(context, "已初始化");
			return;
		}
		Handler handler = new Handler() {
			@Override
			public void handleMessage(Message msg) {
				if (msg.what == NetConfig.TAG_CALLBACK_SUCCESS) {
					GameInfo gameInfo = (GameInfo) msg.obj;
					Util.saveGameEName(context, gameInfo.getGame_ename());
					Util.ShowTips(context, "初始化成功");
				} else {
					Util.ShowTips(context, "初始化失败");
				}
			}
		};
		NetConnectService.doGameInfo(context, handler);
	}
}