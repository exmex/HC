package com.nuclear.dota.platform.DK;

import org.json.JSONException;
import org.json.JSONObject;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;

import com.duoku.platform.DkPlatform;
import com.duoku.platform.DkPlatformSettings;
import com.duoku.platform.DkPlatformSettings.GameCategory;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.Config;
import com.tencent.mm.sdk.openapi.WXAPIFactory;

public class DuokuActivity extends GameActivity {
	
	private boolean doInitWeChat = false;
	
	public DuokuActivity()
	{
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_BaiduDuoKu);
	}
	
	@Override
	protected void onDestroy() {
		// TODO Auto-generated method stub
		DkPlatform.getInstance().dkReleaseResource(this);
		super.onDestroy();

	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		if(doInitWeChat==false)
		{
			
			String infoStr = GameConfig.nativeReadGamePlatformInfo(PlatformAndGameInfo.enPlatform_BaiduDuoKu);
			try {
				JSONObject dataJsonObj = new JSONObject(infoStr);
				int app_id = dataJsonObj.getInt("appid");
		        String app_key = dataJsonObj.getString("appkey");
		                
		        DkPlatformSettings appInfo = new DkPlatformSettings(); 
		        appInfo.setGameCategory(GameCategory.ONLINE_Game);
		        appInfo.setmAppid(String.valueOf(app_id));
		        appInfo.setmAppkey(app_key); 
		        DkPlatform.getInstance().init(this, appInfo);
		        int orient = DkPlatformSettings.SCREEN_ORIENTATION_PORTRAIT;
		        DkPlatform.getInstance().dkSetScreenOrientation(orient);
		        		
			} catch (JSONException e) {
				e.printStackTrace();
			}
			
			ApplicationInfo appInfo = null;
			try {
				appInfo = this.getPackageManager().getApplicationInfo(this.getPackageName(),PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
			
			}
		
			if(appInfo!=null && appInfo.metaData != null)
			{
			String WX_APP_ID = appInfo.metaData.getString("WX_APP_ID");
			if(WX_APP_ID!=null){
				Config.WX_APP_ID = WX_APP_ID;
				}
			}
			
			doInitWeChat = true;
		}
		
		if(null!=Config.WX_APP_ID && !Config.WX_APP_ID.equals(""))
		{
			api = WXAPIFactory.createWXAPI(this, Config.WX_APP_ID, false);
			api.registerApp(Config.WX_APP_ID);// 将该app注册到微信
		}
		
		
	}
}
