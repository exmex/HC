package com.youai.sdk.android.utils;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import java.io.UnsupportedEncodingException;
import java.util.UUID;

public class DeviceUuidFactory {
	protected static final String PREFS_FILE = "device_id.xml";
	protected static final String PREFS_DEVICE_ID = "device_id";
	protected static UUID uuid;
	private Context context;
	private String IMEI = "";
	private String serial_number = "";
	private String android_id = "";
	private TelephonyManager telephonyManager;

	public DeviceUuidFactory(Context context) {
		this.context = context;
		String androidId = Secure.getString(
				context.getContentResolver(), "android_id");
		this.android_id = androidId;
		this.telephonyManager = ((TelephonyManager) context
				.getSystemService("phone"));
		this.IMEI = this.telephonyManager.getDeviceId();
		this.serial_number = this.telephonyManager.getSimSerialNumber();

		if (uuid == null)
			synchronized (DeviceUuidFactory.class) {
				if (uuid == null) {
					SharedPreferences prefs = context.getSharedPreferences(
							"device_id.xml", 0);
					String id = prefs.getString("device_id", null);

					if (id != null) {
						uuid = UUID.fromString(id);
					} else {
						try {
							if (!"9774d56d682e549c".equals(androidId)) {
								uuid = UUID.nameUUIDFromBytes(androidId
										.getBytes("utf8"));
							} else {
								String deviceId = ((TelephonyManager) context
										.getSystemService("phone"))
										.getDeviceId();
								uuid = (deviceId != null) ? UUID
										.nameUUIDFromBytes(deviceId
												.getBytes("utf8")) : UUID
										.randomUUID();
							}
						} catch (UnsupportedEncodingException e) {
							throw new RuntimeException(e);
						}

					}

					prefs.edit().putString("device_id", uuid.toString())
							.commit();
				}
			}
	}

	public String getUUID() {
		SharedPreferences pf = this.context.getSharedPreferences(
				"device_id.xml", 0);
		String id = pf.getString("device_id", "");
		return id;
	}

	public String getIMEI() {
		return this.IMEI;
	}

	public String getAndroid_ID() {
		return this.android_id;
	}

	public String getSerial_Number() {
		return this.serial_number;
	}
	
	public String getNo(){
		if(null!=android_id)
		
			return this.getAndroid_ID();//1
		
		if(null!=IMEI)
		
			return this.getIMEI();
		
	    return this.getUUID();//3
	}
}
