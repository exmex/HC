package com.nuclear.dota.platform.sy4399;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.os.Bundle;
import android.util.Log;

import com.ssjjsy.net.Plugin;
import com.ssjjsy.net.Ssjjsy;
import com.ssjjsy.net.SsjjsyPluginListener;
import com.ssjjsy.sdk.SdkListener;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class SSJJActivity extends GameActivity {

	
	/*
	 * 
	 * */
	public SSJJActivity()
	{
		/*
		 * */
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Game4399);

	}
	
	
	
private static final String TAG = GameActivity.class.getSimpleName();
	
	
	@Override
	protected void onCreate(Bundle savedInstanceState){
		super.onCreate(savedInstanceState);
		Intent intent = getIntent();
		if(intent != null && intent.getBooleanExtra("portrait", false)) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		}
	}
	
	/* ==================== 4399 assistant ==================== */
	
	
	void initSdk() {
		
		//显示小助手
		Ssjjsy.getInstance().setPluginListener(new SsjjsyPluginListener() {
			@Override
			public void onSuccess() {
				Log.i(TAG, "SsjjsyPluginListener.onSuccess()");
				//在需要显示的地方添加浮动的小助手。 如果登录成功跳转到其他的activity，则这段代码需要添加到对于的activity中。
				Plugin.getInstance().setSdkListener(mSdkListener);
				Plugin.getInstance().show(SSJJActivity.this);
			}
		});
	}
	
	private static native boolean nativeScreenShot(String saveName, int startX, int startY, int width, int height);

	private SdkListener mSdkListener = new SdkListener() {
		@Override
		public boolean onScreenShot(final String saveName, final int startX, final int startY, final int width, final int height) {
			runOnGLThread(new Thread() {
				@Override
				public void run() {
					boolean isSuccessed = nativeScreenShot(saveName, startX, startY, width, height);
					Plugin.getInstance().postResult(isSuccessed, saveName);
				}
			});
			return false;
		}
	};

	
	@Override
	protected void onStart() {
		super.onStart();
		Plugin.getInstance().onStart();
	}


	@Override
	protected void onRestart() {
		super.onRestart();
		Plugin.getInstance().onRestart();
	}


	@Override
	protected void onPause() {
		super.onPause();
		Plugin.getInstance().onPause();
	}


	@Override
	protected void onStop() {
		super.onStop();
		Plugin.getInstance().onStop();
	}

	@Override
	public void onResume() {
		super.onResume();
		Plugin.getInstance().onResume();
	}

	
	@Override
	protected void onDestroy() {
		super.onDestroy();
		Plugin.getInstance().onDestroy();
	}
	
	@Override
	public void notifyEnterGame() {
		Ssjjsy.getInstance().setServerId(String.valueOf(Cocos2dxHelper.nativeGetServerId()));
		Ssjjsy.getInstance().loginServerLog(this);
		initSdk();
	}

}
