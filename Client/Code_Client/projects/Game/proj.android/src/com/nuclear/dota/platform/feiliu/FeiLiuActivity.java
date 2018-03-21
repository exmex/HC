package com.nuclear.dota.platform.feiliu;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class FeiLiuActivity extends GameActivity {
	public FeiLiuActivity() {
		// TODO Auto-generated constructor stub
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_FeiLiu);
	}
}
