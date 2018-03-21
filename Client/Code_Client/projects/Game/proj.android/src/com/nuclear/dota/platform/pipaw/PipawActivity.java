package com.nuclear.dota.platform.pipaw;

import android.content.Intent;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class PipawActivity extends GameActivity {
	public PipawActivity() {
		super.mGameCfg = new GameConfig(this,
				PlatformAndGameInfo.enPlatform_Pipaw);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		PlatformPipawLoginAndPay.getInstance().onActivityResult(requestCode,
				resultCode, data);
		super.onActivityResult(requestCode, resultCode, data);
	}
}
