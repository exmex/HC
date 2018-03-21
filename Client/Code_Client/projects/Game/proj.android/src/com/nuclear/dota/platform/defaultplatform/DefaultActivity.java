package com.nuclear.dota.platform.defaultplatform;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class DefaultActivity extends GameActivity {

	
	/*
	 * 
	 * */
	public DefaultActivity()
	{
		/*
		 * */
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Default);

	}
	
}
