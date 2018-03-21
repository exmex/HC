package com.nuclear.dota;

import android.os.Handler;
import android.view.View;

import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;

public interface GameInterface {
	public static int GameStateIDMin = 0;
	public static int GameLogoMovieState = 1;
	public static int GameLogoStateID = 2;
	public static int LeagueUpdateStateID = 3;
	public static int PlatformSDKStateID = 4;
	public static int GameUpdateStateID = 5;
	public static int GameContextStateID = 6;
	public static int GameAppStateID = 7;
	public static int GameStateIDMax = 8;

	/*
	 * 
	 * */
	public static interface IGameLogoStateCallback {
		/*
		 * */
		public void initAppDataPath(String fullPath);
	}

	/*
	 * 
	 * */
	public static interface ILeagueUpdateStateCallback {

	}
	/*
	 * 
	 * */
	public static interface IPlatformSDKStateCallback {
		/*
		 * */
		public void initPlatformSDK(IPlatformLoginAndPay platform);

		/*
		 * */
		public void notifyInitPlatformSDKComplete();
	}

	/*
	 * 
	 * */
	public static interface IGameUpdateStateCallback {
		/*
		 * */
		public void notifyVersionCheckResult(VersionInfo versionInfo);
	}

	/*
	 * 
	 * */
	public static interface IGameContextStateCallback {
		/*
		 * */
		public void initCocos2dxAndroidContext(View glView, View editText,
				Handler handler);
	}

	/*
	 * 
	 * */
	public static interface IGameAppStateCallback {
		/*
		 * 
		 * */
		public void notifyEnterGameAppState(Handler handler);

		/*
		 * 
		 * */
		public void notifyOnTempShortPause();

		/*
		 * 
		 * */
		public void notifyLoginResut(LoginInfo result);

		/*
		 * 
		 * */
		public void notifyPayRechargeResult(PayInfo result);

		/*
		 * 
		 * */
		public void showWaitingViewImp(boolean show, int progress, String text);

		/*
		 * 
		 * */
		public void requestBindTryToOkUser(String tryUin, String okUin);

		/*
		 * 游客试玩转正
		 */
		public void notifyTryUserRegistSuccess();
	}

	/*
	 * 
	 * */
	public static interface Idota extends IGameActivity,
			IGameLogoStateCallback, ILeagueUpdateStateCallback,
			IPlatformSDKStateCallback, IGameUpdateStateCallback,
			IGameContextStateCallback, IGameAppStateCallback {

	}
}
