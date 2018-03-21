package com.nuclear.dota.platform.kugou;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class KuGouActivity extends GameActivity {
	public KuGouActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_KuGou);
	}
}
