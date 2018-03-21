package com.xunlei.phone.game.component.activity;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.TextView;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.protocol.sender.DefaultSenderFactory;
import com.xunlei.phone.util.ReportType;
import com.xunlei.phone.util.XLApplicationContext;

public class XLChargeYKT extends Activity implements OnClickListener {
    private XLApplicationContext xlApplicationContext;
    private ImageButton mBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(RR.layout(XLChargeYKT.this, "xl_activity_charge_ykt"));

        xlApplicationContext = BusinessManager.xlApplicationContext;
        xlApplicationContext.pushActivity(this);

        findViewById(RR.id(XLChargeYKT.this, "xl_charge_yd_button")).setOnClickListener(this);
        findViewById(RR.id(XLChargeYKT.this, "xl_charge_lt_button")).setOnClickListener(this);
        findViewById(RR.id(XLChargeYKT.this, "xl_charge_dx_button")).setOnClickListener(this);

        mBack = (ImageButton) findViewById(RR.id(XLChargeYKT.this, "xl_charge_back_button"));
        mBack.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                xlApplicationContext.pullActivity();
                finish();
                overridePendingTransition(RR.anim(XLChargeYKT.this, "xl_push_left_in"), RR.anim(XLChargeYKT.this, "xl_push_right_out"));

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", 1);
                map.put("id", 1000);
                BusinessManager.getBusinessManager(XLChargeYKT.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
            }
        });

        String rate = xlApplicationContext.getConfig(XLApplicationContext.CHARGE_RATE).toString();
        TextView rateText = (TextView) findViewById(RR.id(XLChargeYKT.this, "xl_charge_rate_text"));
        rateText.setText(rate);
    }

    @Override
    public void onClick(View v) {
        Intent intent = new Intent(this, XLChargeYKTPay.class);
        Bundle data = new Bundle();
        data.putString("type", v.getTag().toString());
        data.putSerializable("callback", getIntent().getSerializableExtra("callback"));
        intent.putExtras(data);
        startActivity(intent);
        overridePendingTransition(RR.anim(XLChargeYKT.this, "xl_push_right_in"), RR.anim(XLChargeYKT.this, "xl_push_left_out"));

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("op", 0);
        map.put("id", 1510);
        BusinessManager.getBusinessManager(this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
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
