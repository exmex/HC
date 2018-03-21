package com.youai.sdk.net;

import android.content.Context;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.youai.sdk.android.api.YouaiApi;
import com.youai.sdk.android.api.YouaiException;
import com.youai.sdk.android.api.HttpParameters;

public class AsyncUserRunner {
	static AsyncHttpClient client = new AsyncHttpClient();
	
	public static void request(final String url, final RequestParams params,
			final String httpMethod, final RequestListener listener) {
		
		
		
		
		if(httpMethod.equals("GET")){
			client.get(url,params, new AsyncHttpResponseHandler(){
				@Override
				public void onSuccess(int statusCode, String content) {
					listener.onComplete(content);
				}
				
				@Override
				public void onFailure(Throwable error,String response) {

					if (listener != null) {
						listener.onError(new YouaiException());
					}
				}
			});
		}else if(httpMethod.equals("POST")){
			client.post(url, params, new AsyncHttpResponseHandler(){
				@Override
				public void onSuccess(int statusCode, String content) {
					listener.onComplete(content);
				}
				
				@Override
				public void onFailure(Throwable error,String response) {

					if (listener != null) {
						listener.onError(new YouaiException());
					}
				}
			});
		}

	}
	
	
	
	public static void requestYouai(final String url,final RequestParams params,
			final String httpMethod,final  RequestListener listener) {
		
		
		if(httpMethod.equals("GET")){
			client.get(url,params, new AsyncHttpResponseHandler(){
				@Override
				public void onSuccess(int statusCode, String content) {
					listener.onComplete(content);
				}
				
				@Override
				public void onFailure(Throwable error,String response) {

					if (listener != null) {
						listener.onError(new YouaiException());
					}
				}
			});
		}else if(httpMethod.equals("POST")){
			client.post(url, params, new AsyncHttpResponseHandler(){
				@Override
				public void onSuccess(int statusCode, String content) {
					listener.onComplete(content);
				}
				
				@Override
				public void onFailure(Throwable error,String response) {

					if (listener != null) {
						listener.onError(new YouaiException());
					}
				}
			});
		}

	}
	
	
	public static void requestInit(final Context pContext,String appid,String appKey,String channelName,final RequestListener listener) {
		//String resp = HttpManager.openUrl(url, httpMethod, params);
		YouaiApi.Init(pContext,appid,appKey,channelName, listener);
	}
	
	
	public static void requestCreate(){
		
	}
	
}
