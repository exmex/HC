package com.studioirregular.libinappbilling;

import java.util.Observable;
import java.util.Observer;

import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.ServiceConnection;
import android.os.IBinder;
import android.util.Log;

import com.android.vending.billing.IInAppBillingService;

public class IabServiceConnection {

	public IabServiceConnection(Context context) {
		this.context = context;
	}
	
	public void observeConnectionStatus(Observer ob) {
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG,
					"IabServiceConnection::observeConnectionStatus ob:" + ob);
		}
		
		if (connectionStatus != null) {
			connectionStatus.addObserver(ob);
		}
	}
	
	public void unregisterConnectionStatus(Observer ob) {
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG,
					"IabServiceConnection::unregisterConnectionStatus ob:" + ob);
		}
		
		if (connectionStatus != null) {
			connectionStatus.deleteObserver(ob);
		}
	}
	
	public boolean bindService() {
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG, "IabServiceConnection::bindSerice");
		}
		
		if (context == null) {
			Log.e(Global.LOG_TAG, "invalid context value: + context");
			return false;
		}
		
		try {
			final boolean result = context.bindService(
					new Intent(IAB_SERVICE_BIND_ACTION), 
					serviceConnection, Context.BIND_AUTO_CREATE);
			
			if (result == false) {
				Log.e(Global.LOG_TAG, "failed to bind service.");
			}
			
			return result;
		} catch (SecurityException e) {
			Log.e(Global.LOG_TAG, "bind service exception:" + e);
			return false;
		}
	}
	
	public void unbindService() {
		
		if (Global.DEBUG_LOG) {
			Log.d(Global.LOG_TAG, "IabServiceConnection::unbindService");
		}
		
		if (context != null) {
			context.unbindService(serviceConnection);
		}
	}
	
	public IInAppBillingService getService() {
		return service;
	}
	
	private Context context;
	
	private IInAppBillingService service;
	
	private ServiceConnection serviceConnection = new ServiceConnection() {

		@Override
		public void onServiceConnected(ComponentName name, IBinder service) {
			
			if (Global.DEBUG_LOG) {
				Log.d(Global.LOG_TAG,
						"IabServiceConnection::serviceConnection::onServiceConnected name:"
								+ name);
			}
				
			IabServiceConnection.this.service = IInAppBillingService.Stub
					.asInterface(service);
			
			if (connectionStatus != null) {
				connectionStatus.onServiceConnected();
			}
		}

		@Override
		public void onServiceDisconnected(ComponentName name) {
			if (Global.DEBUG_LOG) {
				Log.d(Global.LOG_TAG,
						"IabServiceConnection::serviceConnection::onServiceDisconnected name:"
								+ name);
			}
				
			service = null;
			
			if (connectionStatus != null) {
				connectionStatus.onServiceDisconnected();
			}
		}
		
	};
	
	private class ConnectionStatus extends Observable {
		
		public void onServiceConnected() {
			setChanged();
			notifyObservers(Boolean.TRUE);
		}
		
		public void onServiceDisconnected() {
			setChanged();
			notifyObservers(Boolean.FALSE);
		}
	}
	
	private ConnectionStatus connectionStatus = new ConnectionStatus();
	
	public static final String IAB_SERVICE_BIND_ACTION = 
			"com.android.vending.billing.InAppBillingService.BIND";
}
