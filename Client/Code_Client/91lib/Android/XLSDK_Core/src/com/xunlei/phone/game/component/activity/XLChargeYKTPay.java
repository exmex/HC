package com.xunlei.phone.game.component.activity;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.Window;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.protocol.Result;
import com.xunlei.phone.protocol.sender.DefaultSenderFactory;
import com.xunlei.phone.util.ReportType;
import com.xunlei.phone.util.XLApplicationContext;

public class XLChargeYKTPay extends Activity {
    private XLApplicationContext xlApplicationContext;
    private String mYKTType;
    private ImageButton mBack;
    /**
     * current price text
     */
    private TextView mPriceText;
    /**
     * price to display
     */
    private TextView mPriceDisplayed;
    /**
     * data of price
     */
    private String[] mData;
    /**
     * price dialog
     */
    private Dialog mPriceTable;
    /**
     * description
     */
    private Dialog mDescriptionTable;
    /**
     * call back from cp
     */
    private ICallBack mCallBack;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(RR.layout(XLChargeYKTPay.this, "xl_activity_charge_ykt_pay"));

        String[] YD_PRICE = { "10" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "20" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "30" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "50" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "100" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "200" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "300" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "500" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")) };
        String[] LT_PRICE = { "20" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "30" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "50" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "100" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "200" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "300" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "500" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")) };
        String[] DX_PRICE = { "20" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "30" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "50" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")), "100" + getString(RR.string(XLChargeYKTPay.this, "xl_yuan")) };
        
        xlApplicationContext = BusinessManager.xlApplicationContext;
        xlApplicationContext.pushActivity(this);

        Intent intent = getIntent();
        mYKTType = intent.getStringExtra("type");
        mCallBack = (ICallBack) intent.getSerializableExtra("callback");

        TextView mChannel = (TextView) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_ykt_type_text"));
        if (mYKTType.equals("1")) {
            mChannel.setText(getString(RR.string(XLChargeYKTPay.this, "xl_yd")));
            mData = YD_PRICE;
        } else if (mYKTType.equals("2")) {
            mChannel.setText(getString(RR.string(XLChargeYKTPay.this, "xl_lt")));
            mData = LT_PRICE;
        } else {
            mChannel.setText(getString(RR.string(XLChargeYKTPay.this, "xl_dx")));
            mData = DX_PRICE;
        }

        mPriceText = (TextView) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_price_txt"));
        final Button selector = (Button) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_select_num_btn"));
        selector.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                bindPriceTable();
            }
        });
        findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_select_num_panel")).setOnClickListener(new OnClickListener() {
            
