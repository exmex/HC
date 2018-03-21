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

import com.playhaven.android.PlayHaven;

import java.io.File;
import java.io.FileFilter;
import java.util.Date;

/**
 * Clean up stale items from the cache
 */
public class CacheCleaner
implements Runnable
{
    /**
     * Parent directory of the cached files
     */
    private File cacheDir;

    private final static long EXPIRY = 1000 * 60 * 60 * 24 * 2; // 2 days

    /**
     * Create a cache under the Applications cache directory
     *
     * @param cacheDir to clean
     */
    protected CacheCleaner(File cacheDir)
    {
        this.cacheDir = cacheDir;
    }

    class Filter implements FileFilter
    {
        // To compare against
        private long now = 0;

        public Filter()
        {
            now = (new Date()).getTime();
        }

        /**
         * Indicating whether a specific file should be included in a pathname list.
         *
         * @param pathname the abstract file to check.
         * @return {@code true} if the file should be included, {@code false}
         *         otherwise.
         */
        @Override
        public boolean accept(File pathname) {
            if(pathname.isDirectory()) return false;
            long modified = pathname.lastModified();
            if(modified > now) return false;
            return (now - modified) > EXPIRY;
        }
    }

    /**
     * Starts executing the active part of the class' code. This method is
     * called when a thread is started that has been created with a class which
     * implements {@code Runnable}.
     */
    @Override
    public void run() {
        if(!cacheDir.isDirectory())
            return;

        // Cache instance is short-lived, so we only clean once when called
        int deleted = 0;
        for(File file : cacheDir.listFiles(new Filter()))
        {
            if(!file.delete())
                file.deleteOnExit();

            deleted++;
        }
        PlayHaven.d("%d files deleted from cache", deleted);
    }
}
