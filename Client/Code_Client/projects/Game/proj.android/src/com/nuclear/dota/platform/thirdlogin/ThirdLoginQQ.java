package com.nuclear.dota.platform.thirdlogin;

import java.io.IOException;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;

import org.apache.http.conn.ConnectTimeoutException;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.os.Handler;
import android.util.Log;

import com.tencent.open.HttpStatusException;
import com.tencent.open.NetworkUnavailableException;
import com.tencent.tauth.Constants;
import com.tencent.tauth.IRequestListener;
import com.tencent.tauth.IUiListener;
import com.tencent.tauth.Tencent;
import com.tencent.tauth.UiError;
import com.nuclear.dota.platform.thirdlogin.LoginDialog.LoginCallback;

public class ThirdLoginQQ implements IThirdLogin {

	
    private static final String APP_ID = "100363349";//更改为自己申请的app_id;
	private Context mContext;
	private Activity mLoginActivity;
    private static final String SCOPE = "get_user_info,get_simple_userinfo,get_user_profile";
    // private static final String SCOPE = "all";
    private static final int REQUEST_UPLOAD_PIC = 1000;
    private static final int REQUEST_SET_AVATAR = 2;
    private static final int REQUEST_WX = 1001;
    private static final String SERVER_PREFS = "ServerPrefs";
    private static final String SERVER_TYPE = "ServerType";

    private Tencent mTencent;
    private Handler mHandler;
    // set to 1 for test params
    private int mNeedInputParams = 1;
    private IThirdLogin sInstance;
	private LoginCallback mLoginResult;
	private ThirdUserInfo mThirdUser;
    
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub
		if(null==mTencent)
		mTencent = Tencent.createInstance(APP_ID, mContext);
		 
		
		 
		 IUiListener listener = new BaseUiListener() {
              @Override
			public void onError(UiError e) {
				// TODO Auto-generated method stub
            	 Log.i("IuiListener error", e.errorCode+e.errorDetail+e.errorMessage);
				super.onError(e);
			}

			@Override
              protected void doComplete(JSONObject response) {
				Log.i("doComplete:string:", response.toString());
              	try {
	 					Log.i("access_token:","access_token:"+response.getString("access_token"));
						Log.i("openid:","openid:"+response.getString("openid"));//腾讯的uid就是openid
						mThirdUser.setUidStr(response.getString("openid"));
					} catch (JSONException e) {
						e.printStackTrace();
					}
              }
          };
          mThirdUser = new ThirdUserInfo();
      
          
		 if (!mTencent.isSessionValid()) {
	          
	            mTencent.login(mLoginActivity, SCOPE, listener);
	        } else {
	        	
	        	String accesstoken = mTencent.getAccessToken();
	        	Log.i("accesstoken", accesstoken);
	        	mThirdUser.setUidStr(mTencent.getOpenId());
	        }
		 
