package com.nuclear.dota.platform.thirdlogin;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.widget.Toast;

import com.tencent.sdk.nuclear.Oauth2AccessToken;
import com.tencent.sdk.nuclear.Tencent;
import com.tencent.sdk.nuclear.TencentAuthListener;
import com.tencent.sdk.nuclear.TencentDialogError;
import com.tencent.sdk.nuclear.TencentException;
import com.tencent.sdk.nuclear.api.AccountAPI;
import com.tencent.sdk.nuclear.api.UsersAPI;
import com.tencent.sdk.nuclear.demo.TencentAccessTokenKeeper;
import com.nuclear.dota.platform.thirdlogin.LoginDialog.LoginCallback;


public class ThirdLoginQQWeb implements IThirdLogin {
	
	private static ThirdLoginQQWeb sInstance = null;
	private static final String CONSUMER_KEY = "100385103";// 替换为开发者的appkey，例如"1646212860";
    private static final String REDIRECT_URL = "http://oauth_china_android.com";//此处是沙箱访问 。正式访问是：https://oauth.Tencent.com/authorize
    public static Oauth2AccessToken accessToken;
    public static final String TAG = ThirdLoginQQWeb.class.toString();
    Tencent mQQInstance;
    private Context mContext;
    private LoginCallback mLoginResult; 
    private AccountAPI accountUser;
    private ThirdUserInfo mThirdUser;
    private UsersAPI user;
    
    public ThirdLoginQQWeb(){
    	
    }
	
	@Override
	public void GetServerUser() {
		// TODO Auto-generated method stub
				
	}

	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		mQQInstance = Tencent.getInstance(CONSUMER_KEY, REDIRECT_URL);
	}

	@Override
	public IThirdLogin GetInstance() {
		// TODO Auto-generated method stub
		if (sInstance == null) {
			sInstance = new ThirdLoginQQWeb();
			sInstance.onCreate();
		}
		return sInstance;
	}

	@Override
	public void authorize(LoginCallback pLoginResult) {
		// TODO Auto-generated method stub
		mQQInstance.authorize(mContext, new AuthDialogListener());
		mLoginResult = pLoginResult;
	}

	@Override
	public void setContext(Context pContext) {
		// TODO Auto-generated method stub
		mContext = pContext;
	}
	
	
	 class AuthDialogListener implements TencentAuthListener {

	        @Override
	        public void onComplete(String response) {
	        	JSONObject jsonback = null;
				try {
					jsonback = new JSONObject(response);
				} catch (JSONException e1) {
					// TODO Auto-generated catch block
					e1.printStackTrace();
				}
				long longuid = 0l;
				mThirdUser = new ThirdUserInfo();
        		
				try {
					
					
    				
					String msg = jsonback.getString("msg");//错误码
					String ret = jsonback.getString("ret");//0表示正确，其他失败
					String nickname = jsonback.getString("nickname");
					if(ret!="0"){//出现错误了
						
					}
					
					String tempid = mQQInstance.getUid();
    				longuid = Long.valueOf(tempid).longValue();
    				mThirdUser.setUid(longuid);
    				mThirdUser.setUidStr(tempid);
    				mThirdUser.setNickname(nickname);
    				
					
				} catch (Exception e) {
					mLoginResult.onFailed();
					e.printStackTrace();
				}  
				
				mLoginResult.onSuccess();
				
				
					accessToken = mQQInstance.getAccessToken();
	                TencentAccessTokenKeeper.keepAccessToken(mContext,accessToken);
	                Toast.makeText(mContext, "认证成功", Toast.LENGTH_SHORT).show();
	                
	               
	                
	            }

			@Override
			public void onTencentException(TencentException e) {
				// TODO Auto-generated method stub
				 Toast.makeText(mContext,"Auth exception : " + e.getMessage(), Toast.LENGTH_LONG).show();
			}

			@Override
			public void onError(TencentDialogError e) {
				// TODO Auto-generated method stub
				   mLoginResult.onFailed();
			}

			@Override
			public void onCancel() {
				// TODO Auto-generated method stub
				 mLoginResult.onFailed();
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
