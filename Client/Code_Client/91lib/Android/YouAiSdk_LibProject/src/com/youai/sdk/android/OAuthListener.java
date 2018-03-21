package com.youai.sdk.android;

import com.youai.sdk.android.token.Token;

public interface OAuthListener {
	void onSuccess(Token token);

	void onCancel();

	void onError(String error);
}