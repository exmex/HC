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

import java.util.Date;
import java.util.TimeZone;

/**
 * Format TimeZones for server requests
 */
public class TimeZoneFormatter
{
    private static final float ONE_SECOND_IN_MS = 1000;
    private static final float ONE_MINUTE_IN_MS = ONE_SECOND_IN_MS * 60;
    private static final float ONE_HOUR_IN_MS = ONE_MINUTE_IN_MS * 60;

    public static String getDefaultTimezone()
    {
        return formatTimezone(TimeZone.getDefault());
    }

    public static String getTimezone(String id)
    {
        return formatTimezone(TimeZone.getTimeZone(id));
    }

    protected static String formatTimezone(TimeZone tz)
    {
        Date now = new Date();
        float offset = (float)tz.getOffset(now.getTime()) / ONE_HOUR_IN_MS;
        int hours = (int)offset;
        int minutes = (offset - hours == 0) ? 0 : 30;
        return String.format("%d.%02d", hours, minutes);
    }
}
