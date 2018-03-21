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

import java.lang.reflect.Field;

public class UnityCompat
    extends VendorCompat
{
    public UnityCompat(String vendorId)
    {
        super(vendorId);
    }

    private static final String r_styleable = ".R$styleable";

    public TypedArray obtainStyledAttributes(Context context, AttributeSet attrs, STYLEABLE styleable)
    {
        switch(styleable)
        {
            case com_playhaven_android_view_Badge:
            case com_playhaven_android_view_PlayHavenView:
                return context.obtainStyledAttributes(attrs, getResourceStyleableArray(context, styleable.name()), 0, 0);
            default:
                return null;
        }
    }

    public int getAttrId(Context context, ATTR attr)
    {
        return getResourceId(context, ResourceType.attr, attr.name());
    }

    public int getId(Context context, ID id)
    {
        /**
         * Unity needs to look up by string name
         */
        return getResourceId(context, ResourceType.id, id.name());
    }

    public int getResourceId(Context context, ID id)
    {
        return context.getResources().getIdentifier(id.name(), ResourceType.id.name(), context.getPackageName());
    }

    /**                                                                                                                               ul
     * Needed to allow wrapping with Unity 4.1.5 and below.
     * @param context of the application hosting the resources
     * @param name the name of the styleable to parse
     * @return the attrs identifiers of a declare-styleable element, or an empty array
     */
    private int[] getResourceStyleableArray(Context context, String name)
    {
        if(STYLEABLE.com_playhaven_android_view_PlayHavenView.toString().equals(name))
        {
            return new int[]{
                getAttrId(context, ATTR.com_playhaven_android_view_PlayHavenView_placementTag),
                getAttrId(context, ATTR.com_playhaven_android_view_PlayHavenView_cuDisplayOptions)
            };
        }

        if(STYLEABLE.com_playhaven_android_view_Badge.toString().equals(name))
        {
            return new int[]{
                getAttrId(context, ATTR.com_playhaven_android_view_Badge_placementTag),
                getAttrId(context, ATTR.com_playhaven_android_view_Badge_badgeTextColor)
            };
        }

        try {
            Field field = Class.forName(context.getPackageName() + r_styleable).getField(name);
            return (int[])field.get(null);
        } catch (Exception e) {
            PlayHaven.e(e);
        }
        return new int[0];
    }

}
