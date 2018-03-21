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

import static com.playhaven.android.compat.VendorCompat.ATTR.com_playhaven_android_view_PlayHavenView_cuDisplayOptions;
import static com.playhaven.android.compat.VendorCompat.ATTR.com_playhaven_android_view_PlayHavenView_placementTag;
import static com.playhaven.android.compat.VendorCompat.ID.com_playhaven_android_view_Exit;
import static com.playhaven.android.compat.VendorCompat.ID.com_playhaven_android_view_Exit_button;
import static com.playhaven.android.compat.VendorCompat.ID.com_playhaven_android_view_LoadingAnimation;
import static com.playhaven.android.compat.VendorCompat.ID.com_playhaven_android_view_Overlay;
import static com.playhaven.android.compat.VendorCompat.LAYOUT.playhaven_exit;
import static com.playhaven.android.compat.VendorCompat.LAYOUT.playhaven_loadinganim;
import static com.playhaven.android.compat.VendorCompat.LAYOUT.playhaven_overlay;

import android.os.Build;
import android.util.Log;
import android.view.*;
import android.webkit.WebView;
import android.widget.ImageView;
import android.content.Context;
import android.content.res.TypedArray;
import android.os.Bundle;
import android.util.AttributeSet;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;

import com.playhaven.android.Placement;
import com.playhaven.android.PlacementListener;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.compat.VendorCompat;
import com.playhaven.android.util.MemoryReporter;

/**
 * A PlayHaven container view.  This view wraps the logic
 * of talking to the server, downloading the content and
 * displaying the advertisement.
 */
