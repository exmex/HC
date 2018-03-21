package com.douban.sdk.android.api;

import com.douban.sdk.android.Oauth2AccessToken;
import com.douban.sdk.android.DoubanParameters;
import com.douban.sdk.android.net.RequestListener;
/**
 *
 */
public class CommonAPI extends DoubanAPI {
	public CommonAPI(Oauth2AccessToken accessToken) {
        super(accessToken);
    }

    private static final String SERVER_URL_PRIX = API_SERVER + "/common";

	/**
	 * 获取城市列表
	 * 
	 * @param province
	 * @param capital
	 * @param language 返回的语言版本，zh-cn：简体中文、zh-tw：繁体中文、english：英文，默认为zh-cn。
	 * @param listener
	 */
	public void getCity( String province, CAPITAL capital,String language, RequestListener listener) {
		DoubanParameters params = new DoubanParameters();
		params.add("province", province);
	      if(null!=capital){
	          params.add("capital", capital.name().toLowerCase());
	      }
		params.add("language", language);
		request( SERVER_URL_PRIX + "/get_city.json", params, HTTPMETHOD_GET, listener);
	}
		
	/**
     * 获取国家列表
     * @param capital 国家的首字母，a-z，可为空代表返回全部，默认为全部。
     * @param language 返回的语言版本，zh-cn：简体中文、zh-tw：繁体中文、english：英文，默认为zh-cn。
     */
    public void getCountry(CAPITAL capital,String language, RequestListener listener) {
        DoubanParameters params = new DoubanParameters();
      if(null!=capital){
          params.add("capital", capital.name().toLowerCase());
      }
        params.add("language", language);
        request( SERVER_URL_PRIX + "/get_country.json", params, HTTPMETHOD_GET, listener);
    }
	
	/**
	 * 获取时区配置表
	 * 
	 * @param language 返回的语言版本，zh-cn：简体中文、zh-tw：繁体中文、english：英文，默认为zh-cn。
	 * @param listener
	 */
	public void getTimezone( String language, RequestListener listener) {
		DoubanParameters params = new DoubanParameters();
		params.add("language", language);
		request( SERVER_URL_PRIX + "/get_timezone.json", params, HTTPMETHOD_GET, listener);
	}
}
