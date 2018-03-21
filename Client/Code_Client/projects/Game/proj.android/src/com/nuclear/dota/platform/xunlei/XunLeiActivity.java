package com.nuclear.dota.platform.xunlei;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class XunLeiActivity extends GameActivity {
	public XunLeiActivity()
	{
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_XunLei);
	}
}
