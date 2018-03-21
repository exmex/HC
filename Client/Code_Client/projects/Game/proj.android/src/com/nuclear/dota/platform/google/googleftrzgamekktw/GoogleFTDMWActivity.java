package com.nuclear.dota.platform.google.googleftrzgamekktw;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.qsds.ggg.dfgdfg.fvfvf.R;

import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.util.Log;
import com.facebook.AppEventsLogger;
import com.facebook.Session;



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
		PlatformGoogleFTDMWLoginAndPay instantce = PlatformGoogleFTDMWLoginAndPay.getInstance();
		instantce.logger = AppEventsLogger.newLogger(this);
		
		 Intent intent = getIntent();
		 Uri data = intent.getData();
		 Log.e("GoogleFTDMWActivity", "intent.getData()==>"+data);
		 String scheme = intent.getScheme();
		 if((null!=scheme)&&scheme.contains("http")){
			 instantce.logger.logEvent("fb_youai_deeplink");
		 }
		 
		 instantce.logger.logEvent("fb_youai_launcher");
		 
		 
		
    }
	
	@Override
	protected void onResume() {
		super.onResume();
		AppEventsLogger.activateApp(this,  getString(R.string.app_id));
		 
	}
	

    @Override
    protected void onSaveInstanceState(Bundle outState) {
        super.onSaveInstanceState(outState);
        Session session = Session.getActiveSession();
        Session.saveSession(session, outState);
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
