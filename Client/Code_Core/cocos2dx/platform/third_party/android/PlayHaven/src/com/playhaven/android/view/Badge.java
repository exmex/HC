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
import android.graphics.*;
import android.graphics.drawable.Drawable;
import android.os.Handler;
import com.jayway.jsonpath.JsonPath;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.compat.VendorCompat;
import com.playhaven.android.req.MetadataRequest;
import com.playhaven.android.req.RequestListener;
import com.jayway.jsonpath.InvalidPathException;
import com.playhaven.android.util.JsonUtil;

import static com.playhaven.android.compat.VendorCompat.DRAWABLE.playhaven_badge;

/**
 * A Badge
 */
public class Badge
extends Drawable implements RequestListener {
    /**
     * Default color of the numeric display
     */
    protected static int DEFAULT_TEXT_COLOR = Color.WHITE;

    /**
     * Handler for posting to the UI thread
     */
    private Handler handler;

    /**
     * Placement tag as displayed in the Dashboard
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    private String placementTag;

    /**
     * Background image for the badge
     */
    private Drawable background;

    /**
     * Text color for the number on the badge
     */
    private int textColor = DEFAULT_TEXT_COLOR;

    /**
     * Badge number from server model
     */
    private String badgeNum = null;

    /**
     * Size of the Badge
     */
    private int size = 30;

    /**
     * Vendor compat lib for wrappers
     */
    private VendorCompat compat;

    /**
     * Construct a Badge (the number on the circle)
     *
     * @param context of the application
     * @param placementTag to request against
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Badge(Context context, String placementTag)
    {
        super();
        handler = new Handler();
        compat = PlayHaven.getVendorCompat(context);

        // We must explicitely set the bounds
        setBounds(0, 0, size, size);

        this.placementTag = placementTag;
        int drawableId = compat.getDrawableId(context, playhaven_badge);
        background = context.getResources().getDrawable(drawableId);
    }

    /**
     * Load the metadata
     *
     * @param context of the application
     */
    public void load(Context context)
    {
        MetadataRequest req = new MetadataRequest(placementTag);
        req.setResponseHandler(this);
        req.send(context);
    }

    /**
     * Set the text color of the numeric display on the badge
     *
     * @param color for the text
     */
    public void setTextColor(int color)
    {
        this.textColor = color;
        invalidateSelf();
    }

    /**
     * Draw the badge
     *
     * @param canvas to draw on
     */
    @Override
    public void draw(Canvas canvas) {
        if(background == null || badgeNum == null) return;

        /**
         * Don't use the canvas.getWidth() or canvas.getHeight()
         * as that size is too large (button's size?)
         */
        int width = getBounds().width();
        int height = getBounds().height();

        background.setBounds(0, 0, width, height);
        background.draw(canvas);

        Paint paint = new Paint();
        paint.setColor(textColor);
        paint.setTextAlign(Paint.Align.CENTER);
        paint.setAntiAlias(true);
        paint.setTypeface(Typeface.create(Typeface.SERIF, Typeface.BOLD));

//        paint.setTextSize();

        /**
         * canvas.drawText will draw the text on the baseline. What that means is that the text itself
         * will sit ABOVE the y coordinate specified.
         *
         * To fix that, we will specify that we want to move the text downwards 1/2 the text height
         */
        Rect bounds = new Rect();
        paint.getTextBounds(badgeNum, 0, badgeNum.length(), bounds);
        canvas.drawText(badgeNum, width/2, (height/2) + (bounds.height() / 2), paint);
    }

    /**
     * Ignored
     *
     * @param alpha to set
     */
    @Override
    public void setAlpha(int alpha) {
        /* no-op */
    }

    /**
     * Ignored
     *
     * @param cf to set
     */
    @Override
    public void setColorFilter(ColorFilter cf) {
        /* no-op */
    }

    /**
     * Retrieve the opacity
     *
     * @return opacity
     */
    @Override
    public int getOpacity() {
        return PixelFormat.OPAQUE;
    }

    /**
     * Force redraw
     */
    protected void invalidateOnUiThread()
    {
        handler.post(new Runnable() {
            @Override
            public void run() {
                invalidateSelf();
            }
        });
    }

    /**
     * Handle the databound model returned from the server call
     *
     * @param context of the request
     * @param json response from the server
     */
    @Override
    public void handleResponse(Context context, String json) {
        try{
            String text = JsonUtil.getPath(json, "$.response.notification.value");
            if(text == null || text.length() == 0) return;

            this.badgeNum = text;
            invalidateOnUiThread();
        }catch(InvalidPathException e){
            /**
             * If no metadata is returned, don't update the UI
             */
        }
    }

    /**
     * Handle the exception that occurred while trying to retrieve the model from the server
     *
     * @param context of the request
     * @param e that occurred
     */
    @Override
    public void handleResponse(Context context, PlayHavenException e) {
        this.badgeNum = null;
        invalidateOnUiThread();
    }
}
