package com.youai.sdk.android.api;

import java.io.IOException;

import com.loopj.android.http.RequestParams;
import com.youai.sdk.android.token.Token;
import com.youai.sdk.net.AsyncUserRunner;
import com.youai.sdk.net.RequestListener;


public abstract class IUserdApi {
	
	 	protected String SERVER_URL_UID;
	    protected String SERVER_URL_USER;
	    
	    private Token mAccessToken;
	    
	     
		public static final String HTTPMETHOD_POST = "POST";
		public static final String HTTPMETHOD_GET = "GET";
		
		protected String uid;//用户uid
		protected String nickname;//用户昵称
		protected String appid;//用户分配应用appid
		protected RequestListener mRequestListenUid;
		protected RequestListener mRequestListenUser;
		
		protected String accessToken;
		
		
		 
	    public IUserdApi(Token pAccessToken) {
	    	this.mAccessToken = pAccessToken;
	    	accessToken = this.mAccessToken.getAccessToken();
	    	uid = this.mAccessToken.getUid();
	    }
	    
	    public void getMeUid(RequestListener listen) {
	    	 
	     
	    }
	    
	    public void getMeUser(RequestListener listen){
	    	
	    }

	    
	    public void request( final String url, RequestParams params,
				final String httpMethod,RequestListener listener) {
		
		}
	    
}
