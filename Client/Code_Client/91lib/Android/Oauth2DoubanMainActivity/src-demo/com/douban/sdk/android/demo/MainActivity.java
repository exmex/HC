package com.douban.sdk.android.demo;

import java.io.IOException;
import java.text.SimpleDateFormat;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.douban.sdk.android.Douban;
import com.douban.sdk.android.DoubanAuthListener;
import com.douban.sdk.android.DoubanDialogError;
import com.douban.sdk.android.DoubanException;
import com.douban.sdk.android.Oauth2AccessToken;
import com.douban.sdk.android.api.AccountAPI;
import com.douban.sdk.android.api.UsersAPI;
import com.douban.sdk.android.keep.DoubanAccessTokenKeeper;
import com.douban.sdk.android.net.RequestListener;
import com.douban.sdk.android.util.Utility;
/**
 * 
 * @author liyan (liyan9@staff.sina.com.cn)
 */
public class MainActivity extends Activity {

    private Douban mDouban;
    private static final String CONSUMER_KEY = "02e3d7298c9e5dd808ab857ca5db1988";// 替换为开发者的appkey，例如"1646212860";
    private static final String REDIRECT_URL = "http://www.7g8g.cn";
    private Button authBtn, apiBtn,  cancelBtn;
    private TextView mText;
    public static Oauth2AccessToken accessToken;
    public static final String TAG = "sinasdk";
    
    
    
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mDouban = Douban.getInstance(CONSUMER_KEY, REDIRECT_URL);
        authBtn = (Button) findViewById(R.id.auth);
        authBtn.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                mDouban.authorize(MainActivity.this, new AuthDialogListener());
            }
        });
         
         
        cancelBtn = (Button) findViewById(R.id.apiCancel);
        cancelBtn.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View v) {
                DoubanAccessTokenKeeper.clear(MainActivity.this);
                authBtn.setVisibility(View.VISIBLE);
                cancelBtn.setVisibility(View.INVISIBLE);
                mText.setText("");
            }
        });

        mText = (TextView) findViewById(R.id.show);
        MainActivity.accessToken = DoubanAccessTokenKeeper.readAccessToken(this);
        if (MainActivity.accessToken.isSessionValid()) {
            Douban.isWifi = Utility.isWifi(this);
            authBtn.setVisibility(View.INVISIBLE);
            cancelBtn.setVisibility(View.VISIBLE);
            String date = new java.text.SimpleDateFormat("yyyy/MM/dd hh:mm:ss")
                    .format(new java.util.Date(MainActivity.accessToken
                            .getExpiresTime()));
            mText.setText("access_token 仍在有效期内,无需再次登录: \naccess_token:"
                    + MainActivity.accessToken.getToken() + "\n有效期：" + date);
        } else {
            mText.setText("使用SSO登录前，请检查手机上是否已经安装新浪微博客户端，目前仅3.0.0及以上微博客户端版本支持SSO；如果未安装，将自动转为Oauth2.0进行认证");
        }

    }


    class AuthDialogListener implements DoubanAuthListener {

        @Override
        public void onComplete(Bundle values) {
            String token = values.getString("access_token");
            String expires_in = values.getString("expires_in");
            MainActivity.accessToken = new Oauth2AccessToken(token, expires_in);
            if (MainActivity.accessToken.isSessionValid()) {
                String date = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
                        .format(new java.util.Date(MainActivity.accessToken
                                .getExpiresTime()));
                
                mText.setText("认证成功: \r\n access_token: " + token + "\r\n"
                        + "expires_in: " + expires_in + "\r\n有效期：" + date);
                 
                cancelBtn.setVisibility(View.VISIBLE);
                DoubanAccessTokenKeeper.keepAccessToken(MainActivity.this,
                        accessToken);
                Toast.makeText(MainActivity.this, "认证成功", Toast.LENGTH_SHORT)
                        .show();
            }
            
            
            AccountAPI userApi = new AccountAPI(accessToken);
            userApi.getUid(new RequestListener() {
				
				@Override
				public void onIOException(IOException e) {
					// TODO Auto-generated method stub
					
				}
				
				@Override
				public void onError(DoubanException e) {
					// TODO Auto-generated method stub
					
				}
				
				@Override
				public void onComplete(String response) {
					// TODO Auto-generated method stub
					try {
						JSONObject backJson = new JSONObject(response);
						Log.i("id:",backJson.getString("id"));
						Log.i("uid:",backJson.getString("uid"));
						Log.i("name:",backJson.getString("name"));
						
					} catch (JSONException e) {
						e.printStackTrace();
					}
					
				}
			});
        }

        @Override
        public void onError(DoubanDialogError e) {
            Toast.makeText(getApplicationContext(),
                    "Auth error : " + e.getMessage(), Toast.LENGTH_LONG).show();
        }

        @Override
        public void onCancel() {
            Toast.makeText(getApplicationContext(), "Auth cancel",
                    Toast.LENGTH_LONG).show();
        }

        @Override
        public void onDoubanException(DoubanException e) {
            Toast.makeText(getApplicationContext(),
                    "Auth exception : " + e.getMessage(), Toast.LENGTH_LONG)
                    .show();
        }

		@Override
		public void onComplete(final JSONObject values) {
			
			runOnUiThread(new Runnable() {
				
				@Override
				public void run() {
					// TODO Auto-generated method stub
					// TODO Auto-generated method stub
					String token = values.optString("access_token");
		            String expires_in = values.optString("expires_in");
		            MainActivity.accessToken = new Oauth2AccessToken(token, expires_in);
		            if (MainActivity.accessToken.isSessionValid()) {
		                String date = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss")
		                        .format(new java.util.Date(MainActivity.accessToken.getExpiresTime()));
		                mText.setText("认证成功: \r\n access_token: " + token + "\r\n"
		                        + "expires_in: " + expires_in + "\r\n有效期：" + date);
		                 
		                cancelBtn.setVisibility(View.VISIBLE);
		                DoubanAccessTokenKeeper.keepAccessToken(MainActivity.this,
		                        accessToken);
		                Toast.makeText(MainActivity.this, "认证成功", Toast.LENGTH_SHORT)
		                        .show();
		            }
				}

			});
		}

		@Override
		public void onGetbackInfo(String userBack) {
			// TODO Auto-generated method stub
			Log.i("userBack", "userBack"+userBack);
			JSONObject JSON;
			try {
				JSON = new JSONObject(userBack);
				String nickname = JSON.getString("douban_user_name");
				String uid = JSON.getString("douban_user_id");
				Log.i("userinfo:","nickname"+nickname+"uid"+uid);
				
			} catch (JSONException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			
			
		}
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
       
    }

}

