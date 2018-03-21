package com.nuclear.dota.platform.jifeng;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class JiFengActivity extends GameActivity {
	public JiFengActivity()
	{
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_JiFeng);
	}
}
