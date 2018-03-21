package com.playhaven.android.req;

import android.content.Context;
import android.content.SharedPreferences;
import com.playhaven.android.PlayHaven;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.compat.VendorCompat;
import org.springframework.http.HttpMethod;
import org.springframework.web.util.UriComponentsBuilder;

import java.util.Calendar;
import java.util.Date;


public class InstallRequest
extends PlayHavenRequest
{
    public InstallRequest() throws PlayHavenException {
        super();
        setMethod(HttpMethod.POST);
        setIdentifiers(Identifier.AdvertiserID, Identifier.Signature);
    }

    @Override
    protected void handleResponse(Context context, String json) {
        SharedPreferences pref = PlayHaven.getPreferences(context);
        SharedPreferences.Editor edit = pref.edit();
        Calendar rightNow = Calendar.getInstance();
        Date date = rightNow.getTime();
        edit.putLong(PlayHaven.Config.InstallReported.toString(), date.getTime());
        edit.commit();
        PlayHaven.d("Install reported: %s", date);
        super.handleResponse(context, json);
    }

    @Override
    protected int getApiPath(Context context)
    {
        return getCompat(context).getResourceId(context, VendorCompat.ResourceType.string, "playhaven_request_install");
    }
}
