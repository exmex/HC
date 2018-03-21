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
import org.springframework.http.client.ClientHttpResponse;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.client.DefaultResponseErrorHandler;

import java.io.IOException;
import java.io.InputStream;

/**
 * Handle reported errors from the server
 */
public class ServerErrorHandler
extends DefaultResponseErrorHandler
{
    public ServerErrorHandler()
    {
        super();
    }

    /**
     * <p>The default implementation throws a {@link org.springframework.web.client.HttpClientErrorException} if the response status code is
     * {@link org.springframework.http.HttpStatus.Series#CLIENT_ERROR}, a {@link org.springframework.web.client.HttpServerErrorException}
     * if it is {@link org.springframework.http.HttpStatus.Series#SERVER_ERROR},
     * and a {@link org.springframework.web.client.RestClientException} in other cases.
     */
    @Override
    public void handleError(ClientHttpResponse response) throws IOException {
        switch(response.getStatusCode())
        {
            case BAD_REQUEST:
                throw new PlayHavenException(getResponseAsString(response));
            default:
                super.handleError(response);
        }
    }

    private String getResponseAsString(ClientHttpResponse response)
    {
        return new String(getResponseBody(response));
    }

    private byte[] getResponseBody(ClientHttpResponse response) {
        try {
            InputStream responseBody = response.getBody();
            if (responseBody != null) {
                return FileCopyUtils.copyToByteArray(responseBody);
            }
        } catch (IOException ex) {
            // ignore
        }
        return new byte[0];
    }
}
