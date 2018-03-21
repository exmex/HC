package com.nuclear.dota.platform.ld;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class LvDouGameActivity extends GameActivity {
	public LvDouGameActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_LvDouGame);
	}
	
	
}
