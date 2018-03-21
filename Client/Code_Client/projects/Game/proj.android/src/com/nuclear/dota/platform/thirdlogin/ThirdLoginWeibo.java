package com.nuclear.dota.platform.thirdlogin;

import java.io.IOException;
import java.text.SimpleDateFormat;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.weibo.sdk.android.Oauth2AccessToken;
import com.weibo.sdk.android.Weibo;
import com.weibo.sdk.android.WeiboAuthListener;
import com.weibo.sdk.android.WeiboDialogError;
import com.weibo.sdk.android.WeiboException;
import com.weibo.sdk.android.api.AccountAPI;
import com.weibo.sdk.android.api.UsersAPI;
import com.weibo.sdk.android.net.RequestListener;
import com.qsds.ggg.dfgdfg.fvfvf.R;
import com.nuclear.dota.platform.thirdlogin.LoginDialog.LoginCallback;


public class ThirdLoginWeibo implements IThirdLogin {
	
	private static ThirdLoginWeibo sInstance = null;
	private static final String CONSUMER_KEY = "966056985";// 替换为开发者的appkey，例如"1646212860";
    private static final String REDIRECT_URL = "http://www.sina.com";
    public static Oauth2AccessToken accessToken;
    public static final String TAG = LoginDialog.class.toString();
    Weibo mWeiboInstance;
    private Context mContext;
    private LoginCallback mLoginResult; 
    private AccountAPI accountUser;
    private ThirdUserInfo mThirdUser;
    private UsersAPI user;
    
    public ThirdLoginWeibo(){
    	
    }
	
	@Override
	public void GetServerUser() {
		// TODO Auto-generated method stub
		accountUser = new AccountAPI(accessToken);
		mThirdUser = new ThirdUserInfo();
		user = new UsersAPI(accessToken);
		accountUser.getUid(new RequestListener() {
			
			@Override
			public void onIOException(IOException arg0) {
			}
			
			@Override
			public void onError(WeiboException arg0) {
				// TODO Auto-generated method stub
				mThirdUser = null;
			}
			
			@Override
			public void onComplete(String arg0) {
				JSONObject jsonobj = null;
				long longuid = 0l;
				try {
					jsonobj = new JSONObject(arg0);
					String tempid = jsonobj.getString("uid");
					longuid = Long.valueOf(tempid).longValue();
					mThirdUser.setUid(longuid);
					mThirdUser.setUidStr(tempid);
				} catch (JSONException e) {
					mLoginResult.onFailed();
					e.printStackTrace();
				}
				user.show(longuid,new RequestListener(){

					@Override
					public void onComplete(String arg0) {
						// TODO Auto-generated method stub
						JSONObject jsonobj = null;
						try {
							jsonobj = new JSONObject(arg0);
						} catch (JSONException e) {
							e.printStackTrace();
						}
						try {
							mThirdUser.setNickname(jsonobj.getString("screen_name"));
							mLoginResult.onSuccess();
						} catch (JSONException e) {
							// TODO Auto-generated catch block
							mLoginResult.onFailed();
						}
					}

					@Override
					public void onError(WeiboException arg0) {
						// TODO Auto-generated method stub
						mLoginResult.onFailed();
					}

					@Override
					public void onIOException(IOException arg0) {
						// TODO Auto-generated method stub
					}
					
				});
				
			}
		});
		

		
		
	}

	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		mWeiboInstance = Weibo.getInstance(CONSUMER_KEY, REDIRECT_URL);
	}

	@Override
	public IThirdLogin GetInstance() {
		// TODO Auto-generated method stub
		if (sInstance == null) {
			sInstance = new ThirdLoginWeibo();
			sInstance.onCreate();
		}
		return sInstance;
	}

	@Override
	public void authorize(LoginCallback pLoginResult) {
		// TODO Auto-generated method stub
		mWeiboInstance.authorize(mContext, new AuthDialogListener());
		mLoginResult = pLoginResult;
	}

	@Override
	public void setContext(Context pContext) {
		// TODO Auto-generated method stub
		mContext = pContext;
	}
	
	
	 class AuthDialogListener implements WeiboAuthListener {

	        @Override
	        public void onComplete(Bundle values) {
	            String token = values.getString("access_token");
	            String expires_in = values.getString("expires_in");
	            accessToken = new Oauth2AccessToken(token, expires_in);
	            if (accessToken.isSessionValid()) {
	                String date = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
	                        .format(new java.util.Date(accessToken.getExpiresTime()));
	                Log.i("认证成功","认证成功:access_token: " + token + "\r\n"
	                        + "expires_in: " + expires_in + "\r\n有效期：" + date);
	                
	                WeiboAccessTokenKeeper.keepAccessToken(mContext,accessToken);
	                //Toast.makeText(mContext, "认证成功", Toast.LENGTH_SHORT).show();
	                
	                GetServerUser();
	               
	                
	            }
	        }

	        @Override
	        public void onError(WeiboDialogError e) {
	            Toast.makeText(mContext, "Auth error : " + e.getMessage(), Toast.LENGTH_LONG).show();
	            mLoginResult.onFailed();
	        }

	        @Override
	        public void onCancel() {
	            Toast.makeText(mContext, "Auth cancel",Toast.LENGTH_LONG).show();
	            mLoginResult.onFailed();
	        }

	        @Override
	        public void onWeiboException(WeiboException e) {
	            Toast.makeText(mContext,"Auth exception : " + e.getMessage(), Toast.LENGTH_LONG).show();
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
