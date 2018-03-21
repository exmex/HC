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

import android.content.Context;
import com.playhaven.android.PlayHavenException;

import java.io.File;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.List;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Caching manager for stored content templates and resources.
 */
public class Cache
{
    /**
     * Subdirectory of the Application cache for PlayHaven use
     */
    public static final String CACHE_DIR = "playhaven.cache";

    /**
     * Thread pool for downloading external content into the cache
     */
    private ExecutorService pool;

    /**
     * Parent directory of the cached files
     */
    private File cacheDir;

    /**
     * Create a cache under the Applications cache directory
     *
     * @param context of the caller
     * @throws PlayHavenException
     */
    public Cache(Context context)
            throws PlayHavenException
    {
        // Application-wide configuration
        Context appContext = context.getApplicationContext();
        cacheDir = appContext.getDir(CACHE_DIR, Context.MODE_PRIVATE);

        if(!(cacheDir.mkdirs() || cacheDir.isDirectory()))
            throw new PlayHavenException("Unable to access cache" + (cacheDir == null ? "" : ": " + cacheDir.getAbsolutePath()));

        pool = Executors.newCachedThreadPool();
        pool.submit(new CacheCleaner(cacheDir));
    }

    /**
     * Close the Cache
     */
    public void close()
    {
        if(pool != null && !pool.isShutdown())
            pool.shutdownNow();

        pool = null;
        cacheDir = null;
    }

    /**
     * Locates the File in the cache
     *
     * @param file to locate
     * @return true if the file was found; false otherwise
     * @throws PlayHavenException if the file can not be processed
     */
    private boolean existsInCache(final File file)
    throws PlayHavenException
    {
        if(file == null) throw new PlayHavenException("Invalid file: null");
        if(file.isDirectory()) throw new PlayHavenException("File is a directory: " + file.getAbsolutePath());
        if(!file.exists()) return false;
        if(file.lastModified() == 0) return false;

        return true;
    }

    /**
     * Normalize the URL into a filename for the cache
     *
     * @param url to normalize
     * @return string representation of the filename
     */
    private String getFileName(final URL url)
    {
        String path = url.getPath();
        if(path.startsWith("/"))
            path = path.substring(1);

        return path.replaceAll("/", "|");
    }

    /**
     * Asynchronously request content from the cache
     *
     * @param url to request
     * @param handler to be notified of success or failure
     * @throws PlayHavenException if there are any problems obtaining the content
     * @throws MalformedURLException if the URL is not properly formatted
     */
    public void request(final String url, final CacheResponseHandler handler)
            throws PlayHavenException, MalformedURLException
    {
        request(new URL(url), handler);
    }
    
    /**
     * Return a file from the cache. 
     * @param url of file to get 
     */
    public File getFile(URL url)
    {
        String fileName = getFileName(url);
        return new File(cacheDir, fileName);
    }

    /**
     * Asynchronously request content from the cache
     *
     * @param url to request
     * @param handler to be notified of success or failure
     * @throws PlayHavenException if there are any problems obtaining the content
     */
    public void request(URL url, final CacheResponseHandler handler)
            throws PlayHavenException
    {
        /**
         * Server may not have normalized what the user uploaded to the dashboard
         * Do some normalization now..
         */
        try {
            String normalized = url.toExternalForm();
            // Do we need to do full %-encoding?
            normalized = normalized.replaceAll(" ", "%20");
            url = new URL(normalized);
        } catch (MalformedURLException e) {
            throw new PlayHavenException(e);
        }

		File file = getFile(url);

        if(existsInCache(file))
        {
            touch(file);
            handler.cacheSuccess(new CachedInfo(url, file, false));
            return;
        }

        /* Future<File> response = */ pool.submit(new CacheDownloader(url, handler, file));
        // not doing response.get() here so that we don't block the requesting thread
    }

    /**
     * Asynchronously do a bulk request for content from the cache.
     * This method will make 1 callback, regardless of the number of requested files.
     *
     * @param handler to be notified of success or failure
     * @param urls to request
     * @throws PlayHavenException if there are any problems obtaining the content
     * @throws MalformedURLException if the URL is not properly formatted
     */
    public void bulkRequest(final CacheResponseHandler handler, final List<String> urls)
            throws PlayHavenException, MalformedURLException
    {
        new BulkCacheDownloader(this, handler, urls);
    }

    /**
     * Asynchronously do a bulk request for content from the cache.
     * This method will make 1 callback, regardless of the number of requested files.
     *
     * @param handler to be notified of success or failure
     * @param urls to request
     * @throws PlayHavenException if there are any problems obtaining the content
     * @throws MalformedURLException if the URL is not properly formatted
     */
    public void bulkRequest(final CacheResponseHandler handler, final String ... urls)
            throws PlayHavenException, MalformedURLException
    {
        new BulkCacheDownloader(this, handler, urls);
    }

    /**
     * Asynchronously do a bulk request for content from the cache.
     * This method will make 1 callback, regardless of the number of requested files.
     *
     * @param handler to be notified of success or failure
     * @param urls to request
     * @throws PlayHavenException if there are any problems obtaining the content
     */
    public void bulkRequest(final CacheResponseHandler handler, final URL ... urls)
            throws PlayHavenException
    {
        new BulkCacheDownloader(this, handler, urls);
    }

    /**
     * By touching files when accessed, we can use lastModified to implement a basic LRU
     *
     * @param file to touch
     */
    private void touch(File file)
    {
        file.setLastModified( (new Date()).getTime() );
    }
}
