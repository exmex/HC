package com.tencent.sdk.youai.api; 

import com.tencent.sdk.youai.Oauth2AccessToken;
import com.tencent.sdk.youai.TencentParameters;
import com.tencent.sdk.youai.net.RequestListener;


 
/**
 */
public class AccountAPI extends TencentAPI{
     
	 private static final String SERVER_URL_PRIX = "https://graph.z.qq.com/moc2/me";
	    
	    private Oauth2AccessToken mAccessToken;
		
	    public AccountAPI(Oauth2AccessToken accessToken) {
	    	super(accessToken);
	    }

		 
	    
	    /**
	     * OAuth授权之后，获取授权用户的UID
	     * PC网站接入时，获取到用户OpenID，返回包如下：
			callback( {"client_id":"YOUR_APPID","openid":"YOUR_OPENID"} ); 
			WAP网站接入时，返回如下字符串：
			client_id=100222222&openid=1704************************878C
	     * @param listener
	     */
	    public void getUid(RequestListener listener) {
	    	 
	    	TencentParameters params = new TencentParameters();
	        request( SERVER_URL_PRIX +"?"+this.mAccessToken.getToken()+"\"",
	        		params, TencentAPI.HTTPMETHOD_GET,listener);
	    }
}
