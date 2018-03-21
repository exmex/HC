package com.playhaven.android.req;

public enum Identifier
{
    AndroidID("device"),
    SenderID("sid"),
    AdvertiserID("ifa"),
    Signature("sig4");

    Identifier(String param)
    {
        this.param = param;
    }
    private String param;
    public String getParam(){return param;}
}
