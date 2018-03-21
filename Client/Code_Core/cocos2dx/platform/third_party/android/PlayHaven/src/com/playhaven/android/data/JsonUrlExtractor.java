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

import java.util.ArrayList;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Extract urls from JSON
 */
public class JsonUrlExtractor
{
    private static final String URL_PT1 = "([\"])(([^\"]+)([\\.])(";
    private static final String URL_PT2 = "))([\"])";
    private static final int flags = Pattern.DOTALL | Pattern.MULTILINE;
    // Capture group for the pattern to grab the URLs
    private static final int urlPatternGroup = 2;

    // Pattern for pulling content templates out of the json
    private static final Pattern ctPattern = Pattern.compile(URL_PT1 + "gz" + URL_PT2, flags);

    // Pattern for pulling images out of the json
    private static final Pattern imgPattern = Pattern.compile(URL_PT1 + "jpg|gif|png" + URL_PT2, flags);

    public static List<String> getContentTemplates(String json) {
        return getForPattern(ctPattern, json);
    }

    public static List<String> getImages(String json) {
        return getForPattern(imgPattern, json);
    }

    private static List<String> getForPattern(Pattern pattern, String json)
    {
        ArrayList<String> urls = new ArrayList<String>();
        Matcher matcher = pattern.matcher(json);
        while(matcher.find())
            urls.add(matcher.group(urlPatternGroup));

        return urls;
    }

}
