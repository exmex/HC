package com.nuclear.sdk.android;

import android.os.Bundle;

public abstract class CallbackListener {

	public void isOldDeviceUser()
	{
	}
	
	public void onNomalRegister()
	{
	}
	public void onTryRegister()
	{
	}
	
	
	public void onLoginSuccess(String info) {
	}

	public void onLoginError(SdkError error) {
	}

	public void onLogoutSuccess() {

	}

	public boolean onLoginOutAfter() {
		return true;
	}

	public void onLogoutError(SdkError error) {
	}

	public void onInfoSuccess(Bundle bundle) {
	}

	public void onInfoError(SdkError error) {
	}

	public void onMemberCenterBack() {
	}

	public void onMemberCenterError(SdkError error) {

	}

	public void onPaymentSuccess() {
	}

	public void onPaymentError() {
	}

	public void onError(Error error) {
	}

	public void onPaySubmitSuccess() {

	}

	public void onPaySubmitFailed() {

	}
}
