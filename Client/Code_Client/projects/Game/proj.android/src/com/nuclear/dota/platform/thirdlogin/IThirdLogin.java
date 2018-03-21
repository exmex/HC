package com.nuclear.dota.platform.thirdlogin;


import com.nuclear.dota.platform.thirdlogin.LoginDialog.LoginCallback;

import android.app.Activity;
import android.content.Context;

public interface IThirdLogin {
	public void onCreate();
	
	public void GetServerUser();
	
	public IThirdLogin GetInstance();
	public void authorize(LoginCallback pCallBack);
	public void setContext(Context pContext);
	public void setActivity(Activity pAcitivity);
	public ThirdUserInfo GetUserInfo();
}
