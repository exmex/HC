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
package com.playhaven.android.data;

import android.net.Uri;
import android.os.Parcel;
import android.os.Parcelable;
import com.playhaven.android.PlayHavenException;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;
import org.json.JSONException;
import org.json.JSONObject;
import java.util.ArrayList;
import java.util.Collections;
import java.util.LinkedHashSet;
import java.util.Set;

/**
 * Represents the input fields used in an opt-in data collection template. 
 */
public class DataCollectionField implements Parcelable {
    String mType;
    String mName;
    String mCssClass;
    String mValue;

    public enum FieldNames {
        /** Type of the field */
        type,
        /** Name of the field */
        name,
        /** CSS Class of the field */
        cssClass,
        /** Value of the field */
        value
    }

    public static final Parcelable.Creator<DataCollectionField> CREATOR = 
            new Parcelable.Creator<DataCollectionField>() {

                @Override
                public DataCollectionField createFromParcel(Parcel source) {
                    return new DataCollectionField(source);
                }

                @Override
                public DataCollectionField[] newArray(int size) {
                    return new DataCollectionField[size];
                }
            };

    public static ArrayList<DataCollectionField> fromUrl(Uri uri) throws PlayHavenException {
        ArrayList<DataCollectionField> toReturn = new ArrayList<DataCollectionField>();
        if(uri == null) return toReturn;

        for(String paramKey : getQueryParameterNames(uri))
        {
            if(paramKey.equals("dcDataCallback")) continue;
            if(paramKey.equals("_")) continue;
            toReturn.add(new DataCollectionField(String.format(
                "{\"name\":\"%s\", \"value\":\"%s\"}",
                paramKey,
                uri.getQueryParameter(paramKey)))
            );
        }

        return toReturn;
    }

    /**
     * Since the V1 templates aren't written to pass the pertinent data to the SDK, 
     * this is a bit of a hack. We have the page serialize the form and pass 
     * the data back as a JSON string to the console. 
     * @throws PlayHavenException 
     */
    public DataCollectionField (String json) throws PlayHavenException {
        try {
            JSONObject obj = new JSONObject(json);
            mType = obj.optString(FieldNames.type.name(), "text");
            mName = obj.optString(FieldNames.name.name(), "");
            mCssClass = obj.optString(FieldNames.cssClass.name(), "");
            mValue = obj.optString(FieldNames.value.name(), "");
        } catch (JSONException e) {
            throw new PlayHavenException("Could not parse form data from template.", e);
        }
    }

    public DataCollectionField(Parcel source) {
        readFromParcel(source);
    }

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
     * @param dest The Parcel in which the object should be written.
     * @param flags Additional flags about how the object should be written. May be 0 or Parcel#PARCELABLE_WRITE_RETURN_VALUE.
     */
    @Override
    public void writeToParcel(Parcel dest, int flags) {
        dest.writeString(mType);
        dest.writeString(mName);
        dest.writeString(mCssClass);
        dest.writeString(mValue);
    }

    /**
     * Deserialize this object from a Parcel
     *
     * @param in parcel to read from
     */
    protected void readFromParcel(Parcel in)
    {
        mType = in.readString();
        mName = in.readString();
        mCssClass = in.readString();
        mValue = in.readString();
    }

    public String getType(){return mType;}
    public String getName(){return mName;}
    public String getValue(){return mValue;}
    public String getCssClass(){return mCssClass;}

    @Override
    public String toString() {
        return ToStringBuilder.reflectionToString(this);
    }

    @Override
    public int hashCode() {
        return HashCodeBuilder.reflectionHashCode(this);
    }

    @Override
    public boolean equals(Object other) {
        return EqualsBuilder.reflectionEquals(this, other);
    }

    /**
     * Unavailable in <11, so copied in. Difference is that names are not re-encoded in UTF-8. 
     * 
     * Returns a set of the unique names of all query parameters. Iterating
     * over the set will return the names in order of their first occurrence.
     *
     * @throws UnsupportedOperationException if this isn't a hierarchical URI
     *
     * @return a set of decoded names
     */
    public static Set<String> getQueryParameterNames(Uri uri) {

        String query = uri.getEncodedQuery();
        if (query == null) {
            return Collections.emptySet();
        }

        Set<String> names = new LinkedHashSet<String>();
        int start = 0;
        do {
            int next = query.indexOf('&', start);
            int end = (next == -1) ? query.length() : next;

            int separator = query.indexOf('=', start);
            if (separator > end || separator == -1) {
                separator = end;
            }

            String name = query.substring(start, separator);
            names.add(name);

            // Move start to end of name.
            start = end + 1;
        } while (start < query.length());

        return Collections.unmodifiableSet(names);
    }
}
