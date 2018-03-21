package com.douban.sdk.android.net;

import com.douban.sdk.android.DoubanException;
import com.douban.sdk.android.DoubanParameters;

/**
 * 
 * @author luopeng (luopeng@staff.sina.com.cn)
 */
public class AsyncDoubanRunner {
    /**
     * 请求接口数据，并在获取到数据后通过RequestListener将responsetext回传给调用者
     * @param url 服务器地址
     * @param params 存放参数的容器
     * @param httpMethod "GET"or “POST”
     * @param listener 回调对象
     */
	public static void request(final String url, final DoubanParameters params,
			final String httpMethod, final RequestListener listener) {
		new Thread() {
			@Override
			public void run() {
				try {
					String resp = HttpManager.openUrl(url, httpMethod, params,
							params.getValue("pic"));
					listener.onComplete(resp);
				} catch (DoubanException e) {
					listener.onError(e);
				}
			}
		}.start();

	}

}
