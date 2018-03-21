package com.nuclear.dota.platform.punchbox;

import joy.JoyGL;
import joy.JoyInterface;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.view.KeyEvent;
import android.widget.Toast;

import java.lang.reflect.Method;

import com.punchbox.hound.Hound;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class ChuKongActivity extends GameActivity implements JoyGL {
	
	
	PlatformChuKongLoginAndPay mChuKongPlatform = null;
	
	
	public ChuKongActivity(){
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_ChuKong);
	}
	@Override
	protected void onCreate(Bundle savedInstanceState) {

		super.onCreate(savedInstanceState);
	
//		ApplicationInfo appInfo = null;
//		try {
//			appInfo = getPackageManager().getApplicationInfo(getPackageName(),PackageManager.GET_META_DATA);
//		} catch (NameNotFoundException e) {
//			e.printStackTrace();
//		}
		
//		String channel =String.valueOf(appInfo.metaData.getInt("coco_cid", 0));
//		String boxid=appInfo.metaData.getString("coco_pid");
//		if(boxid==null||boxid.equals(""))
//		{
//			boxid=String.valueOf(appInfo.metaData.getInt("chukong_boxid", 0));
//		}
		
		Hound.init(this);
		
		reflectInvoke();
	}
	
	@Override
	public boolean onKeyDown(int keyCode,KeyEvent event){
		if(keyCode == KeyEvent.KEYCODE_BACK){
			showTips();
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}
	
	@Override
	protected void onDestroy() {
		//
		//退出释放资源,一定要在super.onDestroy()之前调用
		Hound.release(this);
		
		super.onDestroy();
		
	}
	
	@Override
	public void initPlatformSDK(IPlatformLoginAndPay platform) {

		super.initPlatformSDK(platform);
		
		mChuKongPlatform = (PlatformChuKongLoginAndPay)mPlatform;
		
		mChuKongPlatform.initChuKong(this);
		
	}
	
	@Override
	public void onPause() {
		super.onPause(); 
		Hound.onPause(this);
		//Toast.makeText(getApplicationContext(), "onPause", Toast.LENGTH_SHORT).show();
	}
	
	@Override
	public void onStop(){
		super.onStop();
		//Toast.makeText(getApplicationContext(), "onStop", Toast.LENGTH_SHORT).show();
	}
	
	@Override
	public void onResume() {
		super.onResume();
		JoyInterface.onResume();
	}
	
	@Override
	protected void onStart() {
		// TODO Auto-generated method stub
		super.onStart();
		Hound.onStart(this);
		//Toast.makeText(getApplicationContext(), "onStart", Toast.LENGTH_SHORT).show();
	}

	static {
		// 见文档1.3.3
		System.loadLibrary("joygamesdk");
	}
	
	public void onActivityResult(int requestCode, int resultCode, Intent data) {
		JoyInterface.onActivityResult(requestCode, resultCode, data);
		super.onActivityResult(requestCode, resultCode, data);
	}
	
	private void reflectInvoke(){
		try {
			Class<?> cls = Class.forName("com.punchbox.hound.Hound");
			Method method = cls.getMethod("getDeviceId", Context.class);
			String dvid = (String)method.invoke(cls, this);
//			TextView tv = (TextView)findViewById(R.id.);
//			tv.setText(dvid);
//			Toast.makeText(this, dvid, Toast.LENGTH_SHORT).show();
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	private void showTips()
	  {
	    AlertDialog.Builder localBuilder = new AlertDialog.Builder(this);
	    localBuilder.setMessage("确定离开吗？");
	    localBuilder.setTitle("刀塔传奇2");
	    localBuilder.setPositiveButton("确定", new DialogInterface.OnClickListener()
	    {
	      public void onClick(DialogInterface paramDialogInterface, int paramInt)
	      {
	        paramDialogInterface.dismiss();
	        Hound.release(ChuKongActivity.this);
	        ChuKongActivity.this.finish();
	        System.exit(0);
	      }
	    });
	    localBuilder.setNegativeButton("取消", new DialogInterface.OnClickListener()
	    {
	      public void onClick(DialogInterface paramDialogInterface, int paramInt)
	      {
	        paramDialogInterface.dismiss();
	      }
	    });
	    localBuilder.create().show();
	  }
}
