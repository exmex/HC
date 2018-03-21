package com.studioirregular.libinappbilling;

import java.util.ArrayList;

import android.os.Bundle;
import android.os.RemoteException;

import com.android.vending.billing.IInAppBillingService;

/*
 * Important: blocking code, you may NOT want to call this in UI thread.
 */
public class API_getSkuDetails extends API_base<Bundle> {
	
	@Override
	protected boolean DEBUG_LOG() {
		return Global.DEBUG_LOG;
	}
	
	@Override
	protected String DEBUG_NAME() {
		return "API_getSkuDetails";
	}
	
	private Product.Type productType;
	
	public void setProductType(Product.Type value) {
		this.productType = value;
	}
	
	private ArrayList<String> productIdList = new ArrayList<String>();
	
	public void addQueryProductId(String value) {
		productIdList.add(value);
	}
	
	@Override
	protected void onCheckArguments() throws IllegalArgumentException {
		
		if (productType == null) {
			throw new IllegalArgumentException("Invalid argument productType:"
					+ productType);
		}
		
		if (productIdList == null || productIdList.isEmpty()) {
			// I decide to allow empty productIdList.
		}
	}

	@Override
	protected Bundle callAPI(IInAppBillingService service)
			throws RemoteException {
		
		return service.getSkuDetails(apiVersion, packageName,
				productType.value, buildProductIdList(productIdList));
	}
	
	private Bundle buildProductIdList(ArrayList<String> idList) {
		
		Bundle bundle = new Bundle();
		if (idList != null) {
			bundle.putStringArrayList("ITEM_ID_LIST", idList);
		}
		
		return bundle;
	}
}
