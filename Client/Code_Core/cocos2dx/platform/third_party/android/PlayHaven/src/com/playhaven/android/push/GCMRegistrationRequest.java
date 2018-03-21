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
package com.playhaven.android.push;

import android.app.PendingIntent;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHaven.Config;

public class GCMRegistrationRequest {
	public void send(Context context, String which){
        SharedPreferences pref = PlayHaven.getPreferences(context);
    	PlayHaven.v("Starting %s request.", which);
    	Intent registrationIntent = new Intent(which);
    	registrationIntent.putExtra("app", PendingIntent.getBroadcast(context, 0, new Intent(), 0));
    	registrationIntent.putExtra("sender", pref.getString(Config.PushProjectId.name(), ""));
    	context.startService(registrationIntent);
	}
	
	public void deregister(Context context){
		this.send(context, GCMBroadcastReceiver.C2DM_UNREGISTER);
	}
	
	public void register(Context context){
		this.send(context, GCMBroadcastReceiver.C2DM_REGISTER);
	}
}
