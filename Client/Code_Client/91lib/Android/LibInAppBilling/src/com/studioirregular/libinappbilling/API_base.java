package com.studioirregular.libinappbilling;

import android.os.RemoteException;
import android.util.Log;

import com.android.vending.billing.IInAppBillingService;


public abstract class API_base <ResultType> {

	protected abstract boolean DEBUG_LOG();
	protected abstract String DEBUG_NAME();
	
	protected Integer apiVersion;
	
	protected String packageName;
	
	public void setApiVersion(int value) {
		this.apiVersion = value;
	}
	
	public void setPackageName(String value) {
		this.packageName = value;
	}
	
	protected void checkArguments() throws IllegalArgumentException {

		if (apiVersion == null || apiVersion < MINIMUM_API_VERSION) {
			throw new IllegalArgumentException("Invalid argument apiVersion:"
					+ apiVersion);
		}

		if (packageName == null) {
			throw new IllegalArgumentException("Invalid argument packageName:"
					+ packageName);
		}
		
		onCheckArguments();
	}
	
	protected abstract void onCheckArguments() throws IllegalArgumentException;
	
	public ResultType execute(IInAppBillingService service)
			throws IllegalArgumentException, RemoteException {
		
		if (DEBUG_LOG()) {
			Log.d(Global.LOG_TAG, DEBUG_NAME() + " execute");
		}
		
		checkArguments();
		
		if (Global.LOG_API_EXECUTION_TIME) {
			if (stopWatch == null) {
				stopWatch = new StopWatch();
			}
			stopWatch.start();
		}
		
		ResultType result = callAPI(service);
		
		if (Global.LOG_API_EXECUTION_TIME) {
			final long executionTime = stopWatch.stop();
			Log.w(Global.LOG_TAG, DEBUG_NAME() + " executionTime:" + executionTime);
		}
		
		return result;
	}
	
	protected abstract ResultType callAPI(IInAppBillingService service)
			throws RemoteException;
	
	protected static final int MINIMUM_API_VERSION = 3;
	
	private StopWatch stopWatch;
}
