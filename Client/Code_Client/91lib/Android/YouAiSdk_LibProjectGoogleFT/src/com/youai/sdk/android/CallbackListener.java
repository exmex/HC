package com.youai.sdk.android;

import android.os.Bundle;

public abstract class CallbackListener {

	public void onLoginSuccess(String info) {
	}

	public void onLoginError(YouaiError error) {
	}

	public void onLogoutSuccess() {

	}

	public boolean onLoginOutAfter() {
		return true;
	}

	public void onLogoutError(YouaiError error) {
	}

	public void onInfoSuccess(Bundle bundle) {
	}

	public void onInfoError(YouaiError error) {
	}

	public void onMemberCenterBack() {
	}

	public void onMemberCenterError(YouaiError error) {

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
