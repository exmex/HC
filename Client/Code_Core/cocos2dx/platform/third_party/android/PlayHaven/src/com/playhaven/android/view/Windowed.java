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

import android.app.Dialog;
import android.content.Context;
import android.graphics.Point;
import android.os.Build;
import android.os.Bundle;
import android.util.DisplayMetrics;
import android.view.OrientationEventListener;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
import com.playhaven.android.Placement;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.compat.VendorCompat;
import com.playhaven.android.util.DisplayUtil;
import com.playhaven.android.util.JsonUtil;
import net.minidev.json.JSONObject;

import static com.playhaven.android.compat.VendorCompat.ID.playhaven_dialog_view;
import static com.playhaven.android.compat.VendorCompat.LAYOUT.playhaven_dialog;

/**
 * Displays a PlayHaven content unit in a dialog
 */
public class Windowed
extends Dialog
implements PlayHavenListener, FrameManager {
    private static final int DEFAULT_THEME = android.R.style.Theme_Translucent_NoTitleBar;
    private PlayHavenListener phListener;
    private PlayHavenView playHavenView;
    private OrientationEventListener orientation;

    /**
     * Construct a Windowed dialog, using the default theme
     *
     * @param context of the application
     */
    public Windowed(Context context) {
        this(context, (String)null, null, DEFAULT_THEME);
    }

    /**
     * Construct a Windowed dialog using the specified theme
     * @param context of the application
     * @param theme A style resource describing the theme to use for the window. See Style and Theme Resources for more information about defining and using styles. This theme is applied on top of the current theme in context. If 0, the default dialog theme will be used.
     */
    public Windowed(Context context, int theme) {
        this(context, (String)null, null, theme);
    }

    /**
     * Construct a Windowed dialog with a PlayHavenListener to listen for view dismissal
     *
     * @param context of the application
     * @param listener to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Windowed(Context context, PlayHavenListener listener)
    {
        this(context, (String)null, listener, DEFAULT_THEME);
    }

    /**
     * Construct a Windowed dialog with the placement as specified in the Dashboard.
     *
     * @param context of the application
     * @param placement to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Windowed(Context context, Placement placement)
    {
        this(context, placement, null, DEFAULT_THEME);
    }

    /**
     * Construct a Windowed dialog with the placement as specified in the Dashboard.
     *
     * @param context of the application
     * @param placementTag to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Windowed(Context context, String placementTag)
    {
        this(context, placementTag, null, DEFAULT_THEME);
    }

    /**
     * Construct a Windowed dialog with the placement as specified in the Dashboard,
     * with a PlayHavenListener to listen for view dismissal
     *
     * @param context of the application
     * @param placement to set
     * @param listener to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Windowed(Context context, Placement placement, PlayHavenListener listener)
    {
        this(context, placement, listener, DEFAULT_THEME);
    }

    /**
     * Construct a Windowed dialog with the placement as specified in the Dashboard,
     * with a PlayHavenListener to listen for view dismissal
     *
     * @param context of the application
     * @param placementTag to set
     * @param listener to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Windowed(Context context, String placementTag, PlayHavenListener listener)
    {
        this(context, placementTag, listener, DEFAULT_THEME);
    }

    /**
     * Construct a Windowed dialog with the placement as specified in the Dashboard, using the specified theme,
     * with a PlayHavenListener to listen for view dismissal
     *
     * @param context of the application
     * @param placement to set
     * @param listener to set
     * @param theme A style resource describing the theme to use for the window. See Style and Theme Resources for more information about defining and using styles. This theme is applied on top of the current theme in context. If 0, the default dialog theme will be used.
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Windowed(Context context, Placement placement, PlayHavenListener listener, int theme)
    {
        super(context, theme);
        configure(context);
        setPlayHavenListener(listener);
        setPlacement(placement);
    }

    /**
     * Construct a Windowed dialog with the placement as specified in the Dashboard, using the specified theme,
     * with a PlayHavenListener to listen for view dismissal
     *
     * @param context of the application
     * @param placementTag to set
     * @param listener to set
     * @param theme A style resource describing the theme to use for the window. See Style and Theme Resources for more information about defining and using styles. This theme is applied on top of the current theme in context. If 0, the default dialog theme will be used.
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Windowed(Context context, String placementTag, PlayHavenListener listener, int theme)
    {
        super(context, theme);
        configure(context);
        setPlayHavenListener(listener);
        setPlacementTag(placementTag);
    }

    /**
     * Initial configuration
     */
    protected void configure(Context context)
    {
        final Window window = getWindow();
        if (window != null) {
            window.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_PAN);
        }

        configureSize();
        playHavenView.setPlayHavenListener(this);
        setContentView(playHavenView);
        orientation = new OrientationEventListener(context) {
            @Override
            public void onOrientationChanged(int i) {
                updateFrame();
            }
        };
        orientation.enable();
    }

    protected void resetWindow(double factor)
    {
        DisplayMetrics dm = new DisplayMetrics();
        Windowed.this.getWindow().getWindowManager().getDefaultDisplay().getMetrics(dm);
        WindowManager.LayoutParams lp=getWindow().getAttributes();
        lp.dimAmount=0.6f;
        lp.width = (int)(dm.widthPixels * factor);
        lp.height = (int)(dm.heightPixels * factor);
        getWindow().setAttributes(lp);
    }

    /**
     * Configure sizing
     */
    protected void configureSize()
    {
        if(playHavenView == null)
        {
            VendorCompat compat = PlayHaven.getVendorCompat(getContext());
            int dialogLayoutId = compat.getLayoutId(getContext(), playhaven_dialog);
            int dialogViewId = compat.getId(getContext(), playhaven_dialog_view);

            android.view.View layout =  getLayoutInflater().inflate(dialogLayoutId, null);
            playHavenView = (PlayHavenView) layout.findViewById(dialogViewId);
            playHavenView.setFrameManager(this);
        }

        // Adjust the size of the dialog to be 90%
        resetWindow(0.90);

        if(Build.VERSION.SDK_INT >= 11)
        {
            // @playhaven.apihack View.OnLayoutChangeListener was added in API11
            playHavenView.addOnLayoutChangeListener(new View.OnLayoutChangeListener() {
                @Override
                public void onLayoutChange(View v, int left, int top, int right, int bottom, int oldLeft, int oldTop, int oldRight, int oldBottom) {
                    updateFrame();
                }
            });
        }
    }

    @Override
    public void updateFrame() {
        if(playHavenView == null) return; // not ready yet

        Placement placement = playHavenView.getPlacement();
        if(placement == null) return; // not ready yet

        String json = placement.getModel();
        if(json == null) return; // not ready yet

        /**
         * If the server didn't provide a frame element, we never adjust anything
         */
        JSONObject frame = JsonUtil.getPath(json, "$.response.frame");
        if(frame == null) return;

        boolean portrait = DisplayUtil.isPortrait(getContext());

        JSONObject ph = JsonUtil.getPath(frame, (portrait ? "$.PH_PORTRAIT" : "$.PH_LANDSCAPE"));
        int jsonX = JsonUtil.asInt(ph, "$.x", 0);
        int jsonY = JsonUtil.asInt(ph, "$.y", 0);
        if(jsonX == 0 && jsonY == 0)
        {
            resetWindow(0.90);
            return;
        }

        /**
         * If we got this far, we need to set some new margins
         */
        int jsonW = JsonUtil.asInt(ph, "$.w", 0);
        int jsonH = JsonUtil.asInt(ph, "$.h", 0);

        WindowManager.LayoutParams lp=getWindow().getAttributes();
        lp.dimAmount=0.6f;
        lp.width = jsonW;
        lp.height = jsonH;
        getWindow().setAttributes(lp);
    }


    /**
     * Retrieve the display options
     *
     * @return the display options
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#NO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_OVERLAY
     * @see PlayHavenView#DISPLAY_ANIMATION
     */
    public int getDisplayOptions()
    {
        return playHavenView.getDisplayOptions();
    }

    /**
     * Set the display options using an ORable mask
     * ie:
     * <code>
     *     setDisplayOptions(PlayHavenView.DISPLAY_OVERLAY | PlayHavenView.DISPLAY_ANIMATION);
     * </code>
     *
     * @param displayOptions to set
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#NO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_OVERLAY
     * @see PlayHavenView#DISPLAY_ANIMATION
     */
    public void setDisplayOptions(int displayOptions)
    {
        playHavenView.setDisplayOptions(displayOptions);
    }

    /**
     * Set the placement as specified in the Dashboard
     *
     * @param placement to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void setPlacement(Placement placement)
    {
        playHavenView.setPlacement(placement);
    }

    /**
     * Set the placement as specified in the Dashboard
     *
     * @param placementTag to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void setPlacementTag(String placementTag)
    {
        playHavenView.setPlacementTag(placementTag);
    }

    /**
     * Retrieve the String representation of the placement
     *
     * @return placement tag
     */
    public String getPlacementTag(){return playHavenView.getPlacementTag();}

    /**
     * Retrieve the placement
     *
     * @return the placement
     */
    public Placement getPlacement(){return playHavenView.getPlacement();}

    /**
     * Retrieve the PlayHavenListener
     *
     * @return the listener
     */
    public PlayHavenListener getPlayHavenListener(){return phListener;}

    /**
     * Set the PlayHavenListener, to listen for view dismissal
     *
     * @param listener to set
     */
    public void setPlayHavenListener(PlayHavenListener listener){this.phListener = listener;}


    /**
     * Dismiss the view when the user presses the back key
     */
    @Override
    public void onBackPressed() {
        if(playHavenView != null)
            playHavenView.dismissView(PlayHavenView.DismissType.BackButton);

        super.onBackPressed();
    }

    /**
     * Notify the listener, if any, that the view has failed to display.
     *
     * @param view that was attempted
     * @param exception that prevented loading of the view
     */
    @Override
    public void viewFailed(PlayHavenView view, PlayHavenException exception) {
        dismiss();
        if(phListener != null)
            phListener.viewFailed(view, exception);
    }

    /**
     * Notify the listener, if any, that the view was dismissed
     *
     * @param view that was dismissed
     * @param dismissType how it was dismissed
     * @param data additional data, depending on the content type
     */
    @Override
    public void viewDismissed(PlayHavenView view, PlayHavenView.DismissType dismissType, Bundle data) {
        dismiss();
        if(phListener != null)
            phListener.viewDismissed(view, dismissType, data);
    }

    /**
     * This hook is called whenever the content view of the screen changes
     * (due to a call to
     * {@link android.view.Window#setContentView(android.view.View, android.view.ViewGroup.LayoutParams)
     * Window.setContentView} or
     * {@link android.view.Window#addContentView(android.view.View, android.view.ViewGroup.LayoutParams)
     * Window.addContentView}).
     */
    @Override
    public void onContentChanged() {
        super.onContentChanged();
    }

    @Override
    public void dismiss() {
        if(orientation != null)
            orientation.disable();

        super.dismiss();
    }
}
