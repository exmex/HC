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
import com.playhaven.android.PlayHavenException;
import org.springframework.web.util.UriComponentsBuilder;

/**
 * Make a METADATA request to PlayHaven
 */
public class MetadataRequest
    extends ContentRequest
{
    public MetadataRequest(String placementTag) {
        super(placementTag);
    }

    public MetadataRequest(int placementResId) {
        super(placementResId);
    }

    @Override
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
        UriComponentsBuilder builder = super.createUrl(context);
        builder.queryParam("metadata", 1);
        return builder;
    }
}
