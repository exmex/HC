package com.youai.sdk.android;


import android.app.AlertDialog;
import android.content.Context;
import android.util.Log;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.loopj.android.http.RequestParams;
import com.youai.sdk.android.config.FatherOAuthConfig;
import com.youai.sdk.android.token.Token;

public class OAuthChina {

	private static final String TAG = OAuthChina.class.getSimpleName();

	private Context mContext;
	private FatherOAuthConfig mConfig;
	private AccessTokenKeeper mKeeper;

	public OAuthChina(Context context, FatherOAuthConfig config) {
		mContext = context;
		mConfig = config;
		mKeeper = new AccessTokenKeeper(config.getClass().getSimpleName());
	}

	public FatherOAuthConfig getConfig() {
		return mConfig;
	}

	public Token getToken() {
		return mKeeper.readAccessToken(mContext);
	}
	public void clearToken() {
		mKeeper.clear(mContext);
	}

	public void refreshToken(String refreshToken, final OAuthListener listen) {
		AsyncHttpClient client = new AsyncHttpClient();
		String url = mConfig.getRefreshTokenUrl();
		if (url == null) {
			throw new UnsupportedOperationException();
		}
		RequestParams params = mConfig.getRefreshTokenParams(refreshToken);
		client.post(url, params, new AsyncHttpResponseHandler() {
			@Override
			public void onSuccess(String response) {
				Token token = Token.make(response, mConfig);
				if (token.isSessionValid()) {
					mKeeper.keepAccessToken(mContext, token);
				}
				if (listen != null) {
					listen.onSuccess(token);
				}
			}

			@Override
			public void onFailure(Throwable e, String response) {
				if (listen != null) {
					listen.onError(response);
				}
			}
		});
	}

	public void startOAuth(final OAuthListener listen) {
		final OAuthDialog dialog = new OAuthDialog(mContext, mConfig);
		dialog.setOAuthListener(new OAuthListener() {
			@Override
			public void onSuccess(Token token) {
				Log.d(TAG, "token: " + token.toString());
				if (token.isSessionValid()) {
					mKeeper.keepAccessToken(mContext, token);
				}
				//dialog.dismiss();
				listen.onSuccess(token);
				
			}
			@Override
			public void onError(String error) {
				Log.d(TAG, "error: " + error);
				if (listen != null) {
					new AlertDialog.Builder(mContext)  
					                .setTitle("提示")
					                .setMessage(error)
					                .setPositiveButton("确定", null)
					                .show();
					dialog.dismiss();
					listen.onError(error);
					
				}
				
			}

			@Override
			public void onCancel() {
				Log.d(TAG, "cancel");
				if (listen != null) {
					listen.onCancel();
				}
			}
		});
		dialog.show();
	}
}
