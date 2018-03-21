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


import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.view.*;

import android.widget.FrameLayout;
import android.widget.LinearLayout;
import com.playhaven.android.Placement;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.compat.VendorCompat;
import com.playhaven.android.push.NotificationBuilder;
import com.playhaven.android.util.DisplayUtil;
import com.playhaven.android.util.JsonUtil;
import net.minidev.json.JSONObject;

import java.util.List;

import static com.playhaven.android.compat.VendorCompat.ID.playhaven_activity_view;
import static com.playhaven.android.compat.VendorCompat.LAYOUT.playhaven_activity;

public class FullScreen
extends Activity
implements PlayHavenListener, FrameManager {
    private static final String TIMESTAMP = "closed.timestamp";

    /**
     * Result to send back to calling Activity
     */
    private Intent result;

    /**
     * Vendor compat lib for wrappers
     */
    private VendorCompat compat;

    /**
     * Resize the frame on orientation changes
     */
    private OrientationEventListener orientation;

    /**
     * No need to clear the flag every time the orientation sensor updates
     */
    private boolean fullscreenFlagCleared = false;

    /**
     * Construct an Intent, used to display a PlayHaven FullScreen ad using the default display options
     *
     * @param context of the application
     * @param placementTag to be displayed
     * @return intent to call
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     */
    public static Intent createIntent(Context context, String placementTag)
    {
        return createIntent(context, placementTag, PlayHavenView.AUTO_DISPLAY_OPTIONS);
    }

    /**
     * Construct an Intent, used to display a PlayHaven FullScreen ad
     *
     * @param context of the application
     * @param placementTag to be displayed
     * @param displayOptions to use
     * @return intent to call
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#NO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_OVERLAY
     * @see PlayHavenView#DISPLAY_ANIMATION
     */
    public static Intent createIntent(Context context, String placementTag, int displayOptions)
    {
        // This method is here instead of in PlayHavenView to prevent circular dependency
        Intent intent = new Intent(context, FullScreen.class);
        intent.putExtra(PlayHavenView.BUNDLE_PLACEMENT_TAG, placementTag);
        intent.putExtra(PlayHavenView.BUNDLE_DISPLAY_OPTIONS, displayOptions);
        intent.putExtra(PlayHaven.Config.FullScreen.toString(), callerIsFullscreen(context));
        return intent;
    }

    /**
     * Construct an Intent, used to display a PlayHaven FullScreen ad using the default display options
     *
     * @param context of the application
     * @param placement to be displayed
     * @return intent to call
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     */
    public static Intent createIntent(Context context, Placement placement)
    {
        return createIntent(context, placement, PlayHavenView.AUTO_DISPLAY_OPTIONS);
    }

    /**
     * Construct an Intent, used to display a PlayHaven FullScreen ad
     *
     * @param context of the application
     * @param placement to be displayed
     * @param displayOptions to use
     * @return intent to call
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     * @see PlayHavenView#AUTO_DISPLAY_OPTIONS
     * @see PlayHavenView#NO_DISPLAY_OPTIONS
     * @see PlayHavenView#DISPLAY_OVERLAY
     * @see PlayHavenView#DISPLAY_ANIMATION
     */
    public static Intent createIntent(Context context, Placement placement, int displayOptions)
    {
        // This method is here instead of in PlayHavenView to prevent circular dependency
        Intent intent = new Intent(context, FullScreen.class);
        intent.putExtra(PlayHavenView.BUNDLE_PLACEMENT, placement);
        intent.putExtra(PlayHavenView.BUNDLE_DISPLAY_OPTIONS, displayOptions);
        intent.putExtra(PlayHaven.Config.FullScreen.toString(), callerIsFullscreen(context));
        return intent;
    }

    /**
     * Has enough time elapsed since the last FullScreen was displayed?
     *
     * @param context of the caller
     * @param durationMs required to be elapsed
     * @return true if durationMs has elapsed since the last FullScreen has returned
     */
    public static boolean timeElapsed(Context context, long durationMs)
    {
        SharedPreferences pref = PlayHaven.getPreferences(context);
        long timestamp = pref.getLong(TIMESTAMP, 0);
        if(timestamp == 0) return true;
        long now = System.currentTimeMillis();
        return (now - timestamp >= durationMs);
    }

    /**
     * Store the current timestamp
     *
     * @see FullScreen#timeElapsed(android.content.Context, long)
     */
    protected void storeTimestamp()
    {
        SharedPreferences pref = PlayHaven.getPreferences(this);
        SharedPreferences.Editor editor = pref.edit();
        editor.putLong(TIMESTAMP, System.currentTimeMillis());
        editor.commit();
    }

    /**
     * Create the FullScreen Activity
     *
     * @param savedInstanceState of the previous run
     */
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Don't re-show from the history
        int flags = getIntent().getFlags();
        if((flags & Intent.FLAG_ACTIVITY_LAUNCHED_FROM_HISTORY) != 0)
        {
            compat = PlayHaven.getVendorCompat(this);
            finish();
            return;
        }

        //Remove title bar
        this.requestWindowFeature(Window.FEATURE_NO_TITLE);

        compat = PlayHaven.getVendorCompat(this);

        if (this.getIntent().getBooleanExtra(PlayHaven.Config.FullScreen.toString(), true)) {
            this.getWindow().addFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
        }
        
        int contentViewId = compat.getLayoutId(getApplicationContext(), playhaven_activity);
        setContentView(contentViewId);

        int activityViewId = compat.getId(getApplicationContext(), VendorCompat.ID.playhaven_activity_view);
        PlayHavenView playHavenView = (PlayHavenView) findViewById(activityViewId);
        playHavenView.setPlayHavenListener(this);
        playHavenView.setFrameManager(this);

        // If launched via Uri.parse, grab the parameters from the Uri
        Uri dataUri = getIntent().getData();
        if(dataUri != null)
        {
            List<String> path = dataUri.getPathSegments();
            if(path.size() == 1)
            {
                PlayHaven.d("path[0]: %s", path.get(0));
            }

            try{
                playHavenView.setDisplayOptions(Integer.parseInt(dataUri.getQueryParameter(PlayHavenView.BUNDLE_DISPLAY_OPTIONS)));
            }catch(NumberFormatException nfe){
                // no-op
            }
            playHavenView.setPlacementTag(dataUri.getQueryParameter(PlayHavenView.BUNDLE_PLACEMENT_TAG));
        }

        // If launched via FullScreen.createIntent, grab the parameters from the Bundle
        Bundle extras = getIntent().getExtras();
        if(extras != null)
        {
            playHavenView.setDisplayOptions(extras.getInt(PlayHavenView.BUNDLE_DISPLAY_OPTIONS));
            // Prefer an actual placement over the placement tag if both are provided
            Placement pl = extras.getParcelable(PlayHavenView.BUNDLE_PLACEMENT);
            if(pl != null)
            {
                playHavenView.setPlacement(pl);
            } else {
                String plId = extras.getString(PlayHavenView.BUNDLE_PLACEMENT_TAG);
                if(plId != null)
                {
                	playHavenView.setPlacementTag(plId);
                } else {
                	// If there was no placement or tag... 
                	PlayHavenException e = new PlayHavenException("FullScreen was launched without a valid placement or tag.");
                	viewFailed(playHavenView, e);
                }
            }
        }

        if(orientation == null)
        {
            orientation = new OrientationEventListener(this) {
                @Override
                public void onOrientationChanged(int i) {
                    updateFrame();
                }
            };
            orientation.enable();
        }
    }

    @Override
    public void updateFrame() {
        if(compat == null) return; // not ready up

        int activityViewId = compat.getId(this, VendorCompat.ID.playhaven_activity_view);
        PlayHavenView playHavenView = (PlayHavenView) findViewById(activityViewId);
        if(playHavenView == null) return; // not ready yet

        Placement placement = playHavenView.getPlacement();
        if(placement == null) return; // not ready yet

        String json = placement.getModel();
        if(json == null) return; // not ready yet

        if(placement.isFullscreenCompatible() && !fullscreenFlagCleared) // relies on the model
        {
            getWindow().clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN);
            PlayHaven.v("Placement should not be displayed fullscreen, clearing flag.");
            fullscreenFlagCleared = true;
        }

        /**
         * If the server didn't provide a frame element, we never adjust anything
         */
        JSONObject frame = JsonUtil.getPath(json, "$.response.frame");
        if(frame == null) return;

        boolean portrait = DisplayUtil.isPortrait(this);

        JSONObject ph = JsonUtil.getPath(frame, (portrait ? "$.PH_PORTRAIT" : "$.PH_LANDSCAPE"));
        int jsonX = JsonUtil.asInt(ph, "$.x", 0);
        int jsonY = JsonUtil.asInt(ph, "$.y", 0);
        if(jsonX == 0 && jsonY == 0)
            return; // they are requesting full screen; nothing to do

        /**
         * If we got this far, we need to set some margins
         */
        int jsonW = JsonUtil.asInt(ph, "$.w", 0);
        int jsonH = JsonUtil.asInt(ph, "$.h", 0);

        ViewGroup.MarginLayoutParams params = (ViewGroup.MarginLayoutParams) playHavenView.getLayoutParams();
        params.height = jsonH;
        params.width = jsonW;
        params.leftMargin = jsonX;
        params.topMargin = jsonY;

        if(Build.VERSION.SDK_INT == 10)
        {
            // @playhaven.apihack gingerbread was not centering

            if(params instanceof LinearLayout.LayoutParams)
            {
                ((LinearLayout.LayoutParams)params).gravity = Gravity.TOP;
            }else if(params instanceof FrameLayout.LayoutParams){
                ((FrameLayout.LayoutParams)params).gravity = Gravity.TOP;
            }
        }

        playHavenView.requestLayout();
    }


    /**
     * Close this ad
     */
    @Override
    public void finish() 
    {
        if(orientation != null)
            orientation.disable();

        if(result == null && compat != null)
        {
            // Default result...
            result = new Intent();
            int activityViewId = compat.getId(getApplicationContext(), playhaven_activity_view);
            PlayHavenView playHavenView = (PlayHavenView) findViewById(activityViewId);
            result.putExtra(PlayHavenView.BUNDLE_DISMISS_TYPE, PlayHavenView.DismissType.SelfClose);
            doResult(RESULT_OK, result, playHavenView);
        }
        storeTimestamp();
        super.finish();
    }

    /**
     * Close this ad when the back button is pressed
     */
    @Override
    public void onBackPressed() 
    {
    	int activityViewId = compat.getId(getApplicationContext(), VendorCompat.ID.playhaven_activity_view);
        PlayHavenView view = (PlayHavenView) findViewById(activityViewId);
        if(view != null)
            view.dismissView(PlayHavenView.DismissType.BackButton);
    }

    /**
     * The view failed to launch properly
     *
     * @param view that was attempted
     * @param exception that prevented loading of the view
     */
    @Override
    public void viewFailed(PlayHavenView view, PlayHavenException exception) 
    {
        result = new Intent();
        result.putExtra(PlayHavenView.BUNDLE_DISMISS_TYPE, PlayHavenView.DismissType.SelfClose);
        result.putExtra(PlayHavenView.BUNDLE_EXCEPTION, exception);
        doResult(RESULT_CANCELED, result, view);
        finish();
    }

    /**
     * The view was dismissed
     *
     * @param view that was dismissed
     * @param dismissType how it was dismissed
     * @param data additional data, depending on the content type
     */
    @Override
    public void viewDismissed(PlayHavenView view, PlayHavenView.DismissType dismissType, Bundle data) 
    {
        result = new Intent();
        result.putExtra(PlayHavenView.BUNDLE_DISMISS_TYPE, dismissType);
        if(data != null) 
        {
            result.putExtra(PlayHavenView.BUNDLE_DATA, data);
        }

        doResult(RESULT_OK, result, view);
        this.finish();
    }
    
    public void doResult(int resultCode, Intent result, PlayHavenView view) 
    {
        if(view != null)
        {
            result.putExtra(PlayHavenView.BUNDLE_PLACEMENT, view.getPlacement());
            result.putExtra(PlayHavenView.BUNDLE_PLACEMENT_TAG, view.getPlacementTag());
            result.putExtra(PlayHavenView.BUNDLE_DISPLAY_OPTIONS, view.getDisplayOptions());
        }

        // If this placement was launched as a result of a Notification, we want to 
        // launch the provided URI as an Intent or launch the providing Application.
        String uriString = getIntent().getStringExtra(NotificationBuilder.Keys.URI.name());
        if(uriString != null)
        {
        	PlayHaven.v("Provided URI was: %s", uriString);
    		PackageManager pm = getPackageManager();
    		Intent newIntent = pm.getLaunchIntentForPackage(getPackageName());
    		newIntent.putExtras(result);

    		// Pass the uri parameters as extras to the Application as it launches (cleaner in API 11+, but...)
        	String[] params = uriString.split("&");
        	for(String param : params) {
        		String[] parts = param.split("=");
        		if(parts.length == 2){
        			newIntent.putExtra(parts[0], parts[1]);
        		}
        	}
    		startActivity(newIntent);
        }
    	// Provide this result to calling activity, if there was one. 
        setResult(resultCode, result);
    }
    
    public static boolean callerIsFullscreen(Context context) {
    	// If this is happening from an Activity context then we would like to know if that 
    	// Activity is being shown fullscreen. 
        // Note: A publisher may choose to provide a different context, in which case we 
    	// default to true. 
    	if (context instanceof Activity) 
    	{
    		Activity originatingActivity = (Activity) context;
    		return (
	        			originatingActivity.getWindow().getAttributes().flags & 
	        			WindowManager.LayoutParams.FLAG_FULLSCREEN
        			) != 0;
    	} 
    	else {
    		PlayHaven.v("Unable to retrieve window flags without an Activity context.");
        	return true;
    	}
    }
}
