package com.studioirregular.libinappbilling;

import android.app.PendingIntent;
import android.os.Bundle;

public class HandleGetBuyIntentResult {

	private Bundle input;
	
	public HandleGetBuyIntentResult(Bundle input) {
		
		this.input = input;
	}
	
	public boolean isApiCallSuccess() {
		
		ServerResponseCode response = getResponseCode();
		return (response.value == ServerResponseCode.BILLING_RESPONSE_RESULT_OK);
	}
	
	public ServerResponseCode getResponseCode() {
		
		return new ServerResponseCode(input);
	}
	
	public PendingIntent getPurchaseIntent() {
		
		return input.getParcelable("BUY_INTENT");
	}
}
