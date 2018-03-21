package com.xunlei.phone.game.component.activity;

import android.app.Activity;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.ImageButton;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.game.component.R;
import com.xunlei.phone.game.component.view.ChannelView;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.util.XLApplicationContext;
import com.xunlei.phone.util.XLContext;
import com.xunlei.phone.vo.User;

public class XLChargeCenterActivity extends Activity {
    private XLApplicationContext xlApplicationContext;

    private TableLayout mChannelPanel;
    private ImageButton mBack;
    /**
     * 8,4,2,1
     */
    private final String[] CHANNELS = { XLApplicationContext.CHANNEL_ZHIFUBAO, XLApplicationContext.CHANNEL_CAIFUTONG, XLApplicationContext.CHANNEL_BANK, XLApplicationContext.CHANNEL_CREDIT_CARD,
            XLApplicationContext.CHANNEL_YIKATONG };
    /**
     * call back from cp
     */
    private ICallBack mCallBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(RR.layout(this, "xl_activity_charge_center"));

        xlApplicationContext = BusinessManager.xlApplicationContext;
        Intent intent = getIntent();
        mCallBack = (ICallBack) intent.getSerializableExtra("callback");
        // do not set default price
        if (xlApplicationContext.getXLContextData(XLContext.CHARGE_NUM) == null) {
            findViewById(RR.id(this, "xl_charge_num")).setVisibility(View.GONE);
            findViewById(RR.id(this, "xl_charge_num_split")).setVisibility(View.GONE);
        } else {
            TextView chargeNum = (TextView) findViewById(RR.id(XLChargeCenterActivity.this, "xl_charge_num_text"));
            chargeNum.setText(xlApplicationContext.getXLContextData(XLContext.CHARGE_NUM).toString() + getString(RR.string(this, "xl_yuan")));
        }

        String username = null;
        if (XLApplicationContext.DEBUG) {
            username = "xlchannel";
        } else {
            username = ((User) xlApplicationContext.getData(XLApplicationContext.CURRENT_USER)).getUserName();
        }
        TextView usernameText = (TextView) findViewById(RR.id(this, "xl_charge_username_text"));
        usernameText.setText(username);

        String rate = xlApplicationContext.getConfig(XLApplicationContext.CHARGE_RATE).toString();
        TextView rateText = (TextView) findViewById(RR.id(this, "xl_charge_rate_text"));
        rateText.setText(rate);

        String gamename = xlApplicationContext.getConfig(XLApplicationContext.GAME_NAME).toString();
        TextView gamenameText = (TextView) findViewById(RR.id(this, "xl_charge_game_text"));
        gamenameText.setText(gamename);

        mBack = (ImageButton) findViewById(RR.id(this, "xl_charge_back_button"));
        mBack.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                xlApplicationContext.pullActivity();
                finish();
                overridePendingTransition(RR.anim(XLChargeCenterActivity.this, "xl_push_left_in"), RR.anim(XLChargeCenterActivity.this, "xl_push_right_out"));
            }
        });

        mChannelPanel = (TableLayout) findViewById(RR.id(XLChargeCenterActivity.this, "xl_charge_channel_panel"));
        // channelPanel
        String channels = Integer.toBinaryString(Integer.valueOf(xlApplicationContext.getConfig(XLApplicationContext.CHARGE_CHANNEL).toString()));
        channels = new StringBuilder(channels).reverse().toString();
        TableRow tablerow = new TableRow(this);
        mChannelPanel.addView(tablerow);
        int col = 0;
        for (int i = 0; i < channels.length(); i++) {
            if (col == 3) {
                col = 0;
                tablerow = new TableRow(this);
                mChannelPanel.addView(tablerow);
            }

            int b = channels.charAt(i) & 1;
            if (b == 1) {
                tablerow.addView(new ChannelView(this, CHANNELS[i], mCallBack));
                col++;
            }
        }

        xlApplicationContext.pushActivity(this);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        mChannelPanel.requestLayout();
        super.onConfigurationChanged(newConfig);
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            mBack.performClick();
        }
        return super.onKeyDown(keyCode, event);
    }
}
