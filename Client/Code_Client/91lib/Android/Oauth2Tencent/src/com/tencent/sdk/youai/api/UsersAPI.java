package com.tencent.sdk.youai.api; 

import com.tencent.sdk.youai.Oauth2AccessToken;
import com.tencent.sdk.youai.TencentParameters;
import com.tencent.sdk.youai.net.RequestListener;


/**
 */
public class UsersAPI extends TencentAPI {
     
	public UsersAPI(Oauth2AccessToken accessToken) {
        super(accessToken);
    }

    private static final String SERVER_URL_PRIX = "https://openmobile.qq.com/user/get_simple_userinfo";

    
    /**
	 * 根据用户ID获取用户信息
	 * @param openid 需要查询的用户ID。
	 * 
	 * JSON示例:
Content-type: text/html; charset=utf-8 
{
"ret":0,
"msg":"",
"nickname":"Peter",
"figureurl":"http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/30",
"figureurl_1":"http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/50",
"figureurl_2":"http://qzapp.qlogo.cn/qzapp/111111/942FEA70050EEAFBD4DCE2C1FC775E56/100",
"figureurl_qq_1":"http://q.qlogo.cn/qqapp/100312990/DE1931D5330620DBD07FB4A5422917B6/40",
"figureurl_qq_2":"http://q.qlogo.cn/qqapp/100312990/DE1931D5330620DBD07FB4A5422917B6/100",
"gender":"男",
"is_yellow_vip":"1",
"vip":"1",
"yellow_vip_level":"7",
"level":"7",
"is_yellow_year_vip":"1"
} 
3.7错误返回示例

Content-type: text/html; charset=utf-8
{
"ret":1002,
"msg":"请先登录"
} 

	 * @param listener
	 */
	public void show(String openid,String access_token,String oauth_consumer_key, RequestListener listener) {
		TencentParameters params = new TencentParameters();
		params.add("uid", openid);
		params.add("access_token", access_token);
		params.add("oauth_consumer_key", oauth_consumer_key);
		request( SERVER_URL_PRIX, params, HTTPMETHOD_GET, listener);
	}
    
	 

}
