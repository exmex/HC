package com.youai.sdk.net;

import java.io.IOException;

import com.youai.sdk.android.api.YouaiException;


/**
 */
public interface RequestListener {
     
	public void onComplete(String response);

	public void onIOException(IOException e);

	public void onError(YouaiException e);

}
