package com.nuclear.dota.platform.thirdlogin;

import org.json.JSONException;

import android.app.Activity;
import android.content.Context;

import com.renn.rennsdk.RennClient;
import com.renn.rennsdk.RennClient.LoginListener;
import com.renn.rennsdk.RennExecutor.CallBack;
import com.renn.rennsdk.RennResponse;
import com.renn.rennsdk.exception.RennException;
import com.renn.rennsdk.param.GetLoginUserParam;
import com.weibo.sdk.android.api.AccountAPI;
import com.xiaomi.gamecenter.sdk.entry.LoginResult;
import com.qsds.ggg.dfgdfg.fvfvf.R;
import com.nuclear.dota.platform.thirdlogin.LoginDialog.LoginCallback;

public class ThirdLoginRenren implements IThirdLogin {

	private static ThirdLoginRenren sInstance = null;
	//以下为"我的人人豆"
    private static final String APP_ID = "105381";

    private static final String API_KEY = "6b1016db20c540e78bd1b20be4c707a3";

    private static final String SECRET_KEY = "4723a695c09e4ddebbe8d87393d95fb4";
    
	private Context mContext;
	private RennClient rennClient;
	private Activity mActivity; 
	private ThirdUserInfo mThirdUser;
	private LoginCallback mLoginCallback;
	    public ThirdLoginRenren(){
	    	
	    }
	    
	@Override
	public void onCreate() {
		// TODO Auto-generated method stub

	}

	@Override
	public void GetServerUser() {
			
	}

	@Override
	public IThirdLogin GetInstance() {
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		if (sInstance == null) {
					sInstance = new ThirdLoginRenren();
					sInstance.onCreate();
		}
		return sInstance;
	}

	@Override
	public void authorize(LoginCallback pLoginResult) {
		mLoginCallback = pLoginResult;
		rennClient = RennClient.getInstance(mContext);
		rennClient.init(APP_ID, API_KEY, SECRET_KEY);
		rennClient
				.setScope("read_user_blog read_user_photo read_user_status read_user_album ");
		 
		rennClient.setTokenType("bearer");
		
		
		rennClient.setLoginListener(new LoginListener() {
			
			@Override
			public void onLoginSuccess() {
				
				mThirdUser = new ThirdUserInfo();
				
				 GetLoginUserParam param5 = new GetLoginUserParam();
				  try {
					  rennClient.getRennService().sendAsynRequest(param5, new CallBack() {    
	                         @Override
	                         public void onSuccess(RennResponse response) {
	                        	 long uid = rennClient.getUid();
	                        	 mThirdUser.setUid(uid);
	                        	 mThirdUser.setUidStr(String.valueOf(uid));
								try {
									mThirdUser.setNickname(response.getResponseObject().getString("name"));
									mLoginCallback.onSuccess();
								} catch (JSONException e) {
									mLoginCallback.onFailed();
								}
	                         }
	                         
	                         @Override
	                         public void onFailed(String errorCode, String errorMessage) {
	                        	 mLoginCallback.onFailed();
	                         }
	                     });
	                 } catch (RennException e1) {
	                     // TODO Auto-generated catch block
	                     e1.printStackTrace();
	                 }
				
			}
			
			@Override
			public void onLoginCanceled() {
				// TODO Auto-generated method stub
				
			}
		});
		
		
		rennClient.login(mActivity);
		
	}

	@Override
	public void setContext(Context pContext) {
		// TODO Auto-generated method stub
		mContext = pContext;
	}

	@Override
	public void setActivity(Activity pAcitivity) {
		// TODO Auto-generated method stub
		mActivity = pAcitivity;
	}

	@Override
	public ThirdUserInfo GetUserInfo() {
		// TODO Auto-generated method stub
		return mThirdUser;
	}

}
