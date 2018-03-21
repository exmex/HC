package com.tencent.sdk.youai.api;

import com.tencent.sdk.youai.Oauth2AccessToken;
import com.tencent.sdk.youai.TencentParameters;
import com.tencent.sdk.youai.net.AsyncTencentRunner;
import com.tencent.sdk.youai.net.RequestListener;


public class TencentAPI {
	 /**
     * 访问腾讯服务接口的地址
     */
	public static final String API_SERVER = "https://openmobile.qq.com";
	/**
	 * post请求方式
	 */
	public static final String HTTPMETHOD_POST = "POST";
	/**
	 * get请求方式
	 */
	public static final String HTTPMETHOD_GET = "GET";
	private Oauth2AccessToken oAuth2accessToken;
	private String accessToken;
	/**
	 * 构造函数，使用各个API接口提供的服务前必须先获取Oauth2AccessToken
	 * @param accesssToken Oauth2AccessToken
	 */
	public TencentAPI(Oauth2AccessToken oauth2AccessToken){
	    this.oAuth2accessToken=oauth2AccessToken;
	    if(oAuth2accessToken!=null){
	        accessToken=oAuth2accessToken.getToken();
	    }
	   
	}
 
	
	public void request( final String url, final TencentParameters params,
			final String httpMethod,RequestListener listener) {
		params.add("access_token", accessToken);
		AsyncTencentRunner.request(url, params, httpMethod, listener);
	}
}
