/**
 * Copyright 2014 Medium Entertainment, Inc.
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
package com.playhaven.android.util;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import com.playhaven.android.PlayHaven;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;

import java.util.Map;

/**
 * Coordinate with a separate Kontagent integration
 */
public class KontagentUtil
{
    private static final String PREFS_NAME = "Kontagent";
    private static final String SENDER_ID_PREFIX = "keySessionSenderId.";
    private static final String KEY_API = "api";
    private static final String KEY_SID = "sid";

    public static void setSenderId(Context context, String apiKey, String senderId)
    {
        if(context == null || apiKey == null || senderId == null)
            return; // ignore if we are missing any info

        String senderKey = SENDER_ID_PREFIX + apiKey;

        SharedPreferences pref = PlayHaven.getPreferences(context);
        SharedPreferences.Editor editor = pref.edit();
        editor.putString(PlayHaven.Config.KontagentAPI.toString(), apiKey);
        editor.commit();

        pref = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        if(pref.getString(senderKey, null) != null)
            return; // don't overwrite an existing value

        editor = pref.edit();
        editor.putString(senderKey, senderId);
        editor.commit();
    }

    public static String getSenderId(Context context)
    {
        SharedPreferences pref = PlayHaven.getPreferences(context);
        String apiKey = pref.getString(PlayHaven.Config.KontagentAPI.toString(), null);
        if(apiKey == null) return null;

        pref = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        String sid = pref.getString(SENDER_ID_PREFIX + apiKey, null);
        if(TextUtils.isEmpty(sid))
            return null;

        return sid;
    }

    public static String getSenderIdsAsJson(Context context)
    {
        if(context == null)
            return null;

        JSONArray array = new JSONArray();
        int length = SENDER_ID_PREFIX.length();
        SharedPreferences pref = context.getSharedPreferences(PREFS_NAME, Context.MODE_PRIVATE);
        Map<String,?> map = pref.getAll();
        for(String key : map.keySet())
        {
            if(!key.startsWith(SENDER_ID_PREFIX) || key.length() <= length)
                continue;

            Object value = map.get(key);
            if(value == null)
                continue;

            JSONObject session = new JSONObject();
            session.put(KEY_API, key.substring(length));
            session.put(KEY_SID, value);
            array.add(session);
        }

        if(array.isEmpty())
            return null;

        /**
         [
         {"api":"895467583e494dbea9c81553c7b6b5ad","sid":"5611190844015425273"},
         {"api":"0123456789abcdef0123456789abcdef","sid":"0123456789abcdef012"}
         ]
         */
        return array.toJSONString();
    }
}
