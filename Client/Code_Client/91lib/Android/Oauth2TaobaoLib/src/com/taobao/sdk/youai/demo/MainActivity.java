package com.taobao.sdk.youai.demo;

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

import com.taobao.sdk.youai.Oauth2AccessToken;
import com.taobao.sdk.youai.R;
import com.taobao.sdk.youai.Taobao;
import com.taobao.sdk.youai.TaobaoAuthListener;
import com.taobao.sdk.youai.TaobaoDialogError;
import com.taobao.sdk.youai.TaobaoException;
import com.taobao.sdk.youai.net.RequestListener;
import com.taobao.sdk.youai.util.Utility;
/**
 * 
 * @author liyan (liyan9@staff.sina.com.cn)
 */
public class MainActivity extends Activity {

    private Taobao mWeibo;
    private static final String CONSUMER_KEY = "966056985";
    private static final String REDIRECT_URL = "http://www.taobao.com";
    private Button authBtn, cancelBtn;
    private TextView mText;
    public static Oauth2AccessToken accessToken;
    public static final String TAG = "sinasdk";
    
    

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mWeibo = Taobao.getInstance(CONSUMER_KEY, REDIRECT_URL);
        authBtn = (Button) findViewById(R.id.auth);
        authBtn.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                mWeibo.authorize(MainActivity.this, new AuthDialogListener());
            }
        });
         

    }


    class AuthDialogListener implements TaobaoAuthListener {

        @Override
        public void onComplete(String values) {
        	JSONObject jsonback = null;
			try {
				jsonback = new JSONObject(values);
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
            String token = null;
            String expires_in  = null;
			try {
				token = jsonback.getString("access_token");
				expires_in = jsonback.getString("expires_in");
			} catch (JSONException e1) {
				// TODO Auto-generated catch block
				e1.printStackTrace();
			}
            
                TaobaoAccessTokenKeeper.keepAccessToken(MainActivity.this,
                        accessToken);
                Toast.makeText(MainActivity.this, "认证成功", Toast.LENGTH_SHORT)
                        .show();
        }

        @Override
        public void onError(TaobaoDialogError e) {
            Toast.makeText(getApplicationContext(),
                    "Auth error : " + e.getMessage(), Toast.LENGTH_LONG).show();
        }

        @Override
        public void onCancel() {
            Toast.makeText(getApplicationContext(), "Auth cancel",
                    Toast.LENGTH_LONG).show();
        }

        @Override
        public void onTaobaoException(TaobaoException e) {
            Toast.makeText(getApplicationContext(),
                    "Auth exception : " + e.getMessage(), Toast.LENGTH_LONG)
                    .show();
        }

    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        
    }

}
