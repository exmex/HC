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

import com.playhaven.android.PlayHavenException;
import org.apache.http.params.CoreProtocolPNames;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.concurrent.Callable;

/**
 * Class for retrieving urls from client-api. 
 * This is used, for example, to retrieve Google Play urls when 
 * a user clicks a buy button.
 */
public class UrlRequest implements Callable <String> {
	public static final String LOCATION_HEADER = "Location";
    private String mInitialUrl;
    
    public UrlRequest(String initialUrl) {
        mInitialUrl = initialUrl;
    }
    
    @Override
    public String call() throws MalformedURLException, IOException, PlayHavenException {
        HttpURLConnection connection = (HttpURLConnection) new URL(mInitialUrl).openConnection();
        connection.setInstanceFollowRedirects(true);
        connection.setRequestProperty(CoreProtocolPNames.USER_AGENT, UserAgent.USER_AGENT);
        connection.getContent(); // .getHeaderFields() will return null if headers not accessed once before 
        
        if(connection.getHeaderFields().containsKey(LOCATION_HEADER)){
            return connection.getHeaderField(LOCATION_HEADER);
        } else {
            throw new PlayHavenException();
        }
    }
}