package com.xunlei.phone.game.component.activity;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import android.app.Activity;
import android.app.Dialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.res.Configuration;
import android.graphics.drawable.ColorDrawable;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.text.Spannable;
import android.text.SpannableString;
import android.text.Spanned;
import android.text.method.LinkMovementMethod;
import android.text.style.ForegroundColorSpan;
import android.util.DisplayMetrics;
import android.view.Gravity;
import android.view.KeyEvent;
import android.view.LayoutInflater;
import android.view.MotionEvent;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.View.OnFocusChangeListener;
import android.view.View.OnTouchListener;
import android.view.ViewGroup;
import android.view.Window;
import android.view.WindowManager;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.view.inputmethod.EditorInfo;
import android.view.inputmethod.InputMethodManager;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.ListView;
import android.widget.PopupWindow;
import android.widget.PopupWindow.OnDismissListener;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;
import android.widget.ViewFlipper;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.data.DataManager;
import com.xunlei.phone.game.util.Account;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.game.util.ValidatorUtil;
import com.xunlei.phone.protocol.Result;
import com.xunlei.phone.protocol.sender.DefaultSenderFactory;
import com.xunlei.phone.util.AndroidUtil;
import com.xunlei.phone.util.ReportType;
import com.xunlei.phone.util.UseridGenUtil;
import com.xunlei.phone.util.XLContext;
import com.xunlei.phone.vo.User;

/**
 * the activity for login and register
 * 
 * @author chenzhiwei
 * @date 2013-7-18
 */
public class XLMainActivity extends Activity {
    private ProgressDialog mProgressDialog;
    private ICallBack callback;
    private ViewFlipper mViewFlipper;

    private PopupWindow mPopupWindowAccountSelecting;
    private PopupWindow mPopupWindowInputPhone;
    private Dialog mInputPhoneDialog;

    private ListView mListView;

    private EditText mLoginUserNameText;
    private EditText mLoginPasswordText;
    private CheckBox mLoginRemberPassword;

    private EditText mRegisterUserNameText;
    private EditText mRegisterPasswordText;
    private CheckBox mRegisterSendMessage;
    private CheckBox mRegisterAgree;
    private ImageView mRegisterClearUserName;
    private ImageView mRegisterClearPassword;

    // private TextView mLoginPopWindowTextView;
    private EditText mPopWindowInputPhoneText;
    private ImageView mPopAccountsImageView;

    private View mHeadLayout;

    private List<Account> data;

    private int current = 0;

    private String[] genAccount = new String[2];
    private boolean autoGenAccount = true;
    private int autoRegisterCount = 0;
    private String phoneNo;
    private boolean manualInputPhoneFlag = false;
    private String lastPhoneNo = "";

    private View mLoginActivity;
    private View mRegisterActivity;

    private static final int retryRegisterTimes = 5;

    // handler for register
    private Handler registerHandler = new Handler() {

        @Override
        public void handleMessage(Message msg) {
            String info = null;
            switch (msg.what) {
            case Result.REGISTER_SUCCESS:
                info = (String) msg.obj;
                next(XLContext.SUCCESS, info);
                break;
            case Result.ACCOUNT_EXIST:
                if (autoGenAccount && (autoRegisterCount++ < retryRegisterTimes)) {
                    // Toast.makeText(XLMainActivity.this, "retry " +
                    // autoRegisterCount, Toast.LENGTH_SHORT).show();
                    String[] account = genAccount();
                    register(account[0], account[1], phoneNo, registerHandler, manualInputPhoneFlag, true);
                } else {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_account_exist_tip"), Toast.LENGTH_SHORT).show();
                }
                break;
            case Result.VCODE_ERROR:
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_verify_code_input_error_tip"), Toast.LENGTH_SHORT).show();
                break;
            case Result.CONNECT_ERROR:
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_connect_errror"), Toast.LENGTH_SHORT).show();
                break;
            case Result.CUSTOMER_ID_NOT_GENERATE:
                init();
                onBackPressed();
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_register_fail"), Toast.LENGTH_SHORT).show();
                break;
            default:
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_operator_fail"), Toast.LENGTH_SHORT).show();
            }
            if (msg.what != Result.ACCOUNT_EXIST || (autoGenAccount && autoRegisterCount >= retryRegisterTimes) || (!autoGenAccount)) {
                resetAutoRegisterState();
                mProgressDialog.dismiss();
                // printRegisterState();
            }
        }

    };

