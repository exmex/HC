package com.nuclear.dota.platform.nduo;

import android.content.Intent;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class NduoGameActivity extends GameActivity {
	public NduoGameActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Nduo);
	}

	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		PlatformNduoGameLoginAndPay.getInstance().onActivityResult(requestCode, resultCode, data);
		super.onActivityResult(requestCode, resultCode, data);
	}
}
