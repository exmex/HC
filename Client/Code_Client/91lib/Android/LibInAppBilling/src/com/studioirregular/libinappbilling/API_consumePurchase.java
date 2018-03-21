package com.studioirregular.libinappbilling;

import android.os.RemoteException;

import com.android.vending.billing.IInAppBillingService;

/*
 * Important: blocking code, you may NOT want to call this in UI thread.
 */
public class API_consumePurchase extends API_base<ServerResponseCode> {

	@Override
	protected boolean DEBUG_LOG() {
		return Global.DEBUG_LOG;
	}
	
	@Override
	protected String DEBUG_NAME() {
		return "API_consumePurchase";
	}
	
	private String purchaseToken;
	
	public void setPurchaseToken(String value) {
		this.purchaseToken = value;
	}
	
	@Override
	protected void onCheckArguments() throws IllegalArgumentException {
		
		if (purchaseToken == null) {
			throw new IllegalArgumentException("Invalid argument purchaseToken:"
					+ purchaseToken);
		}
	}
	
	@Override
	protected ServerResponseCode callAPI(IInAppBillingService service)
			throws RemoteException {
		
		final int code = service.consumePurchase(apiVersion, packageName,
				purchaseToken);
		
		return new ServerResponseCode(code);
	}

}
