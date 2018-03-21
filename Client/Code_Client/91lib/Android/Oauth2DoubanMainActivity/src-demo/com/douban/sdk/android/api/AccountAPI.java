package com.douban.sdk.android.api;

import com.douban.sdk.android.DoubanParameters;
import com.douban.sdk.android.Oauth2AccessToken;
import com.douban.sdk.android.net.RequestListener;
/**
 */
public class AccountAPI extends DoubanAPI {
    private static final String SERVER_URL_PRIX = API_SERVER + "/user/~me";
    
    private Oauth2AccessToken mAccessToken;
	public AccountAPI(Oauth2AccessToken accessToken) {
        super(accessToken);
    }

	 
    
    /**
     * OAuth授权之后，获取授权用户的UID
     * @param listener
     */
    public void getUid(RequestListener listener) {
        DoubanParameters params = new DoubanParameters();
        request( SERVER_URL_PRIX + "\"-H Authorization: Bearer "+this.mAccessToken.getToken()+"\"",
        		params, HTTPMETHOD_GET,listener);
    }
	 
}
