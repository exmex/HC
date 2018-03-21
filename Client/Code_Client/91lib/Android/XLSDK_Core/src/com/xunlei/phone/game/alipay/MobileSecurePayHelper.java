/*
 * Copyright (C) 2010 The MobileSecurePay Project
 * All right reserved.
 * author: shiqun.shi@alipay.com
 */

package com.xunlei.phone.game.alipay;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Date;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;

import com.xunlei.phone.game.util.RR;

/**
 * 
 */
public class MobileSecurePayHelper {
    static final String TAG = "MobileSecurePayHelper";

    private ProgressDialog mProgress = null;
    Context mContext = null;

    public MobileSecurePayHelper(Context context) {
        this.mContext = context;
    }

    /**
     * detect mobile ali installed or not
     * 
     * @return
     */
    public boolean detectMobile_sp() {
        boolean isMobile_spExist = isMobile_spExist();
        if (!isMobile_spExist) {
            //
            // get the cacheDiRR.
            File cacheDir = mContext.getCacheDir();
            final String cachePath = cacheDir.getAbsolutePath() + "/temp.apk";
            //
            // install apk from assets
            retrieveApkFromAssets(mContext, PartnerConfig.ALIPAY_PLUGIN_NAME, cachePath);

            mProgress = BaseHelper.showProgress(mContext, null, mContext.getString(RR.string(mContext, "xl_alipay_check_new")), false, true);

            // download new version
            new Thread(new Runnable() {
                public void run() {
                    //
                    // check new version
                    PackageInfo apkInfo = getApkInfo(mContext, cachePath);
                    String newApkdlUrl = checkNewUpdate(apkInfo);

                    //
                    long start = new Date().getTime();
                    if (newApkdlUrl != null)
                        retrieveApkFromNet(mContext, newApkdlUrl, cachePath);
                    long end = new Date().getTime();
                    System.out.println("retrieveApkFromNet" + (end - start));
                    // send the result back to calleRR.
                    Message msg = new Message();
                    msg.what = AlixId.RQF_INSTALL_CHECK;
                    msg.obj = cachePath;
                    mHandler.sendMessage(msg);
                }
            }).start();
        }
        // else ok.

        return isMobile_spExist;
    }

