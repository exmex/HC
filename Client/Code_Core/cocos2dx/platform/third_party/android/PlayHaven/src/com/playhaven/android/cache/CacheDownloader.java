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
import com.playhaven.android.PlayHavenException;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.ByteBuffer;
import java.nio.channels.Channels;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.WritableByteChannel;

/**
 * Download an external file to store in the cache
 */
public class CacheDownloader implements Runnable
{
    /**
     * Amount to copy at a time
     */
    private static final int BLOCK_SIZE = 4096;

    /**
     * The URL to download
     */
    private URL url;

    /**
     * The handler to notify on success or failure
     */
    private CacheResponseHandler handler;

    /**
     * The file to populate from the URL
     */
    private File file;

    /**
     * Create a new cache downloader
     *
     * @param url to download
     * @param handler to notify of success or failure
     * @param file to populate from the URL
     */
    public CacheDownloader(String url, CacheResponseHandler handler, File file) throws MalformedURLException {
        this(new URL(url), handler, file);
    }

    /**
     * Create a new cache downloader
     *
     * @param url to download
     * @param handler to notify of success or failure
     * @param file to populate from the URL
     */
    public CacheDownloader(URL url, CacheResponseHandler handler, File file)
    {
        this.url = url;
        this.handler = handler;
        this.file = file;
    }

    /** {@inheritDoc}
     */
    @Override
    public void run() {
        try{
            PlayHaven.v("Caching %s", url);

            /**
             * Start by making sure the destination directory exists
             */
            File parentFile = file.getParentFile();
            if(parentFile != null)
            {
                if(!(parentFile.mkdirs() || parentFile.isDirectory()))
                    throw new IOException("Unable to create directory: " + parentFile.getAbsolutePath());
            }

            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            /**
             * Use non-blocking IO for (hopefully) better performance
             */
            ReadableByteChannel in = Channels.newChannel(connection.getInputStream());
            WritableByteChannel out = Channels.newChannel(new FileOutputStream(file));
            ByteBuffer buffer = ByteBuffer.allocateDirect(BLOCK_SIZE);

            /**
             * Reads bytes from the channel into the given buffer.
             * @see ReadableByteChannel#read(java.nio.ByteBuffer)
             */
            while( in.read(buffer) != -1 )
            {
                /**
                 * The limit is set to the current position, then the position is set to zero, and the mark is cleared.
                 * @see java.nio.ByteBuffer#flip()
                 */
                buffer.flip();

                /**
                 * Writes bytes from the given buffer to the channel.
                 * @see WritableByteChannel#write
                 */
                out.write(buffer);

                /**
                 * The remaining bytes will be moved to the head of the buffer, starting from position zero.
                 * Then the position is set to remaining(); the limit is set to capacity; the mark is cleared.
                 * @see java.nio.ByteBuffer#compact()
                 */
                buffer.compact();
            }

            /**
             * make sure completely drained
             */
            buffer.flip();
            while(buffer.hasRemaining())
                out.write(buffer);

            /**
             * And clean up references
             */
            out.close();
            in.close();
            handler.cacheSuccess(new CachedInfo(url, file, true));
        }catch(PlayHavenException e){
            handler.cacheFail(url, e);
        }catch(IOException e2){
            handler.cacheFail(url, new PlayHavenException("Unable to obtain content: " + url.toExternalForm(), e2));
        } catch (Exception e3) {
            handler.cacheFail(url, new PlayHavenException("Unable to obtain content: " + url.toExternalForm(), e3.getMessage()));
        }
    }
}
