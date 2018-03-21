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
package com.playhaven.android.data;

import com.playhaven.android.PlayHavenException;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import net.minidev.json.JSONValue;
import net.minidev.json.parser.JSONParser;

import java.io.Reader;
import java.util.Map;

public class CustomEvent
{
    private static final String KEY_TIMESTAMP = "ts";
    private static final String KEY_EVENT = "event";
    private JSONObject root;

    public CustomEvent(Reader json) throws PlayHavenException
    {
        this();
        try {
            JSONParser parser = new JSONParser(JSONParser.MODE_PERMISSIVE);
            root.put(KEY_EVENT, parser.parse(json));
        } catch (Exception e) {
            throw new PlayHavenException("Unable to parse json", e);
        }
    }

    public CustomEvent(String json) throws PlayHavenException {
        this();
        try {
            root.put(KEY_EVENT, JSONValue.parse(json));
        } catch (Exception e) {
            throw new PlayHavenException("Unable to parse json", e);
        }
    }

    public CustomEvent(Map<String, Object> data)
    {
        this();
        root.put(KEY_EVENT, new JSONObject(data));
    }


    public CustomEvent(JSONObject data)
    {
        this();
        root.put(KEY_EVENT, data);
    }

    public CustomEvent(JSONArray data)
    {
        this();
        root.put(KEY_EVENT, data);
    }

    private CustomEvent()
    {
        root = new JSONObject();
        root.put(KEY_TIMESTAMP, (int) (System.currentTimeMillis() / 1000L)); // unixtime per server
    }

    public JSONObject toJSONObject(){return root;}

    public String toString()
    {
        return root.toJSONString();
    }
}
