package com.xunlei.phone.game;

import java.util.HashMap;
import java.util.Map;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;

import com.xunlei.phone.business.BusinessManager;
import com.xunlei.phone.exception.XLIllegalStateException;
import com.xunlei.phone.game.component.activity.XLChargeCenterActivity;
import com.xunlei.phone.game.component.activity.XLDialog;
import com.xunlei.phone.game.component.activity.XLMainActivity;
import com.xunlei.phone.game.util.ICallBack;
import com.xunlei.phone.game.util.RR;
import com.xunlei.phone.protocol.sender.DefaultSenderFactory;
import com.xunlei.phone.util.ReportType;
import com.xunlei.phone.util.XLApplicationContext;
import com.xunlei.phone.util.XLContext;

/**
 * Entrance for game part
 * 
 * @author Davis Yang am12:29:57
 */
public class XLPhonePluginHelper {
    /**
     * init sdk, get context
     * 
     * @param context
     * @param gameid
     * @param cpid
     * @param publicKey
     * @return
     */
    public static XLContext init(Context context, String gameid, String cpid, byte[] publicKey) {
        if (gameid.length() != 5) {
            throw new XLIllegalStateException("illegal game id, please check");
        }

        if (cpid.length() != 6) {
            throw new XLIllegalStateException("illegal cp id, please check");
        }

        XLContext xlContext = new XLContext(gameid, cpid, publicKey);
        BusinessManager.getBusinessManager(context, null, new DefaultSenderFactory()).init(xlContext);
        return xlContext;
    }

    /**
     * The entrance of pay
     * 
     * @param context
     */
    @Deprecated
    public static void pay(Activity mActivity, String mExtendInfo, int amount) {
        XLDialog mDialog = new XLDialog(mActivity, RR.style(mActivity, "xl_activity"));

        // XLBaseActivity charge = new XLChargeActivity(mDialog, mActivity,
        // mExtendInfo, amount);
        // charge.create();
    }

    /**
     * entrance of pay
     * 
     * @param context
     * @param cpOrder
     *            order from cp
     * @param callback
     */
    public static void pay(Context context, String cpOrder, ICallBack callback) {
        if (!XLApplicationContext.DEBUG) {
            if (BusinessManager.xlApplicationContext.getData(XLApplicationContext.CURRENT_USER) == null) {
                throw new XLIllegalStateException("can not start up charge before login in");
            }
        }

        Intent intent = new Intent(context, XLChargeCenterActivity.class);
        Bundle data = new Bundle();
        data.putSerializable("callback", callback);
        if (cpOrder != null) {
            BusinessManager.xlApplicationContext.setXLContext(XLContext.EXTEND_INFO, cpOrder);
        }
        intent.putExtras(data);
        context.startActivity(intent);

        Map<String, Object> map = new HashMap<String, Object>();
        map.put("op", 0);
        map.put("id", 1000);
        BusinessManager.getBusinessManager(context, null, new DefaultSenderFactory()).report(ReportType.xlsypay, map);
    }

    /**
     * entrance of pay
     * 
     * @param context
     * @param callback
     */
    public static void pay(Context context, ICallBack callback) {
        pay(context, null, callback);
    }

    /**
     * The entrance of login
     * 
     * @param context
     * @param next
     */
    @Deprecated
    public static void login(Activity activity, String next) {
        XLDialog mDialog = new XLDialog(activity, RR.style(activity, "xl_activity"));
        // XLMainActivity xlmain = new XLMainActivity(mDialog, activity, next);
        // xlmain.create();
    }

    /**
     * entrance of login
     * 
     * @param context
     * @param callback
     */
    public static void login(Context context, ICallBack callback) {
        Intent intent = new Intent(context, XLMainActivity.class);
        Bundle data = new Bundle();
        data.putSerializable("callback", callback);
        intent.putExtras(data);
        context.startActivity(intent);
    }
}
