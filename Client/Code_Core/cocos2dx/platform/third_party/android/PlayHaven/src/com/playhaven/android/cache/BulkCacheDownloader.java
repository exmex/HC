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

import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.CopyOnWriteArrayList;

/**
 * Utility class to handle multiple downloads with a single callback
 */
class BulkCacheDownloader
implements CacheResponseHandler
{
    // Cache to be used
    private Cache cache;

    // Handler to notify
    private CacheResponseHandler handler;

    // List of responses
    private CopyOnWriteArrayList<CachedInfo> responses;

    // Expected number of responses
    private int length;


    /**
     * Create a cache under the Applications cache directory
     *
     * @param cache to be used
     * @param handler to be notified of success or failure
     * @param urls to download
     * @throws com.playhaven.android.PlayHavenException
     * @throws java.net.MalformedURLException
     */
    public BulkCacheDownloader(Cache cache, CacheResponseHandler handler, List<String> urls)
            throws PlayHavenException, MalformedURLException {
        this.cache = cache;
        this.handler = handler;

        responses = new CopyOnWriteArrayList<CachedInfo>();
        length = urls.size();
        for(String url : urls)
            cache.request(url, this);
    }

    /**
     * Create a cache under the Applications cache directory
     *
     * @param cache to be used
     * @param handler to be notified of success or failure
     * @param urls to download
     * @throws com.playhaven.android.PlayHavenException
     * @throws java.net.MalformedURLException
     */
    public BulkCacheDownloader(Cache cache, CacheResponseHandler handler, String... urls)
            throws PlayHavenException, MalformedURLException {
        this.cache = cache;
        this.handler = handler;

        responses = new CopyOnWriteArrayList<CachedInfo>();
        length = urls.length;
        for(String url : urls)
            cache.request(url, this);
    }

    /**
     * Create a cache under the Applications cache directory
     *
     * @param cache to be used
     * @param handler to be notified of success or failure
     * @param urls to download
     * @throws com.playhaven.android.PlayHavenException
     */
    public BulkCacheDownloader(Cache cache, CacheResponseHandler handler, URL... urls)
            throws PlayHavenException {
        this.cache = cache;
        this.handler = handler;

        responses = new CopyOnWriteArrayList<CachedInfo>();
        length = urls.length;
        for(URL  url : urls)
            cache.request(url, this);
    }


    /**
     * Called when a files are successfully retrieved
     *
     * @param cachedInfos of cached content
     */
    @Override
    public void cacheSuccess(CachedInfo... cachedInfos) {
        // Store the subset that reported in
        responses.addAll(Arrays.asList(cachedInfos));

        // Check if we are done
        if(responses.size() < length) return;

        // Report back to the handler
        handler.cacheSuccess(responses.toArray(new CachedInfo[responses.size()]));
    }

    /**
     * Called when a file fails to be retrieved
     *
     * @param url       of the request
     * @param exception reason for the failure
     */
    @Override
    public void cacheFail(URL url, PlayHavenException exception) {
        handler.cacheFail(url, exception);
    }
}
