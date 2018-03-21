package com.studioirregular.libinappbilling;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;

import android.os.Bundle;
import android.util.Log;

public class HandleGetPurchasesResult {

	private String publicKeyBase64;
	private Bundle bundle;
	
	public HandleGetPurchasesResult(String publicKeyBase64,
			Bundle purchaseResult) throws IllegalArgumentException {

		this.publicKeyBase64 = publicKeyBase64;
		verifyInput(purchaseResult);
		this.bundle = purchaseResult;
	}
	
	public void execute() throws JSONException, SignatureVerificationException {
		
		if (bundle.containsKey(KEY_CONTINUATION_TOKEN)) {
			continuationToken = bundle.getString(KEY_CONTINUATION_TOKEN);
		}
		
		ArrayList<String> productIds = bundle.getStringArrayList(KEY_PRODUCT_ID_LIST);
		ArrayList<String> dataList = bundle.getStringArrayList(KEY_DATA_LIST);
		ArrayList<String> signatures = bundle.getStringArrayList(KEY_SIGNATURE_LIST);
		
		for (int i = 0; i < dataList.size(); i++) {
			final String id = productIds.get(i);
			final String data = dataList.get(i);
			final String signature = signatures.get(i);
			
			if (Global.DEBUG_LOG) {
				Log.e(Global.LOG_TAG,"verifyPurchaseData:"+data);
			}
			if (Global.DEBUG_LOG) {
				Log.e(Global.LOG_TAG,"verifyPurchasesignatures:"+signatures);
			}
			final boolean pass = Security.verifyPurchase(publicKeyBase64, data,
					signature);
			if (!pass) {
				if (Global.DEBUG_LOG) {
					Log.e(Global.LOG_TAG,
							"HandleGetPurchasesResult::execute() Signature verification failed for product id:"
									+ id);
				}
				
				throw new SignatureVerificationException(
						"Signature verification failed for product:" + id);
			}
			
			PurchasedItem item = new PurchasedItem(data,signature);
			purchasedItemList.add(item);
		}
	}
	
	private List<PurchasedItem> purchasedItemList = new ArrayList<PurchasedItem>();
	
	public List<PurchasedItem> getPurchasedItemList() {
		return purchasedItemList;
	}
	
	private String continuationToken;
	
	public String getContinuationToken() {
		return continuationToken;
	}
	
	private void verifyInput(Bundle input) throws IllegalArgumentException {
		
		if (input == null) {
			throw new IllegalArgumentException(
					"Invalid input:" + input);
		}
		
		if (!input.containsKey(KEY_PRODUCT_ID_LIST)) {
			throw new IllegalArgumentException("Expect bundle with key:"
					+ KEY_PRODUCT_ID_LIST);
		}
		
		if (!input.containsKey(KEY_DATA_LIST)) {
			throw new IllegalArgumentException("Expect bundle with key:"
					+ KEY_DATA_LIST);
		}
		
		if (!input.containsKey(KEY_SIGNATURE_LIST)) {
			throw new IllegalArgumentException("Expect bundle with key:"
					+ KEY_SIGNATURE_LIST);
		}
	}
	
	private static final String KEY_PRODUCT_ID_LIST    = "INAPP_PURCHASE_ITEM_LIST";
	private static final String KEY_DATA_LIST          = "INAPP_PURCHASE_DATA_LIST";
	private static final String KEY_SIGNATURE_LIST     = "INAPP_DATA_SIGNATURE_LIST";
	private static final String KEY_CONTINUATION_TOKEN = "INAPP_CONTINUATION_TOKEN";
}
