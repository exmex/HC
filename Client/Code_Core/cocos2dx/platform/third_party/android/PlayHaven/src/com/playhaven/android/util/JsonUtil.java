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
package com.playhaven.android.util;

import com.jayway.jsonpath.InvalidPathException;
import com.jayway.jsonpath.JsonPath;
import com.playhaven.android.PlayHaven;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import net.minidev.json.JSONValue;

import java.util.Iterator;
import java.util.List;

public class JsonUtil
{
    public static <T> T getPath(JSONObject json, String path)
    {
        return getPath(json == null? null : json.toJSONString(), path);
    }

    public static <T> T getPath(String json, String path)
    {
        try{
            return JsonPath.read(json, path);
        }catch(IllegalArgumentException e){
            return null;
        }catch(InvalidPathException e){
            return null;
        }catch(NullPointerException e){
            return null;
        }
    }

    public static boolean hasPath(String json, String path)
    {
        try{
            return JsonPath.read(json, path) != null;
        }catch(InvalidPathException e){
            return false;
        }
    }

    private static class JSONIterator implements Iterator<String>
    {
        private Iterator<JSONObject> source;

        public JSONIterator(Iterator<JSONObject> source)
        {
            this.source = source;
        }

        /**
         * Returns true if there is at least one more element, false otherwise.
         *
         * @see #next
         */
        @Override
        public boolean hasNext() {
            return source.hasNext();
        }

        /**
         * Returns the next object and advances the iterator.
         *
         * @return the next object.
         * @throws java.util.NoSuchElementException if there are no more elements.
         * @see #hasNext
         */
        @Override
        public String next() {
            JSONObject obj = source.next();
            if(obj == null) return null;
            return obj.toJSONString();
        }

        /**
         * Removes the last object returned by {@code next} from the collection.
         * This method can only be called once between each call to {@code next}.
         *
         * @throws UnsupportedOperationException if removing is not supported by the collection being
         *                                       iterated.
         * @throws IllegalStateException         if {@code next} has not been called, or {@code remove} has
         *                                       already been called after the last call to {@code next}.
         */
        @Override
        public void remove() {
            source.remove();
        }
    }

    public static Iterable<String> forEach(String json, String path)
    {
        if(json == null || path == null) return null;
        final List<JSONObject> jsonObjects = JsonPath.read(json, path);

        return new Iterable<String>(){

            /**
             * Returns an {@link java.util.Iterator} for the elements in this object.
             *
             * @return An {@code Iterator} instance.
             */
            @Override
            public Iterator<String> iterator() {
                return new JSONIterator(jsonObjects.iterator());
            }
        };
    }

    public static String asString(JSONObject json, String path)
    {
        return asString(json.toJSONString(), path);
    }


    public static String asString(String json, String path)
    {
        Object o = JsonPath.read(json, path);
        if(o == null) return null;
        return o.toString();
    }

    public static int asInt(JSONObject json, String path, int defaultValue)
    {
        Integer val = asInteger(json, path);
        if(val == null) return defaultValue;
        return val;
    }

    public static int asInt(String json, String path, int defaultValue)
    {
        Integer val = asInteger(json, path);
        if(val == null) return defaultValue;
        return val;
    }

    public static Integer asInteger(JSONObject json, String path)
    {
        String s = asString(json, path);
        if(s == null) return null;
        return Integer.valueOf(s);
    }

    public static Integer asInteger(String json, String path)
    {
        String s = asString(json, path);
        if(s == null) return null;
        return Integer.valueOf(s);
    }

    public static Double asDouble(String json, String path)
    {
        String s = asString(json, path);
        if(s == null) return null;
        return Double.valueOf(s);
    }

    public static Long asLong(String json, String path)
    {
        String s = asString(json, path);
        if(s == null) return null;
        return Long.valueOf(s);
    }
}
