package com.nuclear.dota.platform.huawei;

import java.text.NumberFormat;

import android.app.Activity;
import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.util.Log;
import com.huawei.deviceCloud.microKernel.core.MicroKernelFramework;
import com.huawei.deviceCloud.microKernel.manager.update.IUpdateNotifier;
import com.huawei.deviceCloud.microKernel.manager.update.info.ComponentInfo;

public class UpdateNotifierHandler implements IUpdateNotifier {
    private final static String TAG =
    		UpdateNotifierHandler.class.getSimpleName();
    
    private Activity context = null;
    private ProgressDialog progressDialog = null;
    private MicroKernelFramework framework = null;
    
    private final static NumberFormat nf  =  NumberFormat.getPercentInstance();
    static {
        nf.setMaximumFractionDigits(1);
    }
     
    public UpdateNotifierHandler(Activity context, MicroKernelFramework framework) {
        this.context = context;
        this.framework = framework;
    }
    
    /**
     * 通知某个插件有新版本
     * @param ci 插件信息
     * @param existsOldVersion 是否存在老版本的插件，如果存在，由应用决定是否立即加载
     * 在调用checkSinglePlugin的线程中运行
     */
    public void thereAreNewVersion(final ComponentInfo ci, final Runnable downloadHandler, boolean existsOldVersion) {
        Log.d(TAG, "thereAreNewVersion:" + ci.getPackageName() + ", versionCode:" + ci.getVersionCode()+" existsOldVersion:"+existsOldVersion);
        DialogInterface.OnClickListener update = new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                /**
                 * 当用户确定下载时，开始下载，其他的都不要调用此函数
                 * 非阻塞，会启动新的线程下载
                 */
                downloadHandler.run();
                dialog.dismiss();
            }
        };        
        
        DialogInterface.OnClickListener cancel = new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
//                runService(ci.getPackageName());
            }
        };
        
        new AlertDialog.Builder(context)
            .setTitle("插件更新：" + Constant.allPluginName.get(ci.getPackageName()))
            .setMessage(Constant.allPluginName.get(ci.getPackageName()) + " 有新版本： " + ci.getVersionName() + "， 点击“确定”更新")
            .setCancelable(false)
            .setNegativeButton("取消", cancel)
            .setPositiveButton("确定", update)
            .show();
    }
    
    /**
     * 开始下载插件，可以在这里显示一个进度条
     * @param ci 插件信息
     * 在调用checkSinglePlugin的线程中运行
     */
    public void startDownload(ComponentInfo ci) {
        Log.d(TAG, "startDownload:" + ci.getPackageName() + ", versionCode:" + ci.getVersionCode());
        progressDialog = new ProgressDialog(context);
        progressDialog.setTitle("插件 " + Constant.allPluginName.get(ci.getPackageName()));
        progressDialog.setMessage("正在下载...");
        progressDialog.setIndeterminate(false);
        progressDialog.setCancelable(false);
        progressDialog.setOnCancelListener(new DialogInterface.OnCancelListener() {
            public void onCancel(DialogInterface dialog) {
                framework.cancelDownload();
                progressDialog.dismiss();
            }
        });
        progressDialog.show();
    }
    
    /**
     * 开始下载插件
     * @param ci 插件信息
     * 在下载线程中运行，所以要注意，使用ui线程运行界面操作
     */
    public void downloading(final ComponentInfo ci, final long downloadedSize, final long totalSize) {
        Log.d(TAG, "downloading:" + ci.getPackageName() + ", versionCode:" + ci.getVersionCode());
        context.runOnUiThread(new Runnable() {
            public void run(){ 
                progressDialog.setMessage("Load..." + nf.format(((double)downloadedSize / totalSize)));
            }
        });
    }
    
    /**
     * 插件下载完成
     * @param ci 插件信息
     * 在下载线程中运行，所以要注意，使用ui线程运行界面操作
     */
    public void downloaded(final ComponentInfo ci) {
        Log.d(TAG, "downloaded:" + ci.getPackageName() + ", versionCode:" + ci.getVersionCode());
        context.runOnUiThread(new Runnable() {
            public void run(){ 
                progressDialog.dismiss();
//                Toast.makeText(context, "Success to download " + ci.getPackageName(), Toast.LENGTH_LONG).show();
            }
        });
//        runService(ci.getPackageName());
    }
    
    /**
     * 插件下载失败
     * @param ci 插件信息
     * 在下载线程中运行，所以要注意，使用ui线程运行界面操作
     */
    public void downloadFailed(final ComponentInfo ci, boolean existsOldVersion, int errorCode) {
        Log.d(TAG, "downloadFailed:" + ci.getPackageName() + ", versionCode:" + ci.getVersionCode() + ",errorCode:" + errorCode);
        context.runOnUiThread(new Runnable() {
            public void run(){ 
                progressDialog.dismiss();
//                Toast.makeText(context, "Fail to download " + ci.getPackageName(), Toast.LENGTH_LONG).show();
            }
        });
        
        runService(ci.getPackageName());
    }

    /**
     * 插件未更新，本地插件仍然有效
     * @param ci 插件信息
     * 在调用checkSinglePlugin的线程中运行
     */
    public void localIsRecent(ComponentInfo ci) {
        Log.d(TAG, "localIsRecent:" + ci.getPackageName() + ", versionCode:" + ci.getVersionCode());
//        Toast.makeText(context, "Local plugin " + ci.getPackageName() + " is recent", Toast.LENGTH_LONG).show();
        
//        runService(ci.getPackageName());
    }
    
    private void runService(String packageName) {
        Log.d(TAG, "runService, load plugin " + packageName);
        framework.loadPlugin(packageName);
        
    }
}
