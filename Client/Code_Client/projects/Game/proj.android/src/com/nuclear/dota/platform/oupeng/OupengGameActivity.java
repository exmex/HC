package com.nuclear.dota.platform.oupeng;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class OupengGameActivity extends GameActivity {
	public OupengGameActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Oupeng);
	}
}
