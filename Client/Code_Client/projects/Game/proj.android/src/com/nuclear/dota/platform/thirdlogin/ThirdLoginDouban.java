package com.nuclear.dota.platform.thirdlogin;

import java.io.IOException;
import java.text.SimpleDateFormat;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Toast;

import com.douban.sdk.android.Oauth2AccessToken;
import com.douban.sdk.android.Douban;
import com.douban.sdk.android.DoubanAuthListener;
import com.douban.sdk.android.DoubanDialogError;
import com.douban.sdk.android.DoubanException;
import com.douban.sdk.android.api.AccountAPI;
import com.douban.sdk.android.api.UsersAPI;
import com.douban.sdk.android.demo.MainActivity;
import com.douban.sdk.android.keep.DoubanAccessTokenKeeper;
import com.douban.sdk.android.net.RequestListener;
import com.qsds.ggg.dfgdfg.fvfvf.R;
import com.nuclear.dota.platform.thirdlogin.LoginDialog.LoginCallback;

/* 这个豆瓣认证登录的需要一个lib库  还有些配置信息暂时写到了lib库里面，需要相应的跟随修改 */
public class ThirdLoginDouban implements IThirdLogin {

	private static ThirdLoginDouban sInstance = null;
	private static final String CONSUMER_KEY = "02e3d7298c9e5dd808ab857ca5db1988";// 替换为开发者的appkey
    private static final String REDIRECT_URL = "http://www.7g8g.cn";
    public static Oauth2AccessToken accessToken;
    public static final String TAG = ThirdLoginDouban.class.toString();
    Douban mDoubanInstance;
    private Context mContext;
    private LoginCallback mLoginResult; 
    private AccountAPI accountUser;
    private ThirdUserInfo mThirdUser;
    private UsersAPI user;
    
    public ThirdLoginDouban(){
    	
    }
	
	@Override
	public void GetServerUser() {
		
	}
	
	
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		mDoubanInstance = Douban.getInstance(CONSUMER_KEY, REDIRECT_URL);
	}

	@Override
	public IThirdLogin GetInstance() {
		// TODO Auto-generated method stub
		if (sInstance == null) {
			sInstance = new ThirdLoginDouban();
			sInstance.onCreate();
		}
		return sInstance;
	}

	@Override
	public void authorize(LoginCallback pLoginResult) {
		// TODO Auto-generated method stub
		mDoubanInstance.authorize(mContext, new AuthDialogListener());
		mLoginResult = pLoginResult;
	}

	@Override
	public void setContext(Context pContext) {
		// TODO Auto-generated method stub
		mContext = pContext;
	}
	
	
	 class AuthDialogListener implements DoubanAuthListener {

		 	public void onGetbackInfo(String userinfo){
		 	}
		 
	        @Override
	        public void onComplete(Bundle values) {
	            
	        }

	        @Override
	        public void onError(DoubanDialogError e) {
	            Toast.makeText(mContext, "Auth error : " + e.getMessage(), Toast.LENGTH_LONG).show();
	            mLoginResult.onFailed();
	        }

	        @Override
	        public void onCancel() {
	            Toast.makeText(mContext, "Auth cancel",Toast.LENGTH_LONG).show();
	            mLoginResult.onFailed();
	        }

			@Override
			public void onComplete(JSONObject values) {
					
						// TODO Auto-generated method stub
						// TODO Auto-generated method stub
						String token = values.optString("access_token");
			            String expires_in = values.optString("expires_in");
			            accessToken = new Oauth2AccessToken(token, expires_in);
			            if (accessToken.isSessionValid()) {
			                String date = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
			                        .format(new java.util.Date(accessToken.getExpiresTime()));
			                DoubanAccessTokenKeeper.keepAccessToken(mContext, accessToken);
			                //Toast.makeText(mContext, "认证成功", Toast.LENGTH_SHORT).show();
			                Log.i("onComplete:accessToken", accessToken.getToken());
			            }
			            
			            String    userinfo =  mDoubanInstance.GetUserInfo();
			            mThirdUser = new ThirdUserInfo();
				 		try {
							JSONObject userObj = new JSONObject(userinfo);
							Log.i("userinfo:", userinfo);
							mThirdUser.setNickname(userObj.getString("douban_user_name"));
							mThirdUser.setUidStr(userObj.getString("douban_user_id"));
							mThirdUser.setUid(Long.valueOf(mThirdUser.getUidStr()).longValue());
							mLoginResult.onSuccess();
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							mLoginResult.onFailed();
						}
			}

			 
			@Override
			public void onDoubanException(DoubanException arg0) {
				// TODO Auto-generated method stub
				
			}
 
	    }


	@Override
	public void setActivity(Activity pAcitivity) {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public ThirdUserInfo GetUserInfo() {
		// TODO Auto-generated method stub
		return mThirdUser;
	}
 

}