    // handler for login
    private Handler loginHandler = new Handler() {

        @Override
        public void handleMessage(Message msg) {
            mProgressDialog.dismiss();
            String info = null;
            switch (msg.what) {
            case Result.AUTH_SUCCESS:
                info = (String) msg.obj;
                next(XLContext.SUCCESS, info);
                break;
            case Result.ACCOUNT_PASS_ERROR:
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_password_error_tip"), Toast.LENGTH_SHORT).show();
                break;
            case Result.CONNECT_ERROR:
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_connect_errror"), Toast.LENGTH_SHORT).show();
                break;
            case Result.CUSTOMER_ID_NOT_GENERATE:
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_try_login_later"), Toast.LENGTH_SHORT).show();
                break;
            default:
                Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_operator_fail"), Toast.LENGTH_SHORT).show();
            }
        }
    };

    private void printRegisterState() {
        System.out.println("autoGenAccount:" + autoGenAccount);
        System.out.println("autoRegisterCount:" + autoRegisterCount);
        System.out.println("genAccount[0]:" + genAccount[0]);
        System.out.println("genAccount[1]:" + genAccount[1]);
        System.out.println("phoneNo:" + phoneNo);
        System.out.println("manualInputPhoneFlag:" + manualInputPhoneFlag);

    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        super.onCreate(savedInstanceState);
        setContentView(RR.layout(this, "xl_activity_xlmain"));

        callback = (ICallBack) this.getIntent().getSerializableExtra("callback");
        mProgressDialog = new ProgressDialog(this);
        mViewFlipper = (ViewFlipper) this.findViewById(RR.id(this, "xl_flipper_xlmain_login_main"));

        LayoutInflater infla = LayoutInflater.from(this);
        mLoginActivity = infla.inflate(RR.layout(this, "xl_activity_login"), mViewFlipper);
        mRegisterActivity = infla.inflate(RR.layout(this, "xl_activity_register"), mViewFlipper);
        bindLoginPage(mLoginActivity);
        bindRegisterPage(mRegisterActivity);

        init();

    }

    private void next(int result, String info) {
        this.finish();
        callback.onCallBack(result, info);
    }

    /**
     * generate an account
     */
    private String[] genAccount() {
        BusinessManager businessManager = BusinessManager.getBusinessManager(XLMainActivity.this, null, new DefaultSenderFactory());
        String accountUnique = businessManager.getSimpleData(DataManager.SETTINGS, "accountUnique");
        if (accountUnique != null && "true".equals(accountUnique)) {
            genAccount[0] = UseridGenUtil.genUserid(XLMainActivity.this, null, true);
        } else {
            genAccount[0] = UseridGenUtil.genUserid(XLMainActivity.this, null, false);
        }
        autoGenAccount = true;
        if (autoRegisterCount == 0) {
            genAccount[1] = UseridGenUtil.randomNumber(6) + "";
        }
        return genAccount;

    }

    /**
     * init login page
     */
    private void init() {
        getData();
        if (data.size() <= 1) {
            mPopAccountsImageView.setVisibility(View.INVISIBLE);
        }
        if (data.size() != 0) {
            mLoginUserNameText.setText(data.get(0).getUsername());
            mLoginPasswordText.setText(data.get(0).getPassword());
            if (data.get(0).getPassword() != null && data.get(0).getPassword().length() != 0) {
                mLoginRemberPassword.setChecked(true);
            }
        }

        mHeadLayout = this.findViewById(RR.id(this, "xl_head_layout"));
        // mHeadLogo = (ImageView) this.findViewById(RR.id("xl_head_logo);
        relayoutHead(getResources().getConfiguration().orientation);
    }

