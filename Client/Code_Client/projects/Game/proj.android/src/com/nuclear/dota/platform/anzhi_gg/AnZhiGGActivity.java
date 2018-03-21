package com.nuclear.dota.platform.anzhi_gg;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class AnZhiGGActivity extends GameActivity {
	
	public AnZhiGGActivity() {
		
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_AnZhiGG);
	
	}
}
