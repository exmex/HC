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
import com.google.android.gms.ads.identifier.AdvertisingIdClient;
import com.google.android.gms.common.GooglePlayServicesNotAvailableException;
import com.google.android.gms.common.GooglePlayServicesRepairableException;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.push.PushReceiver;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;

public class ContentUnitRequest extends ContentRequest {
	private String messageId;
	private String contentUnitId;

	public ContentUnitRequest(String placementTag) {
		super(placementTag);
	}

    @Override
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
    	UriComponentsBuilder builder = super.createUrl(context);
    	builder.queryParam(PushReceiver.PushParams.message_id.name(), messageId);
    	builder.queryParam(PushReceiver.PushParams.content_id.name(), contentUnitId);
    	return builder;
    }

	public String getMessageId() {
		return messageId;
	}

	public void setMessageId(String messageId) {
		this.messageId = messageId;
	}

	public String getContentUnitId() {
		return contentUnitId;
	}

	public void setContentUnitId(String contentUnitId) {
		this.contentUnitId = contentUnitId;
	}

    @Override
    protected AdvertisingIdClient.Info getAdvertisingIdInfo(Context context)
            throws GooglePlayServicesNotAvailableException, IOException, GooglePlayServicesRepairableException
    {
        // android.content.ReceiverCallNotAllowedException: BroadcastReceiver components are not allowed to bind to services
        return null;
    }
}
