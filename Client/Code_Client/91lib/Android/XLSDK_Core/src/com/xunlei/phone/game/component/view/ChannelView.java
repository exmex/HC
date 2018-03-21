package com.xunlei.phone.game.component.view;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.FrameLayout;
import android.widget.TextView;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.game.component.activity.XLChargeCommonActivity;
import com.xunlei.phone.game.component.activity.XLChargeYKT;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.protocol.sender.DefaultSenderFactory;
import com.xunlei.phone.util.ReportType;
import com.xunlei.phone.util.XLApplicationContext;

/**
 * 渠道
 * 
 * @author Davis Yang 下午6:20:22
 */
public class ChannelView extends FrameLayout {
    private ICallBack mCallBack;

    public ChannelView(Context context, String channel, ICallBack callBack) {
        super(context);

        this.mCallBack = callBack;
        init(channel);
    }

    public ChannelView(Context context, AttributeSet attrs, int defStyle, String channel, ICallBack callBack) {
        super(context, attrs, defStyle);

        this.mCallBack = callBack;
        init(channel);
    }

    public ChannelView(Context context, AttributeSet attrs, String channel, ICallBack callBack) {
        super(context, attrs);

        this.mCallBack = callBack;
        init(channel);
    }

    /**
     * 初始化
     */
    private void init(String channel) {
        LayoutInflater li = LayoutInflater.from(this.getContext());
        View view = li.inflate(RR.layout(getContext(), "xl_view_charge_channel"), this);

        TextView icon = (TextView) view.findViewById(RR.id(getContext(), "xl_charge_channel_icon"));
        TextView text = (TextView) view.findViewById(RR.id(getContext(), "xl_charge_channel_text"));

        if (channel.equals(XLApplicationContext.CHANNEL_BANK)) {
            icon.setBackgroundResource(RR.drawable(getContext(), "xl_charge_bank"));
            text.setText(getContext().getString(RR.string(getContext(), "xl_bank")));

            setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(getContext(), XLChargeCommonActivity.class);
                    Bundle data = new Bundle();
                    data.putString(XLApplicationContext.CHARGE_CHANNEL, XLApplicationContext.CHANNEL_BANK);
                    data.putSerializable("callback", mCallBack);
                    intent.putExtras(data);
                    getContext().startActivity(intent);
                    ((Activity) getContext()).overridePendingTransition(RR.anim(getContext(), "xl_push_right_in"), RR.anim(getContext(), "xl_push_left_out"));

                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("op", 0);
                    map.put("id", 1300);
                    BusinessManager.getBusinessManager(getContext(), null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                }
            });
        } else if (channel.equals(XLApplicationContext.CHANNEL_CAIFUTONG)) {
            icon.setBackgroundResource(RR.drawable(getContext(), "xl_charge_cft"));
            text.setText(getContext().getString(RR.string(getContext(), "xl_cft")));

            setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(getContext(), XLChargeCommonActivity.class);
                    Bundle data = new Bundle();
                    data.putString(XLApplicationContext.CHARGE_CHANNEL, XLApplicationContext.CHANNEL_CAIFUTONG);
                    data.putSerializable("callback", mCallBack);
                    intent.putExtras(data);
                    getContext().startActivity(intent);
                    ((Activity) getContext()).overridePendingTransition(RR.anim(getContext(), "xl_push_right_in"), RR.anim(getContext(), "xl_push_left_out"));

                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("op", 0);
                    map.put("id", 1200);
                    BusinessManager.getBusinessManager(getContext(), null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                }
            });
        } else if (channel.equals(XLApplicationContext.CHANNEL_YIKATONG)) {
            icon.setBackgroundResource(RR.drawable(getContext(), "xl_charge_ykt"));
            text.setText(getContext().getString(RR.string(getContext(), "xl_ykt")));

            setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(getContext(), XLChargeYKT.class);
                    Bundle data = new Bundle();
                    data.putString(XLApplicationContext.CHARGE_CHANNEL, XLApplicationContext.CHANNEL_YIKATONG);
                    data.putSerializable("callback", mCallBack);
                    intent.putExtras(data);
                    getContext().startActivity(intent);
                    ((Activity) getContext()).overridePendingTransition(RR.anim(getContext(), "xl_push_right_in"), RR.anim(getContext(), "xl_push_left_out"));

                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("op", 0);
                    map.put("id", 1500);
                    BusinessManager.getBusinessManager(getContext(), null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                }
            });
        } else if (channel.equals(XLApplicationContext.CHANNEL_ZHIFUBAO)) {
            icon.setBackgroundResource(RR.drawable(getContext(), "xl_charge_zfb"));
            text.setText(getContext().getString(RR.string(getContext(), "xl_zft")));

            setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(getContext(), XLChargeCommonActivity.class);
                    Bundle data = new Bundle();
                    data.putString(XLApplicationContext.CHARGE_CHANNEL, XLApplicationContext.CHANNEL_ZHIFUBAO);
                    data.putSerializable("callback", mCallBack);
                    intent.putExtras(data);
                    getContext().startActivity(intent);
                    ((Activity) getContext()).overridePendingTransition(RR.anim(getContext(), "xl_push_right_in"), RR.anim(getContext(), "xl_push_left_out"));

                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("op", 0);
                    map.put("id", 1100);
                    BusinessManager.getBusinessManager(getContext(), null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                }
            });
        } else if (channel.equals(XLApplicationContext.CHANNEL_CREDIT_CARD)) {
            icon.setBackgroundResource(RR.drawable(getContext(), "xl_charge_credit_card"));
            text.setText(getContext().getString(RR.string(getContext(), "xl_credit")));

            setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    Intent intent = new Intent(getContext(), XLChargeCommonActivity.class);
                    Bundle data = new Bundle();
                    data.putString(XLApplicationContext.CHARGE_CHANNEL, XLApplicationContext.CHANNEL_CREDIT_CARD);
                    data.putSerializable("callback", mCallBack);
                    intent.putExtras(data);
                    getContext().startActivity(intent);
                    ((Activity) getContext()).overridePendingTransition(RR.anim(getContext(), "xl_push_right_in"), RR.anim(getContext(), "xl_push_left_out"));

                    Map<String, Object> map = new HashMap<String, Object>();
                    map.put("op", 0);
                    map.put("id", 1400);
                    BusinessManager.getBusinessManager(getContext(), null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                }
            });
        }
    }

}