    /**
     * show confirm dialog
     * 
     * @param context
     * @param cachePath
     */
    public void showInstallConfirmDialog(final Context context, final String cachePath) {
        AlertDialog.Builder tDialog = new AlertDialog.Builder(context);
        tDialog.setIcon(RR.drawable(mContext, "alipay_info"));
        tDialog.setTitle(context.getResources().getString(RR.string(mContext, "xl_alipay_confirm_install_hint")));
        tDialog.setMessage(context.getResources().getString(RR.string(mContext, "xl_alipay_confirm_install")));

        tDialog.setPositiveButton(RR.string(mContext, "xl_alipay_Ensure"), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                //
                // modify access mod
                BaseHelper.chmod("777", cachePath);

                //
                // install the apk.
                Intent intent = new Intent(Intent.ACTION_VIEW);
                intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
                intent.setDataAndType(Uri.parse("file://" + cachePath), "application/vnd.android.package-archive");
                context.startActivity(intent);
            }
        });

        tDialog.setNegativeButton(context.getResources().getString(RR.string(mContext, "xl_alipay_Cancel")), new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
            }
        });

        tDialog.show();
    }

    /**
     * 
     * @return
     */
    public boolean isMobile_spExist() {
        PackageManager manager = mContext.getPackageManager();
        List<PackageInfo> pkgList = manager.getInstalledPackages(0);
        for (int i = 0; i < pkgList.size(); i++) {
            PackageInfo pI = pkgList.get(i);
            if (pI.packageName.equalsIgnoreCase("com.alipay.android.app"))
                return true;
        }

        return false;
    }

    /**
     * install apk from assets
     * 
     * @param context
     * @param fileName
     * @param path
     * @return
     */
    public boolean retrieveApkFromAssets(Context context, String fileName, String path) {
        boolean bRet = false;

        try {
            InputStream is = context.getAssets().open(fileName);

            File file = new File(path);
            file.createNewFile();
            FileOutputStream fos = new FileOutputStream(file);

            byte[] temp = new byte[1024];
            int i = 0;
            while ((i = is.read(temp)) > 0) {
                fos.write(temp, 0, i);
            }

            fos.close();
            is.close();

            bRet = true;

        } catch (IOException e) {
            e.printStackTrace();
        }

        return bRet;
    }

    /**
     * get apk info
     * 
     * @param context
     * @param archiveFilePath
     *            APK file path：/sdcard/download/XX.apk
     */
    public static PackageInfo getApkInfo(Context context, String archiveFilePath) {
        PackageManager pm = context.getPackageManager();
        PackageInfo apkInfo = pm.getPackageArchiveInfo(archiveFilePath, PackageManager.GET_META_DATA);
        return apkInfo;
    }

    /**
     * check new version, if exists, download
     * 
     * @param packageInfo
     *            {@link PackageInfo}
     * @return
     */
    public String checkNewUpdate(PackageInfo packageInfo) {
        String url = null;

        try {
            JSONObject resp = sendCheckNewUpdate(packageInfo.versionName);
            // JSONObject resp = sendCheckNewUpdate("1.0.0");
            if (resp.getString("needUpdate").equalsIgnoreCase("true")) {
                url = resp.getString("updateUrl");
            }
            // else ok.
        } catch (Exception e) {
            e.printStackTrace();
        }

        return url;
    }

    /**
     * @param versionName
     * @return
     */
    public JSONObject sendCheckNewUpdate(String versionName) {
        JSONObject objResp = null;
        try {
            JSONObject req = new JSONObject();
            req.put(AlixDefine.action, AlixDefine.actionUpdate);

            JSONObject data = new JSONObject();
            data.put(AlixDefine.platform, "android");
            data.put(AlixDefine.VERSION, versionName);
            data.put(AlixDefine.partner, "");

            req.put(AlixDefine.data, data);

            objResp = sendRequest(req.toString());
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return objResp;
    }

    /**
     * 
     * @param content
     * @return
     */
    public JSONObject sendRequest(final String content) {
        NetworkManager nM = new NetworkManager(this.mContext);

        //
        JSONObject jsonResponse = null;
        try {
            String response = null;

            synchronized (nM) {
                //
                response = nM.SendAndWaitResponse(content, Constant.server_url);
            }

            jsonResponse = new JSONObject(response);
        } catch (Exception e) {
            e.printStackTrace();
        }

        //
        if (jsonResponse != null)
            BaseHelper.log(TAG, jsonResponse.toString());

        return jsonResponse;
    }

    /**
     * download apk
     * 
     * @param context
     * @param strurl
     * @param filename
     * @return
     */
    public boolean retrieveApkFromNet(Context context, String strurl, String filename) {
        boolean bRet = false;

        try {
            NetworkManager nM = new NetworkManager(this.mContext);
            bRet = nM.urlDownloadToFile(context, strurl, filename);
        } catch (Exception e) {
            e.printStackTrace();
        }

        return bRet;
    }

    //
    // close the progress bar
    void closeProgress() {
        try {
            if (mProgress != null) {
                mProgress.dismiss();
                mProgress = null;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    //
    // the handler use to receive the install check result.
    private Handler mHandler = new Handler() {
        public void handleMessage(Message msg) {
            try {
                switch (msg.what) {
                case AlixId.RQF_INSTALL_CHECK: {
                    //
                    closeProgress();
                    String cachePath = (String) msg.obj;

                    showInstallConfirmDialog(mContext, cachePath);
                }
                    break;
                }

                super.handleMessage(msg);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };
}
