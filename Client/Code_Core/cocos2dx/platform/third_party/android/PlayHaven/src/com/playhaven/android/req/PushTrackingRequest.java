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
package com.playhaven.android.req;

import android.content.Context;
import android.content.SharedPreferences;
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.push.GCMBroadcastReceiver;
import com.playhaven.android.push.PushReceiver;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;

import static com.playhaven.android.compat.VendorCompat.ResourceType;

public class PushTrackingRequest extends PlayHavenRequest {
	private String mPushToken;
	private String mMessageId;
	private String mContentId;
	
	public PushTrackingRequest(Context context, String message_id, String content_id){
        super();
		mMessageId = message_id;
		mContentId = content_id;
		
        SharedPreferences pref = PlayHaven.getPreferences(context);
        mPushToken = pref.getString(GCMBroadcastReceiver.REGID, null);
	}
	
	/**
	 * Create a tracking request, possibly before a sharedprefs edit has been finished. 
	 */
	public PushTrackingRequest(String registration_id, String message_id, String content_id){
        super();
		mMessageId = message_id;
		mContentId = content_id;
		mPushToken = registration_id;
	}

    @Override 
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
        UriComponentsBuilder builder = super.createUrl(context);
        builder.queryParam(PushReceiver.PushParams.push_token.name(),  mPushToken); // aka GCM registration id. 
        builder.queryParam(PushReceiver.PushParams.message_id.name(),  mMessageId);
        builder.queryParam(PushReceiver.PushParams.content_id.name(),  mContentId);
        return builder;
    }

    @Override
    protected int getApiPath(Context context) {
        return getCompat(context).getResourceId(context, ResourceType.string, "playhaven_request_push");
    }

    @Override
    protected AdvertisingIdClient.Info getAdvertisingIdInfo(Context context)
    throws GooglePlayServicesNotAvailableException, IOException, GooglePlayServicesRepairableException
    {
        // android.content.ReceiverCallNotAllowedException: BroadcastReceiver components are not allowed to bind to services
        return null;
    }
}
