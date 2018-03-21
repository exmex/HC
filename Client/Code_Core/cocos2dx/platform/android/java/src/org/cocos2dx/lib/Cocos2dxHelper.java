/****************************************************************************
Copyright (c) 2010-2013 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package org.cocos2dx.lib;


import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.UnsupportedEncodingException;
import java.util.Date;
import java.util.Locale;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.DialogInterface.OnClickListener;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.res.AssetFileDescriptor;
import android.content.res.AssetManager;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.Handler;
import android.os.ParcelFileDescriptor;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;

public class Cocos2dxHelper {
	// ===========================================================
	// Constants
	// ===========================================================
	private static final String PREFS_NAME = "Cocos2dxPrefsFile";
	// ===========================================================
	// Fields
	// ===========================================================

	public static Cocos2dxMusic sCocos2dMusic;
	private static Cocos2dxSound sCocos2dSound;
	private static AssetManager sAssetManager;
	private static Cocos2dxAccelerometer sCocos2dxAccelerometer;
	private static boolean sAccelerometerEnabled;
	private static String sPackageName;
	private static String sFileDirectory;
	private static Context sContext = null;
	private static Cocos2dxHelperListener sCocos2dxHelperListener;
	
	private static Handler applicationHandler;
	private static GameHelper mHelper;
	private static Boolean mIsUsingObb=false;
	private static String mObbFileName=null;
	private static File mObbZipFile=null;

	// ===========================================================
	// Constructors
	// ===========================================================
	
	public static String getObbBasePath(Context context)
	{
	       String packageName = context.getApplicationInfo().packageName; 
			String path = Environment.getExternalStorageDirectory().getAbsolutePath() + File.separator
					+ "Android" + File.separator 
					+"obb"+ File.separator  
					+packageName;
			return path;
	}
	public static String getObbPath(Context context)
	{
		int versionCode = 0;
        try {
            PackageInfo pInfo = context.getPackageManager().getPackageInfo(context.getPackageName(), 0);
            versionCode = pInfo.versionCode;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
        }
        
        String packageName = context.getApplicationInfo().packageName; 
		String path = getObbBasePath(context);
		if(versionCode>0)
		{
			String favorite =  path + File.separator  
					+"main."+versionCode+"."+packageName+".obb";
			
			File f = new File(favorite);
			if(f.exists())
			{
				return favorite;
			}
		}
		
		File p = new File(path);
		if(p.exists() && p.isDirectory())
		{
			String maxVersionFile = null;
			int    maxVersion =0;
			
			String []files = p.list();
			for(int i=0;i<files.length;i++)
			{
				//Log.d("OBB FINDING", files[i]);
				if(files[i].matches("^main\\.[0-9]+\\."+packageName +"\\.obb$"))
				{
					Log.d("OBB FINDING", files[i]);
					if(new File(path + File.separator +files[i]).isFile())
					{
						String [] pp = files[i].split("\\.");
						if(pp.length>1)
						{
							int versionNum = Integer.parseInt(pp[1]);
							if(maxVersionFile==null)
							{
								maxVersionFile = files[i];
								maxVersion = versionNum;
							}
							else
							{
								if(versionNum>maxVersion)
								{
									maxVersionFile = files[i];
									maxVersion = versionNum;
								}
							}
						}
					}
				}
			}
			if(maxVersionFile!=null)
			{
				maxVersionFile =  path + File.separator +  maxVersionFile;
				Log.e("OBB FOUND", maxVersionFile);
				return maxVersionFile;
			}
		}
		
		

		return null;
	}
	
	
	public static boolean isUsingObb()
	{
		return mIsUsingObb  && mObbFileName!=null && mObbZipFile!=null;
	}
	
	public static AssetFileDescriptor openObbAssetsFileDescriptor(String path)
	{
		if(!isUsingObb())
		{
			return null;
		}
		if(!path.startsWith("assets/"))
		{
			path = "assets/"+path;
		}
		String res= nativeGetZipfileEntry(path);
		if(res ==null || res.length()==0)
			return null;
		String []values = res.split(",");
		if(values.length!=3)
		{
			return null;
		}
		
		long offset = Long.parseLong(values[0]);
		long compressedSize = Long.parseLong(values[1]);
		long uncompressedSize = Long.parseLong(values[2]);
        if(compressedSize!=uncompressedSize)
        {
        	Log.e("cocos2dhelper","assets file is compressed "+path + "  " + compressedSize + " -> " + uncompressedSize );
    	   return null;
        }
        
		ParcelFileDescriptor pfd;
        try {
            pfd = ParcelFileDescriptor.open(mObbZipFile, ParcelFileDescriptor.MODE_READ_ONLY);
            AssetFileDescriptor ret =  new AssetFileDescriptor(pfd, offset, compressedSize);
         //   Log.d("cocos2dhelper","file is open as assetFile " + path + ret.toString());
            return ret;
        } catch (FileNotFoundException e) {
            // TODO Auto-generated catch block
             e.printStackTrace();
        }
   
        
		
         return null;
		//return mObbZipFile.getAssetFileDescriptor(path);
	}
	
	
//	
//	public static InputStream openObbAssetsInputStream(String assetPath) throws IOException 
//	{
//		if(!isUsingObb())
//		{
//			throw new FileNotFoundException();
//		}
//		return mObbZipFile.getInputStream(assetPath);
//	}
	
	
//	public static void  setUsingObb(Boolean v)
//	{
//		mIsUsingObb =v;
//	}
	
//	public static String getObbFilePathName(String inputFileName)
//	{
//		if(inputFileName.startsWith(File.separator) || !isUsingObb()|| ObbExpansionsManager.getInstance()==null)
//		{
//			return inputFileName;
//		}
//		inputFileName = inputFileName.replace("assets/", "");
//		
//		File f = ObbExpansionsManager.getInstance().getFileFromMain(inputFileName);
//		if(f.exists())
//		{
//			Log.d("getObbFilePathName", "file found:"+f.getAbsolutePath());
//		}
//		else
//		{
//			Log.d("getObbFilePathName", "file not found:"+f.getAbsolutePath());
//		}
//		return f.getAbsolutePath();
//
//	}
	
	public static void checkObbFile(Context pContext)
	{
		String path = getObbPath(pContext);
		if(path!=null)
		{
			mIsUsingObb = true;
			mObbFileName = path;
			mObbZipFile = new File(mObbFileName);
//			try {
//				mObbZipFile = new ZipResourceFile(mObbFileName);
//			} catch (IOException e) {
//				// TODO Auto-generated catch block
//				e.printStackTrace();
//			}
			
		}
	}
	public static void init(final Context pContext, final Cocos2dxHelperListener pCocos2dxHelperListener) {
		final ApplicationInfo applicationInfo = pContext.getApplicationInfo();
		
		Cocos2dxHelper.sContext = pContext;
		Cocos2dxHelper.sCocos2dxHelperListener = pCocos2dxHelperListener;
		applicationHandler =  new Handler(sContext.getMainLooper());
		 
		Cocos2dxHelper.sPackageName = applicationInfo.packageName;
		Cocos2dxHelper.sFileDirectory = pContext.getFilesDir().getAbsolutePath();

 		if(isUsingObb())
			Cocos2dxHelper.nativeSetApkPath(mObbFileName);
		else
			Cocos2dxHelper.nativeSetApkPath(applicationInfo.sourceDir);

		Cocos2dxHelper.sCocos2dxAccelerometer = new Cocos2dxAccelerometer(pContext);
		if(Cocos2dxHelper.sCocos2dMusic == null)
		{
			Cocos2dxHelper.sCocos2dMusic = new Cocos2dxMusic(pContext);
		}
		Cocos2dxHelper.sCocos2dSound = new Cocos2dxSound(pContext);
		Cocos2dxHelper.sAssetManager = pContext.getAssets();
		Cocos2dxBitmap.setContext(pContext);
		

        if (mHelper == null) {
        	Cocos2dxActivity activity = (Cocos2dxActivity)sContext;
            mHelper = new GameHelper(activity, GameHelper.CLIENT_GAMES);
            mHelper.enableDebugLog(true);
            mHelper.setup(activity);
        }
        
	}
	
	

	// ===========================================================
	// Getter & Setter
	// ===========================================================

	// ===========================================================
	// Methods for/from SuperClass/Interfaces
	// ===========================================================

	// ===========================================================
	// Methods
	// ===========================================================

	private static native void nativeSetApkPath(final String pApkPath);

	private static native void nativeSetEditTextDialogResult(final byte[] pBytes);
	
	private static native void nativeNotifyPayResult();
	
	private static native void nativeNofityFacebookConnectResult(int result);

	private static native String nativeGetZipfileEntry(String szFileName);
	private static native int closePopWin();
	
	public static String getCocos2dxPackageName() {
		return Cocos2dxHelper.sPackageName;
	}

	public static String getCocos2dxWritablePath() {
		return Cocos2dxHelper.sFileDirectory;
	}

	public static String getCurrentLanguage() {
		return Locale.getDefault().getLanguage();
	}
	
	public static String getDeviceModel(){
		return Build.MODEL;
    }

	public static AssetManager getAssetManager() {
		return Cocos2dxHelper.sAssetManager;
	}

	public static void enableAccelerometer() {
		Cocos2dxHelper.sAccelerometerEnabled = true;
		Cocos2dxHelper.sCocos2dxAccelerometer.enable();
	}


	public static void setAccelerometerInterval(float interval) {
		Cocos2dxHelper.sCocos2dxAccelerometer.setInterval(interval);
	}

	public static void disableAccelerometer() {
		Cocos2dxHelper.sAccelerometerEnabled = false;
		Cocos2dxHelper.sCocos2dxAccelerometer.disable();
	}

	public static void preloadBackgroundMusic(final String pPath) {
		Cocos2dxHelper.sCocos2dMusic.preloadBackgroundMusic(pPath);
	}

	public static void playBackgroundMusic(final String pPath, final boolean isLoop) {
		Cocos2dxHelper.sCocos2dMusic.playBackgroundMusic(pPath, isLoop);
	}

	public static void resumeBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.resumeBackgroundMusic();
	}

	public static void pauseBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.pauseBackgroundMusic();
	}

	public static void stopBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.stopBackgroundMusic();
	}

	public static void rewindBackgroundMusic() {
		Cocos2dxHelper.sCocos2dMusic.rewindBackgroundMusic();
	}

	public static boolean isBackgroundMusicPlaying() {
		return Cocos2dxHelper.sCocos2dMusic.isBackgroundMusicPlaying();
	}

	public static float getBackgroundMusicVolume() {
		return Cocos2dxHelper.sCocos2dMusic.getBackgroundVolume();
	}

	public static void setBackgroundMusicVolume(final float volume) {
		Cocos2dxHelper.sCocos2dMusic.setBackgroundVolume(volume);
	}

	public static void preloadEffect(final String path) {
		Cocos2dxHelper.sCocos2dSound.preloadEffect(path);
	}

	public static int playEffect(final String path, final boolean isLoop) {
		return Cocos2dxHelper.sCocos2dSound.playEffect(path, isLoop);
	}

	public static void resumeEffect(final int soundId) {
		Cocos2dxHelper.sCocos2dSound.resumeEffect(soundId);
	}

	public static void pauseEffect(final int soundId) {
		Cocos2dxHelper.sCocos2dSound.pauseEffect(soundId);
	}

	public static void stopEffect(final int soundId) {
		Cocos2dxHelper.sCocos2dSound.stopEffect(soundId);
	}

	public static float getEffectsVolume() {
		return Cocos2dxHelper.sCocos2dSound.getEffectsVolume();
	}

	public static void setEffectsVolume(final float volume) {
		Cocos2dxHelper.sCocos2dSound.setEffectsVolume(volume);
	}

	public static void unloadEffect(final String path) {
		Cocos2dxHelper.sCocos2dSound.unloadEffect(path);
	}

	public static void pauseAllEffects() {
		Cocos2dxHelper.sCocos2dSound.pauseAllEffects();
	}

	public static void resumeAllEffects() {
		Cocos2dxHelper.sCocos2dSound.resumeAllEffects();
	}

	public static void stopAllEffects() {
		Cocos2dxHelper.sCocos2dSound.stopAllEffects();
	}

	public static void end() {
		Cocos2dxHelper.sCocos2dMusic.end();
		Cocos2dxHelper.sCocos2dSound.end();
	}

	public static void onResume() {
		if (Cocos2dxHelper.sAccelerometerEnabled) {
			Cocos2dxHelper.sCocos2dxAccelerometer.enable();
		}
	}

	public static void onPause() {
		if (Cocos2dxHelper.sAccelerometerEnabled) {
			Cocos2dxHelper.sCocos2dxAccelerometer.disable();
		}
	}

	public static void terminateProcess() {
		android.os.Process.killProcess(android.os.Process.myPid());
	}
	
	public static void showDialog(final String pTitle, final String pMessage) {
		Cocos2dxHelper.sCocos2dxHelperListener.showDialog(pTitle, pMessage);
	}
	
	public static void showConfirmDialog(final String pTitle, final String pMessage, final String pButtonText, final OnClickListener callback) {
		Cocos2dxHelper.sCocos2dxHelperListener.showConfirmDialog(pTitle, pMessage, pButtonText, callback);
	}

	private static void showEditTextDialog(final String pTitle, final String pMessage, final int pInputMode, final int pInputFlag, final int pReturnType, final int pMaxLength) {
		Cocos2dxHelper.sCocos2dxHelperListener.showEditTextDialog(pTitle, pMessage, pInputMode, pInputFlag, pReturnType, pMaxLength);
	}

	public static void setEditTextDialogResult(final String pResult) {
		try {
			final byte[] bytesUTF8 = pResult.getBytes("UTF8");

			Cocos2dxHelper.sCocos2dxHelperListener.runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxHelper.nativeSetEditTextDialogResult(bytesUTF8);
				}
			});
		} catch (UnsupportedEncodingException pUnsupportedEncodingException) {
			/* Nothing. */
		}
	}
	
	public static void notifyPayResult()
	{
		Cocos2dxHelper.sCocos2dxHelperListener.runOnGLThread(new Runnable() {
			@Override
			public void run() {
				Cocos2dxHelper.nativeNotifyPayResult();
			}
		});
	}


    public static int getDPI()
    {
		if (sContext != null)
		{
			DisplayMetrics metrics = new DisplayMetrics();
			WindowManager wm = ((Activity)sContext).getWindowManager();
			if (wm != null)
			{
				Display d = wm.getDefaultDisplay();
				if (d != null)
				{
					d.getMetrics(metrics);
					return (int)(metrics.density*160.0f);
				}
			}
		}
		return -1;
    }
    
    
    
    // ===========================================================
 	// Functions for CCUserDefault
 	// ===========================================================
    
    public static boolean getBoolForKey(String key, boolean defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getBoolean(key, defaultValue);
    }
    
    public static int getIntegerForKey(String key, int defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getInt(key, defaultValue);
    }
    
    public static float getFloatForKey(String key, float defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getFloat(key, defaultValue);
    }
    
    public static double getDoubleForKey(String key, double defaultValue) {
    	// SharedPreferences doesn't support saving double value
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getFloat(key, (float)defaultValue);
    }
    
    public static String getStringForKey(String key, String defaultValue) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	return settings.getString(key, defaultValue);
    }
    
    public static void setBoolForKey(String key, boolean value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putBoolean(key, value);
    	editor.commit();
    }
    
    public static void setIntegerForKey(String key, int value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putInt(key, value);
    	editor.commit();
    }
    
    public static void setFloatForKey(String key, float value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putFloat(key, value);
    	editor.commit();
    }
    
    public static void setDoubleForKey(String key, double value) {
    	// SharedPreferences doesn't support recording double value
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putFloat(key, (float)value);
    	editor.commit();
    }
    
    public static void setStringForKey(String key, String value) {
    	SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.putString(key, value);
    	editor.commit();
    }
	
    
    /**
     * for json parse 
     * @param jsonStr
     * @return null or jsonobject
     * @author dany 
     */
    
    static public Object  create_json_obj_frome_string(String jsonStr)
    {
    	JSONObject obj = null;
		try {
			obj = new JSONObject(jsonStr);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
       return obj;
    }
    
    
    static public Object json_get_value(Object json_obj, String key)
    {
    	 JSONObject obj  = (JSONObject)json_obj;
		 Object ret = obj.opt(key);
		 return ret;
    }


    static public  Object json_get_array(Object json_obj, String key)
    {
   	    JSONObject obj  = (JSONObject)json_obj;
   		JSONArray arr = obj.optJSONArray(key);
		return arr;
	
    }
    
    static public  void free_json_obj(Object json_obj)
    {
   	 	
    }

    static public  String json_value_to_string(Object jsonvalue)
    {
	   	 if(jsonvalue instanceof String)
	   	 {
	   		 return (String)jsonvalue;
	   	 }
	   	 else
	   	 {
	   		 return ""+jsonvalue.toString();
	   	 }
	        
    }
    
    static public  int json_value_to_integer(Object jsonvalue)
    {
	   	 if(jsonvalue instanceof String )
	   	 {
	   		 return Integer.parseInt((String )jsonvalue);
	   	 }
	   	 else if(jsonvalue instanceof Long )
	   	 {
	   		 return ((Long)jsonvalue).intValue();
	   	 }
	   	 else if( jsonvalue instanceof Integer)
	   	 {
	   		 return ((Integer)jsonvalue).intValue();
	   	 }
	   	 else if(jsonvalue instanceof Short)
	   	 {
	   		return ((Short)jsonvalue).intValue();
	   	 }
	   	 else if(jsonvalue instanceof Byte)
	   	 {
	   		return ((Byte)jsonvalue).intValue();
	   	 }
		 return 0;
      
    }
    
    static public Object json_array_index_of(Object arr, int idx)
    {
    	JSONArray ja=(JSONArray)arr;
    	try {
			return ja.get(idx);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
    	return null;
    }
    
    static public int json_array_count(Object arr)
    {
    	JSONArray ja=(JSONArray)arr;
    	return ja.length();
    }
    
  
    static public void android_restart_application()
    {
    	android.os.Process.killProcess(android.os.Process.myPid());
    	
		Intent intent = sContext.getPackageManager().getLaunchIntentForPackage(sContext.getPackageName());
		intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP | Intent.FLAG_ACTIVITY_SINGLE_TOP | Intent.FLAG_ACTIVITY_NEW_TASK);
		sContext.startActivity(intent);
    }
    
    
    static public void open_url(String url)
    {
    	 final String furl = url;
    	 runOnUIThread(new Runnable() {
			@Override
			public void run() {
				Intent browserIntent = new Intent(Intent.ACTION_VIEW, Uri.parse(furl));
		    	sContext.startActivity(browserIntent);
			}
		});

    	            
    	
    }
    
    static public void sendMailReportIssue(String xissueType, String xclientVersion, String xplayerID)
    {
    	 final String issueType = xissueType;
    	 final String clientVersion = xclientVersion;
    	 final String playerID = xplayerID;
    	
    	 
    	 runOnUIThread(new Runnable() {
			@Override
			public void run() {
				Intent data=new Intent(Intent.ACTION_SENDTO); 
		    	data.setData(Uri.parse("mailto:support@ucool.com")); 
		    	data.putExtra(Intent.EXTRA_SUBJECT, "Heroes Charge "+issueType); 
		    	/*
		        UTC Time:
		        Version:
		        PlayerID:
		        Category: Report probem
		        Language: EN
		        Device Type: ipod5.1
		        OS Version: 7.1.1
		    	 */
		    	String content = "";
		    	if(issueType.equals("Lost Account"))
		    	{
		    		content+="Please Give us the following information about your lost account.";
		    		content+="\nExact name of account:";
		    		content+="\nGame level:";
		    		content+="\nName of guild(if any):\n\n\n\n";

		    	}else{
		    		content+="\n\n\n\n";
		    	}

		    	content+="\n---------DO NOT DELETE---------";
		    	//NSString* strTime = [DataStorage getLocalTime];
		    	content+="\nUTC Time: " + new Date().toGMTString();
		    	content+="\nGame: Heroes Charge";
		    	content+="\nVersion: " + clientVersion;
		    	content+="\nPlayerID: " + playerID;
		    	content+="\nCategory: " + issueType;
		    	content+="\nLanguage: EN";
		    	content+="\nDevice Type: " + Build.MODEL + " - " +  Build.DEVICE + " - " + Build.MANUFACTURER;
		    	content+="\nOS Version: " + Build.DISPLAY + " SDK " + Build.VERSION.SDK_INT ;
		    	content+="\n-------------------------------";

		    	data.putExtra(Intent.EXTRA_TEXT, content); 
		    	sContext.startActivity(data); 
			}
		});
    	 
    	

    }

	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================

	public static interface Cocos2dxHelperListener {
		public void showDialog(final String pTitle, final String pMessage);
		public void showConfirmDialog(final String pTitle, final String pMessage, final String pButtonText, final OnClickListener callback);
		public void showEditTextDialog(final String pTitle, final String pMessage, final int pInputMode, final int pInputFlag, final int pReturnType, final int pMaxLength);

		public void runOnGLThread(final Runnable pRunnable);
		public void initPayment(String urls);
		public void doPayment(String data);
		
		public void onSignInFailed();

        /** Called when sign-in succeeds. */
		public void onSignInSucceeded();
		
		public void doExtra(Context sContext,String paramString1, String paramString2);
		public void setSoundSwitch(int g_soundSwitch);
		
		public void doFacebookConnect();

	}

	
	public static String getAndroId() {
		String _androidId = "";
		Cocos2dxActivity activity = (Cocos2dxActivity)sContext;
		TelephonyManager tm = (TelephonyManager) activity.getSystemService(Context.TELEPHONY_SERVICE);
		_androidId = tm.getDeviceId();

		if (null == _androidId) {
			_androidId = Secure.getString(activity.getContentResolver(),
					Secure.ANDROID_ID);
		}
		
		return _androidId;
	}
	
	public static void runOnUIThread(final Runnable pRunnable) {
		if(applicationHandler !=null)
			applicationHandler.post(pRunnable);
	}
	
	public static SharedPreferences getSharedPreferences(String spName) {
		Cocos2dxActivity activity = (Cocos2dxActivity)sContext;
		return activity.getSharedPreferences(spName, sContext.MODE_PRIVATE);
	}
	

	
  
	static public void doExtra(String paramString1, String paramString2)  
	{
		final String data1 = paramString1;
		final String data2 = paramString2;
		runOnUIThread(new Runnable() {
			
			@Override
			public void run() {
				sCocos2dxHelperListener.doExtra(sContext,data1,data2);
			}
		});
    }
	
	static public void setSoundSwitch(int g_soundSwitch)
	{
		final int data1 = g_soundSwitch;
		runOnUIThread(new Runnable() {
			
			@Override
			public void run() {
				Log.e("setSoundSwitch", "setSoundSwitch");
				
				sCocos2dxHelperListener.setSoundSwitch(data1);
			}
		});
	}
	
	public static void initPayment(String urls)
	{
		final String data = urls;
		runOnUIThread(new Runnable() {
			
			@Override
			public void run() {
				sCocos2dxHelperListener.initPayment(data);
			}
		});
	}
	
	public static void doPayment(String orderData)
	{
		final String _orderData = orderData;
		runOnUIThread(new Runnable() {
			
			@Override
			public void run() {
				sCocos2dxHelperListener.doPayment(_orderData);
			}
		});
		
	}
	
	public static void onFacebookConnectComplete(boolean isOk, String accessToken,  long expiredIn)
	{
		if(isOk )
		{
			SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
	    	SharedPreferences.Editor editor = settings.edit();
	    	editor.putString("fb_access_token", accessToken);
	    	editor.putLong("fb_expires_in",expiredIn);
	    	editor.commit();
	    	Cocos2dxHelper.sCocos2dxHelperListener.runOnGLThread(new Runnable() {
				@Override
				public void run() {
					Cocos2dxHelper.nativeNofityFacebookConnectResult(1);
				}
			});
	    	
		}
	}
	
	public static void disconnectFacebook()
	{
		SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
    	SharedPreferences.Editor editor = settings.edit();
    	editor.remove("fb_access_token");
    	editor.remove("fb_expires_in");
    	editor.commit();
    	
    	//todo, maybe need to call facebook.logout but it's not unneccessary .
	}
	
	
	public static int isFacebookConnected()
	{
		SharedPreferences settings = ((Activity)sContext).getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		String fb_access_token = settings.getString("fb_access_token", "");
		long fb_expires_in = settings.getLong("fb_expires_in", 0);
		if(fb_access_token.length()>0 && new Date(fb_expires_in).after(new Date()))
		{
			return 1;
		}
		return 0;
	}
	
	
	public static void connectFacebook()
	{
		runOnUIThread(new Runnable() {
			
			@Override
			public void run() {
				sCocos2dxHelperListener.doFacebookConnect();
			}
		});
	}
	
	public static GameHelper gameHelper() {
        return mHelper;
    }
    
    public static Handler handler() {
    	return applicationHandler;
    }
    
    public static Cocos2dxActivity activity() {
    	if (null == sContext) {
    		return null;
    	}
        Cocos2dxActivity activity = (Cocos2dxActivity)sContext;
        return activity;
    }
    
    
    public static int closePopWinJava()
    {
    	Log.e("cocos2dhelper","CCLayerColor closePopWinJava");
    	
    	int iLen=closePopWin();
    	
    	return iLen;
    }

}
