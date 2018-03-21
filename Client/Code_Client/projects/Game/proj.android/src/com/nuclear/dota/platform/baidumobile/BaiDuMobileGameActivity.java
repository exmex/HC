package com.nuclear.dota.platform.baidumobile;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class BaiDuMobileGameActivity extends GameActivity {
	public BaiDuMobileGameActivity() {
		super.mGameCfg = new GameConfig(this,
				PlatformAndGameInfo.enPlatform_BaiDuMobileGame);
	}
}
