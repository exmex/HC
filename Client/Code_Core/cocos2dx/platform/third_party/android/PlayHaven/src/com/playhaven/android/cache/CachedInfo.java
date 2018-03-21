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

import java.io.File;
import java.net.URL;

/**
 * Holds information regarding cached content
 */
public class CachedInfo
{
    // Requested content
    private URL url;

    // Downloaded content
    private File file;

    // True if the content was freshly downloaded; false if we already had it
    private boolean newlyDownloaded;

    /**
     * Create a new CachedInfo
     *
     * @param url of the requested content
     * @param file of the downloaded content
     * @param newlyDownloaded true if the content was freshly downloaded; false if we already had it
     */
    public CachedInfo(URL url, File file, boolean newlyDownloaded)
    {
        this.url = url;
        this.file = file;
        this.newlyDownloaded = newlyDownloaded;
    }

    /**
     * @return requested content url
     */
    public URL getURL() {
        return url;
    }

    /**
     * @return downloaded content
     */
    public File getFile() {
        return file;
    }

    /**
     * @return true if the content was freshly downloaded; false if we already had it
     */
    public boolean isNewlyDownloaded() {
        return newlyDownloaded;
    }
}
