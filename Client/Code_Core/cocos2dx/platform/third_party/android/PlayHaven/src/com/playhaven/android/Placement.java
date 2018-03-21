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
package com.playhaven.android;

import android.content.Context;
import android.os.Build;
import android.os.Parcel;
import android.os.Parcelable;

import com.jayway.jsonpath.InvalidPathException;
import com.jayway.jsonpath.JsonPath;
import com.playhaven.android.cache.Cache;
import com.playhaven.android.cache.CacheResponseHandler;
import com.playhaven.android.cache.CachedInfo;
import com.playhaven.android.data.ContentUnitType;
import com.playhaven.android.data.JsonUrlExtractor;
import com.playhaven.android.req.*;
import com.playhaven.android.util.JsonUtil;
import net.minidev.json.JSONObject;
import net.minidev.json.parser.JSONParser;
import net.minidev.json.parser.ParseException;

import java.io.IOException;
import java.net.URL;
import java.util.ArrayList;
import java.util.Map;

/**
 * A representation of a placement
 */
public class Placement
implements Parcelable, CacheResponseHandler, RequestListener
{
    /**
     * Placement tag as defined in the Dashboard
     *
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    protected String placementTag;

    /**
     * Json model returned from the server
     */
    private String contentModel, dispatchModel;

    /**
     * Listener for successful loading of the content
     * NOT serialized
     */
    private PlacementListener listener;

    /**
     * Cache used for loading of the content
     * NOT serialized
     */
    protected Cache cache;

    /**
     * Flag to indicate whether this placement is in the process of loading
     * NOT serialized
     */
    protected boolean isLoading = false;

    /**
     * Custom Dimensions
     */
    private JSONObject customDimensions;

    /**
     * Construct a placement from a tag
     *
     * @param placementTag from the Dashboard
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public Placement(String placementTag)
    {
        this.placementTag = placementTag;
    }

    /**
     * Construct a placement from a Parcel
     *
     * @param in parcel containing this object
     */
    public Placement(Parcel in)
    {
        readFromParcel(in);
    }

    /**
     * Retrieve the placement tag as defined in the Dashboard
     *
     * @return placement tag
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public String getPlacementTag() {
        return placementTag;
    }

    /**
     * Set the placement tag as defined in the Dashboard
     *
     * @param placementTag to set
     * @see <a href="https://dashboard.playhaven.com/">https://dashboard.playhaven.com/</a>
     */
    public void setPlacementTag(String placementTag) {
        this.placementTag = placementTag;
    }

    /**
     * Retrieve the databound model returned from the server
     *
     * @return model
     */
    public String getModel() {
        /**
         * This could happen if a first request dispatched a second and caused a PlayHavenException
         */
        if(contentModel == null && dispatchModel != null)
            return getDispatchModel();

        return contentModel;
    }
    public String getDispatchModel() {return dispatchModel;}

    /**
     * Set the databound model returned from the server
     *
     * @param model to set
     */
    public void setModel(String model) {
        this.contentModel = model;
    }
    public void setDispatchModel(String model){this.dispatchModel = model;}

    /**
     * Retrieve the listener used to detect successful loading of the content
     *
     * @return the listener
     */
    public PlacementListener getListener() {
        return listener;
    }

    /**
     * Set the listener used to detect successful loading of the content
     *
     * @param listener to set
     */
    public void setListener(PlacementListener listener) {
        this.listener = listener;
    }

    /**
     * Required Android annoyance used to create an instance of this class
     */
    public static final Parcelable.Creator<Placement> CREATOR = new Creator<Placement>()
    {
        public Placement createFromParcel(Parcel in){return new Placement(in);}
        public Placement[] newArray(int size){return new Placement[size];}
    };

    /**
     * Describe the kinds of special objects contained in this Parcelable's marshalled representation.
     *
     * @return a bitmask indicating the set of special object types marshalled by the Parcelable.
     */
    @Override
    public int describeContents() {
        return 0;
    }

    /**
     * Flatten this object in to a Parcel.
     *
     * @param dest  The Parcel in which the object should be written.
     * @param flags Additional flags about how the object should be written. May be 0 or Parcelable#PARCELABLE_WRITE_RETURN_VALUE.
     */
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(placementTag);

        if(contentModel == null)
        {
            dest.writeString(null);
        }else{
            try{
                dest.writeString(contentModel);
            }catch(Exception e){
                PlayHaven.w(e);
                dest.writeString(null);
            }
        }

        if(dispatchModel == null)
        {
            dest.writeString(null);
        }else{
            try{
                dest.writeString(dispatchModel);
            }catch(Exception e){
                PlayHaven.w(e);
                dest.writeString(null);
            }
        }

        if(customDimensions == null)
        {
            dest.writeString(null);
        }else{
            dest.writeString(customDimensions.toString());
        }
    }

    /**
     * Deserialize this object from a Parcel
     *
     * @param in parcel to read from
     */
    protected void readFromParcel(Parcel in)
    {
        setPlacementTag(in.readString());

        contentModel = in.readString();
        dispatchModel = in.readString();

        String dim = in.readString();
        if(dim != null)
        {
            try{
                customDimensions = (JSONObject) (new JSONParser(JSONParser.MODE_JSON_SIMPLE)).parse(dim);
            } catch (ParseException e) {
                PlayHaven.d(e.getMessage());
            }
        }
    }

    /**
     * Preload a content unit for this placement. 
     * @param context of the caller
     */
    public void preload(final Context context)
    {
        if(isLoading) return;

        if(placementTag == null)
        {
            // what to do?
            PlayHaven.d("Skipping 'null' placement");
            return;
        }

        PlayHaven.d("Start server call: %s", placementTag);
        isLoading = true;

        try{
            if(cache == null)
                cache = new Cache(context);
        } catch (PlayHavenException e) {
            contentFailed(e);
        }
        
        ContentRequest content = new ContentRequest(placementTag);
        if(customDimensions != null &&  customDimensions.size() > 0)
            content.addDimensions(customDimensions);

        content.setPreload(true);
        content.setResponseHandler(this);
        content.send(context);
    }

    /**
     * Notify listener that the content was loaded successfully
     */
    protected void contentLoaded() {
        if(contentModel == null && dispatchModel == null)
            return;

        isLoading = false;
        if(listener != null)
            listener.contentLoaded(this);
    }

    /**
     * Notify listener that the content failed to load successfully
     *
     * @param e containing the error that prevented loading
     */
    protected void contentFailed(PlayHavenException e) {
        isLoading = false;
        if(listener != null)
            listener.contentFailed(this, e);
    }

    /**
     * Called when a files are successfully retrieved
     *
     * @param cachedInfos of cached content
     */
    @Override
    public void cacheSuccess(CachedInfo... cachedInfos)
    {
        contentLoaded();
    }

    /**
     * Called when a file fails to be retrieved
     *
     * @param url       of the request
     * @param exception reason for the failure
     */
    @Override
    public void cacheFail(URL url, PlayHavenException exception) {
        contentFailed(exception);
    }

    /**
     * Is this placement in a state appropriate for displaying
     *
     * @return true if this placement is not empty and is already loaded
     */
    public boolean isDisplayable()
    {
        return isLoaded() && !isEmpty();
    }
    
    /**
     * Can this placement be displayed fullscreen? 
     * http://code.google.com/p/android/issues/detail?id=5497 
     * @return true if the placement is not known to be fullscreen incompatible 
     */
    public boolean isFullscreenCompatible()
    {
    	Integer jsonSays = 1;
        if(contentModel != null)
        {
            try {
                jsonSays = JsonUtil.asInteger(contentModel, "$.response.resizable");
            } catch (ClassCastException e) {
                PlayHaven.v("Unable to ascertain fullscreen compatibility from JSON, invalid value.");
            } catch (InvalidPathException e){
                PlayHaven.v("Unable to ascertain fullscreen compatibility from JSON, missing value.");
            }
        }

    	return (jsonSays == 1);
    }

    /**
     * Is this placement empty?
     *
     * @return if there is no response in the model, or the model has not yet been loaded from the server
     */
    public boolean isEmpty()
    {
        if(!isLoaded()) return true;
        return JsonUtil.getPath(contentModel, "$.response") == null;
    }

    /**
     * Has this placement been loaded?
     *
     * @return true if the model has been loaded.
     */
    public boolean isLoaded()
    {
        return contentModel != null;
    }

    /**
     * Is this placement in the process of loading
     *
     * @return true if this placement has started, but not yet completed, the loading process
     */
    public boolean isLoading()
    {
        return isLoading;
    }


    public void reset()
    {
        isLoading = false;
        contentModel = null;
    }

    /**
     * Handle the model returned from the server call
     *
     * @param context of the request
     * @param json response from the server
     */
    @Override
    public void handleResponse(Context context, String json) {
        switch(ContentUnitType.getType(json))
        {
            case Content:
                handleContentResponse(context, json);
                break;
            case ContentDispatch:
                handleContentDispatchResponse(context, json);
                break;
        }
    }

    protected void handleContentDispatchResponse(Context context, String json)
    {
        setDispatchModel(json);

        try{
            switch(ContentDispatchType.getType(dispatchModel))
            {
                case UpsightContent:
                    ContentDispatchRequest content = new ContentDispatchRequest(dispatchModel);
                    if(customDimensions != null &&  customDimensions.size() > 0)
                        content.addDimensions(customDimensions);

                    content.setPreload(true);
                    content.setResponseHandler(this);
                    content.send(context);
                    break;
                default:
                    break;
            }
        } catch (PlayHavenException e) {
            contentFailed(e);
        }
    }

    protected void handleContentResponse(Context context, String json)
    {
        try{
            processContentResponse(json);
        } catch (PlayHavenException e) {
            // Is there a valid fallback content model?
            if(dispatchModel != null && !dispatchModel.equals(json))
            {
                try{
                    processContentResponse(dispatchModel);
                } catch (PlayHavenException e1) {
                    PlayHaven.e(e1);
                    // fall through to normal behavior
                }
            }

            contentFailed(e);
        }
    }

    protected void processContentResponse(String json) throws PlayHavenException
    {
        validateModel(json);
        setModel(json);
        preloadContent(json);
    }

    protected void validateModel(String json) throws PlayHavenException
    {
        if(json == null)
            throw new PlayHavenException("No returned model");

        String err = JsonUtil.getPath(json, "$.error");
        if(err != null)
            throw new PlayHavenException(err);

        if(!JsonUtil.hasPath(json, "$.response.context.content"))
            throw new NoContentException();
    }

    protected void preloadContent(String json) throws PlayHavenException
    {
        try{
            ArrayList<String> urls = new ArrayList<String>();
            urls.addAll(JsonUrlExtractor.getContentTemplates(json));
            // Pre API level 11 one cannot intercept resource requests, and
            // so preloaded images aren't useful.
            if(Build.VERSION.SDK_INT >= 11){
                urls.addAll(JsonUrlExtractor.getImages(json));
            }
            cache.bulkRequest(Placement.this, urls);
        }catch(PlayHavenException e){
            throw e;
        }catch(IOException e2){
            throw new PlayHavenException(e2);
        }catch (Exception e3){
            throw new PlayHavenException(e3.getMessage());
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
        contentFailed(e);
    }

    /**
     * Add a set of custom dimensions to the request.
     *
     * @param dimensions to add to this request.
     */
    public void addDimensions(Map<String,Object> dimensions)
    {
        if(customDimensions == null)
            customDimensions = new JSONObject();

        customDimensions.putAll(dimensions);
    }

    /**
     * Add a single custom dimension to the request.
     *
     * @param name of the custom dimension
     * @param value of the custom dimension, or null to remove it
     */
    public void addDimension(String name, Object value)
    {
        if(customDimensions == null)
            customDimensions = new JSONObject();

        customDimensions.put(name, value);
    }
}