		 if(ready())
		 mTencent.requestAsync(Constants.GRAPH_SIMPLE_USER_INFO, null,
                 Constants.HTTP_GET, new BaseApiListener("get_simple_userinfo", false), null);
	}
	
	 private boolean ready() {
	        boolean ready = mTencent.isSessionValid()
	                && mTencent.getOpenId() != null;
	        return ready;
	    }

	@Override
	public void GetServerUser() {
		// TODO Auto-generated method stub
	}

	@Override
	public IThirdLogin GetInstance() {
		if (sInstance == null) {
			sInstance = new ThirdLoginQQ();
		}
		return sInstance;
	}

	@Override
	public void authorize(LoginCallback pLoginResult) {
		mLoginResult = pLoginResult;
		onCreate();
		
	}

	@Override
	public void setContext(Context pContext) {
		// TODO Auto-generated method stub
		mContext =  pContext;
	}
	
	private void showResult(final String base, final String msg) {
		mLoginResult.onFailed();
        mHandler.post(new Runnable() {

            @Override
            public void run() {
            	Log.i("showResult:msg:", msg);
            }
        });
	}
	private class BaseUiListener implements IUiListener {

        @Override
        public void onComplete(JSONObject response) {
        	Log.i("onComplete",response.toString());
            doComplete(response);
        }

        protected void doComplete(JSONObject values) {

        }

        @Override
        public void onError(UiError e) {
           /* showResult("onError:", "code:" + e.errorCode + ", msg:"
                    + e.errorMessage + ", detail:" + e.errorDetail);*/
        	Log.i("UiError","code:" + e.errorCode + ", msg:"
                    + e.errorMessage + ", detail:" + e.errorDetail);
        }

        @Override
        public void onCancel() {
            /*showResult("onCancel", "");*/
        	Log.i("onCancel","onCancel");
        }
    }


	@Override
	public void setActivity(Activity pAcitivity) {
		mLoginActivity = pAcitivity;
	}
	
	
	
	
	  private class BaseApiListener implements IRequestListener {
	        private String mScope = "all";
	        private Boolean mNeedReAuth = false;

	        public BaseApiListener(String scope, boolean needReAuth) {
	            mScope = scope;
	            mNeedReAuth = needReAuth;
	        }

	        @Override
	        public void onComplete(final JSONObject response, Object state) {
	           // showResult("IRequestListener.onComplete:", response.toString());
	            doComplete(response, state);
	        }

	        protected void doComplete(JSONObject response, Object state) {
	            try {
	                int ret = response.getInt("ret");
	                mThirdUser.setNickname(response.getString("nickname"));
	                if (ret == 100030) {
	                    if (mNeedReAuth) {
	                        Runnable r = new Runnable() {
	                            public void run() {
	                                mTencent.reAuth(mLoginActivity, mScope, new BaseUiListener());
	                            }
	                        };
	                        mLoginActivity.runOnUiThread(r);
	                    }
	                }
	                mLoginResult.onSuccess();
	                
	                // azrael 2/1注释掉了, 这里为何要在api返回的时候设置token呢,
	                // 如果cgi返回的值没有token, 则会清空原来的token
	                // String token = response.getString("access_token");
	                // String expire = response.getString("expires_in");
	                // String openid = response.getString("openid");
	                // mTencent.setAccessToken(token, expire);
	                // mTencent.setOpenId(openid);
	            } catch (JSONException e) {
	                e.printStackTrace();
	                mLoginResult.onFailed();
	                Log.e("toddtest", response.toString());
	            }

	        }

	        @Override
	        public void onIOException(final IOException e, Object state) {
	            showResult("IRequestListener.onIOException:", e.getMessage());
	        }

	        @Override
	        public void onMalformedURLException(final MalformedURLException e,
	                Object state) {
	            showResult("IRequestListener.onMalformedURLException", e.toString());
	        }

	        @Override
	        public void onJSONException(final JSONException e, Object state) {
	            showResult("IRequestListener.onJSONException:", e.getMessage());
	        }

	        @Override
	        public void onConnectTimeoutException(ConnectTimeoutException arg0,
	                Object arg1) {
	            showResult("IRequestListener.onConnectTimeoutException:", arg0.getMessage());

	        }

	        @Override
	        public void onSocketTimeoutException(SocketTimeoutException arg0,
	                Object arg1) {
	            showResult("IRequestListener.SocketTimeoutException:", arg0.getMessage());
	        }

	        @Override
	        public void onUnknowException(Exception arg0, Object arg1) {
	            showResult("IRequestListener.onUnknowException:", arg0.getMessage());
	        }

	        @Override
	        public void onHttpStatusException(HttpStatusException arg0, Object arg1) {
	            showResult("IRequestListener.HttpStatusException:", arg0.getMessage());
	        }

	        @Override
	        public void onNetworkUnavailableException(NetworkUnavailableException arg0, Object arg1) {
	            showResult("IRequestListener.onNetworkUnavailableException:", arg0.getMessage());
	        }
	    }


	@Override
	public ThirdUserInfo GetUserInfo() {
		// TODO Auto-generated method stub
		
		return mThirdUser;
	}


	
	
}
