package com.xunlei.phone.game.component.activity;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.KeyEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.inputmethod.InputMethodManager;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.TextView;
import android.widget.Toast;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.game.alipay.AlixId;
import com.xunlei.phone.game.alipay.MobileSecurePayHelper;
import com.xunlei.phone.game.alipay.MobileSecurePayer;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.protocol.Result;
import com.xunlei.phone.protocol.sender.DefaultSenderFactory;
import com.xunlei.phone.util.ReportType;
import com.xunlei.phone.util.XLApplicationContext;
import com.xunlei.phone.util.XLContext;

public class XLChargeCommonActivity extends Activity implements OnClickListener {
    private XLApplicationContext xlApplicationContext;
    /**
     * pay type
     */
    private String mType;
    /**
     * back button
     */
    private ImageButton mBack;
    /**
     * pay channel
     */
    private TextView mChannel;
    /**
     * buttons of price
     */
    private TextView mChargeOptions[] = new TextView[6];
    /**
     * current price
     */
    private int mCurrentCharge;
    /**
     * price text
     */
    private TextView mChargeNum;
    /**
     * input
     */
    private EditText mPriceEdit;
    /**
     * order for query
     */
    private String mQuery;
    /**
     * price
     */
    private String price;
    /**
     * type of bank
     */
    private String bankType;
    /**
     * call back from cp
     */
    private ICallBack mCallBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(RR.layout(XLChargeCommonActivity.this, "xl_activity_charge_common"));

        xlApplicationContext = BusinessManager.xlApplicationContext;

        mChannel = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_channel_text"));
        Intent intent = getIntent();
        mType = intent.getStringExtra(XLApplicationContext.CHARGE_CHANNEL);
        mCallBack = (ICallBack) intent.getSerializableExtra("callback");

