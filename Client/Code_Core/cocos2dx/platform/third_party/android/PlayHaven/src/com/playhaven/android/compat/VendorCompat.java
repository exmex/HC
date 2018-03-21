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
package com.playhaven.android.compat;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.R;

public class VendorCompat
{
    public enum LAYOUT
    {
        playhaven_activity,
        playhaven_overlay,
        playhaven_loadinganim,
        playhaven_exit,
        playhaven_dialog,
    }

    public enum DRAWABLE
    {
        playhaven_badge,
    }

    public enum ATTR
    {
        com_playhaven_android_view_PlayHavenView_placementTag,
        com_playhaven_android_view_PlayHavenView_cuDisplayOptions,
        com_playhaven_android_view_Badge_placementTag,
        com_playhaven_android_view_Badge_badgeTextColor,
    }

    public enum STYLEABLE
    {
        com_playhaven_android_view_Badge,
        com_playhaven_android_view_PlayHavenView,
    }

    public enum ID
    {
        playhaven_dialog_view,
        com_playhaven_android_view_Overlay,
        com_playhaven_android_view_LoadingAnimation,
        com_playhaven_android_view_Exit,
        com_playhaven_android_view_Exit_button,
        playhaven_activity_view
    }

    public enum ResourceType {
        string,
        layout,
        id,
        styleable,
        drawable,
        attr
    }

    private String vendorId;

    public VendorCompat(Context context, String vendorId)
    {
        // We don't need the context, just ignore it
        this(vendorId);
    }

    public VendorCompat(String vendorId)
    {
        if(vendorId != null || vendorId.length() > 0)
        {
            /**
             * Per http://tools.ietf.org/html/rfc3986#section-2.3
             * unreserved  = ALPHA / DIGIT / "-" / "." / "_" / "~"
             */
            String replacePattern = "[^A-Za-z0-9\\-\\.\\_\\~]*";

            /**
             * Replace all invalid characters
             * This works because we are saying to replace all characters that don't match
             */
            this.vendorId = vendorId.replaceAll(replacePattern, "");

        }

        if(this.vendorId == null || this.vendorId.length() == 0)
        {
            PlayHaven.v("vendorId has no valid characters in it. Using default.");
            this.vendorId = getClass().getSimpleName();
        }

        // Trim to size
        this.vendorId = this.vendorId.substring(0, Math.min(this.vendorId.length(), 42));
    }

    public String getVendorId(){return vendorId;}

    public int getLayoutId(Context context, LAYOUT layout)
    {
        return getResourceId(context, ResourceType.layout, layout.name());
    }

    public int getDrawableId(Context context, DRAWABLE drawable)
    {
        return getResourceId(context, ResourceType.drawable, drawable.name());
    }

    public int getAttrId(Context context, ATTR attr)
    {
        switch(attr)
        {
            case com_playhaven_android_view_PlayHavenView_cuDisplayOptions:
                return R.styleable.com_playhaven_android_view_PlayHavenView_cuDisplayOptions;
            case com_playhaven_android_view_PlayHavenView_placementTag:
                return R.styleable.com_playhaven_android_view_PlayHavenView_placementTag;
            case com_playhaven_android_view_Badge_placementTag:
                return R.styleable.com_playhaven_android_view_Badge_placementTag;
            case com_playhaven_android_view_Badge_badgeTextColor:
                return R.styleable.com_playhaven_android_view_Badge_badgeTextColor;
            default:
                return getResourceId(context, ResourceType.attr, attr.name());
        }
    }

    public int getId(Context context, ID id)
    {
        /**
         * Unity needs to look up by string name
         * If not Unity, this will give us better performance
         */
        switch(id)
        {
            case com_playhaven_android_view_Exit:
                return R.id.com_playhaven_android_view_Exit;
            case com_playhaven_android_view_Exit_button:
                return R.id.com_playhaven_android_view_Exit_button;
            case com_playhaven_android_view_Overlay:
                return R.id.com_playhaven_android_view_Overlay;
            case com_playhaven_android_view_LoadingAnimation:
                return R.id.com_playhaven_android_view_LoadingAnimation;
            default:
                return getResourceId(context, ResourceType.id, id.name());
        }
    }

    /**
     * @param context
     * @param type the ResourceType wanted
     * @param name the name of the wanted resource
     * @return the resource id for a given resource
     */
    public int getResourceId(Context context, ResourceType type, String name)
    {
        return context.getResources().getIdentifier(name, type.name(), context.getPackageName());
    }

    public TypedArray obtainStyledAttributes(Context context, AttributeSet attrs, STYLEABLE styleable)
    {
        switch(styleable)
        {
            case com_playhaven_android_view_Badge:
                return context.obtainStyledAttributes(attrs, R.styleable.com_playhaven_android_view_Badge, 0, 0);
            case com_playhaven_android_view_PlayHavenView:
                return context.obtainStyledAttributes(attrs, R.styleable.com_playhaven_android_view_PlayHavenView, 0, 0);
            default:
                return null;
        }
    }
}
