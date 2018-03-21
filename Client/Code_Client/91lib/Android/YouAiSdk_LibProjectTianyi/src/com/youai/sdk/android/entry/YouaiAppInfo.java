package com.youai.sdk.android.entry;

import android.app.Activity;


public class YouaiAppInfo {

  private  Activity ctx;
  public static int appId;
  public static String appKey;
  public static  String appSecret;
  


public Activity getCtx()
  {
    return this.ctx;
  }

  public void setCtx(Activity ctx)
  {
    this.ctx = ctx;
  }

  public int getAppId()
  {
    return this.appId;
  }

  public void setAppId(int appId)
  {
    this.appId = appId;
  }

  public String getAppKey()
  {
    return this.appKey;
  }

  public void setAppKey(String appKey)
  {
    this.appKey = appKey;
  }
  public String getAppSecret() {
	return appSecret;
}

  public void setAppSecret(String appSecret) {
	this.appSecret = appSecret;
}
}