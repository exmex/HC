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
package com.playhaven.android.view;

import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.widget.Button;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.compat.VendorCompat;


/**
 * More Games button
 */
public class MoreGames
extends Button
{
    /**
     * Badge to attach to the button
     */
    private Badge badge;

    /**
     * Construct a MoreGames button
     *
     * @param context The Context the view is running in, through which it can
     *        access the current theme, resources, etc.
     * @see android.view.View#View(Context)
     */
    public MoreGames(Context context) {
        super(context);
    }

    /**
     * Construct a MoreGames button
     *
     * @param context The Context the view is running in, through which it can
     *        access the current theme, resources, etc.
     * @param attrs The attributes of the XML tag that is inflating the view.
     * @see android.view.View#View(Context, AttributeSet)
     */
    public MoreGames(Context context, AttributeSet attrs) {
        super(context, attrs);

        VendorCompat compat = PlayHaven.getVendorCompat(context);
        TypedArray arr = compat.obtainStyledAttributes(context, attrs, VendorCompat.STYLEABLE.com_playhaven_android_view_Badge);
        try {
        	int badgeStyleableId = compat.getAttrId(context, VendorCompat.ATTR.com_playhaven_android_view_Badge_placementTag);
        	int badgeColorId = compat.getAttrId(context, VendorCompat.ATTR.com_playhaven_android_view_Badge_badgeTextColor);

        	setPlacementTag(arr.getString(badgeStyleableId));
            setTextColor(arr.getColor(badgeColorId, Badge.DEFAULT_TEXT_COLOR));
        } finally {
            arr.recycle();
        }
    }
    
    

    /**
     * Construct a MoreGames button
     *
     * @param context The Context the view is running in, through which it can
     *        access the current theme, resources, etc.
     * @param attrs The attributes of the XML tag that is inflating the view.
     * @param defStyle default style
     * @see android.view.View#View(Context, AttributeSet, int)
     */
    public MoreGames(Context context, AttributeSet attrs, int defStyle) {
        super(context, attrs, defStyle);

        VendorCompat compat = PlayHaven.getVendorCompat(context);
        TypedArray arr = compat.obtainStyledAttributes(context, attrs, VendorCompat.STYLEABLE.com_playhaven_android_view_Badge);
        try {
            int badgeStyleableId = compat.getAttrId(context, VendorCompat.ATTR.com_playhaven_android_view_Badge_placementTag);
            int badgeColorId = compat.getAttrId(context, VendorCompat.ATTR.com_playhaven_android_view_Badge_badgeTextColor);

        	setPlacementTag(arr.getString(badgeStyleableId));
            setTextColor(arr.getColor(badgeColorId, Badge.DEFAULT_TEXT_COLOR));
        } finally {
            arr.recycle();
        }
    }

    /**
     * Set the placement tag as specified in the Dashboard
     *
     * @param placementTag to request from
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void setPlacementTag(String placementTag)
    {
        this.badge = new Badge(getContext(), placementTag);
        setCompoundDrawables(null, null, badge, null);
    }

    /**
     * Set the text color of the numeric display on the badge
     *
     * @param color for the text
     */
    public void setTextColor(int color)
    {
        if(badge != null)
            badge.setTextColor(color);
    }

    /**
     * Load the metadata
     *
     * @param context of the application
     */
    public void load(Context context)
    {
        if(badge != null)
            badge.load(context);
    }
}
