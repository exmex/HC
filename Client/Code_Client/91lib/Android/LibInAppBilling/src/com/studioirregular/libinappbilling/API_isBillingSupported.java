package com.studioirregular.libinappbilling;

import android.os.RemoteException;

import com.android.vending.billing.IInAppBillingService;

public class API_isBillingSupported extends API_base<ServerResponseCode> {

	@Override
	protected boolean DEBUG_LOG() {
		return Global.DEBUG_LOG;
	}
	
	@Override
	protected String DEBUG_NAME() {
		return "API_isBillingSupported";
	}
	
	public API_isBillingSupported() {
	}
	
	private Product.Type productType;
	
	public API_isBillingSupported setProductType(Product.Type value) {
		this.productType = value;
		return this;
	}
	
	@Override
	protected void onCheckArguments() throws IllegalArgumentException {
		
		if (productType == null) {
			throw new IllegalArgumentException("Invalid argument productType:"
					+ productType);
		}
	}

	@Override
	protected ServerResponseCode callAPI(IInAppBillingService service)
			throws RemoteException {
		
		final int responseValue = service.isBillingSupported(apiVersion,
				packageName, productType.value);
		
		return new ServerResponseCode(responseValue);
	}
}
