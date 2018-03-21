package com.taobao.sdk.youai.net;

import com.taobao.sdk.youai.TaobaoException;
import com.taobao.sdk.youai.TaobaoParameters;

public class AsyncTaobaoRunner {

	
	public static void request(final String url, final TaobaoParameters params,
			final String httpMethod, final RequestListener listener) {
		new Thread() {
			@Override
			public void run() {
				try {
					String resp = HttpManager.openUrl(url, httpMethod, params,
							params.getValue("pic"));
					listener.onComplete(resp);
				} catch (TaobaoException e) {
					listener.onError(e);
				}
			}
		}.start();

	}
	
}
