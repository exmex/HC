
package com.nuclear.dota.platform.punchbox;


import java.net.URLEncoder;

import android.content.Context;
import android.util.Log;

/***
 * 此类使用AuthorizationCode，请求您的应用服务器*/
public class TokenInfoTask {

    private static final String TAG = "TokenInfoTask";
    public static String GETTOKEN = ""; 
   
    public static void doRequest(Context context, String authorizationCode,
            String appKey, String appSecret, 
            final TokenInfoListener listener) {
    	String uil_str =GETTOKEN+"auth_code=" + URLEncoder.encode(authorizationCode) + "&appid=" + 
    			URLEncoder.encode(appKey) +"&app_secret="+ URLEncoder.encode(appSecret);
    	/*String uil_str =GETTOKEN+"grant_type=authorizationCode&"
        		+ "code=" +authorizationCode + "&appid=" + 
    			appKey +"&app_secret="+appSecret;*/
    	
		SdkHttpTask.doGet(new SdkHttpListener() {

			@Override
			public void onError() {
				 listener.onGotError("");
			}
			
            @Override
            public void onResponse(String response) {
                listener.onGotTokenInfo(response);
            }

            @Override
            public void onCancelled() {
                listener.onGotTokenInfo(null);
            }

        }, uil_str);
        
        Log.d(TAG, "url=" + uil_str);
    }
 

}