        if (mType.equals(XLApplicationContext.CHANNEL_ZHIFUBAO)) {
            mChannel.setText(getString(RR.string(XLChargeCommonActivity.this, "xl_zft")));

            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_bank_panel")).setVisibility(View.GONE);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_credit_card_panel")).setVisibility(View.GONE);
            Button payButton = (Button) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_pay_button"));
            payButton.setOnClickListener(this);
        } else if (mType.equals(XLApplicationContext.CHANNEL_CAIFUTONG)) {
            mChannel.setText(getString(RR.string(XLChargeCommonActivity.this, "xl_cft")));

            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_bank_panel")).setVisibility(View.GONE);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_credit_card_panel")).setVisibility(View.GONE);
            Button payButton = (Button) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_pay_button"));
            payButton.setOnClickListener(this);
        } else if (mType.equals(XLApplicationContext.CHANNEL_BANK)) {
            mChannel.setText(getString(RR.string(XLChargeCommonActivity.this, "xl_bank")));

            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_pay_button")).setVisibility(View.GONE);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_credit_card_panel")).setVisibility(View.GONE);

            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_zs_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_js_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_ny_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_gd_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_gf_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_zx_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_hr_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_ms_button")).setOnClickListener(this);
        } else {
            mChannel.setText(getString(RR.string(XLChargeCommonActivity.this, "xl_credit")));

            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_pay_button")).setVisibility(View.GONE);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_bank_panel")).setVisibility(View.GONE);

            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_gs_creadit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_ny_creadit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_zs_creadit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_js_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_zg_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_sfz_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_xy_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_pa_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_gd_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_gf_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_zx_credit_button")).setOnClickListener(this);
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_ms_credit_button")).setOnClickListener(this);
        }

        String rate = xlApplicationContext.getConfig(XLApplicationContext.CHARGE_RATE).toString();
        TextView rateText = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_rate_text"));
        rateText.setText(rate);

        mBack = (ImageButton) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_back_button"));
        mBack.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                xlApplicationContext.pullActivity();
                finish();
                overridePendingTransition(RR.anim(XLChargeCommonActivity.this, "xl_push_left_in"), RR.anim(XLChargeCommonActivity.this, "xl_push_right_out"));

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", 1);
                map.put("id", 1000);
                BusinessManager.getBusinessManager(XLChargeCommonActivity.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
            }
        });

        mPriceEdit = (EditText) findViewById(RR.id(XLChargeCommonActivity.this, "xl_alipay_price_edtext"));
        mPriceEdit.addTextChangedListener(new TextWatcher() {

            @Override
            public void onTextChanged(CharSequence s, int start, int before, int count) {
                if (!s.toString().equals("")) {
                    mChargeOptions[mCurrentCharge].setBackgroundColor(0xfffafafa);
                    mChargeOptions[mCurrentCharge].setTextColor(0xff5E7C93);

                    mChargeNum.setText(s.toString() + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
                    price = s.toString();
                } else {
                    if (mPriceEdit.isFocused()) {
                        mChargeNum.setText("0" + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
                        price = "0";
                    }
                }
            }

            @Override
            public void beforeTextChanged(CharSequence s, int start, int count, int after) {
            }

            @Override
            public void afterTextChanged(Editable s) {
            }
        });

        mChargeNum = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_num_text"));
        // if default price set, hide the price panel
        if (xlApplicationContext.getXLContextData(XLContext.CHARGE_NUM) != null) {
            findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_price_table")).setVisibility(View.GONE);

            mChargeNum.setText(xlApplicationContext.getXLContextData(XLContext.CHARGE_NUM).toString() + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            price = xlApplicationContext.getXLContextData(XLContext.CHARGE_NUM).toString();
        } else {
            String[] chargeNumArray = (String[]) xlApplicationContext.getConfig(XLApplicationContext.CHARGE_NUMBER);
            mChargeNum.setText(chargeNumArray[0] + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            price = chargeNumArray[0];

            TextView chargeOption1 = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_option_1"));
            chargeOption1.setText(chargeNumArray[0] + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            chargeOption1.setBackgroundColor(0xff3d9ef5);
            chargeOption1.setTextColor(0xfffafafa);

            mChargeOptions[0] = chargeOption1;
            chargeOption1.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    selectButton(0);
                }
            });
            TextView chargeOption2 = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_option_2"));
            chargeOption2.setText(chargeNumArray[1] + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            chargeOption2.setBackgroundColor(0xfffafafa);
            chargeOption2.setTextColor(0xff5E7C93);
            mChargeOptions[1] = chargeOption2;
            chargeOption2.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    selectButton(1);
                }
            });
            TextView chargeOption3 = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_option_3"));
            chargeOption3.setText(chargeNumArray[2] + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            chargeOption3.setBackgroundColor(0xfffafafa);
            chargeOption3.setTextColor(0xff5E7C93);
            mChargeOptions[2] = chargeOption3;
            chargeOption3.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    selectButton(2);
                }
            });
            TextView chargeOption4 = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_option_4"));
            chargeOption4.setText(chargeNumArray[3] + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            chargeOption4.setBackgroundColor(0xfffafafa);
            chargeOption4.setTextColor(0xff5E7C93);
            mChargeOptions[3] = chargeOption4;
            chargeOption4.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    selectButton(3);
                }
            });
            TextView chargeOption5 = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_option_5"));
            chargeOption5.setText(chargeNumArray[4] + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            chargeOption5.setBackgroundColor(0xfffafafa);
            chargeOption5.setTextColor(0xff5E7C93);
            mChargeOptions[4] = chargeOption5;
            chargeOption5.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    selectButton(4);
                }
            });
            TextView chargeOption6 = (TextView) findViewById(RR.id(XLChargeCommonActivity.this, "xl_charge_option_6"));
            chargeOption6.setText(chargeNumArray[5] + getString(RR.string(XLChargeCommonActivity.this, "xl_yuan")));
            mChargeOptions[5] = chargeOption6;
            chargeOption6.setBackgroundColor(0xfffafafa);
            chargeOption6.setTextColor(0xff5E7C93);
            chargeOption6.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    selectButton(5);
                }
            });
        }

        findViewById(RR.id(XLChargeCommonActivity.this, "xl_price_layout")).setFocusableInTouchMode(true);
        findViewById(RR.id(XLChargeCommonActivity.this, "xl_price_layout")).requestFocus();
        xlApplicationContext.pushActivity(this);
    }

    /**
     * 选择金额
     * 
     * @param index
     */
    private void selectButton(int index) {
        mChargeOptions[mCurrentCharge].setBackgroundColor(0xfffafafa);
        mChargeOptions[mCurrentCharge].setTextColor(0xff5E7C93);
        mChargeOptions[index].setBackgroundColor(0xff3d9ef5);
        mChargeOptions[index].setTextColor(0xfffafafa);

        mCurrentCharge = index;
        mChargeNum.setText(mChargeOptions[mCurrentCharge].getText().toString());
        price = mChargeOptions[mCurrentCharge].getText().toString().substring(0, mChargeOptions[mCurrentCharge].getText().toString().length() - 1);

        mPriceEdit.clearFocus();
        mPriceEdit.setText("");
        InputMethodManager imm = (InputMethodManager) this.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(mPriceEdit.getWindowToken(), 0);
    }

    /**
     * step1: get order from server
     */
    private void getOrder() {
        if (Integer.valueOf(price) > 5000 || Integer.valueOf(price) == 0) {
            Toast.makeText(this, getString(RR.string(XLChargeCommonActivity.this, "xl_illegal_price")), Toast.LENGTH_SHORT).show();
            return;
        }

        final ProgressDialog mChargeDialog = new ProgressDialog(this);
        mChargeDialog.setCancelable(false);
        mChargeDialog.setMessage(this.getResources().getString(RR.string(XLChargeCommonActivity.this, "xl_charge_checkVersion")));
        mChargeDialog.show();

        Handler handler = new Handler() {

            @Override
            public void handleMessage(Message msg) {
                if (msg.what == Result.SUCCESS) {
                    // Toast.makeText(XLChargeCommonActivity.this,
                    // msg.obj.toString(), Toast.LENGTH_LONG).show();
                    String orderString = msg.obj.toString();
                    mQuery = msg.getData().getString("orderid");
                    pay(orderString);
                } else {
                    Toast.makeText(XLChargeCommonActivity.this, getString(RR.string(XLChargeCommonActivity.this, "xl_error_getting_order")), Toast.LENGTH_LONG).show();
                }
                mChargeDialog.dismiss();
            }

        };
        BusinessManager businessManager = BusinessManager.getBusinessManager(this, handler, new DefaultSenderFactory());
        businessManager.getOrder(price, mType.equals(XLApplicationContext.CHANNEL_BANK) || mType.equals(XLApplicationContext.CHANNEL_CREDIT_CARD) ? "T1" : mType);
    }

    /**
     * step2: pay
     * 
     * @param orderString
     */
    private void pay(String orderString) {
        // call alipay plugin
        if (mType.equals(XLApplicationContext.CHANNEL_ZHIFUBAO)) {
            if (aliCheckAlipayUpdate()) {
                aliPay(orderString);

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", 0);
                map.put("id", 1110);
                BusinessManager.getBusinessManager(this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
            }
        } else if (mType.equals(XLApplicationContext.CHANNEL_CAIFUTONG)) {
            // jump to cft
            Intent intent = new Intent(this, XLChargeCFT.class);
            Bundle data = new Bundle();
            data.putString("order", orderString);
            data.putString("bank", "9999");
            data.putSerializable("callback", mCallBack);
            data.putString("query", mQuery);
            data.putString("type", mType);
            intent.putExtras(data);
            startActivity(intent);
            overridePendingTransition(RR.anim(XLChargeCommonActivity.this, "xl_push_right_in"), RR.anim(XLChargeCommonActivity.this, "xl_push_left_out"));

            Map<String, Object> map = new HashMap<String, Object>();
            map.put("op", 0);
            map.put("id", 1210);
            BusinessManager.getBusinessManager(this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
        } else {
            // jump to cft bank page
            Intent intent = new Intent(this, XLChargeCFT.class);
            Bundle data = new Bundle();
            data.putString("order", orderString);
            data.putSerializable("callback", mCallBack);
            data.putString("bank", bankType);
            data.putString("query", mQuery);
            data.putString("type", mType);
            intent.putExtras(data);
            startActivity(intent);
            overridePendingTransition(RR.anim(XLChargeCommonActivity.this, "xl_push_right_in"), RR.anim(XLChargeCommonActivity.this, "xl_push_left_out"));

            if (mType.equals(XLApplicationContext.CHANNEL_BANK)) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", 0);
                map.put("id", 1310);
                BusinessManager.getBusinessManager(this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
            } else if (mType.equals(XLApplicationContext.CHANNEL_CREDIT_CARD)) {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", 0);
                map.put("id", 1410);
                BusinessManager.getBusinessManager(this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
            }
        }
    }

    /**
     * zhifubao step1: check alipay version
     * 
     * @return
     */
    private boolean aliCheckAlipayUpdate() {
        // check to see if the MobileSecurePay is already installed.
        MobileSecurePayHelper mspHelper = new MobileSecurePayHelper(this);
        return mspHelper.detectMobile_sp();
    }

    /**
     * zhifubao Step 2: call alipay
     * 
     * @param message
     */
    private void aliPay(String orderString) {
        Handler handler = new Handler() {

            @Override
            public void handleMessage(Message msg) {
                try {
                    String strRet = (String) msg.obj;

                    switch (msg.what) {
                    case AlixId.RQF_PAY: {
                        try {
                            String tradeStatus = "resultStatus={";
                            int imemoStart = strRet.indexOf("resultStatus=");
                            imemoStart += tradeStatus.length();
                            int imemoEnd = strRet.indexOf("};memo=");
                            tradeStatus = strRet.substring(imemoStart, imemoEnd);

                            if (tradeStatus.equals("9000")) { // success
                                Toast.makeText(XLChargeCommonActivity.this, XLChargeCommonActivity.this.getResources().getString(RR.string(XLChargeCommonActivity.this, "xl_charge_success")), Toast.LENGTH_SHORT).show();
                                mCallBack.onCallBack(XLContext.SUCCESS, mQuery);

                                Map<String, Object> map = new HashMap<String, Object>();
                                map.put("op", 0);
                                map.put("id", 1111);
                                BusinessManager.getBusinessManager(XLChargeCommonActivity.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                                xlApplicationContext.finish();
                            } else {
                                Toast.makeText(XLChargeCommonActivity.this, getString(RR.string(XLChargeCommonActivity.this, "xl_error_pay")), Toast.LENGTH_SHORT).show();

                                Map<String, Object> map = new HashMap<String, Object>();
                                map.put("op", 0);
                                map.put("id", 1112);
                                BusinessManager.getBusinessManager(XLChargeCommonActivity.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                            }

                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                        break;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }

        };
        MobileSecurePayer msp = new MobileSecurePayer();
        boolean bRet = msp.pay(orderString, handler, AlixId.RQF_PAY, this);
    }

    @Override
    public void onClick(View v) {
        getOrder();

        if (v.getTag() != null) {
            bankType = v.getTag().toString();
        }
    }

    @Override
    public boolean onKeyDown(int keyCode, KeyEvent event) {
        if (keyCode == KeyEvent.KEYCODE_BACK) {
            mBack.performClick();
            return true;
        }
        return super.onKeyDown(keyCode, event);
    }
    
    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        super.onConfigurationChanged(newConfig);
    }
}
