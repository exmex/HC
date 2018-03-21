/**
 * Copyright 2014 Medium Entertainment, Inc.
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

import android.content.Context;
import android.graphics.Point;
import android.os.Build;
import android.util.Log;
import android.view.Display;
import android.view.WindowManager;

public class DisplayUtil
{
    public static Display getDisplay(Context context)
    {
        return ((WindowManager) context.getSystemService(Context.WINDOW_SERVICE)).getDefaultDisplay();
    }

    public static Point getScreenSize(Context context)
    {
        Display display = getDisplay(context);
        Point size = new Point();
        // @playhaven.apihack getWidth/getHeight were deprecated in API 13
        if(Build.VERSION.SDK_INT >= 13)
        {
            display.getSize(size);
        }else{
            size.x = display.getWidth();
            size.y = display.getHeight();
        }

        return size;
    }

    public static boolean isPortrait(Context context)
    {
        Display display = getDisplay(context);
        /**
         * We can't use display.getRotation() because:
         * 1) gingerbread always returned 0
         * 2) Xoom2 and other tablets are 90* off of the phones
         */
        Point size = getScreenSize(context);
        return (size.x <= size.y);
    }
}
