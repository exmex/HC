package com.example.gtvsdk;

import java.io.Serializable;

import android.R.integer;

public interface GTVSDKInterface extends Serializable{

	public void GTVDidLogIn(GTVSDK sdk);

	public void GTVDidRegister(GTVSDK sdk);

	public void GTVDidRecharge(GTVSDK sdk);

	public void GTVSDKWebViewDidCancel(GTVSDK sdk);

	public void GTVSDKrequestDidFailWithError(GTVSDK sdk, String error);
}
