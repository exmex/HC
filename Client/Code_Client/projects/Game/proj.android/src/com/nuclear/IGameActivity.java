

package com.nuclear;

import com.nuclear.PlatformAndGameInfo.GameInfo;

import android.app.Activity;
import android.os.Handler;



public interface IGameActivity
{
	/*
	 * return the main activity of our android game app
	 * */
	public Activity getActivity();
	/*
	 * 
	 * */
	public Handler getMainHandler();
	/*
	 * 
	 * */
	public IPlatformLoginAndPay getPlatformSDK();
	/*
	 * 
	 * */
	public GameInfo getGameInfo();
	/*
	 * */
	public void requestDestroy();
	/*
	 * */
	public String getAppFilesRootPath();
	/*
	 * */
	public String getAppFilesResourcesPath();
	/*
	 * */
	public String getAppFilesCachePath();
	/*
	 * 
	 * */
	public void showToastMsg(String msg);
}

