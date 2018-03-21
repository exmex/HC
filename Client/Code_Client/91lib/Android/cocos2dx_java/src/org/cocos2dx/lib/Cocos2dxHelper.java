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

import java.io.UnsupportedEncodingException;
import java.util.Locale;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.pm.ApplicationInfo;
import android.content.res.AssetManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Build;
import android.os.Environment;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;

public class Cocos2dxHelper
{
	
	// ===========================================================
	// Constants
	// ===========================================================
	private static final String				PREFS_NAME	= "Cocos2dxPrefsFile";
	private static final String				TAG			= Cocos2dxHelper.class
																.getSimpleName();
	
	// ===========================================================
	// Fields
	// ===========================================================
	
	private static Cocos2dxMusic			sCocos2dMusic;
	private static Cocos2dxSound			sCocos2dSound;
	private static AssetManager				sAssetManager;
	private static Cocos2dxAccelerometer	sCocos2dxAccelerometer;
	private static boolean					sAccelerometerEnabled;
	private static String					sPackageName;
	private static String					sFileDirectory;
	private static Context					sContext	= null;
	private static Cocos2dxHelperListener	sCocos2dxHelperListener;
	
	// ===========================================================
	// Constructors
	// ===========================================================
	
	public static void init(final Context pContext,
			final Cocos2dxHelperListener pCocos2dxHelperListener,
			final String pAppExternalStoragePath)
	{
		
		Log.d(TAG, "4		call Cocos2dxHelper.init");
		
		final ApplicationInfo applicationInfo = pContext.getApplicationInfo();
		
		Cocos2dxHelper.sContext = pContext;
		Cocos2dxHelper.sCocos2dxHelperListener = pCocos2dxHelperListener;
		
		Cocos2dxHelper.sPackageName = applicationInfo.packageName;
		// Cocos2dxHelper.sFileDirectory =
		// pContext.getFilesDir().getAbsolutePath();
		Cocos2dxHelper.sFileDirectory = pAppExternalStoragePath;
		Cocos2dxHelper.nativeSetApkPath(applicationInfo.sourceDir,
				pAppExternalStoragePath);
		
		Cocos2dxHelper.sCocos2dxAccelerometer = new Cocos2dxAccelerometer(
				pContext);
		Cocos2dxHelper.sCocos2dMusic = new Cocos2dxMusic(pContext);
		Cocos2dxHelper.sCocos2dSound = new Cocos2dxSound(pContext);
		Cocos2dxHelper.sAssetManager = pContext.getAssets();
		Cocos2dxBitmap.setContext(pContext);
		//
		
		Log.d(TAG, "applicationInfo.packageName: "
				+ applicationInfo.packageName);
		Log.d(TAG, "pContext.getFilesDir().getAbsolutePath(): "
				+ pContext.getFilesDir().getAbsolutePath());
		Log.d(TAG, "applicationInfo.sourceDir(the apk path): "
				+ applicationInfo.sourceDir);
		//
		Log.d(TAG, "pContext.getCacheDir().getAbsolutePath(): "
				+ pContext.getCacheDir().getAbsolutePath());
		if (pContext.getExternalCacheDir() != null)
			Log.d(TAG, "pContext.getExternalCacheDir().getAbsolutePath(): "
					+ pContext.getExternalCacheDir().getAbsolutePath());
		Log.d(TAG, "Environment.getRootDirectory().getAbsolutePath(): "
				+ Environment.getRootDirectory().getAbsolutePath());
		Log.d(TAG, "Environment.getDataDirectory().getAbsolutePath(): "
				+ Environment.getDataDirectory().getAbsolutePath());
		Log.d(TAG,
				"Environment.getExternalStorageDirectory().getAbsolutePath(): "
						+ Environment.getExternalStorageDirectory()
								.getAbsolutePath());
		//
		Log.d(TAG,
				"ExternalStorageState: "
						+ Environment.getExternalStorageState());
		if (Environment.getExternalStorageState().equalsIgnoreCase(
				Environment.MEDIA_MOUNTED))
		{
			Log.d(TAG, "ExternalStorage: "
					+ Environment.getExternalStorageDirectory()
							.getAbsolutePath()
					+ " is read/write access available");
			Log.d(TAG,
					"AndroidManageAppExternalStorage: "
							+ pContext.getExternalFilesDir(null));
			Log.d(TAG,
					"AndroidManageAppExternalStorage: "
							+ Environment
									.getExternalStoragePublicDirectory(Environment.DIRECTORY_PICTURES));
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
	
	private static native void nativeSetApkPath(final String pApkPath,
			final String pAppExternalStoragePath);
	
	private static native void nativeSetEditTextDialogResult(final byte[] pBytes);
	
	public static native void nativeDialogOkCallback(int tag);
	
	public static native void nativeNotifyPlatformGameUpdateResult(int result,
			int max_version, int local_version, String down_url);
	
	public static native void nativeNotifyPlatformLoginResult(int result,
			String uin, String seesionid, String nickname);
	
	public static native void nativeNotifyPlatformPayResult(int result,
			String serial, String productId, String productName, float price,
			float orignalPrice, int count, String description);
	
	public static native String nativeGameSnapshot();
	
	//public static native void nativeGameDestroy();
	
	public static native void nativePurgeCachedData();
	
	public static native int nativeGetServerId();

	public static native boolean nativeHasEnterMainFrame();	

	public static String getCocos2dxPackageName()
	{
		return Cocos2dxHelper.sPackageName;
	}
	
	public static String getCocos2dxWritablePath()
	{
		return Cocos2dxHelper.sFileDirectory;
	}
	
	public static String getCurrentLanguage()
	{
		return Locale.getDefault().getLanguage();
	}
	
	public static String getDeviceModel()
	{
		return Build.MODEL;
	}
	
	public static AssetManager getAssetManager()
	{
		return Cocos2dxHelper.sAssetManager;
	}
	
	public static void enableAccelerometer()
	{
		Cocos2dxHelper.sAccelerometerEnabled = true;
		Cocos2dxHelper.sCocos2dxAccelerometer.enable();
	}
	
	public static void setAccelerometerInterval(float interval)
	{
		Cocos2dxHelper.sCocos2dxAccelerometer.setInterval(interval);
	}
	
	public static void disableAccelerometer()
	{
		Cocos2dxHelper.sAccelerometerEnabled = false;
		Cocos2dxHelper.sCocos2dxAccelerometer.disable();
	}
	
	public static void preloadBackgroundMusic(final String pPath)
	{
		Cocos2dxHelper.sCocos2dMusic.preloadBackgroundMusic(pPath);
	}
	
	public static void playBackgroundMusic(final String pPath,
			final boolean isLoop)
	{
		Cocos2dxHelper.sCocos2dMusic.playBackgroundMusic(pPath, isLoop);
	}
	
	public static void resumeBackgroundMusic()
	{
		Cocos2dxHelper.sCocos2dMusic.resumeBackgroundMusic();
	}
	
	public static void pauseBackgroundMusic()
	{
		Cocos2dxHelper.sCocos2dMusic.pauseBackgroundMusic();
	}
	
	public static void stopBackgroundMusic()
	{
		Cocos2dxHelper.sCocos2dMusic.stopBackgroundMusic();
	}
	
	public static void rewindBackgroundMusic()
	{
		Cocos2dxHelper.sCocos2dMusic.rewindBackgroundMusic();
	}
	
	public static boolean isBackgroundMusicPlaying()
	{
		return Cocos2dxHelper.sCocos2dMusic.isBackgroundMusicPlaying();
	}
	
	public static float getBackgroundMusicVolume()
	{
		return Cocos2dxHelper.sCocos2dMusic.getBackgroundVolume();
	}
	
	public static void setBackgroundMusicVolume(final float volume)
	{
		Cocos2dxHelper.sCocos2dMusic.setBackgroundVolume(volume);
	}
	
	public static void preloadEffect(final String path)
	{
		Cocos2dxHelper.sCocos2dSound.preloadEffect(path);
	}
	
	public static int playEffect(final String path, final boolean isLoop)
	{
		return Cocos2dxHelper.sCocos2dSound.playEffect(path, isLoop);
	}
	
	public static void resumeEffect(final int soundId)
	{
		Cocos2dxHelper.sCocos2dSound.resumeEffect(soundId);
	}
	
	public static void pauseEffect(final int soundId)
	{
		Cocos2dxHelper.sCocos2dSound.pauseEffect(soundId);
	}
	
	public static void stopEffect(final int soundId)
	{
		Cocos2dxHelper.sCocos2dSound.stopEffect(soundId);
	}
	
	public static float getEffectsVolume()
	{
		return Cocos2dxHelper.sCocos2dSound.getEffectsVolume();
	}
	
	public static void setEffectsVolume(final float volume)
	{
		Cocos2dxHelper.sCocos2dSound.setEffectsVolume(volume);
	}
	
	public static void unloadEffect(final String path)
	{
		Cocos2dxHelper.sCocos2dSound.unloadEffect(path);
	}
	
	public static void pauseAllEffects()
	{
		Cocos2dxHelper.sCocos2dSound.pauseAllEffects();
	}
	
	public static void resumeAllEffects()
	{
		Cocos2dxHelper.sCocos2dSound.resumeAllEffects();
	}
	
	public static void stopAllEffects()
	{
		Cocos2dxHelper.sCocos2dSound.stopAllEffects();
	}
	
	public static void end()
	{
		Cocos2dxHelper.sCocos2dMusic.end();
		Cocos2dxHelper.sCocos2dSound.end();
	}
	
	public static void onResume()
	{
		if (Cocos2dxHelper.sAccelerometerEnabled)
		{
			Cocos2dxHelper.sCocos2dxAccelerometer.enable();
		}
	}
	
	public static void onPause()
	{
		if (Cocos2dxHelper.sAccelerometerEnabled)
		{
			Cocos2dxHelper.sCocos2dxAccelerometer.disable();
		}
	}
	
	public static void terminateProcess()
	{
		android.os.Process.killProcess(android.os.Process.myPid());
	}
	
	public static void showDialog(final String pTitle, final String pMessage,
			final int msgId, final String positiveCallback)
	{
		Cocos2dxHelper.sCocos2dxHelperListener.showDialog(pTitle, pMessage,
				msgId, positiveCallback);
	}
	
	public static void showQuestionDialog(final String pTitle,
			final String pMessage, final int msgId,
			final String positiveCallback, final String negativeCallback)
	{
		Cocos2dxHelper.sCocos2dxHelperListener.showQuestionDialog(pTitle,
				pMessage, msgId, positiveCallback, negativeCallback);
	}
	
	public static void showEditTextDialog(final String pTitle,
			final String pMessage, final int pInputMode, final int pInputFlag,
			final int pReturnType, final int pMaxLength)
	{
		Cocos2dxHelper.sCocos2dxHelperListener.showEditTextDialog(pTitle,
				pMessage, pInputMode, pInputFlag, pReturnType, pMaxLength);
	}
	
	public static void setEditTextDialogResult(final String pResult)
	{
		try
		{
			final byte[] bytesUTF8 = pResult.getBytes("UTF8");
			
			Cocos2dxHelper.sCocos2dxHelperListener.runOnGLThread(new Runnable()
			{
				
				@Override
				public void run()
				{
					Cocos2dxHelper.nativeSetEditTextDialogResult(bytesUTF8);
				}
			});
		}
		catch (UnsupportedEncodingException pUnsupportedEncodingException)
		{
			/* Nothing. */
		}
	}
	
	public static int getDPI()
	{
		if (sContext != null)
		{
			DisplayMetrics metrics = new DisplayMetrics();
			WindowManager wm = ((Activity) sContext).getWindowManager();
			if (wm != null)
			{
				Display d = wm.getDefaultDisplay();
				if (d != null)
				{
					d.getMetrics(metrics);
					return (int) (metrics.density * 160.0f);
				}
			}
		}
		return -1;
	}
	
	// ===========================================================
	// Functions for CCUserDefault
	// ===========================================================
	
	public static boolean getBoolForKey(String key, boolean defaultValue)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		return settings.getBoolean(key, defaultValue);
	}
	
	public static int getIntegerForKey(String key, int defaultValue)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		return settings.getInt(key, defaultValue);
	}
	
