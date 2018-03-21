package com.nuclear.dota;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;

public class BootReceiver extends BroadcastReceiver {

	@Override
	public void onReceive(Context context, Intent intent) {
		if (Intent.ACTION_BOOT_COMPLETED.equals(intent.getAction())) {
			System.out.println("手机开机了....");
			startUploadService(context);
		}
		if (Intent.ACTION_USER_PRESENT.equals(intent.getAction())) {
			startUploadService(context);
		}
	}

	public void startUploadService(Context context) {
		Intent intent = new Intent(context, NotificationService.class);
		context.startService(intent);
	}
}
