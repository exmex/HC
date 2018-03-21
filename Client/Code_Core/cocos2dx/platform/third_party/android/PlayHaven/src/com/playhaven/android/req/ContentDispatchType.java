package com.playhaven.android.req;

import com.playhaven.android.data.ContentUnitType;
import com.playhaven.android.util.JsonUtil;

public enum ContentDispatchType
{
    Unknown("unknown"),
    UpsightContent("upsight_content");

    ContentDispatchType(String value)
    {
        this.value = value;
    }
    private String value;
    public String toString(){return value;}
    public static ContentDispatchType getType(String json)
    {
        if(json == null) return Unknown;
        String dispatch_type = JsonUtil.getPath(json, "$.response.content_dispatch.type");
        if(dispatch_type == null) return Unknown;
        for(ContentDispatchType type : values())
        {
            if(type.value.equals(dispatch_type))
                return type;
        }
        return Unknown;
    }
}
