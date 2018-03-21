package com.nuclear.dota.platform.thirdlogin;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;


public class ThirdLoginActivity extends GameActivity {
	
	/*
	 * 
	 * */
	public ThirdLoginActivity()
	{
		/*
		 * */
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_ThirdLogin);

	}
	
}
