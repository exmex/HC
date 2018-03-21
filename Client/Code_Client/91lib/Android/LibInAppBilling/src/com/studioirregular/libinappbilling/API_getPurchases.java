package com.studioirregular.libinappbilling;

import com.android.vending.billing.IInAppBillingService;

import android.os.Bundle;
import android.os.RemoteException;

/*
 * For large product numbers (> 700 as official doc said when I wrote this program), 
 * you need to call this API multiple times with continuation token from last call.
 */
public class API_getPurchases extends API_base<Bundle> {

	@Override
	protected boolean DEBUG_LOG() {
		return Global.DEBUG_LOG;
	}
	
	@Override
	protected String DEBUG_NAME() {
		return "API_getPurchases";
	}
	
	private Product.Type productType;
	
	public void setProductType(Product.Type value) {
		this.productType = value;
	}
	
	private String continuationToken;
	
	/* optional */
	public void setContinuationToken(String value) {
		this.continuationToken = value;
	}
	
	@Override
	protected void onCheckArguments() throws IllegalArgumentException {
		
		if (productType == null) {
			throw new IllegalArgumentException("Invalid argument productType:"
					+ productType);
		}
		
		// continuationToken can be null.
	}
	
	@Override
	protected Bundle callAPI(IInAppBillingService service)
			throws RemoteException {
		
		return service.getPurchases(apiVersion, packageName, productType.value,
				continuationToken);
	}

}
