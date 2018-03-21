package com.nuclear.sdk.net;

import java.io.IOException;

import com.nuclear.sdk.android.api.SdkException;


/**
 */
public interface RequestListener {
     
	public void onComplete(String response);

	public void onIOException(IOException e);

	public void onError(SdkException e);

}
