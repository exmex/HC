package com.nuclear.dota.platform.GTV;

import java.io.Serializable;

import android.util.Log;

import com.example.gtvsdk.GTVSDK;
import com.example.gtvsdk.GTVSDKInterface;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;

public class GTVActivity extends GameActivity implements GTVSDKInterface {
	private static final long serialVersionUID = 1L;
	public GTVActivity()
	{
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_GTV);
	}
	@Override
	public void GTVDidLogIn(GTVSDK sdk) {
		// TODO Auto-generated method stub
		PlatformGTVLoginAndPay.getInstance().isLogin = true;
		final IGameAppStateCallback callback = PlatformGTVLoginAndPay.getInstance().mCallback3;
		callback.showWaitingViewImp(false, -1, "");
		LoginInfo login_info = new LoginInfo();
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
		login_info.account_uid_str = GTVSDK.userID;
		login_info.account_nick_name = "更换账号";
		login_info.account_user_name = "更换账号";
		PlatformGTVLoginAndPay.getInstance().isLogin = true;
		PlatformGTVLoginAndPay.getInstance().notifyLoginResult(login_info);
	}


	@Override
	public void GTVDidRegister(GTVSDK sdk) {
		// TODO Auto-generated method stub
		
	}


	@Override
	public void GTVDidRecharge(GTVSDK sdk) {
		// TODO Auto-generated method stub
		PlatformGTVLoginAndPay.getInstance().pay_info.result = 0;
   	 	PlatformGTVLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformGTVLoginAndPay.getInstance().pay_info);
	
	}


	@Override
	public void GTVSDKWebViewDidCancel(GTVSDK sdk) {
		// TODO Auto-generated method stub
		final IGameAppStateCallback callback = PlatformGTVLoginAndPay.getInstance().mCallback3;
		callback.showWaitingViewImp(false, -1, "");
	}


	@Override
	public void GTVSDKrequestDidFailWithError(GTVSDK sdk, String error) {
		// TODO Auto-generated method stub
		Log.e("----->", "出错了" + error);
		final IGameAppStateCallback callback = PlatformGTVLoginAndPay.getInstance().mCallback3;
		callback.showWaitingViewImp(false, -1, "");
	}
}
