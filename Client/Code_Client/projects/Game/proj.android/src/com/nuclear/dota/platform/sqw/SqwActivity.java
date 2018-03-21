package com.nuclear.dota.platform.sqw;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class SqwActivity extends GameActivity {
	public SqwActivity()
	{
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Sqw);
	}
}
