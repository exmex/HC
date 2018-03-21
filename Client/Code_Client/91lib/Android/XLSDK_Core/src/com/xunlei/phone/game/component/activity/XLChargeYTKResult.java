package com.xunlei.phone.game.component.activity;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.TextView;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.util.XLApplicationContext;
import com.xunlei.phone.util.XLContext;

public class XLChargeYTKResult extends Activity {
    private XLApplicationContext xlApplicationContext;
    /**
     * call back from cp
     */
    private ICallBack mCallBack;
    /**
     * order for query
     */
    private String order;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(RR.layout(XLChargeYTKResult.this, "xl_activity_charge_ykt_result"));

        xlApplicationContext = BusinessManager.xlApplicationContext;
        xlApplicationContext.pushActivity(this);

        Intent intent = getIntent();
        mCallBack = (ICallBack) intent.getSerializableExtra("callback");
        order = intent.getStringExtra("order");

        TextView orderText = (TextView) findViewById(RR.id(XLChargeYTKResult.this, "xl_charge_ytk_order"));
        orderText.setText(order);

        Button ok = (Button) findViewById(RR.id(XLChargeYTKResult.this, "xl_charge_pay_button"));
        ok.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                mCallBack.onCallBack(XLContext.SUCCESS, order);
                xlApplicationContext.finish();
            }
        });
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            mCallBack.onCallBack(XLContext.SUCCESS, order);
            xlApplicationContext.finish();
        }
        return super.onKeyDown(keyCode, event);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }
}
