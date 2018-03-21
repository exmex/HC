package com.studioirregular.libinappbilling;

import com.android.vending.billing.IInAppBillingService;

import android.os.Bundle;
import android.os.RemoteException;

public class API_getBuyIntent extends API_base<Bundle> {

	@Override
	protected boolean DEBUG_LOG() {
		return Global.DEBUG_LOG;
	}
	
	@Override
	protected String DEBUG_NAME() {
		return "API_getBuyIntent";
	}
	
	private String productId;
	
	public void setProductId(String value) {
		this.productId = value;
	}
	
	private Product.Type productType;
	
	public void setProductType(Product.Type value) {
		this.productType = value;
	}
	
	private String developerPayload;
	
	/* optional */
	public void setDeveloperPayload(String value) {
		this.developerPayload = value;
	}
	
	@Override
	protected void onCheckArguments() throws IllegalArgumentException {
		
		if (productId == null) {
			throw new IllegalArgumentException("Invalid argument productId:"
					+ productId);
		}
		
		if (productType == null) {
			throw new IllegalArgumentException("Invalid argument productType:"
					+ productType);
		}
		
		if (developerPayload == null) {
			// Optional argument, OK to be null.
		}
	}

	@Override
	protected Bundle callAPI(IInAppBillingService service)
			throws RemoteException {
		
		return service.getBuyIntent(apiVersion, packageName, productId,
				productType.value, developerPayload);
	}

}
