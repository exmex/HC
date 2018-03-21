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

import android.app.Notification;
import android.app.PendingIntent;
import android.content.Context;
import android.os.Bundle;
import android.support.v4.app.NotificationCompat;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;

public class NotificationBuilder {
	private Context mContext;

    public enum Keys {
    	TITLE,
    	TEXT,
    	URI
    }
    
    public NotificationBuilder(Context context){
    	mContext = context;
    }
	
	/**
	 * Create a notification from a Bundle, using the provided PendingIntent 
	 */
    public Notification makeNotification(Bundle extras, PendingIntent pendingIntent) {
    	try {
        	if(extras == null || extras.size() < 2){
        		throw new PlayHavenException();
        	}
	    	NotificationCompat.Builder builder = new NotificationCompat.Builder(mContext);
	    	builder.setContentTitle(extras.getString(Keys.TITLE.name()));
	    	builder.setContentText(extras.getString(Keys.TEXT.name()));
	    	builder.setAutoCancel(true);
	    	builder.setSmallIcon(mContext.getApplicationInfo().icon); // We use the application's icon. 
	    	builder.setContentIntent(pendingIntent);
			return builder.getNotification();
    	} catch (Exception e) {
    		PlayHaven.e("Unable to create Notification from intent.");
    		return null;
    	}
    }
}
