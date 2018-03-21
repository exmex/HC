package com.nuclear.sdk.android;

import com.nuclear.sdk.android.token.Token;

public interface OAuthListener {
	void onSuccess(Token token);

	void onCancel();

	void onError(String error);
}