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
package com.playhaven.android.cache;

import com.playhaven.android.PlayHavenException;

import java.net.URL;

/**
 * Implement this class to receive asynchronous callbacks from cache requests
 */
public interface CacheResponseHandler
{
    /**
     * Called when a files are successfully retrieved
     *
     * @param cachedInfos of cached content
     */
    public void cacheSuccess(CachedInfo... cachedInfos);

    /**
     * Called when a file fails to be retrieved
     *
     * @param url of the request
     * @param exception reason for the failure
     */
    public void cacheFail(URL url, PlayHavenException exception);
}
