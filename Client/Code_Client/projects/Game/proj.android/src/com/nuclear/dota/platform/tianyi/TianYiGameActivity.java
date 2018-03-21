package com.youai.dota.platform.tianyi;

import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class TianYiGameActivity extends GameActivity {
	public TianYiGameActivity()
	{
		/*
		 * */
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_TianYi);
		

	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		ApplicationInfo appInfo = null;
		try {
			appInfo = TianYiGameActivity.this.
					getPackageManager().
					getApplicationInfo(TianYiGameActivity.this.
							getPackageName(),
							PackageManager.GET_META_DATA);
		} catch (NameNotFoundException e) {
			e.printStackTrace();
		}
		
		int channelId=appInfo.metaData.getInt("youai_channel");
		super.getGameInfo().platform_channel_str=super.getGameInfo().platform_type_str+"_"+String.valueOf(channelId);
		super.onCreate(savedInstanceState);
	}
}
