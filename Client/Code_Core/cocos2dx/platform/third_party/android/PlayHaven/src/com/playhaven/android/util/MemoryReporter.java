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
package com.playhaven.android.util;

import android.util.Log;
import com.playhaven.android.PlayHaven;

/**
 * Report memory utilization
 */
public class MemoryReporter
{
    enum Size
    {
        /** Bytes */
        B("%f bytes"),
        /** Kilobytes */
        KB("%1.2f KB"),
        /** Megabytes */
        MB("%1.2f MB"),
        /** Gigabytes */
        GB("%1.2f GB");
        Size(String format)
        {
            bytes = Math.pow(1024, ordinal());
            this.format = format;
        }
        protected double bytes = -1;
        protected String format = null;
    }

    private static String normalize(double bytesToReport)
    {
        int length = Size.values().length;
        for(int i=length; i>0; i--)
        {
            Size size = Size.values()[i-1];

            if(bytesToReport >= size.bytes)
                return String.format(size.format, bytesToReport/size.bytes);
        }

        return "" + bytesToReport; // should never get here
    }

    /**
     * Log to the VERBOSE log level if enabled
     *
     * @see PlayHaven#TAG
     */
    public static void report()
    {
        long totalMemory = Runtime.getRuntime().totalMemory();
        long freeMemory = Runtime.getRuntime().freeMemory();
        long usedMemory = totalMemory - freeMemory;
        PlayHaven.v("Memory [Total: %s] [Free: %s] [Used: %s]", normalize(totalMemory), normalize(freeMemory), normalize(usedMemory));
    }

    /**
     * Log to the VERBOSE log level with the specified tag
     *
     * @param tag to log against
     */
    public static void report(String tag)
    {
        report(tag, null);
    }

    /**
     * Log to the VERBOSE log level with the specified tag
     *
     * @param tag to log against
     * @param optional addendum
     */
    public static void report(String tag, String optional)
    {
        long totalMemory = Runtime.getRuntime().totalMemory();
        long freeMemory = Runtime.getRuntime().freeMemory();
        long usedMemory = totalMemory - freeMemory;
        String addendum = (optional == null ? "" : optional);
        Log.v(tag, String.format("Memory [Total: %s] [Free: %s] [Used: %s] %s", normalize(totalMemory), normalize(freeMemory), normalize(usedMemory), addendum));
    }
}
