package com.playhaven.android.data;

import com.playhaven.android.PlayHaven;
import com.playhaven.android.util.JsonUtil;

public enum ContentUnitType
{
    Content("content"),
    ContentDispatch("content_dispatch");

    ContentUnitType(String value)
    {
        this.value = value;
    }
    private String value;
    public String toString(){return value;}
    public static ContentUnitType getType(String json)
    {
        if(json == null) return Content;
        String content_type = JsonUtil.getPath(json, "$.response.content_type");
        if(content_type == null) return Content;
        for(ContentUnitType type : values())
        {
            if(type.value.equals(content_type))
                return type;
        }
        return Content;
    }
}
