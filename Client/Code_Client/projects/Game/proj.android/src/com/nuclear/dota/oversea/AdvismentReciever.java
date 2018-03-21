package com.nuclear.dota.oversea;

import com.appsflyer.MultipleInstallBroadcastReceiver;
import com.inmobi.commons.analytics.androidsdk.IMAdTrackerReceiver;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class AdvismentReciever extends BroadcastReceiver{

	@Override
	public void onReceive(Context context, Intent intent) {
		if(intent.getAction().equals("com.android.vending.INSTALL_REFERRER")){
			new MultipleInstallBroadcastReceiver().onReceive(context, intent);
			new IMAdTrackerReceiver().onReceive(context, intent);
		}
	}
}
