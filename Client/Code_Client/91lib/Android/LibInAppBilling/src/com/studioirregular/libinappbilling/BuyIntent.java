package com.studioirregular.libinappbilling;

import android.app.PendingIntent;
import android.os.Bundle;
import android.util.Log;

public class BuyIntent {

	public BuyIntent(Bundle apiResult) {
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG, "BuyIntent: apiResult:" + apiResult);
		}
		
		this.apiResult = apiResult;
	}
	
	public ServerResponseCode getServerResponseCode() {
		
		return new ServerResponseCode(apiResult);
	}
	
	public PendingIntent getIntent() {
		
		return apiResult.getParcelable("BUY_INTENT");
	}
	
	private Bundle apiResult;
}
