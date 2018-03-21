package com.studioirregular.libinappbilling;

import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class PurchasedItem {

	public String mOriginalJson;
	
	public String mSignature;
	
	public String orderId;
	
	public String packageName;
	
	public String productId;
	
	public long purchaseTime;
	
	public int stateno;
	
	public enum PurchaseState {
		
		PURCHASED,
		CANCELED,
		REFUNDED;
		
	public static PurchaseState get(int value) {
			switch (value) {
			case 0:
				return PURCHASED;
			case 1:
				return CANCELED;
			case 2:
				return REFUNDED;
			}
			return null;
		}
	};
	
	public PurchaseState purchaseState;
	
	public String developerPayload;
	
	public String purchaseToken;
	
	/*public PurchasedItem(String jsonString) throws JSONException {
		mOriginalJson = jsonString;
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG, "PurchasedItem: jsonString:" + jsonString);
		}
		
		parse(new JSONObject(jsonString));
	}*/
	
	public PurchasedItem(String jsonString,String pSignature) throws JSONException {
		mOriginalJson = jsonString;
		mSignature = pSignature;
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG, "PurchasedItem: jsonString:" + jsonString);
		}
		
		parse(new JSONObject(jsonString));
	}
	
	
	private void parse(JSONObject json) {
		
		orderId = json.optString("orderId");
		
		packageName = json.optString("packageName");
		
		productId = json.optString("productId");
		
		purchaseTime = json.optLong("purchaseTime");
		
		stateno =  json.optInt("purchaseState");
		
		purchaseState = PurchaseState.get(json.optInt("purchaseState"));
		
		developerPayload = json.optString("developerPayload");
		
		purchaseToken = json.optString("purchaseToken");
	}
	
	@Override
	public String toString() {
		
		StringBuilder result = new StringBuilder(getClass().getName());
		result.append("\n");
		result.append("\torderId : ").append(orderId).append("\n");
		result.append("\tpackageName : ").append(packageName).append("\n");
		result.append("\tpurchaseTime : ").append(purchaseTime).append("\n");
		result.append("\tpurchaseState : ").append(purchaseState).append("\n");
		result.append("\tdeveloperPayload : ").append(developerPayload).append("\n");
		result.append("\tpurchaseToken : ").append(purchaseToken).append("\n");
		
		return result.toString();
	}
}
