package com.nuclear.dota.platform.google.googleftrzgametw;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

import android.content.Intent;
import android.os.Bundle;




public class GoogleFTDMWActivity extends GameActivity {
	
	
	/*
	 * 
	 * */
	public GoogleFTDMWActivity()
	{
		/*
		 * */
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_GoogleFT);
		

	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		
    }
	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		 if(PlatformGoogleFTDMWLoginAndPay.getInstance().onActivityResult(requestCode, resultCode, data))
		 {
			 super.onActivityResult(requestCode, resultCode, data);
			 return;
		 } 
	}
	
}