public class PlayHavenView
extends FrameLayout
implements PlacementListener, FrameManager
{
    /** Bundle extra parameter for the placement tag (also used for dataUri) */
    public static final String BUNDLE_PLACEMENT_TAG = "placementTag";

    /** Bundle extra parameter for the display options (also used for dataUri) */
    public static final String BUNDLE_DISPLAY_OPTIONS = "displayOptions";

    /** Bundle extra parameter for the Placement object (not used for the dataUri) */
    public static final String BUNDLE_PLACEMENT = "placement";

    /** Bundle extra parameter for dismiss type */
    public static final String BUNDLE_DISMISS_TYPE = "dismissType";

    /** Bundle extra parameter for any exceptions */
    public static final String BUNDLE_EXCEPTION = "exception";

    /** Bundle extra parameter for data */
    public static final String BUNDLE_DATA = "data";

    /** Bundle parameter for reward data */
    public static final String BUNDLE_DATA_REWARD = "data.reward";

    /** Bundle parameter for puchase data */
    public static final String BUNDLE_DATA_PURCHASE = "data.purchase";

    /** Bundle parameter for opt-in data */
    public static final String BUNDLE_DATA_OPTIN = "data.optin";

    /** NO Display Options */
    public static final int NO_DISPLAY_OPTIONS = 0x00;

    /** AUTO Display Options */
    public static final int AUTO_DISPLAY_OPTIONS = 0x01;

    /** Show an overlay over the content */
    public static final int DISPLAY_OVERLAY = 0x02;

    /** Show a loading animation */
    public static final int DISPLAY_ANIMATION = 0x04;

    /** Notification listener */
    private PlayHavenListener phListener;

    /**
     * How the view was dismissed
     */
    public enum DismissType {
        /** The user clicks the emergency close button. */
        Emergency,
        /** The user clicks the HTML button to dismiss. */
        NoThanks,
        /** The user chooses to get something we've offered. */
        Launch,
        /** The view closed itself due to some error. */
        SelfClose,
        /** Back button was pressed */
        BackButton,
        /** Reward collected */
        Reward,
        /** Purchase clicked */
        Purchase,
        /** Opt-In data submitted */
        OptIn
    }

    /**
     * Placement by ID as displayed in the Dashboard
     *
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    private Placement placement;

    /**
     * Display options
     */
    private int displayOptions;

    /**
     * Vendor compat lib for wrappers
     */
    private VendorCompat compat;

    /**
     * Child View that contains the content units
     */
    private ChildView<? extends View> childView;

    /**
     * Allow views to control how wrapping frames are resized.
     */
    private FrameManager frameMgr = this;

    /**
     * Simple constructor to use when creating a PlayHavenView from code.
     *
     * @param context The Context the view is running in, through which it can
     *        access the current theme, resources, etc.
     */
    public PlayHavenView(Context context) {
        super(context);
        compat = PlayHaven.getVendorCompat(context);
        createLayers();
    }

    /**
     * Constructor that is called when inflating a PlayHavenView from XML. This is called
     * when a PlayHavenView is being constructed from an XML file, supplying attributes
     * that were specified in the XML file. This version uses a default style of
     * 0, so the only attribute values applied are those in the Context's Theme
     * and the given AttributeSet.
     *
     * <p>
     * The method onFinishInflate() will be called after all children have been
     * added.
     *
     * @param context The Context the view is running in, through which it can
     *        access the current theme, resources, etc.
     * @param attrs The attributes of the XML tag that is inflating the view.
     * @see View#View(Context, AttributeSet, int)
     */
    public PlayHavenView(Context context, AttributeSet attrs)
    {
        super(context, attrs);
        compat = PlayHaven.getVendorCompat(context);
        createLayers();

        TypedArray arr = compat.obtainStyledAttributes(context, attrs, VendorCompat.STYLEABLE.com_playhaven_android_view_PlayHavenView);
        try {
            int viewStyleIdTag = compat.getAttrId(context, com_playhaven_android_view_PlayHavenView_placementTag);
            int displayOptsId = compat.getAttrId(context, com_playhaven_android_view_PlayHavenView_cuDisplayOptions);

            setPlacementTag(arr.getString(viewStyleIdTag));
            setDisplayOptions(arr.getInteger(displayOptsId, AUTO_DISPLAY_OPTIONS));
        } finally {
            arr.recycle();
        }
    }

    /**
     * Create an exit handler
     *
     * @return the exit onclick listener
     */
    protected OnClickListener createExitListener()
    {
        return new OnClickListener() {
            @Override
            public void onClick(android.view.View v) {
                dismissView(DismissType.Emergency);
            }
        };
    }

    /**
     * Create the different display layers
     */
    protected void createLayers()
    {
        MemoryReporter.report();

        int overlayId = compat.getLayoutId(getContext(), playhaven_overlay);
        int animationId = compat.getLayoutId(getContext(), playhaven_loadinganim);
        int exitId = compat.getLayoutId(getContext(), playhaven_exit);
        int exitBtnId = compat.getId(getContext(), com_playhaven_android_view_Exit_button);
        if(overlayId <= 0 || animationId <= 0 || exitId <= 0 || exitBtnId <= 0)
        {
            failView(new PlayHavenException("createLayers was unable to locate a resource: %d / %d / %d / %d", overlayId, animationId, exitId, exitBtnId));
            return;
        }

        setMeasureAllChildren(true);

        LayoutInflater inflater = (LayoutInflater)getContext().getSystemService(Context.LAYOUT_INFLATER_SERVICE);

        // Bottom Layer is the Overlay
        LinearLayout overlay = (LinearLayout)inflater.inflate(overlayId, null);
        overlay.setVisibility(GONE);
        addView(overlay);

        // Next Layer is the Animation
        RelativeLayout animation = (RelativeLayout)inflater.inflate(animationId, null);
        animation.setVisibility(GONE);
        addView(animation);

        // Then the content unit
        addView(new android.view.View(getContext()));

        // Then the top Layer is the close button
        LinearLayout exit = (LinearLayout)inflater.inflate(exitId, null);
        exit.setVisibility(VISIBLE);
        ImageView exitBtn = (ImageView) exit.findViewById(exitBtnId);
        exitBtn.setOnClickListener(createExitListener());
        addView(exit);
    }

    /**
     * Retrieve the placement tag
     */
    public String getPlacementTag()
    {
        return (placement == null ? null : placement.getPlacementTag());
    }

    /**
     * Set the placement as configured in the Dashboard
     *
     * @param placementTag to display
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void setPlacementTag(String placementTag)
    {
        if(placementTag == null) return;

        setPlacement(new Placement(placementTag));
        PlayHaven.d("placementTag = %s", placementTag);
    }

    /**
     * Retrieve the placement
     */
    public Placement getPlacement()
    {
        return placement;
    }

    /**
     * Set the placement as configured in the Dashboard
     *
     * @param placement to display
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void setPlacement(Placement placement)
    {
        this.placement = placement;

        if(placement.isLoaded() && placement.isEmpty())
            placement.reset();

        placement.setListener(this);
        if(placement.isDisplayable())
        {
            if(isAutoDisplayOptionSet())
                setDisplayOptions(NO_DISPLAY_OPTIONS);

            contentLoaded(placement);
        }else if(placement.isLoading()){
            if(isAutoDisplayOptionSet())
                setDisplayOptions(DISPLAY_ANIMATION | DISPLAY_OVERLAY);

            updateLoading();
        }else if(!placement.isLoaded()){
            if(isAutoDisplayOptionSet())
                setDisplayOptions(DISPLAY_ANIMATION | DISPLAY_OVERLAY);

            placement.preload(getContext());
        }
    }

    /**
     * Reload the current placement
     */
    public void reload()
    {
        setPlacementTag(getPlacementTag());
    }

    /**
     * Retrieve the display options
     *
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#NO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_OVERLAY
     * @see PlayHavenView#DISPLAY_ANIMATION
     */
    public int getDisplayOptions()
    {
        return displayOptions;
    }

    /**
     * Set the display options
     *
     * @param displayOptions to use
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#NO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_OVERLAY
     * @see PlayHavenView#DISPLAY_ANIMATION
     */
    public void setDisplayOptions(int displayOptions)
    {
        this.displayOptions = displayOptions;
        PlayHaven.v(
            "displayOptions = %d (%s %s)",
            displayOptions,
            (isAnimationSet() ? "animation":""),
            (isOverlaySet() ? "overlay" : "")
        );

        updateLoading();
    }

    /**
     * Check whether PlayHavenView#AUTO_DISPLAY_OPTIONS is set
     *
     * @return true if PlayHavenView#AUTO_DISPLAY_OPTIONS is set
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     */
    protected boolean isAutoDisplayOptionSet()
    {
        return (displayOptions | AUTO_DISPLAY_OPTIONS) == displayOptions;
    }

    /**
     * Check whether PlayHavenView#DISPLAY_ANIMATION is set
     *
     * @return true if PlayHavenView#DISPLAY_ANIMATION is set or if PlayHavenView#AUTO_DISPLAY_OPTIONS is set and has determined that the animations should be enabled
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_ANIMATION
     */
    public boolean isAnimationSet()
    {
        return (displayOptions | DISPLAY_ANIMATION) == displayOptions;
    }

    /**
     * Check whether PlayHavenView#DISPLAY_OVERLAY is set
     *
     * @return true if PlayHavenView#DISPLAY_OVERLAY is set or if PlayHavenView#AUTO_DISPLAY_OPTIONS is set and has determined that the overlay should be enabled
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_OVERLAY
     */
    public boolean isOverlaySet()
    {
        return (displayOptions | DISPLAY_OVERLAY) == displayOptions;
    }

    /**
     * This is called when the view is attached to a window. At this point it has a Surface and will start drawing.
     */
    @Override
    protected void onAttachedToWindow() {
        super.onAttachedToWindow();
        updateLoading();
    }

    /**
     * Update the visibility of the layers based on the placement status
     */
    private void updateLoading()
    {
        if(placement != null && placement.isLoading())
        {
            setOverlayVisible(isOverlaySet());
            setAnimationVisible(isAnimationSet());
            setExitVisible(true);
        }
    }

    /**
     * Change the visibility of the overlay layer
     *
     * @param visible if the overlay should be visible
     */
    protected void setOverlayVisible(final boolean visible)
    {
        int overlayId = compat.getId(getContext(), com_playhaven_android_view_Overlay);
        final android.view.View overlay = findViewById(overlayId);
        post(new Runnable(){
            @Override
            public void run() {
                overlay.setVisibility(visible ? VISIBLE : GONE);
            }
        });
    }

    /**
     * Change the visibility of the animation layer
     *
     * @param visible if the animation should be visible
     */
    protected void setAnimationVisible(final boolean visible)
    {
        int animationId = compat.getId(getContext(), com_playhaven_android_view_LoadingAnimation);
        final android.view.View animation = findViewById(animationId);
        post(new Runnable() {
            @Override
            public void run() {
                animation.setVisibility(visible ? VISIBLE : GONE);
            }
        });
    }

    /**
     * Change the visibility of the exit button layer
     *
     * @param visible if the exit button should be visible
     */
    protected void setExitVisible(final boolean visible)
    {
        int exitViewId = compat.getId(getContext(), com_playhaven_android_view_Exit);
        final android.view.View exit = findViewById(exitViewId);
        post(new Runnable() {
            @Override
            public void run() {
                exit.setVisibility(visible ? VISIBLE : GONE);
            }
        });
    }

    /**
     * Notify the listener, if any, that the view failed to load
     *
     * @param e that prevented loading of the view
     */
    protected void failView(PlayHavenException e)
    {
        PlayHaven.e(e);

        if(phListener != null)
            phListener.viewFailed(this, e);
    }

    /**
     * Retrieve the listener to be notified of view dismissal
     *
     * @return the listener
     */
    public PlayHavenListener getPlayHavenListener() {
        return phListener;
    }

    /**
     * Set the listener to be notified of view dismissal
     *
     * @param listener to set
     */
    public void setPlayHavenListener(PlayHavenListener listener) {
        this.phListener = listener;
    }

    /**
     * Allow views to control how wrapping frames are resized.
     *
     * @param frameMgr to control the frame updates
     */
    protected void setFrameManager(FrameManager frameMgr)
    {
        this.frameMgr = frameMgr;
    }

    @Override
    public void updateFrame() {
        /**
         * Windowed and FullScreen have their own method for handling this functionality.
         * Default behavior is for Embedded View (aka bare)
         * In this state, the publisher is specifically (and manually) setting a size on us
         * so we do not want to resize...  We can't even make assumptions about rotation since that might
         * be a completely different layout file.
         */
    }

    /**
     * Content was loaded successfully
     *
     * @param placement to load
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    @Override
    @SuppressWarnings("unchecked")
    public void contentLoaded(final Placement placement) 
    {
        setAnimationVisible(false);
        setOverlayVisible(false);
//      setExitVisible(false);

        post(new Runnable() {
            @Override
            public void run() {

                // If necessary, resize before giving the webview a chance to measure anything
                if(frameMgr != null) frameMgr.updateFrame();

                /**
                 * Do we load a native view or an html view?  Deciding factors:
                 * Did the server send only one of the URLs?
                 * Do we have a native/html version of that particular content template?
                 * Is our size better for native or html?
                 * Is this a 3rd party provided ad?
                 * Does native or html work better for this particular content template?
                 *
                 * Currently, native views are not enabled, so we will default to the HTMLView
                 */

                /**
                 * @playhaven.apihack if on KitKat+, enable Remote Webview Debugging via Chrome
                 * https://developers.google.com/chrome-developer-tools/docs/remote-debugging
                 */
                if(Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT)
                    WebView.setWebContentsDebuggingEnabled(PlayHaven.isLoggable(Log.DEBUG));

                childView = new HTMLView(getContext());
                childView.setPlacement(placement);

                /**
                 * 0 is overlay layer
                 * 1 is animation layer
                 * 2 is Native/Web PlayHavenView
                 * 3 is exit button layer
                 */
                removeViews(2, 1);

                ((android.view.View) childView).setVisibility(android.view.View.INVISIBLE);
                addView((android.view.View)childView, 2);
            }
        });
    }

	/**
     * Content failed to load successfully
     *
     * @param placement that was attempted
     * @param e containing the error that prevented loading
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    @Override
    public void contentFailed(Placement placement, PlayHavenException e) {
        failView(e);
    }

    /**
     * The content was dismissed
     *
     * @param placement that was dismissed
     * @param dismissType how it was dismissed
     * @param data additional data, depending on the content type
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     * @see com.playhaven.android.data.Purchase
     * @see com.playhaven.android.data.Reward
     * @see com.playhaven.android.data.DataCollectionField
     */
    @Override
    public void contentDismissed(Placement placement, DismissType dismissType, Bundle data) {
        if(phListener != null)
            phListener.viewDismissed(this, dismissType, data);
    }

    protected void dismissView(DismissType dismissType)
    {
        if(phListener == null) return;
        Bundle bundle = null;
        if(childView != null)
            bundle = childView.generateResponseBundle();

        phListener.viewDismissed(this, dismissType, bundle);
    }

    /**
     * This is called when the view is detached from a window. At this point it no longer has a surface for drawing.
     */
    @Override
    protected void onDetachedFromWindow() {
        MemoryReporter.report();
        super.onDetachedFromWindow();
    }
}
