package com.youai.sdk.webpay;


public interface PayWebListen {
	public void onSuccess(String response) ;

	public void onCancel();

	public void onFailed(String response);
}
