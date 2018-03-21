package com.tencent.sdk.youai.net;

import com.tencent.sdk.youai.TencentException;
import com.tencent.sdk.youai.TencentParameters;

public class AsyncTencentRunner {

	
	public static void request(final String url, final TencentParameters params,
			final String httpMethod, final RequestListener listener) {
		new Thread() {
			@Override
			public void run() {
				try {
					String resp = HttpManager.openUrl(url, httpMethod, params,
							params.getValue("pic"));
					listener.onComplete(resp);
				} catch (TencentException e) {
					listener.onError(e);
				}
			}
		}.start();

	}
	
}
