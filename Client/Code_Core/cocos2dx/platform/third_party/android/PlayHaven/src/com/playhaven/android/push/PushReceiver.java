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
package com.playhaven.android.push;

import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.net.Uri;
import android.os.Bundle;

import com.playhaven.android.*;
import com.playhaven.android.push.NotificationBuilder.Keys;
import com.playhaven.android.req.PushTrackingRequest;
import com.playhaven.android.view.FullScreen;
import com.playhaven.android.view.PlayHavenView;
import com.playhaven.android.view.PlayHavenView.DismissType;

/**
 * Handles the Notification side of push notifications. 
 */
public class PushReceiver extends BroadcastReceiver implements PlacementListener {
	protected Context mContext;
	protected Bundle mBundle;
	
	/** The URIs we will receive and handle from push notifications.*/
	public enum UriTypes {
		DEFAULT,
		CUSTOM,
		INVALID,
		PLACEMENT,
		ACTIVITY
	}
	
	/** Parameters to reuse for requests to PlayHaven. */
	public enum PushParams {
    	push_token, 
    	message_id, 
    	content_id
	}
	
	@Override
	public void contentLoaded(Placement placement) {
		Intent newIntent = new Intent(mContext, PushReceiver.class);
		newIntent.putExtra(PlayHavenView.BUNDLE_PLACEMENT, placement);
		newIntent.putExtras(mBundle);
		newIntent.putExtra(NotificationBuilder.Keys.URI.name(), mBundle.getString(NotificationBuilder.Keys.URI.name()));
		
		PendingIntent pendingIntent = PendingIntent.getBroadcast(mContext, this.hashCode(), newIntent, 0);
		Notification notification = new NotificationBuilder(mContext).makeNotification(mBundle, pendingIntent);
    	NotificationManager manager = (NotificationManager) mContext.getSystemService(Service.NOTIFICATION_SERVICE);
    	
		// The request code helps instrumentation tests retrieve notifications from the Notification Manager. 
		int requestCode;
		try {
			requestCode = Integer.parseInt(((PushPlacement) placement).getMessageId());
		} catch (NumberFormatException e){
			requestCode = this.hashCode();
		}
		
    	manager.notify(requestCode, notification);
	}
	
	@Override
	public void contentFailed(Placement placement, PlayHavenException e) {
		PlayHaven.e("contentFailed() for placement \"%s\"", placement == null ? placement : placement.getPlacementTag());
		PlayHaven.e(e);
	}
	
	@Override
	/** The receiver probably won't be around to receive this event. */
	public void contentDismissed(Placement placement, DismissType dismissType, Bundle data) {
		PlayHaven.v("Placement dismissed with type %s", dismissType);
	}

	@Override
	/**
	 * Handles returning from Notification. See messaging-service-specific 
	 * classes for when system provides push notifications. 
	 * (Such as GCMBroadcastReceiver.) 
	 */
	public void onReceive(Context context, Intent intent) {
		Bundle bundle = intent.getExtras();
		if(bundle == null){
			// There is nothing more we can do. 
			PlayHaven.e("Received Notification with no extras.");
			return;
		}
		
		Uri uri = Uri.parse(bundle.getString(NotificationBuilder.Keys.URI.name()));
		Intent nextIntent = null;
		switch(checkUri(uri, context)){
			case ACTIVITY:
				// The publisher has provided a particular activity to launch after the notification.
				try {
					Class<?> activityClass = Class.forName(uri.getQueryParameter(PlayHaven.ACTION_ACTIVITY));
					nextIntent = new Intent(context, activityClass);
				} catch (ClassNotFoundException e) {
					PlayHaven.e(e);
				}
				break;
			case DEFAULT:
				// The default is to invoke the Application's default launcher after a notification. 
	    		PackageManager pm = context.getPackageManager();
				nextIntent = pm.getLaunchIntentForPackage(context.getPackageName());
				break;
			case PLACEMENT:
				// Launch a placement. 
				Placement placement = intent.getParcelableExtra(PlayHavenView.BUNDLE_PLACEMENT);
				nextIntent = FullScreen.createIntent(context, placement, PlayHavenView.AUTO_DISPLAY_OPTIONS);
				break;
			case CUSTOM:
				nextIntent = new Intent(Intent.ACTION_VIEW, uri);
			default:
				break;
		}
		
		String message_id = bundle.getString(PushParams.message_id.name());
		String content_id = uri.getQueryParameter(PlayHaven.ACTION_CONTENT_UNIT);
		
		PushTrackingRequest trackingRequest = new PushTrackingRequest(context, message_id, content_id);
		trackingRequest.send(context);
		
		if(nextIntent != null) {
			nextIntent.putExtras(bundle);
            nextIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
			try {
				context.startActivity(nextIntent);
			} catch (Exception e) {
				PlayHaven.e("Unable to launch URI provided from push notification: \"%s\".", uri);
				e.printStackTrace();
			}
		}
	}
	
