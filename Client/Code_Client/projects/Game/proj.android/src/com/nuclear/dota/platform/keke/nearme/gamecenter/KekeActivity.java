package com.nuclear.dota.platform.keke.nearme.gamecenter;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class KekeActivity extends GameActivity{
	public KekeActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Keke);
	}
}
