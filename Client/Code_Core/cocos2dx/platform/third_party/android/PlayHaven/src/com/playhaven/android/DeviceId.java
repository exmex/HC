/**
 * Copyright 2013 Medium Entertainment, Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package com.playhaven.android;

import android.content.Context;
import android.provider.Settings;

/**
 * Obtain and validate the Device ID
 */
public class DeviceId
{
    /**
     * Non-Unique Device ID that was used by Moto, HTC, Emulator, etc
     */
    private static final String MAGIC_DEVICE_ID = "9774d56d682e549c";

    /**
     * Obtained/Generated device identifier
     */
    private String deviceId;

    @SuppressWarnings("deprecation")
    public DeviceId(Context context)
    {
        /**
         * Note: PlayHaven v1.x only did:
         * Settings.System.getString(context.getContentResolver(), Settings.System.ANDROID_ID)
         */
        deviceId = Settings.Secure.getString(context.getContentResolver(),Settings.Secure.ANDROID_ID);
        if(isValidDeviceId(deviceId)) return;

        deviceId = Settings.System.getString(context.getContentResolver(), Settings.System.ANDROID_ID);
        if(isValidDeviceId(deviceId)) return;

        deviceId = MAGIC_DEVICE_ID;
    }

    public String toString(){return deviceId;}

    /**
     * Validate the device id is in the correct format.
     *
     * @param devId to validate
     * @return true if the devId is in the correct format
     */
    protected boolean isValidDeviceId(String devId)
    {
        if(devId == null) return false;
        if(devId.length() == 0) return false;
        if(MAGIC_DEVICE_ID.equals(devId)) return false;

        return true;
    }
}
