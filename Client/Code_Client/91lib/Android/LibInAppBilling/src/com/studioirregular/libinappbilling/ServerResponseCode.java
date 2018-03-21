package com.studioirregular.libinappbilling;

import android.content.Intent;
import android.os.Bundle;

public class ServerResponseCode {

	public static final int INVALID_CODE_VALUE = -1;
	
	public static final int BILLING_RESPONSE_RESULT_OK = 0;
	
	public static final int BILLING_RESPONSE_RESULT_USER_CANCELED = 1;
	
	public static final int BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE = 3;
	
	public static final int BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE = 4;
	
	public static final int BILLING_RESPONSE_RESULT_DEVELOPER_ERROR = 5;
	
	public static final int BILLING_RESPONSE_RESULT_ERROR = 6;
	
	public static final int BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED = 7;
	
	public static final int BILLING_RESPONSE_RESULT_ITEM_NOT_OWNED = 8;
	
	public ServerResponseCode(int value) {
		this.value = value;
	}
	
	public ServerResponseCode(Bundle bundle) {
		
		Object obj = bundle.get(RESPONSE_CODE_KEY);
		
		if (obj == null) {
			// Intent with no response code, assuming OK (known issue).
			value = BILLING_RESPONSE_RESULT_OK;
			
		} else if (obj instanceof Integer) {
			value = ((Integer)obj).intValue();
			
		} else if (obj instanceof Long) {
			value = ((Long)obj).intValue();
		} else {
			throw new RuntimeException("Unexpected type of ResponseCode:"
					+ obj.getClass().getName());
		}
	}
	
	public ServerResponseCode(Intent intent) {
		
		this(intent.getExtras());
	}
	
	public boolean isOK() {
		
		return (value == BILLING_RESPONSE_RESULT_OK);
	}
	
	public int value = INVALID_CODE_VALUE;
	
	@Override
	public String toString() {
		
		switch (value) {
		
		case INVALID_CODE_VALUE:
			return "INVALID_CODE_VALUE";
			
		case BILLING_RESPONSE_RESULT_OK:
			return "BILLING_RESPONSE_RESULT_OK";
			
		case BILLING_RESPONSE_RESULT_USER_CANCELED:
			return "BILLING_RESPONSE_RESULT_USER_CANCELED";
			
		case BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE:
			return "BILLING_RESPONSE_RESULT_BILLING_UNAVAILABLE";
		
		case BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE:
			return "BILLING_RESPONSE_RESULT_ITEM_UNAVAILABLE";
		
		case BILLING_RESPONSE_RESULT_DEVELOPER_ERROR:
			return "BILLING_RESPONSE_RESULT_DEVELOPER_ERROR";
		
		case BILLING_RESPONSE_RESULT_ERROR:
			return "BILLING_RESPONSE_RESULT_ERROR";
		
		case BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED:
			return "BILLING_RESPONSE_RESULT_ITEM_ALREADY_OWNED";
		
		case BILLING_RESPONSE_RESULT_ITEM_NOT_OWNED:
			return "BILLING_RESPONSE_RESULT_ITEM_NOT_OWNED";
		}
		
		return "ServerResponseCode: invalid value:" + value;
	}
	
	private static final String RESPONSE_CODE_KEY = "RESPONSE_CODE";
}
