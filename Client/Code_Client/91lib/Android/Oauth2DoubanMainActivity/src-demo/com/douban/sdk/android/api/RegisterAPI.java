package com.douban.sdk.android.api;

import com.douban.sdk.android.Oauth2AccessToken;
import com.douban.sdk.android.DoubanParameters;
import com.douban.sdk.android.net.RequestListener;
/**
 */
public class RegisterAPI extends DoubanAPI {
	public RegisterAPI(Oauth2AccessToken accessToken) {
        super(accessToken);
    }

    private static final String SERVER_URL_PRIX = API_SERVER + "/register";

	/**
	 * 验证昵称是否可用
	 * 
	 * @param nickname 需要验证的昵称。4-20个字符，支持中英文、数字、"_"或减号。
	 * @param listener
	 */
	public void suggestions( String nickname, RequestListener listener) {
		DoubanParameters params = new DoubanParameters();
		params.add("nickname", nickname);
		request( SERVER_URL_PRIX + "/verify_nickname.json", params, HTTPMETHOD_GET, listener);
	}

}
