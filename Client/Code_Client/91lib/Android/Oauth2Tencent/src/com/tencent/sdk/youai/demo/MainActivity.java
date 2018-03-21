package com.tencent.sdk.youai.demo;

import java.text.SimpleDateFormat;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.tencent.sdk.youai.Oauth2AccessToken;
import com.tencent.sdk.youai.R;
import com.tencent.sdk.youai.Tencent;
import com.tencent.sdk.youai.TencentAuthListener;
import com.tencent.sdk.youai.TencentDialogError;
import com.tencent.sdk.youai.TencentException;
import com.tencent.sdk.youai.util.Utility;
/**
 * 
 * @author liyan (liyan9@staff.sina.com.cn)
 */
public class MainActivity extends Activity {

    private Tencent mTencent;
    private static final String CONSUMER_KEY = "100385103";
    private static final String REDIRECT_URL = "http://oauth_china_android.com";
    private Button authBtn, cancelBtn;
    private TextView mText;
    public static Oauth2AccessToken accessToken;
    public static final String TAG = "tencentsdk";
    
    private static final String secret = "3322c4e134eeff6f5c36893edce7cd30";
			

    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        mTencent = Tencent.getInstance(CONSUMER_KEY, REDIRECT_URL);
        authBtn = (Button) findViewById(R.id.auth);
        authBtn.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                mTencent.authorize(MainActivity.this, new AuthDialogListener());
            }
        });
         

    }


    class AuthDialogListener implements TencentAuthListener {

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
            
           
        }

        @Override
        public void onError(TencentDialogError e) {
            Toast.makeText(getApplicationContext(),
                    "Auth error : " + e.getMessage(), Toast.LENGTH_LONG).show();
        }

        @Override
        public void onCancel() {
            Toast.makeText(getApplicationContext(), "Auth cancel",
                    Toast.LENGTH_LONG).show();
        }

        @Override
        public void onTencentException(TencentException e) {
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
