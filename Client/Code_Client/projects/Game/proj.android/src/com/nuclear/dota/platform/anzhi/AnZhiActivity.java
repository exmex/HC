package com.nuclear.dota.platform.anzhi;

import org.json.JSONObject;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;

import com.anzhi.usercenter.sdk.AnzhiUserCenter;
import com.anzhi.usercenter.sdk.item.CPInfo;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.Config;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class AnZhiActivity extends GameActivity {
	public AnZhiActivity() {
		// TODO Auto-generated constructor stub
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_AnZhi);
	}
	
	private boolean doInitWeChat = false;

	@Override
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		
		String str = GameConfig.nativeReadGamePlatformInfo(PlatformAndGameInfo.enPlatform_AnZhi);
		try {
			JSONObject dataJsonObj = new JSONObject(str);
			final CPInfo info = new CPInfo();
//			final CPAppInfo info = new CPAppInfo();
			
			info.setAppKey(dataJsonObj.getString("appkey")); 
			info.setSecret(dataJsonObj.getString("appsecret")); 
			info.setChannel(PlatformAndGameInfo.enPlatformName_AnZhi); 
			info.setGameName("刀塔传奇2");
			//info.setOpenOfficialLogin(true);    //是否开启官方账号登录功能，默认为关闭 
			PlatformAnZhiLoginAndPay.getInstance().center = AnzhiUserCenter.getInstance();//(this.game_ctx);
			PlatformAnZhiLoginAndPay.getInstance().center.setCPInfo(info);
			PlatformAnZhiLoginAndPay.getInstance().center.setActivityOrientation(1);
			PlatformAnZhiLoginAndPay.getInstance().center.createFloatView(this);
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		
		Intent intent = getIntent();
		if(intent != null && intent.getBooleanExtra("portrait", false)) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		}
		
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
	protected void onDestroy() {
		// TODO Auto-generated method stub
		super.onDestroy();
		
		PlatformAnZhiLoginAndPay.getInstance().center.gameOver(this);
	}
}
