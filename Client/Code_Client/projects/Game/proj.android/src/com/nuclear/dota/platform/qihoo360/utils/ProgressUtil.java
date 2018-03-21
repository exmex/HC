
package com.nuclear.dota.platform.qihoo360.utils;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface.OnCancelListener;

public class ProgressUtil {

    public static ProgressDialog show(Context context, String title, String message) {
        try {
            ProgressDialog pd = new ProgressDialog(context);
            pd.setTitle(title);
            pd.setMessage(message);
            pd.setCancelable(true);
            pd.show();
            return pd;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static ProgressDialog show(Context context, int titleResId, int messageResId, OnCancelListener cancelListener) {
        try {
            ProgressDialog pd = new ProgressDialog(context);
            pd.setTitle(titleResId);
            pd.setMessage(context.getText(messageResId));
            pd.setCancelable(true);
            pd.setOnCancelListener(cancelListener);
            pd.show();
            return pd;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public static void setText(ProgressDialog pd, String title, String message, OnCancelListener cancelListener) {
        if (pd == null)
            return;
        
        if (cancelListener != null)
            pd.setOnCancelListener(cancelListener);

        if (title != null)
            pd.setTitle(title);

        if (message != null)
            pd.setMessage(message);
    }

    public static void dismiss(ProgressDialog pd) {
        if (pd == null)
            return;

        if (pd.isShowing() && pd.getWindow() != null) {
            try {
                pd.dismiss();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
