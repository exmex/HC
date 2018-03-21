package com.taobao.sdk.youai.api; 

import com.taobao.sdk.youai.Oauth2AccessToken;
import com.taobao.sdk.youai.TaobaoParameters;
import com.taobao.sdk.youai.net.RequestListener;


 
/**
 */
public class AccountAPI extends TaobaoAPI{
     
	 private static final String SERVER_URL_PRIX = "ip:" + "/user/~me";
	    
	    private Oauth2AccessToken mAccessToken;
		
	    public AccountAPI(Oauth2AccessToken accessToken) {
	    	super(accessToken);
	    }

		 
	    
	    /**
	     * OAuth授权之后，获取授权用户的UID
	     * @param listener
	     */
	    public void getUid(RequestListener listener) {
	    	 
	    	TaobaoParameters params = new TaobaoParameters();
	        request( SERVER_URL_PRIX + "\"-H Authorization: Bearer "+this.mAccessToken.getToken()+"\"",
	        		params, TaobaoAPI.HTTPMETHOD_POST,listener);
	    }
}
