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
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.cache.Cache;
import com.playhaven.android.req.ContentUnitRequest;

public class PushPlacement extends Placement {
	private String messageId;
	private String contentUnitId;

	public PushPlacement(String placementTag) {
		super(placementTag);
	}
	
	public void setMessageId(String id){
		this.messageId = id;
	}
	
	public String getMessageId(){
		return messageId;
	}
	
	public void setContentUnitId(String id){
		this.contentUnitId = id;
	}
	
	@Override
    /**
     * Preload a content unit for this placement. 
     * @param context of the caller
     */
    public void preload(final Context context) {
        if(isLoading) return;
        isLoading = true;

        try {
            if(cache == null) cache = new Cache(context);
        } catch (PlayHavenException e) {
            contentFailed(e);
        }
        
        ContentUnitRequest content = new ContentUnitRequest(placementTag);
        content.setMessageId(this.messageId);
        content.setContentUnitId(this.contentUnitId);
        content.setPreload(true);
        content.setResponseHandler(this);
        content.send(context);
    }
}