	public static float getFloatForKey(String key, float defaultValue)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		return settings.getFloat(key, defaultValue);
	}
	
	public static double getDoubleForKey(String key, double defaultValue)
	{
		// SharedPreferences doesn't support saving double value
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		return settings.getFloat(key, (float) defaultValue);
	}
	
	public static String getStringForKey(String key, String defaultValue)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		return settings.getString(key, defaultValue);
	}
	
	public static void setBoolForKey(String key, boolean value)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		SharedPreferences.Editor editor = settings.edit();
		editor.putBoolean(key, value);
		editor.commit();
	}
	
	public static void setIntegerForKey(String key, int value)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		SharedPreferences.Editor editor = settings.edit();
		editor.putInt(key, value);
		editor.commit();
	}
	
	public static void setFloatForKey(String key, float value)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		SharedPreferences.Editor editor = settings.edit();
		editor.putFloat(key, value);
		editor.commit();
	}
	
	public static void setDoubleForKey(String key, double value)
	{
		// SharedPreferences doesn't support recording double value
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		SharedPreferences.Editor editor = settings.edit();
		editor.putFloat(key, (float) value);
		editor.commit();
	}
	
	public static void setStringForKey(String key, String value)
	{
		SharedPreferences settings = ((Activity) sContext)
				.getSharedPreferences(Cocos2dxHelper.PREFS_NAME, 0);
		SharedPreferences.Editor editor = settings.edit();
		editor.putString(key, value);
		editor.commit();
	}
	
	public static void callPlatformLogin()
	{
		Cocos2dxHelper.sCocos2dxHelperListener.callPlatformLogin();
	}
	
	public static void callPlatformLogout()
	{
		Cocos2dxHelper.sCocos2dxHelperListener.callPlatformLogout();
	}
	
	public static void callPlatformAccountManage()
	{
		Cocos2dxHelper.sCocos2dxHelperListener.callPlatformAccountManage();
	}
	
	public static void callPlatformPayRecharge(String serial, String productId,
			String productName, float price, float orignalPrice, int count,
			String description)
	{
		Cocos2dxHelper.sCocos2dxHelperListener
				.callPlatformPayRecharge(serial, productId, productName, price,
						orignalPrice, count, description);
	}
	
	public static boolean getPlatformLoginStatus()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getPlatformLoginStatus();
	}
	
	public static String getPlatformLoginUin()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getPlatformLoginUin();
	}
	
	public static String getPlatformLoginSessionId()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener
				.getPlatformLoginSessionId();
	}
	
	public static String getPlatformUserNickName()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getPlatformUserNickName();
	}
	
	public static String generateNewOrderSerial()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.generateNewOrderSerial();
	}
	
	public static void callPlatformFeedback()
	{
		Cocos2dxHelper.sCocos2dxHelperListener.callPlatformFeedback();
	}
	
	public static void callPlatformSupportThirdShare(String content,
			String imgPath)
	{
		Cocos2dxHelper.sCocos2dxHelperListener.callPlatformSupportThirdShare(
				content, imgPath);
	}
	
	public static void callPlatformGameBBS(String url)
	{
		Cocos2dxHelper.sCocos2dxHelperListener.callPlatformGameBBS(url);
	}
	
	public static boolean getIsOnTempShortPause()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getIsOnTempShortPause();
	}
	
	public static String getDeviceID()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getDeviceID();
	}
	
	public static String getPlatformInfo()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getPlatformInfo();
	}
	
	public static String getDeviceInfo()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getDeviceInfo();
	}
	
	public static void notifyEnterGame()
	{
		Cocos2dxHelper.sCocos2dxHelperListener.notifyEnterGame();
	}
	
	public static String getClientChannel()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getClientChannel();
	}
	
	public static int getPlatformId()
	{
		return Cocos2dxHelper.sCocos2dxHelperListener.getPlatformId();
	}
	
	public static void openUrlOutside(String url)
	{
		Cocos2dxHelper.sCocos2dxHelperListener.openUrlOutside(url);
	}
	
	public static void showWaitingView(boolean show, int progress, String text)
	{
		Cocos2dxHelper.sCocos2dxHelperListener.showWaitingView(show, progress,
				text);
	}
	public static  void clearNotification(){
		Cocos2dxHelper.sCocos2dxHelperListener.clearSysNotification();
	}
	
	public static void showNotification(String pTitle,String msg,int pInstantMinite){
		
		Cocos2dxHelper.sCocos2dxHelperListener.pushSysNotification(pTitle,msg,pInstantMinite);
		
	}
	
	public static void showGameAnnounce(String pAnnounceUrl){
		Cocos2dxHelper.sCocos2dxHelperListener.ShowAnnounce(pAnnounceUrl);
	}
	
	public static int getNetworkStatus()
	{
		ConnectivityManager cm = (ConnectivityManager) sContext
				.getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo niWiFi = cm.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
		NetworkInfo niMobile = cm
				.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
		//
		if ((!niWiFi.isAvailable() && !niMobile.isAvailable())
				|| (!niWiFi.isConnected() && !niMobile.isConnected()))
		{
			
			return 0;
		}
		//
		if (niWiFi.isAvailable() && niWiFi.isConnected())
			return 1;
		if (niMobile.isAvailable() && niMobile.isConnected())
			return 2;
		//
		return 0;
	}
	
	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================
	
	public static interface Cocos2dxHelperListener
	{
		
		public void callPlatformLogin();
		
		public void callPlatformLogout();
		
		public void callPlatformAccountManage();
		
		public void callPlatformPayRecharge(String serial, String productId,
				String productName, float price, float orignalPrice, int count,
				String description);
		
		public boolean getPlatformLoginStatus();
		
		public String getPlatformLoginUin();
		
		public String getPlatformLoginSessionId();
		
		public String getPlatformUserNickName();
		
		public String generateNewOrderSerial();
		
		public void callPlatformFeedback();
		
		public void callPlatformSupportThirdShare(String content, String imgPath);
		
		public void callPlatformGameBBS(String url);
		
		public boolean getIsOnTempShortPause();
		
		public String getDeviceID();
		
		public String getPlatformInfo();
		
		public String getDeviceInfo();
		
		public void notifyEnterGame();
		
		public String getClientChannel();
		
		public int getPlatformId();
		
		public void openUrlOutside(String url);
		
		public void showWaitingView(boolean show, int progress, String text);
		
		public void showDialog(final String pTitle, final String pMessage,
				final int msgId, final String positiveCallback);
		
		public void showQuestionDialog(final String pTitle,
				final String pMessage, final int msgId,
				final String positiveCallback, final String negativeCallback);
		
		public void showEditTextDialog(final String pTitle,
				final String pMessage, final int pInputMode,
				final int pInputFlag, final int pReturnType,
				final int pMaxLength);
		
		public void runOnGLThread(final Runnable pRunnable);
		
		public void pushSysNotification(String pTitle,String msg,int pInstantMinite);
		
		public void ShowAnnounce(String pAnnounceUrl);
		public void clearSysNotification();
	}
}
