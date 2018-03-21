package com.nuclear.dota.platform.baidugame;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class BaiDuGameActivity extends GameActivity {
	public BaiDuGameActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_BaiDuGame);
	}
	
}
