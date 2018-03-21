/**
 * Copyright 2014 Medium Entertainment, Inc.
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
import android.util.Base64;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.compat.VendorCompat;
import com.playhaven.android.data.CustomEvent;
import net.minidev.json.JSONArray;
import org.springframework.http.HttpMethod;
import org.springframework.web.util.UriComponentsBuilder;
import javax.crypto.Mac;
import javax.crypto.spec.SecretKeySpec;

import static com.playhaven.android.PlayHaven.Config.Secret;

public class CustomEventRequest
extends ContentRequest  // to get session handling
{
    private static final String PARAM_DATA = "data";
    private static final String PARAM_DATA_SIG = "data_sig";
    private static final String PARAM_TYPE = "type";
    private static final String PARAM_TYPE_VALUE = "event";
    private static final String PARAM_VERSION = "version";
    private static final int PARAM_VERSION_VALUE = 1;

    private JSONArray customEvents;

    public CustomEventRequest(CustomEvent ... customEvents) throws PlayHavenException {
        super();
        if(customEvents.length == 0)
            throw new PlayHavenException("No custom event specified for request");

        this.customEvents = new JSONArray();
        for(CustomEvent event : customEvents)
            this.customEvents.add(event.toJSONObject());

        setMethod(HttpMethod.POST);
    }

    @Override
    protected int getApiPath(Context context)
    {
        return getCompat(context).getResourceId(context, VendorCompat.ResourceType.string, "playhaven_request_event");
    }

    @Override
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
        UriComponentsBuilder builder = super.createUrl(context);

        String json = customEvents.toJSONString();
        builder.queryParam(PARAM_DATA, json);
        builder.queryParam(PARAM_TYPE, PARAM_TYPE_VALUE);
        builder.queryParam(PARAM_VERSION, PARAM_VERSION_VALUE);

        try{
            SharedPreferences pref = PlayHaven.getPreferences(context);
            builder.queryParam(PARAM_DATA_SIG, createHmac(pref, json, true));
        } catch (Exception e) {
            throw new PlayHavenException("Unable to create signature for events", e);
        }

        return builder;
    }
}
