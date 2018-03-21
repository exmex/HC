package com.youai.sdk.android.api;

import com.loopj.android.http.RequestParams;
import com.youai.sdk.android.token.Token;
import com.youai.sdk.net.AsyncUserRunner;
import com.youai.sdk.net.RequestListener;

public class UserApiTencent extends IUserdApi {

	public UserApiTencent(Token accessToken) {
		super(accessToken);
		this.SERVER_URL_UID = "https://graph.z.qq.com/moc2/me";
		this.SERVER_URL_USER = "https://openmobile.qq.com/user/get_simple_userinfo";
	}
	
	/**
     * OAuth授权之后，获取授权用户的UID
     * PC网站接入时，获取到用户OpenID，返回包如下：
		callback( {"client_id":"YOUR_APPID","openid":"YOUR_OPENID"} ); 
		WAP网站接入时，返回如下字符串：
		client_id=100222222&openid=1704************************878C
     * @param listener
     */
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
		super.getMeUser(listen);
		
		RequestParams params = new RequestParams();
		params.put("access_token", this.accessToken);
		params.put("oauth_consumer_key", this.appid);
		params.put("openid", this.uid);
		request( SERVER_URL_USER, params, HTTPMETHOD_GET, listen);
		
	}
	
	
	@Override
	public void request(String url, RequestParams params, String httpMethod,
			RequestListener listener) {
		// TODO Auto-generated method stub
		AsyncUserRunner.request(url, params, httpMethod, listener);
	}
	
}

