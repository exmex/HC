package com.nuclear.dota;

import java.util.Date;
import java.util.Timer;
import java.util.TimerTask;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.IBinder;
import android.util.Log;

import com.nuclear.dota.GameActivity;

public class NotificationService extends Service {

	private final static String TAG = NotificationService.class.getSimpleName();

	private Timer timer;

	private NotificationManager notif;

	private DataReceiver dataReceiver;
	private Date date;
	private StringBuilder buf;

	@Override
	public void onCreate() {

		super.onCreate();
		timer = new Timer("Notificationservice");
		notif = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);
		dataReceiver = new DataReceiver();
		IntentFilter filter = new IntentFilter();
		filter.addAction("com.nuclear.dota.notificationservice");
		registerReceiver(dataReceiver, filter);
	}

	class DataReceiver extends BroadcastReceiver {

		@Override
		public void onReceive(Context context, Intent intent) {
			// TODO Auto-generated method stub
			boolean isClear = intent.getBooleanExtra("clear", false);
			if (isClear) {
				timer.cancel();
				timer = new Timer("Notificationservice");
				return;
			}

			String title = intent.getStringExtra("title");
			String msg = intent.getStringExtra("message");
			int time = intent.getIntExtra("delayminite", 0);
			Log.i("DataReceiver onReceive:", title + msg);
			if(time<0){
				time=0;
			}
			try {
				timer.schedule(new NotificationTask(msg, title),time* 60 * 1000);
			} catch (Exception e) {
				// TODO: handle exception
				Log.e(TAG, "time"+time);
			}
		
		}

	}

	/***/
	class NotificationTask extends TimerTask {
		String Notititle;
		String Noticontent;
		long showTime;

		public NotificationTask(String pTickrText, String pNotititle) {
			this.Notititle = pNotititle;
			this.Noticontent = pTickrText;
			showTime = System.currentTimeMillis();
		}

		@SuppressWarnings("deprecation")
		@Override
		public void run() {
			Notification notifica = new Notification(getApplicationInfo().icon,
					Notititle, showTime);
			notifica.flags = Notification.FLAG_AUTO_CANCEL;
			Intent intent = new Intent(NotificationService.this,
					GameActivity.class);
			intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP
					| Intent.FLAG_ACTIVITY_NEW_TASK);
			intent.setAction("com.nuclear.dota.notificationservice");
			// intent.setFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
			PendingIntent
			/*
			 * PendingIntent contentIntent = PendingIntent.getActivity(
			 * MainActivity.this, R.string.app_name, intent,
			 * PendingIntent.FLAG_UPDATE_CURRENT);
			 */
			contentIntent = PendingIntent.getActivity(NotificationService.this,
					0, intent, PendingIntent.FLAG_ONE_SHOT);

			notifica.setLatestEventInfo(NotificationService.this, Notititle,
					Noticontent, contentIntent);

			date = new Date();
			buf = new StringBuilder();
			int seq = 0;
			int ROTATION = 99999;
			if (seq > ROTATION)
				seq = 0;
			buf.delete(0, buf.length());
			date.setTime(System.currentTimeMillis());
			String str = String.format("%1$tY%1$tm%1$td%1$tk%1$tM%1$tS%2$05d",
					date, seq++);
			notif.notify((int) Long.parseLong(str), notifica);

		}
	}

	@Override
	public int onStartCommand(Intent intent, int flags, int startId) {
		flags = START_STICKY;
		return super.onStartCommand(intent, flags, startId);
	}

	@Override
	public void onDestroy() {
		Log.i(TAG, "Service destroyed");
		stopForeground(true);
		Intent intent = new Intent("com.nuclear.dota.destroy");
		sendBroadcast(intent);
		super.onDestroy();
		// timer.cancel();
		// timer = null;
		// unregisterReceiver(dataReceiver);
	}

	public IBinder onBind(Intent intent) {
		return null;
	}
}