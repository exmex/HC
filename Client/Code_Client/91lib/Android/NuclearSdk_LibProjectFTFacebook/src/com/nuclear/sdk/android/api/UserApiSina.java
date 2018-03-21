package com.nuclear.sdk.android.api;

import com.loopj.android.http.RequestParams;
import com.nuclear.sdk.android.token.Token;
import com.nuclear.sdk.net.AsyncUserRunner;
import com.nuclear.sdk.net.RequestListener;

public class UserApiSina extends IUserdApi {

	public UserApiSina(Token accessToken,String pAppid) {
		super(accessToken);
		this.appid = pAppid;
		this.SERVER_URL_UID = "https://api.weibo.com/oauth2/get_token_info";
		this.SERVER_URL_USER = "https://api.weibo.com/2/users/show.json";
	}

	 
	
	/**token已经获取uid，那么就不需要重复获取了*/
	@Override
	public void getMeUid(RequestListener listen) {
		// TODO Auto-generated method stub
		super.getMeUid(listen);
	
		RequestParams params = new RequestParams();
		params.put("access_token", this.accessToken);
		
		request( SERVER_URL_UID, params, HTTPMETHOD_GET, listen);
	
	}
	
	
	@Override
	public void getMeUser(RequestListener listen) {
		// TODO Auto-generated method stub
		
		RequestParams params = new RequestParams();
		params.put("source", this.appid);
		params.put("access_token", this.accessToken);
		params.put("uid", this.uid);
		request( SERVER_URL_USER, params, HTTPMETHOD_GET, listen);
		
	}
	
	
	@Override
	public void request(String url, RequestParams params, String httpMethod,
			RequestListener listener) {
		AsyncUserRunner.request(url, params, httpMethod, listener);
	}
}
