package com.studioirregular.libinappbilling;

import org.json.JSONException;

import android.content.Intent;
import android.os.Bundle;
import android.util.Log;

/*
 * This class process purchase resulted intent data, as described in: 
 * http://developer.android.com/google/play/billing/billing_reference.html#getBuyIntent
 */
public class HandlePurchaseActivityResult {

	private Intent data;
	
	public HandlePurchaseActivityResult(Intent data)
			throws IllegalArgumentException {
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG, "HandlePurchaseActivityResult");
		}
		
		if (data == null) {
			throw new IllegalArgumentException("Invalid intent data:" + data);
		}
		
		if (Global.DEBUG_LOG) {
			Bundle extras = data.getExtras();
			if (extras != null) {
				Log.d(Global.LOG_TAG, "\tdata.extras:");
				for (String key : extras.keySet()) {
					Log.d(Global.LOG_TAG, "\t\t[" + key + "] : " + extras.get(key));
				}
			}
		}
		
		this.data = data;
	}
	
	public ServerResponseCode getResponseCode() {
		
		return new ServerResponseCode(data);
	}
	
	public PurchasedItem getPurchasedItem(String publicKeyBase64)
			throws SignatureVerificationException, JSONException {
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG,
					"HandlePurchaseActivityResult::getPurchasedItem: publicKeyBase64:"
							+ publicKeyBase64);
		}
		
		final String purchaseData = data.getExtras().getString(KEY_PURCHASE_DATA);
		final String signature = data.getExtras().getString(KEY_DATA_SIGNATURE);
		
		final boolean pass = Security.verifyPurchase(
				publicKeyBase64, purchaseData, signature);
		
		if (!pass) {
			throw new SignatureVerificationException(
					"getPurchasedItem: verify signature failed.");
		}		
		
		return new PurchasedItem(purchaseData,signature);
	}
	
	private static final String KEY_PURCHASE_DATA  = "INAPP_PURCHASE_DATA";
	private static final String KEY_DATA_SIGNATURE = "INAPP_DATA_SIGNATURE";
}