            @Override
            public void onClick(View v) {
                selector.performClick();                
            }
        });
        
        mPriceDisplayed = (TextView) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_num_text"));
        mPriceDisplayed.setText(mData[0] + "");
        mPriceText.setText(mData[0] + "");

        TextView description = (TextView) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_description"));
        description.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                if (mDescriptionTable == null) {
                    mDescriptionTable = new Dialog(XLChargeYKTPay.this);
                    LayoutInflater li = LayoutInflater.from(XLChargeYKTPay.this);
                    View view = li.inflate(RR.layout(XLChargeYKTPay.this, "xl_pop_description"), null);
                    mDescriptionTable.requestWindowFeature(Window.FEATURE_NO_TITLE);
                    mDescriptionTable.setContentView(view);

                }

                mDescriptionTable.show();
            }
        });

        Button confirm = (Button) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_pay_button"));
        confirm.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                EditText accountEdt = (EditText) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_ykt_account_edt"));
                String account = accountEdt.getText().toString();
                if (account == null || account.equals("")) {
                    Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_input_account")), Toast.LENGTH_SHORT).show();
                    return;
                }

                EditText pasEdt = (EditText) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_ykt_pas_edt"));
                String pas = pasEdt.getText().toString();
                if (pas == null || pas.equals("")) {
                    Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_input_pas")), Toast.LENGTH_SHORT).show();
                    return;
                }

                if (mYKTType.equals("1")) {
                    if (account.length() != 17) {
                        Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_error_account")), Toast.LENGTH_SHORT).show();
                        return;
                    }
                    
                    if (pas.length() != 18) {
                        Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_error_pas")), Toast.LENGTH_SHORT).show();
                        return;
                    }
                } else if (mYKTType.equals("2")) {
                    if (account.length() != 15) {
                        Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_error_account")), Toast.LENGTH_SHORT).show();
                        return;
                    }
                    
                    if (pas.length() != 19) {
                        Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_error_pas")), Toast.LENGTH_SHORT).show();
                        return;
                    }
                } else {
                    if (account.length() != 19) {
                        Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_error_account")), Toast.LENGTH_SHORT).show();
                        return;
                    }
                    
                    if (pas.length() != 18) {
                        Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_error_pas")), Toast.LENGTH_SHORT).show();
                        return;
                    }
                }
                
                final ProgressDialog mChargeDialog = new ProgressDialog(XLChargeYKTPay.this);
                mChargeDialog.setCancelable(false);
                mChargeDialog.setMessage(XLChargeYKTPay.this.getResources().getString(RR.string(XLChargeYKTPay.this, "xl_charge_checkVersion")));
                mChargeDialog.show();

                Handler handler = new Handler() {

                    @Override
                    public void handleMessage(Message msg) {
                        if (msg.what == Result.SUCCESS) {
                            String order = msg.getData().getString("orderid");
                            Intent intent = new Intent(XLChargeYKTPay.this, XLChargeYTKResult.class);
                            Bundle data = new Bundle();
                            data.putSerializable("callback", mCallBack);
                            data.putString("order", order);
                            intent.putExtras(data);
                            startActivity(intent);
                            overridePendingTransition(RR.anim(XLChargeYKTPay.this, "xl_push_right_in"), RR.anim(XLChargeYKTPay.this, "xl_push_left_out"));

                            Map<String, Object> map = new HashMap<String, Object>();
                            map.put("op", 0);
                            map.put("id", 1511);
                            BusinessManager.getBusinessManager(XLChargeYKTPay.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
                        } else {
                            Toast.makeText(XLChargeYKTPay.this, getString(RR.string(XLChargeYKTPay.this, "xl_error_getting_order")), Toast.LENGTH_LONG).show();
                        }
                        mChargeDialog.dismiss();
                    }

                };
                BusinessManager businessManager = BusinessManager.getBusinessManager(XLChargeYKTPay.this, handler, new DefaultSenderFactory());
                businessManager.getOrder(mPriceText.getText().toString().substring(0, mPriceText.getText().toString().length() - 1), account, pas, mYKTType);
            }
        });

        mBack = (ImageButton) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_back_button"));
        mBack.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                xlApplicationContext.pullActivity();
                finish();
                overridePendingTransition(RR.anim(XLChargeYKTPay.this, "xl_push_left_in"), RR.anim(XLChargeYKTPay.this, "xl_push_right_out"));

                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", 1);
                map.put("id", 1500);
                BusinessManager.getBusinessManager(XLChargeYKTPay.this, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
            }
        });
        
        String rate = xlApplicationContext.getConfig(XLApplicationContext.CHARGE_RATE).toString();
        TextView rateText = (TextView) findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_rate_text"));
        rateText.setText(rate);
        
        findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_ykt_layout")).setFocusableInTouchMode(true);
        findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_ykt_layout")).requestFocus();
    }

    /**
     * show price dialog
     */
    private void bindPriceTable() {
        if (mPriceTable == null) {
            mPriceTable = new Dialog(XLChargeYKTPay.this);
            LayoutInflater li = LayoutInflater.from(XLChargeYKTPay.this);
            View view = li.inflate(RR.layout(XLChargeYKTPay.this, "xl_pop_price_selector"), null);
            mPriceTable.requestWindowFeature(Window.FEATURE_NO_TITLE);
            mPriceTable.setContentView(view);

            ListView priceList = (ListView) view.findViewById(RR.id(XLChargeYKTPay.this, "xl_charge_price_selector"));
            priceList.setAdapter(new ArrayAdapter<String>(this, RR.layout(XLChargeYKTPay.this, "xl_pop_price_item"), mData));
            priceList.setDividerHeight(30);
            priceList.setOnItemClickListener(new OnItemClickListener() {

                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    mPriceText.setText(mData[position] + "");
                    mPriceDisplayed.setText(mData[position] + "");
                    mPriceTable.hide();
                }
            });
        }

        mPriceTable.show();
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
