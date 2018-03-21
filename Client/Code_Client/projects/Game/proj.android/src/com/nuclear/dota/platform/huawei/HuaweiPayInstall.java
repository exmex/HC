package com.nuclear.dota.platform.huawei;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.List;

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

public class HuaweiPayInstall {

	private Context context;
	private String cachePath;
	private ProgressDialog dialog;
	public HuaweiPayInstall(Context context)
	{
		this.context = context;
	}
	

	/**
	 *  此处接收安装检测结果
	 */
	private Handler mHandler = new Handler() {
		public void handleMessage(Message msg) {
			try {
				switch (msg.what) {
				case HuaweiPayUtil.RQF_INSTALL_CHECK: {
					dialog.dismiss();
					cachePath = (String) msg.obj;
					chmod("777", cachePath);
					showInstallConfirmDialog(context, cachePath);
				}
					break;
				}

				super.handleMessage(msg);
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
	};
	
	public boolean detectMobile_sp()
	{
		boolean isMobile_spExist = isMobile_spExist(HuaweiPayUtil.PackageName);
		if (!isMobile_spExist) {
			//
			// get the cacheDir.
			// 获取系统缓冲绝对路径 获取/data/data//cache目录
			File cacheDir = context.getCacheDir();
			final String cachePath = cacheDir.getAbsolutePath() + "/hwpay.apk";
			chmod("777", cachePath);

		
			//弹框显示
			dialog = ProgressDialog.show(context, "","正在检测安全支付版本", true);
			// 实例新线程检测是否有新版本进行下载
			new Thread(new Runnable() {
				public void run() {

					//预装assets文件夹下的apk
				boolean has = retrieveApkFromAssets(context, HuaweiPayUtil.HWPAY_PLUGIN_NAME,
							cachePath);
					
//					//下载apk
				if(!has)
					retrieveApkFromNet(context, HuaweiPayUtil.apk_download_url, cachePath);
					
					// send the result back to caller.
					// 发送结果
					Message msg = new Message();
					msg.what = HuaweiPayUtil.RQF_INSTALL_CHECK;
					msg.obj = cachePath;
					mHandler.sendMessage(msg);
				}
			}).start();
		}
		// else ok.

		return isMobile_spExist;
	}
	
	/**
	 * 遍历程序列表，判断是否安装安全支付服务
	 * 
	 * @return
	 */
	public boolean isMobile_spExist(String packageName) {
		PackageManager manager = context.getPackageManager();
		List<PackageInfo> pkgList = manager.getInstalledPackages(0);
		for (int i = 0; i < pkgList.size(); i++) {
			PackageInfo pI = pkgList.get(i);
			// if (pI.packageName.equalsIgnoreCase("com.alipay.android.app"))
			// return true;
			if (pI.packageName.equalsIgnoreCase(packageName))
				return true;

		}
		return false;
	}

	
	/**
	 * 显示确认安装的提示
	 * 
	 * @param context
	 *            上下文环境
	 * @param cachePath
	 *            安装文件路径
	 */
	public void showInstallConfirmDialog(final Context context,
			final String cachePath) {
		AlertDialog.Builder tDialog = new AlertDialog.Builder(context);
		tDialog.setTitle("安装提示");
		tDialog.setMessage("为了您的交易安全，需要安装华为安全支付服务，才能进行付款。\n\n点击确定，立即安装。");
		tDialog.setCancelable(false);
		tDialog.setPositiveButton(android.R.string.ok,
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						//
						// 修改apk权限
						chmod("777", cachePath);
						// install the apk.
						// 安装安全支付服务APK
						Intent intent = new Intent(Intent.ACTION_VIEW);
						intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
						intent.setDataAndType(Uri.parse("file://" + cachePath),
								"application/vnd.android.package-archive");
						context.startActivity(intent);  
					}
				});

		tDialog.setNegativeButton(
				context.getResources().getString(android.R.string.cancel),
				new DialogInterface.OnClickListener() {
					public void onClick(DialogInterface dialog, int which) {
						dialog.dismiss();
					
					}
				});
		tDialog.show();
	}

	/**
	 * 动态下载apk
	 * 
	 * @param context
	 *            上下文环境
	 * @param strurl
	 *            下载地址
	 * @param filename
	 *            文件名称
	 * @return
	 */
	public boolean retrieveApkFromNet(Context context, String strurl,
			String filename) {
		boolean bRet = false;

		try {
			NetworkManager nM = new NetworkManager(context);
			bRet = nM.urlDownloadToFile(context, strurl, filename);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return bRet;
	}
	
	/**
	 * 获取权限
	 * 
	 * @param permission
	 *            权限
	 * @param path
	 *            路径
	 */
	public  void chmod(String permission, String path) {
		try {
			String command = "chmod " + permission + " " + path;
			Runtime runtime = Runtime.getRuntime();
			runtime.exec(command);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	
	//com.huawei.accountagent
	/**
	 * 安装安全支付服务，安装assets文件夹下的apk
	 * 
	 * @param context
	 *            上下文环境
	 * @param fileName
	 *            apk名称
	 * @param path
	 *            安装路径
	 * @return
	 */
	public boolean retrieveApkFromAssets(Context context, String fileName,
			String path) {
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
}
