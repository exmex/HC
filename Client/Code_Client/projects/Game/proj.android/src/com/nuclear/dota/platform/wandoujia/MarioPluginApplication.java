package com.nuclear.dota.platform.wandoujia;

import java.io.File;

import android.app.Application;
import android.content.Context;
import android.os.Environment;

import com.wandoujia.mariosdk.plugin.api.api.WandouGamesApi;
import com.youai.StorageUtil;

public class MarioPluginApplication extends Application {
	
	/*
	 * 豌豆荚SDK初始化所需的app_id和app_key，从so里面读取会出错
	 * */
	private long APP_KEY = 100001163;
	private String SECURITY_KEY = "c4a33b0af422276256386c84ca8686c9";


	private static WandouGamesApi wandouGamesApi;
	
	public static WandouGamesApi getWandouGamesApi() {
		return wandouGamesApi;
	}
	
	
	@Override
	protected void attachBaseContext(Context base) {
		String path = Environment.getExternalStorageDirectory() + File.separator + "MarioPlugin";
		StorageUtil.removeFileDirectory(new File(path));
		WandouGamesApi.initPlugin(base, APP_KEY, SECURITY_KEY);
		super.attachBaseContext(base);
	}
	
	
	@Override
	public void onCreate() {
		wandouGamesApi = new WandouGamesApi.Builder(this, APP_KEY, SECURITY_KEY).create();
		wandouGamesApi.setLogEnabled(true);
		super.onCreate();
	}
}
