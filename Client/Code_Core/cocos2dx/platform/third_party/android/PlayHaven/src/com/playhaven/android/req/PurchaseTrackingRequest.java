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
package com.playhaven.android.req;

import android.content.Context;
import android.content.SharedPreferences;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.data.Purchase;
import org.springframework.http.HttpMethod;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Currency;
import java.util.Locale;

import static com.playhaven.android.compat.VendorCompat.ResourceType;

/**
 * Report purchase transactions
 */
public class PurchaseTrackingRequest
    extends ContentRequest  // to get session handling
{
    private Purchase purchase;

    public PurchaseTrackingRequest(Purchase purchase)
    {
        super(purchase.getPlacementTag());
        setMethod(HttpMethod.GET);
        this.purchase = purchase;
    }

    @Override
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
        UriComponentsBuilder builder = super.createUrl(context);

        if(purchase != null)
        {
            PlayHaven.d("Using: %s", purchase);
            SharedPreferences pref = PlayHaven.getPreferences(context);

            addNonNull(builder, "product", purchase.getSKU());
            addNonNull(builder, "quantity", purchase.getQuantity());
            addNonNull(builder, "placement_tag", purchase.getPlacementTag());
            Purchase.Result result = purchase.getResult();
            if(result != null)
                addNonNull(builder, "resolution", result.getUrlValue());

            String store = purchase.getStore();
            if(store == null)
            {
                // This tells us where we were installed from -- not where the purchase happened!
                store = context.getPackageManager().getInstallerPackageName(getString(pref, PlayHaven.Config.AppPkg));
            }
            addNonNull(builder, "store", store == null ? "sideload" : store);
            addNonNull(builder, "cookie", purchase.getCookie());
            addNonNull(builder, "price", purchase.getPrice());
            addNonNull(builder, "price_locale", Currency.getInstance(Locale.getDefault()).getCurrencyCode());
            addNonNull(builder, "payload", purchase.getPayload());
            addNonNull(builder, "order_id", purchase.getOrderId());
        }

        return builder;
    }

    protected void addNonNull(UriComponentsBuilder builder, String name, String value)
    {
        builder.queryParam(name, value == null ? "" : value);
    }

    @Override
    protected int getApiPath(Context context) 
    {
        return getCompat(context).getResourceId(context, ResourceType.string, "playhaven_request_iap_tracking");
    }
}
