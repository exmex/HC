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
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import org.springframework.http.HttpMethod;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Calendar;
import java.util.Date;

import static com.playhaven.android.compat.VendorCompat.ResourceType;

/**
 * Make a CONTENT request to PlayHaven
 */
public class ContentRequest extends PlayHavenRequest
{
    private static final String STIME = "stime";
    private static final String SSTART = "sstart";

    private String placementTag = null;
    private int placementResId = -1;
    private boolean preload = false;

    public ContentRequest(String placementTag)
    {
        super();
        setMethod(HttpMethod.POST);
        this.placementTag = placementTag;
    }

    public ContentRequest(int placementResId)
    {
        super();
        setMethod(HttpMethod.POST);
        this.placementResId = placementResId;
    }

    // for overriding without a placement
    protected ContentRequest()
    {
        super();
        setMethod(HttpMethod.POST);
    }

    @Override
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
        UriComponentsBuilder builder = super.createUrl(context);
        if(placementResId != -1)
            placementTag = context.getResources().getString(placementResId);

        if(placementTag != null)
            builder.queryParam("placement_id", placementTag);

        builder.queryParam("preload", isPreload() ? "1" : "0");

        SharedPreferences pref = PlayHaven.getPreferences(context);
        Calendar rightNow = Calendar.getInstance();
        Date date = rightNow.getTime();
        long end = date.getTime();
        long start = pref.getLong(SSTART, end);
        long stime = ((end - start) / 1000); // in seconds

        builder.queryParam(STIME, stime);

        // Store current stime for consumption by open requests
        SharedPreferences.Editor edit = pref.edit();
        edit.putLong(STIME, stime);
        edit.commit();

        return builder;
    }

    @Override
    protected int getApiPath(Context context) {
        return getCompat(context).getResourceId(context, ResourceType.string, "playhaven_request_content");
    }

    public boolean isPreload() {
        return preload;
    }

    public void setPreload(boolean preload) {
        this.preload = preload;
    }
}
