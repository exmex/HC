package org.cocos2dx.lib;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.RandomAccessFile;

import android.content.Context;
import android.content.SharedPreferences.Editor;
import android.os.Environment;
import android.util.Log;
import android.widget.Toast;

public class LoginDataStorage {
    public static int LOGIN_STATE_INIT = 0;
    public static int LOGIN_STATE_URL_EMPTY = 1;
    public static int LOGIN_STATE_HTTP_ERROR = 2;
    public static int LOGIN_STATE_EXCEPTION = 3;
    public static int LOGIN_STATE_NEED_USER_CONFIRM = 4;
    public static int LOGIN_STATE_SUCCESS = 5;
    public static int LOGIN_STATE_ERROR = 6;
    public static int LOGIN_STATE_GOOGLE_PLAY_BIND_SUCCESS = 7;
    public static int LOGIN_STATE_GOOGLE_PLAY_BIND_FAILED = 8;
    
	public static String deviceLoginURL = "";
	public static String gameCenterCheckURL = "";
	public static String gameCenterBindURL = "";

	private static String _devideId = "";
	public static String uuid;
	public static String googlePlayID = "";

	public static String uin;
	public static String sessionKey;
	public static String userId;
	public static String serverId;
	public static String deviceID;
	public static String serverIP;
	public static String serverPort;

	public static String linkedAccountName;
	public static String linkedAccountLevel;

	public static String loginError = "";
	public static int loginState = 0;
	
	// -- google play账号是否已经跟device id关联成功
    public static boolean isAccountLinked = false;
    static final Object[] sDataLock = new Object[0];
	// -- 载入google play账号进度后需要重新进入游戏
	public static boolean needRestartGame = false;

	public static String getSDCardFileName()
	{
		return   "."+Cocos2dxHelper.getCocos2dxPackageName()+".device_id";
	}

	public static String  getWritableFileName()
	{
		return   ".deviceid";
	}


	public static String getDeviceId() {
		if (_devideId.equals("")) {
			_devideId = Cocos2dxHelper.getSharedPreferences("deviceid")
					.getString("deviceid", "");
			if(_devideId.length()==0)
			{
				_devideId =restoreDeviceId();
			}
			Log.i("deviceid", "read is " + _devideId);
		}
		return _devideId;
	}


	public static void writeStringTofile(File inputFile, String contents)
	{
		try {
		   
			RandomAccessFile file =  new RandomAccessFile(inputFile, "rw");
		    file.writeUTF(contents);
		    file.close();
		} catch (Exception e) {
  		 
  			 e.printStackTrace();
		}
	}

	public static String readStringFromFile(File inputFile )
	{
		if(inputFile.isFile() && inputFile.exists())
		{
			String s =  "";
			RandomAccessFile rr;
			try {
				rr = new RandomAccessFile(inputFile, "r");
				s = rr.readUTF();
				rr.close();
			} catch (FileNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			 return s;
		}
		return "";
	}

	public static void backupDeviceId(String _devideIdSet)
	{
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) 
		{      
			 writeStringTofile(new File(Environment.getExternalStorageDirectory(), getSDCardFileName()),
					 _devideIdSet);
		}
		
//		synchronized (LoginDataStorage.sDataLock) {
//			 writeStringTofile(new File(Cocos2dxActivity.getContext().getFilesDir(), getWritableFileName()), _devideIdSet);
//			 
//		}
//		
		Log.d("Login","backupDeviceId : " + _devideIdSet);
	//	Cocos2dxActivity.notifyBackup();
	}

	public static String restoreDeviceId()
	{
		String ret1 ="";
		String ret2 ="";
		if (Environment.getExternalStorageState().equals(Environment.MEDIA_MOUNTED)) 
		{ 
			 ret1 = readStringFromFile(new File(Environment.getExternalStorageDirectory(), getSDCardFileName()));
		}
		
//		 synchronized (LoginDataStorage.sDataLock) {
//			 ret2 = readStringFromFile(new File(Cocos2dxActivity.getContext().getFilesDir(), getWritableFileName()));
//		 }
		 
		Log.d("Login","restoreDeviceId : " + ret1 + " " + ret2);

		return ret1.length()>0?ret1:ret2;
	}

	public static void setDevideId(Context ctx,String _devideIdSet) {
		Editor editor = Cocos2dxHelper.getSharedPreferences("deviceid").edit();
		editor.putString("deviceid", _devideIdSet);
		editor.commit();

		Log.i("deviceid", "set to " + _devideIdSet);
		_devideId = _devideIdSet;
		backupDeviceId(_devideId);
	}
	
	public static void reset() {
		deviceLoginURL = "";
		gameCenterCheckURL = "";
		gameCenterBindURL = "";
		
		_devideId = "";
		uuid = "";
		googlePlayID = "";
		uin = "";
		sessionKey = "";
		userId = "";
		serverId = "";
		deviceID = "";
		serverIP = "";
		serverPort = "";
		linkedAccountName = "";
		linkedAccountLevel = "";
		loginError = "";
		loginState = 0;
		isAccountLinked = false;
		needRestartGame = false;
	}
}