    /**
     * bind login page
     * 
     * @param view
     */
    private void bindLoginPage(View view) {
        mLoginUserNameText = (EditText) view.findViewById(RR.id(this, "xl_login_username_edittext"));
        mLoginPasswordText = (EditText) view.findViewById(RR.id(this, "xl_login_password_edittext"));

        TextView mLoginForgetPassword = (TextView) view.findViewById(RR.id(this, "xl_login_forget_password_textView"));
        Button mRegisterButton = (Button) view.findViewById(RR.id(this, "xl_login_register_button"));
        Button mLoginButton = (Button) view.findViewById(RR.id(this, "xl_login_login_button"));
        mPopAccountsImageView = (ImageView) view.findViewById(RR.id(this, "xl_login_pop_accounts_imageView"));

        mLoginRemberPassword = (CheckBox) view.findViewById(RR.id(this, "xl_login_remember_password_checkbox"));
        final View area = this.findViewById(RR.id(this, "xl_login_area"));

        OnFocusChangeListener onFocusChangeListener = new OnFocusChangeListener() {

            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    area.setBackgroundResource(RR.drawable(XLMainActivity.this, "xl_blue_circle"));
                } else {
                    area.setBackgroundResource(RR.drawable(XLMainActivity.this, "xl_shape_window_bg"));
                }
            }
        };
        mLoginUserNameText.setOnFocusChangeListener(onFocusChangeListener);
        mLoginUserNameText.setOnKeyListener(new View.OnKeyListener() {

            @Override
            public boolean onKey(View paramView, int paramInt, KeyEvent paramKeyEvent) {
                mLoginPasswordText.setText("");
                return false;
            }
        });
        mLoginPasswordText.setOnFocusChangeListener(onFocusChangeListener);
        mLoginPasswordText.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                mLoginPasswordText.requestFocus();
                mLoginPasswordText.selectAll();

            }
        });
        mLoginPasswordText.setOnTouchListener(new OnTouchListener() {

            @Override
            public boolean onTouch(View v, MotionEvent event) {
                mLoginPasswordText.requestFocus();
                mLoginPasswordText.selectAll();
                return false;
            }
        });
        mLoginPasswordText.setOnEditorActionListener(new TextView.OnEditorActionListener() {

            @Override
            public boolean onEditorAction(TextView v, int actionId, KeyEvent event) {
                if (actionId == EditorInfo.IME_ACTION_DONE) {
                    hideSoftKeyBoard(v);
                }
                return false;
            }
        });

        String text = getResources().getString(RR.string(XLMainActivity.this, "xl_forget_password"));
        SpannableString sp = new SpannableString(text);
        NoUnderlineSpan urlSpan = new NoUnderlineSpan(getResources().getString(RR.string(XLMainActivity.this, "xl_forget_password_url")));
        sp.setSpan(urlSpan, 0, text.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        sp.setSpan(new ForegroundColorSpan(getResources().getColor(RR.color(this, "xl_login_forget_password"))), 0, text.length(), Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        mLoginForgetPassword.setText(sp);
        mLoginForgetPassword.setMovementMethod(LinkMovementMethod.getInstance());
        // go to register
        mRegisterButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                hideSoftKeyBoard(v);
                Animation rInAnim = AnimationUtils.loadAnimation(XLMainActivity.this, RR.anim(XLMainActivity.this, "xl_push_right_in"));
                Animation rOutAnim = AnimationUtils.loadAnimation(XLMainActivity.this, RR.anim(XLMainActivity.this, "xl_push_left_out"));

                mViewFlipper.setInAnimation(rInAnim);
                mViewFlipper.setOutAnimation(rOutAnim);
                mViewFlipper.showNext();
                initForRegisterPage();
                current = 1;
            }
        });

        // login
        mLoginButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                hideSoftKeyBoard(v);
                String username = mLoginUserNameText.getText().toString().trim();
                String password = mLoginPasswordText.getText().toString().trim();

                if (username.length() == 0) {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_login_username_input_empty_tip"), Toast.LENGTH_SHORT).show();
                    return;
                }
                if (password.length() == 0) {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_login_password_input_empty_tip"), Toast.LENGTH_SHORT).show();
                    return;
                }

                mProgressDialog.setMessage(getResources().getString(RR.string(XLMainActivity.this, "xl_login_loading")));
                mProgressDialog.setCancelable(false);
                mProgressDialog.show();

                BusinessManager businessManager = BusinessManager.getBusinessManager(XLMainActivity.this, loginHandler, new DefaultSenderFactory());
                User user = new User();
                user.setUserName(mLoginUserNameText.getText().toString());
                user.setPassword(mLoginPasswordText.getText().toString());
                user.setRememberPassword(mLoginRemberPassword.isChecked());
                businessManager.login(user);
            }
        });

        mPopAccountsImageView.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                hideSoftKeyBoard(v);
                // String username =
                // mLoginUserNameText.getText().toString().trim();
                // if (username.length() != 0) {
                // mLoginPopWindowTextView.setText(username);
                // }
                popAccountSelectingDialog(v);
            }
        });

    }

    /**
     * bind phone number input window
     * 
     * @param view
     */
    @Deprecated
    private void bindInputPhonePopWindow(View view) {
        if (mPopupWindowInputPhone == null) {
            LayoutInflater infla = LayoutInflater.from(this);
            View popViewInputPhone = infla.inflate(RR.layout(XLMainActivity.this, "xl_activity_pop_input_phone"), null);
            mPopupWindowInputPhone = new PopupWindow(popViewInputPhone, WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT, true);
            mPopupWindowInputPhone.setBackgroundDrawable(new ColorDrawable(-00000));
            mPopupWindowInputPhone.setFocusable(true);
            mPopupWindowInputPhone.setTouchable(true);
            mPopupWindowInputPhone.setInputMethodMode(PopupWindow.INPUT_METHOD_NEEDED);
            mPopupWindowInputPhone.setOnDismissListener(new OnDismissListener() {

                @Override
                public void onDismiss() {

                }
            });

            mPopWindowInputPhoneText = (EditText) view.findViewById(RR.id(XLMainActivity.this, "xl_pop_input_phone_editText"));
            Button mInputPhonePopWindowButton = (Button) view.findViewById(RR.id(XLMainActivity.this, "xl_pop_input_phone_next_button"));
            mInputPhonePopWindowButton.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    String phoneNumber = mPopWindowInputPhoneText.getText().toString().trim();
                    manualInputPhoneFlag = true;
                    register(mRegisterUserNameText.getText().toString().trim(), mRegisterPasswordText.getText().toString(), phoneNumber, registerHandler, manualInputPhoneFlag, false);
                    mPopupWindowInputPhone.dismiss();
                }
            });
        }
    }

    /**
     * bind register page
     * 
     * @param view
     */
    private void bindRegisterPage(View view) {
        final View area = this.findViewById(RR.id(XLMainActivity.this, "xl_register_area"));
        TextView mRegisterUserProtocolTextView = (TextView) view.findViewById(RR.id(XLMainActivity.this, "xl_register_user_protocol_textView"));
        mRegisterUserNameText = (EditText) view.findViewById(RR.id(XLMainActivity.this, "xl_register_username_edittext"));
        mRegisterPasswordText = (EditText) view.findViewById(RR.id(XLMainActivity.this, "xl_register_password_edittext"));

        mRegisterSendMessage = (CheckBox) view.findViewById(RR.id(XLMainActivity.this, "xl_register_send_message_checkbox"));
        mRegisterAgree = (CheckBox) view.findViewById(RR.id(XLMainActivity.this, "xl_register_agree_protocol_checkbox"));
        mRegisterClearUserName = (ImageView) view.findViewById(RR.id(XLMainActivity.this, "xl_register_clear_username"));
        mRegisterClearPassword = (ImageView) view.findViewById(RR.id(XLMainActivity.this, "xl_register_clear_password"));

        /**
         * set listener for the clear-username button
         */
        mRegisterClearUserName.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                mRegisterUserNameText.setText("");
                mRegisterUserNameText.requestFocus();
                mRegisterClearUserName.setVisibility(View.INVISIBLE);
                showSoftKeyBoard(mRegisterUserNameText);
                BusinessManager businessManager = BusinessManager.getBusinessManager(XLMainActivity.this, null, new DefaultSenderFactory());
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", "1");
                businessManager.report(ReportType.xlsyclick, map);
            }
        });

        /**
         * set listener for the clear-password button
         */
        mRegisterClearPassword.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                mRegisterPasswordText.setText("");
                mRegisterPasswordText.requestFocus();
                mRegisterClearPassword.setVisibility(View.INVISIBLE);
                showSoftKeyBoard(mRegisterPasswordText);
                BusinessManager businessManager = BusinessManager.getBusinessManager(XLMainActivity.this, null, new DefaultSenderFactory());
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("op", "2");
                businessManager.report(ReportType.xlsyclick, map);
            }
        });
        OnFocusChangeListener onFocusChangeListener = new OnFocusChangeListener() {

            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    area.setBackgroundResource(RR.drawable(XLMainActivity.this, "xl_blue_circle"));
                } else {
                    area.setBackgroundResource(RR.drawable(XLMainActivity.this, "xl_shape_window_bg"));
                }
            }
        };
        mRegisterUserNameText.setOnFocusChangeListener(onFocusChangeListener);
        mRegisterPasswordText.setOnFocusChangeListener(onFocusChangeListener);

        String text = getResources().getString(RR.string(XLMainActivity.this, "xl_register_user_protocol"));
        SpannableString sp = new SpannableString(text);
        NoUnderlineSpan urlSpan = new NoUnderlineSpan(getResources().getString(RR.string(XLMainActivity.this, "xl_register_user_protocol_url")));
        sp.setSpan(urlSpan, 0, text.length(), Spanned.SPAN_INCLUSIVE_EXCLUSIVE);
        sp.setSpan(new ForegroundColorSpan(getResources().getColor(RR.color(XLMainActivity.this, "xl_register_user_protocol"))), 0, text.length(), Spannable.SPAN_EXCLUSIVE_INCLUSIVE);
        mRegisterUserProtocolTextView.setText(sp);
        mRegisterUserProtocolTextView.setMovementMethod(LinkMovementMethod.getInstance());

        // Submit register button
        Button mSubmitButton = (Button) view.findViewById(RR.id(XLMainActivity.this, "xl_register_register_button"));
        mSubmitButton.setOnClickListener(new OnClickListener() {

            @Override
            public void onClick(View v) {
                hideSoftKeyBoard(v);

                String username = mRegisterUserNameText.getText().toString().trim();
                String password = mRegisterPasswordText.getText().toString().trim();
                if (username.length() == 0) {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_login_username_input_empty_tip"), Toast.LENGTH_SHORT).show();
                    return;
                }
                if (!ValidatorUtil.isValidUserName(username)) {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_register_username_input_error_tip"), Toast.LENGTH_SHORT).show();
                    return;
                }
                if (password.length() == 0) {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_login_password_input_empty_tip"), Toast.LENGTH_SHORT).show();
                    return;
                }
                if (!ValidatorUtil.isValidPassword(password)) {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_register_password_input_error_tip"), Toast.LENGTH_SHORT).show();
                    return;
                }

                if (!mRegisterAgree.isChecked()) {
                    Toast.makeText(XLMainActivity.this, RR.string(XLMainActivity.this, "xl_register_disagree_protocol_tip"), Toast.LENGTH_SHORT).show();
                    return;
                }

                String phoneNumber = AndroidUtil.getPhoneNumber(XLMainActivity.this);
                if (ValidatorUtil.isPhone(phoneNumber)) {
                    if (mRegisterSendMessage.isChecked()) {
                        register(mRegisterUserNameText.getText().toString(), mRegisterPasswordText.getText().toString(), phoneNumber, registerHandler, manualInputPhoneFlag, false);
                    } else {
                        register(mRegisterUserNameText.getText().toString(), mRegisterPasswordText.getText().toString(), phoneNumber, registerHandler, manualInputPhoneFlag, false);
                    }
                } else {
                    if (mRegisterSendMessage.isChecked()) {
                        popInputPhoneDialog(v);
                    } else {
                        register(mRegisterUserNameText.getText().toString(), mRegisterPasswordText.getText().toString(), null, registerHandler, manualInputPhoneFlag, false);
                    }
                }

            }
        });
    }

    /**
     * pop up the dialog for phone input
     * 
     * @param v
     */
    private void popInputPhoneDialog(View v) {
        if (mInputPhoneDialog == null) {
            mInputPhoneDialog = new Dialog(XLMainActivity.this);
            LayoutInflater li = LayoutInflater.from(XLMainActivity.this);
            View view = li.inflate(RR.layout(XLMainActivity.this, "xl_activity_pop_input_phone"), null);
            mInputPhoneDialog.requestWindowFeature(Window.FEATURE_NO_TITLE);
            mInputPhoneDialog.setContentView(view);
            mPopWindowInputPhoneText = (EditText) view.findViewById(RR.id(XLMainActivity.this, "xl_pop_input_phone_editText"));
            Button mInputPhonePopWindowButton = (Button) view.findViewById(RR.id(XLMainActivity.this, "xl_pop_input_phone_next_button"));
            mInputPhonePopWindowButton.setOnClickListener(new OnClickListener() {

                @Override
                public void onClick(View v) {
                    mInputPhoneDialog.hide();
                    String phoneNumber = mPopWindowInputPhoneText.getText().toString().trim();
                    lastPhoneNo = phoneNumber;
                    manualInputPhoneFlag = true;
                    register(mRegisterUserNameText.getText().toString().trim(), mRegisterPasswordText.getText().toString(), phoneNumber, registerHandler, manualInputPhoneFlag, false);
                }
            });
        }

        mPopWindowInputPhoneText.setText(lastPhoneNo);
        mInputPhoneDialog.show();
    }

    private void popAccountSelectingDialog(View v) {
        if (mPopupWindowAccountSelecting == null) {
            LayoutInflater infla = LayoutInflater.from(this);
            View popViewAccountSelecting = infla.inflate(RR.layout(XLMainActivity.this, "xl_activity_pop_accounts"), null);
            mPopupWindowAccountSelecting = new PopupWindow(popViewAccountSelecting, WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT, true);
            mPopupWindowAccountSelecting.setBackgroundDrawable(new ColorDrawable(-00000));
            mPopupWindowAccountSelecting.setFocusable(true);
            mPopupWindowAccountSelecting.setTouchable(true);// mPopupWindow.update();
            mPopupWindowAccountSelecting.setOnDismissListener(new OnDismissListener() {

                @Override
                public void onDismiss() {
                    // area.setBackgroundResource(RR.drawable("xl_shape_window_bg);
                }
            });

            mListView = (ListView) popViewAccountSelecting.findViewById(RR.id(XLMainActivity.this, "xl_login_accounts_list"));
            if (data.size() >= 4) {
                mListView.getLayoutParams().height = 250;
            }
            mListView.setAdapter(new MyAdapter(this, data));
            mListView.setOnItemClickListener(new OnItemClickListener() {

                @Override
                public void onItemClick(AdapterView<?> parent, View view, int position, long id) {
                    mLoginUserNameText.setText(data.get(position).getUsername());
                    mLoginPasswordText.setText(data.get(position).getPassword());
                    if (data.get(position).getPassword() != null && data.get(position).getPassword().length() != 0) {
                        mLoginRemberPassword.setChecked(true);
                    } else {
                        mLoginRemberPassword.setChecked(false);
                    }
                    mPopupWindowAccountSelecting.dismiss();
                }
            });
        }
        mPopupWindowAccountSelecting.showAtLocation(v, Gravity.CENTER, 0, 0);
    }

    /**
     * register request
     * 
     * @param username
     * @param password
     * @param phoneNo
     * @param sendMSGFlag
     * @param handler
     */
    private void register(String username, String password, String phoneNo, Handler handler, boolean manualInputPhoneFlag, boolean retryRegisterFlag) {
        mProgressDialog.setMessage(getResources().getString(RR.string(XLMainActivity.this, "xl_register_loading")));
        mProgressDialog.setCancelable(false);
        mProgressDialog.show();

        if (!username.equals(genAccount[0])) {
            resetAutoRegisterState();
        } else {
            this.phoneNo = phoneNo;
        }

        genAccount[1] = password;

        BusinessManager businessManager = BusinessManager.getBusinessManager(XLMainActivity.this, handler, new DefaultSenderFactory());
        User user = new User();
        user.setUserName(username);
        user.setPassword(password);
        user.setPhoneNo(phoneNo);
        user.setSendMSGFlag(mRegisterSendMessage.isChecked() ? "0" : null);
        user.setManualInputPhoneFlag(manualInputPhoneFlag);
        user.setRetryRegisterFlag(retryRegisterFlag);
        businessManager.register(user);
    }

    private void resetAutoRegisterState() {
        autoGenAccount = false;
        autoRegisterCount = 0;
        genAccount[0] = null;
        genAccount[1] = null;
        phoneNo = null;
        manualInputPhoneFlag = false;
    }

    private void initForRegisterPage() {
        lastPhoneNo = "";
        String[] account = genAccount();
        mRegisterUserNameText.setText(account[0]);
        mRegisterPasswordText.setText(account[1]);
        mRegisterClearUserName.setVisibility(View.VISIBLE);
        mRegisterClearPassword.setVisibility(View.VISIBLE);
        mRegisterSendMessage.setChecked(false);
        mRegisterAgree.setChecked(true);
    }

    @Override
    public void onConfigurationChanged(Configuration newConfig) {
        relayoutHead(newConfig.orientation);
        super.onConfigurationChanged(newConfig);
    }

    private void relayoutHead(int orientation) {
        DisplayMetrics dm = new DisplayMetrics();
        getWindowManager().getDefaultDisplay().getMetrics(dm);
        int screenHeight = dm.heightPixels;
        if (orientation == Configuration.ORIENTATION_LANDSCAPE) {
            mHeadLayout.setLayoutParams(new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, (int) (screenHeight * 0.28)));
        } else if (orientation == Configuration.ORIENTATION_PORTRAIT) {
            mHeadLayout.setLayoutParams(new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT));
        } else {
            mHeadLayout.setLayoutParams(new RelativeLayout.LayoutParams(RelativeLayout.LayoutParams.MATCH_PARENT, RelativeLayout.LayoutParams.WRAP_CONTENT));
        }
    }

    private List<Account> getData() {
        BusinessManager businessManager = BusinessManager.getBusinessManager(XLMainActivity.this, null, new DefaultSenderFactory());
        String accounts = businessManager.getSimpleData(DataManager.ACCOUNTS, "accounts");
        List<Account> list = new ArrayList<Account>();
        if (accounts != null) {
            String[] users = accounts.split(" ");
            for (int i = 0; i < users.length; i++) {
                if (users[i] != null && users[i].trim().length() != 0) {
                    Account account = new Account();
                    account.setUsername(users[i].trim());
                    account.setLastTime(businessManager.getSimpleData(DataManager.ACCOUNTS, account.getUsername()));
                    account.setPassword(businessManager.getSimpleData(DataManager.ACCOUNTS, account.getUsername() + "p"));
                    list.add(account);
                }
            }
        }
        Collections.sort(list);
        Collections.reverse(list);

        data = list;
        return data;

    }

    private void hideSoftKeyBoard(View view) {
        InputMethodManager imm = (InputMethodManager) XLMainActivity.this.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.hideSoftInputFromWindow(view.getWindowToken(), 0);
    }

    private void showSoftKeyBoard(View view) {
        InputMethodManager imm = (InputMethodManager) XLMainActivity.this.getSystemService(Context.INPUT_METHOD_SERVICE);
        imm.showSoftInput(view, 0);
    }

    @Override
    public void onBackPressed() {
        if (current == 1) {
            Animation rInAnim = AnimationUtils.loadAnimation(this, RR.anim(XLMainActivity.this, "xl_push_left_in"));
            Animation rOutAnim = AnimationUtils.loadAnimation(this, RR.anim(XLMainActivity.this, "xl_push_right_out"));

            mViewFlipper.setInAnimation(rInAnim);
            mViewFlipper.setOutAnimation(rOutAnim);
            mViewFlipper.showPrevious();
            current = 0;
        } else {
            super.onBackPressed();
        }
    }

    class MyAdapter extends BaseAdapter {
        private List<Account> data;
        private LayoutInflater layoutInflater;

        public MyAdapter(Context context, List<Account> data) {
            this.data = data;
            this.layoutInflater = LayoutInflater.from(context);
        }

        @Override
        public int getCount() {
            return data.size();
        }

        @Override
        public Object getItem(int paramInt) {
            return data.get(paramInt);
        }

        @Override
        public long getItemId(int paramInt) {
            return paramInt;
        }

        @Override
        public View getView(int position, View convertView, ViewGroup parent) {
            ViewHolder viewHolder;
            if (convertView == null) {
                convertView = layoutInflater.inflate(RR.layout(XLMainActivity.this, "xl_activity_pop_accounts_item"), null);
                viewHolder = new ViewHolder();
                viewHolder.gougou = (ImageView) convertView.findViewById(RR.id(XLMainActivity.this, "xl_login_pop_gougou_imageView"));
                viewHolder.account = (TextView) convertView.findViewById(RR.id(XLMainActivity.this, "xl_login_pop_account_textView"));
                convertView.setTag(viewHolder);
            } else {
                viewHolder = (ViewHolder) convertView.getTag();
            }
            if (this.data.get(position).getUsername().equals(this.data.get(0).getUsername())) {
                viewHolder.gougou.setVisibility(View.VISIBLE);
            } else {
                viewHolder.gougou.setVisibility(View.INVISIBLE);
            }
            viewHolder.account.setText(this.data.get(position).getUsername());
            return convertView;
        }

        @Override
        public boolean areAllItemsEnabled() {
            return false;
        }
    }

    class ViewHolder {
        ImageView gougou;
        TextView account;
    }
}
