

package com.nuclear.dota;

import android.util.Log;

import com.nuclear.IGameActivity;
import com.nuclear.IGameActivityState;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.IStateManager;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;




public class GameUpdateState implements IGameActivityState
{
	public static final String	TAG	= GameUpdateState.class.getSimpleName();

	@Override
	public void enter()
	{
		Log.d(TAG, "enter GameUpdateState");
		
		int supportType = mPlatform.isSupportInSDKGameUpdate();
		if (supportType == PlatformAndGameInfo.DoNotSupportUpdate)
		{
			VersionInfo versionInfo = new VersionInfo();
			versionInfo.update_info = PlatformAndGameInfo.enUpdateInfo_No;
			versionInfo.download_url = "";
			mCallback.notifyVersionCheckResult(versionInfo);
		}
		else
		{
			mPlatform.setGameUpdateStateCallback(new GameUpdateStateCallback());
			
			mPlatform.callCheckVersionUpate();
		}
		/*
		 * 不等版本�?��结果了，直接下一步，到GameAppState�?��结果或�?继续等待结果，再通知是否可发起内更新
		 * */
		mStateMgr.changeState(GameInterface.GameContextStateID);
	}

	@Override
	public void exit()
	{
		
		mStateMgr = null;
		mGameActivity = null;
		//mCallback = null;
		
		//mPlatform.setGameUpdateStateCallback(null);
		mPlatform = null;
		
		Log.d(TAG, "exit GameUpdateState");
	}
	
	/*
	 * 
	 * */
	public GameUpdateState(IStateManager pStateMgr, IGameActivity pGameActivity, IGameUpdateStateCallback pCallback)
	{
		mStateMgr = pStateMgr;
		mGameActivity = pGameActivity;
		mCallback = pCallback;
		
		mPlatform = mGameActivity.getPlatformSDK();
	}
	/*
	 * 
	 * */
	private IStateManager mStateMgr;
	/*
	 * 
	 * */
	private IGameActivity mGameActivity;
	/*
	 * 
	 * */
	private IGameUpdateStateCallback mCallback;
	/*
	 * */
	private IPlatformLoginAndPay mPlatform;
	/*
	 * */
	private class GameUpdateStateCallback implements IGameUpdateStateCallback
	{

		@Override
		public void notifyVersionCheckResult(VersionInfo versionInfo)
		{
			mCallback.notifyVersionCheckResult(versionInfo);
			
			if (versionInfo.update_info == PlatformAndGameInfo.enUpdateInfo_No)
			{
				
			}
			else if (versionInfo.update_info == PlatformAndGameInfo.enUpdateInfo_Suggest)
			{
				
			}
			else if (versionInfo.update_info == PlatformAndGameInfo.enUpdateInfo_Force)
			{
				System.exit(0);
			}
		}
		
	}
}


