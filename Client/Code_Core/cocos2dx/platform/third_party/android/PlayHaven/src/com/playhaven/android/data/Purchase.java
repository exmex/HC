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

import android.net.UrlQuerySanitizer;
import android.os.Parcel;
import android.os.Parcelable;
import com.jayway.jsonpath.JsonPath;
import com.playhaven.android.util.JsonUtil;
import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;
import org.apache.commons.lang.builder.ToStringBuilder;

import java.util.ArrayList;
import java.util.List;

/**
 * A representation of a Purchase
 */
public class Purchase
        implements Parcelable
{
    public enum Result
    {
        /** Result was not set */
        Unset("unset"),
        /** The item has been bought */
        Bought("buy"),
        /** The purchase was cancelled */
        Cancelled("cancel"),
        /** The requested item was invalid */
        Invalid("invalid"),
        /** The requested item was already owned by this user */
        Owned("owned"),
        /** There was an error during the purchase process */
        Error("error");
        Result(String urlValue)
        {
            this.urlValue = urlValue;
        }
        private String urlValue;
        public String getUrlValue(){return urlValue;}
    }

    public enum Store
    {
        Google, Amazon, PayPal,
        Samsung, LG, Motorola, Dell, CISCO, Docomo, Lenovo,
        Verizon, Vodafone, ChinaMobile, TMobile, Sprint, Aircel, Airtel, Maxis, TIM, ATT, M1, TStore, AppZone, Turkcell, Omnitel, MTNPlay,
        AppBrain, SlideMe, AppsLib, Tegra, AndroidPit, Socii0, Camangi, Nook, Appoke
    }

    private String cookie, title, sku, signature, quantity, receipt, placementTag, price, store;
    // For receipt verification
    private String payload, orderId;
    private Result result = Result.Unset;

    public static ArrayList<Purchase> fromJson(String json)
    {
        if(json == null) return new ArrayList<Purchase>(0);

        String url = JsonUtil.getPath(json, "$.url");
        UrlQuerySanitizer sanitizer = new UrlQuerySanitizer(url);
        final String placementTag = sanitizer.getValue("placement_tag");

        ArrayList<Purchase> toReturn = new ArrayList<Purchase>();
        for(String jsonPurchase : JsonUtil.forEach(json, "$.purchases"))
            toReturn.add(new Purchase(jsonPurchase, placementTag));

        return toReturn;
    }

    public Purchase(String json, String placementTag)
    {
        this.cookie = JsonUtil.getPath(json, "$.cookie");
        this.title = JsonUtil.getPath(json, "$.name");
        this.sku = JsonUtil.getPath(json, "$.product");
        this.signature = JsonUtil.getPath(json, "$.sig4");
        this.price = null;
        this.store = null;
        this.placementTag = placementTag;
        this.payload = null;
        this.orderId = null;

        /**
         * Google/Amazon/Samsung all use Strings
         * client-api expects Integer
         */
        this.quantity = JsonUtil.asString(json, "$.quantity");
        this.receipt = JsonUtil.asString(json, "$.receipt");
    }

    public Purchase(Parcel in)
    {
        readFromParcel(in);
    }

    public Purchase()
    {

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
    public void writeToParcel(Parcel dest, int flags)
    {
        dest.writeString(sku);
        dest.writeString(title);
        dest.writeString(quantity);
        dest.writeString(price);
        dest.writeString(store);
        dest.writeString(signature);
        dest.writeString(receipt);
        dest.writeString(cookie);
        dest.writeString(placementTag);
        dest.writeString(payload);
        dest.writeString(orderId);
        dest.writeInt(result.ordinal());
    }

    /**
     * Deserialize this object from a Parcel
     *
     * @param in parcel to read from
     */
    protected void readFromParcel(Parcel in)
    {
        sku = in.readString();
        title = in.readString();
        quantity = in.readString();
        price = in.readString();
        store = in.readString();
        signature = in.readString();
        receipt = in.readString();
        cookie = in.readString();
        placementTag = in.readString();
        payload = in.readString();
        orderId = in.readString();
        result = Result.values()[in.readInt()];
    }

    /**
     * Required Android annoyance
     */
    public static final Parcelable.Creator<Purchase> CREATOR = new Creator<Purchase>()
    {
        public Purchase createFromParcel(Parcel in){return new Purchase(in);}
        public Purchase[] newArray(int size){return new Purchase[size];}
    };

    public String getCookie(){return cookie;}
    public String getTitle(){return title;}
    public String getSKU(){return sku;}
    public void setSKU(String sku){this.sku = sku;}
    public String getSignature(){return signature;}
    public String getQuantity(){return quantity;}
    public void setQuantity(int qty){this.quantity = "" + qty;}
    public String getReceipt(){return receipt;}
    public String getPlacementTag(){return placementTag;}
    public Result getResult(){return result;}
    public void setResult(Result result){this.result = result;}
    public String getPrice(){return price;}
    public void setPrice(String price)
    {
        if(price == null)
            this.price = null;
        else
            this.price = price.replaceAll("[^0-9\\.]", "");
    }
    public void setPrice(Double price)
    {
        setPrice("" + price);
    }
    public void setStore(Store store){setStore(store.toString());}
    public void setStore(String store){this.store = store;}
    public String getStore(){return store;}
    public void setPayload(String payload){this.payload = payload;}
    public String getPayload(){return payload;}
    public void setOrderId(String orderId){this.orderId = orderId;}
    public String getOrderId(){return orderId;}


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
}
