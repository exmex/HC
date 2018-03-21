package com.playhaven.android.req;

import android.content.Context;
import com.playhaven.android.PlayHavenException;
import com.playhaven.android.util.JsonUtil;
import net.minidev.json.JSONArray;
import net.minidev.json.JSONObject;
import org.springframework.web.util.UriComponentsBuilder;
import java.net.URI;
import java.net.URL;

public class ContentDispatchRequest extends ContentRequest
{
    private JSONObject data;
    private String host, path;

    public ContentDispatchRequest(String json) throws PlayHavenException
    {
        this((JSONObject) JsonUtil.getPath(json, "$.response.content_dispatch.data"));
    }

    protected ContentDispatchRequest(JSONObject data) throws PlayHavenException {
        super();
        if(data == null)
            throw new PlayHavenException("Data can not be null");

        this.data = data;
        setIdentifiers((JSONArray) JsonUtil.getPath(data, "$.client_params"));
        try {
            String dataUrl = JsonUtil.getPath(data, "$.url");
            if(dataUrl != null)
            {
                URI uri = new URL(dataUrl).toURI();
                URI hostBits = new URI(uri.getScheme(), uri.getUserInfo(), uri.getHost(), uri.getPort(), null, null, null);
                host = hostBits.toString();
                if(dataUrl.startsWith(host)) {
                    path = dataUrl.substring(host.length());

                    // Strip any extra path
                    int idx = path.indexOf('?');
                    if(idx != -1)
                        path = path.substring(0, idx);
                }else {
                    host = null;
                }
            }
        }catch(Exception e){
            throw new PlayHavenException(e);
        }
    }

    @Override
    protected UriComponentsBuilder createApiUrl(Context context) throws PlayHavenException {
        if(data == null || host == null)
            return super.createApiUrl(context);

        try {
            return UriComponentsBuilder.fromHttpUrl(host);
        }catch(Exception e){
            throw new PlayHavenException("Unable to request appropriate url");
        }
    }

    @SuppressWarnings("deprecation")
    protected UriComponentsBuilder addApiPath(Context context, UriComponentsBuilder builder) throws PlayHavenException{
        if(data == null)
            return super.addApiPath(context, builder);

        try {
            builder.path(path);
            return builder;
        }catch(Exception e){
            throw new PlayHavenException("Unable to request appropriate url");
        }
    }

    @Override
    protected UriComponentsBuilder createUrl(Context context) throws PlayHavenException {
        UriComponentsBuilder builder = super.createUrl(context);
        if(data != null)
        {
            JSONObject params = JsonUtil.getPath(data, "$.params");
            if(params != null)
            {
                for(String key : params.keySet())
                    builder.queryParam(key, params.get(key));
            }
        }
        return builder;
    }
}