	/**
	 * Parses the intent provided from a push notification to create a 
	 * Notification (if appropriate) or perform other actions. 
	 */
	public void interpretPush(Intent intent, Context context) {
		mContext = context;
		mBundle = validatePushKeys(intent.getExtras());
		
		Uri uri = Uri.parse(mBundle.getString(NotificationBuilder.Keys.URI.name()));
		Notification notification = null;
		String messageId = intent.getStringExtra(PushParams.message_id.name());

		Intent newIntent = new Intent(context, PushReceiver.class);
		newIntent.putExtras(mBundle);
		PendingIntent pendingIntent = PendingIntent.getBroadcast(mContext, getMessageId(intent), newIntent, 0);
		
		switch(checkUri(uri, mContext)){
			case DEFAULT:
			case CUSTOM: 
				notification = new NotificationBuilder(mContext).makeNotification(mBundle, pendingIntent);
		    	break;
			case PLACEMENT:
				// Load a placement or content unit to show when the notification is clicked. 
				String placementTag = uri.getQueryParameter(PlayHaven.ACTION_PLACEMENT);
				String contentUnitId = uri.getQueryParameter(PlayHaven.ACTION_CONTENT_UNIT);
				
				PushPlacement placement = new PushPlacement(placementTag);
				placement.setMessageId(messageId);
				placement.setContentUnitId(contentUnitId);
				placement.setListener(PushReceiver.this);
				placement.preload(mContext); 
				break;
			/* removed in [and-41] 
			case CUSTOM:
				// The publisher has provided a Uri to broadcast. 
				PlayHaven.v("Broadcasting custom intent: %s.", uri);
				Intent customIntent = new Intent(Intent.ACTION_VIEW, uri);
				try {
					mContext.sendBroadcast(customIntent);
				} catch (Exception e) {
					PlayHaven.v("Could not broadcast URI: %s.", uri);
					e.printStackTrace();
				}
				break;
			*/ 
			case ACTIVITY: 
				notification = new NotificationBuilder(mContext).makeNotification(mBundle, pendingIntent);
				break;
			default: 
				PlayHaven.e("An invalid URI was provided in a push notification: %s", uri);
				break;
		}
		
		if(notification != null){
	    	NotificationManager manager = (NotificationManager) mContext.getSystemService(Service.NOTIFICATION_SERVICE);
	    	manager.notify(getMessageId(intent), notification);
		}
	}
	
	/**
	 * Instrumentation needs to be able to retrieve the Notification from 
	 * the Notification Manager and so uses the message id to set the Notification id. 
	 * It requires an integer ID, which the message id might not always be if 
	 * coming from the PlayHaven server. 
	 */
	public int getMessageId(Intent intent){
		try {
			String messageId = intent.getStringExtra(PushParams.message_id.name());
			return Integer.parseInt(messageId);
		} catch (NumberFormatException e){
			return intent.hashCode();
		}
	}
    
    /**
     * Determine the desired behavior. Besides, custom, we support: 
     * playhaven://com.playhaven.android/?<activity=x>|<placement=y>|<content_id=z>
     * 
     * There may, in the future, be restrictions on allowed custom URIs. 
     */
    public UriTypes checkUri(Uri uri, Context context){
    	String host = uri.getHost();
    	String scheme = uri.getScheme();
    	
    	if((host == null && scheme == null) || ("".equals(host) && "".equals(scheme))){
    		PlayHaven.e("Invalid URI, host or scheme is null: %s.", uri);
    		return UriTypes.INVALID;
    	}
		
    	if(PlayHaven.URI_SCHEME.equals(scheme) && "com.playhaven.android".equals(host)){
			if(uri.getQueryParameter(PlayHaven.ACTION_ACTIVITY) != null) {
				return UriTypes.ACTIVITY;
			}
			if(uri.getQueryParameter(PlayHaven.ACTION_PLACEMENT) != null) {
				return UriTypes.PLACEMENT;
			}
			if(uri.getQueryParameter(PlayHaven.ACTION_CONTENT_UNIT) != null) {
				return UriTypes.PLACEMENT;
			}
			return UriTypes.DEFAULT;
    	}
    	
    	// Make sure that any custom URI has something to receive it, before 
    	// we create a notification. 
    	ResolveInfo info = null;
    	try {
        	Intent testIntent = new Intent().setData(uri);
        	info = context.getPackageManager().resolveActivity(testIntent, 0);
    	} catch (Exception e) {
    		PlayHaven.e("Nothing registered for %s", uri);
    		return UriTypes.INVALID;
    	}

    	return info == null ? UriTypes.INVALID : UriTypes.CUSTOM;
    }
    
    /**
     * Converts the keys for strings needed to create a Notification to uppercase. 
     * Does not consider collisions. 
     */
    public static Bundle validatePushKeys(Bundle extras) {
    	for(Keys item : NotificationBuilder.Keys.values()){
    		if(!extras.containsKey(item.name())){
    			if(extras.containsKey(item.name().toLowerCase())){
    				extras.putString(item.name(), extras.getString(item.name().toLowerCase()));
    				extras.remove(item.name().toLowerCase());
    			}
    		}
    	}
    	return extras;
    }
}
