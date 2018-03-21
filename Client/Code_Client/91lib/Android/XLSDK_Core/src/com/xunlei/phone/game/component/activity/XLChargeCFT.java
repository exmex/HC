package com.xunlei.phone.game.component.activity;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.ImageButton;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.protocol.sender.DefaultSenderFactory;
import com.xunlei.phone.util.ReportType;
import com.xunlei.phone.util.XLApplicationContext;
import com.xunlei.phone.util.XLContext;

/**
 * CFT activity
 * 
 * @author Davis Yang 下午2:12:43
 */
public class XLChargeCFT extends Activity {
    private XLApplicationContext xlApplicationContext;

    private ProgressDialog mLoading;
    private WebView mWebView;
    private Handler mLoadingOverHandler;
    private ImageButton mBack;

    /**
     * order for query
     */
    private String mQuery;
    /**
     * call back from cp
     */
    private ICallBack mCallBack;
    /**
     * handler
     */
    private Handler mHandler;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(RR.layout(XLChargeCFT.this, "xl_activity_charge_cft"));

        xlApplicationContext = BusinessManager.xlApplicationContext;
        xlApplicationContext.pushActivity(this);

        Intent intent = getIntent();
        mQuery = intent.getStringExtra("query");
        mCallBack = (ICallBack) intent.getSerializableExtra("callback");

        final String type = intent.getStringExtra("type");
        String order = intent.getStringExtra("order");
        String bankType = intent.getStringExtra("bank");
        String url = "https://wap.tenpay.com/cgi-bin/wappayv2.0/wappay_gate.cgi?token_id=" + order + "&bank_type=" + bankType + "&paybind=0";
        // String url =
        // "http://youxi.xunlei.com/shouyou/sdk/payresult.html?pay_result=0";

        mHandler = new Handler() {

            @Override
            public void handleMessage(Message msg) {
                if (msg.what == 0) {
                    // onload, report
                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("op", 0);
                    map.put("id", 1211);
                    BusinessManager.getBusinessManager(XLChargeCFT.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                    mBack.setVisibility(View.GONE);
                } else {
                    mCallBack.onCallBack(XLContext.SUCCESS, mQuery);
                }
            }

        };

        mBack = (ImageButton) findViewById(RR.id(XLChargeCFT.this, "xl_charge_back_button"));
        mBack.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                xlApplicationContext.pullActivity();
                finish();
                overridePendingTransition(RR.anim(XLChargeCFT.this, "xl_push_left_in"), RR.anim(XLChargeCFT.this, "xl_push_right_out"));

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", 1);
                if (type.equals(XLApplicationContext.CHANNEL_CAIFUTONG)) {
                    map.put("id", 1200);
                } else if (type.equals(XLApplicationContext.CHANNEL_BANK)) {
                    map.put("id", 1300);
                } else {
                    map.put("id", 1400);
                }
                BusinessManager.getBusinessManager(XLChargeCFT.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
            }
        });

        mWebView = (WebView) findViewById(RR.id(XLChargeCFT.this, "xl_charge_cft_wv"));
        mWebView.getSettings().setJavaScriptEnabled(true);// enable JS
        mWebView.setWebViewClient(new WebViewClient() {
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                view.loadUrl(url);
                return true;
            }

            @Override
            public void onPageFinished(WebView view, String url) {
                mLoadingOverHandler.sendEmptyMessage(0);
            }

        });

        mWebView.addJavascriptInterface(new Object() {
            public void onPayFinish(int result) {
                xlApplicationContext.finish();
                if (result == 0) {
                    mHandler.sendEmptyMessage(1);
                }
            }

            public void onLoadReady() {
                mHandler.sendEmptyMessage(0);
            }
        }, "xljs");

        mLoading = new ProgressDialog(this);
        mLoading.setProgressStyle(ProgressDialog.STYLE_SPINNER);
        mLoading.setMessage(getString(RR.string(XLChargeCFT.this, "xl_loading_web")));
        mLoading.show();

        mLoadingOverHandler = new Handler() {

            @Override
            public void handleMessage(Message msg) {
                mLoading.dismiss();
            }

        };
        mWebView.loadUrl(url);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            mBack.performClick();
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }
}
