package com.nuclear.dota.platform.wandoujia;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;

import com.wandoujia.mariosdk.plugin.api.api.WandouGamesApi;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.Config;

public class WanDouJiaActivity extends GameActivity {
	public WanDouJiaActivity() {
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_WanDouJia);
	}
	
	private WandouGamesApi wandouGamesApi = MarioPluginApplication.getWandouGamesApi();
	private boolean doInitWeChat = false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
	    this.wandouGamesApi.init(this);
		if(doInitWeChat==false)
		{
			ApplicationInfo appInfo = null;
			try {
				appInfo = this.getPackageManager().getApplicationInfo(this.getPackageName(),PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
		
			}
		
			if(appInfo!=null && appInfo.metaData != null)
			{
				String WX_APP_ID = appInfo.metaData.getString("WX_APP_ID");
				if(WX_APP_ID!=null)
				{
				Config.WX_APP_ID = WX_APP_ID;
				}
			}
			
			doInitWeChat = true;
		}
		if(null!=Config.WX_APP_ID && !Config.WX_APP_ID.equals("")){
			api = WXAPIFactory.createWXAPI(this, Config.WX_APP_ID, false);
			api.registerApp(Config.WX_APP_ID);// 将该app注册到微信
		}
		
    }
	
	@Override
	protected void onResume() {
		super.onResume();
		this.wandouGamesApi.onResume(this);
	}

	@Override
	protected void onPause() {
		super.onPause();
	    this.wandouGamesApi.onPause(this);
	}
}
