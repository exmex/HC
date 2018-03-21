package com.youai.sdk.android.api;

import com.loopj.android.http.RequestParams;
import com.youai.sdk.android.token.Token;
import com.youai.sdk.net.AsyncUserRunner;
import com.youai.sdk.net.RequestListener;

public class UserApiDouban extends IUserdApi {

	public UserApiDouban(Token accessToken) {
		super(accessToken);
	}

	
	
	@Override
	public void request(String url, RequestParams params, String httpMethod,
			RequestListener listener) {
		AsyncUserRunner.request(url, params, httpMethod, listener);
	}
}
