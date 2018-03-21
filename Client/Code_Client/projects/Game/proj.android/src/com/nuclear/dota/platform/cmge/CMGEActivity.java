package com.nuclear.dota.platform.cmge;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class CMGEActivity extends GameActivity{
	public CMGEActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_CMGE);
	}
}
