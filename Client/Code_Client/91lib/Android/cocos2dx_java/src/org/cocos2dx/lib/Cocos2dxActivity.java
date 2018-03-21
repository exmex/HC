/****************************************************************************
Copyright (c) 2010-2013 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/
package org.cocos2dx.lib;

import org.cocos2dx.lib.Cocos2dxHelper.Cocos2dxHelperListener;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;



public abstract class Cocos2dxActivity extends Activity implements
		Cocos2dxHelperListener
{
	
	// ===========================================================
	// Constants
	// ===========================================================
	
	private static final String		TAG											= Cocos2dxActivity.class
																						.getSimpleName();
	//
	
	// ===========================================================
	// Fields
	// ===========================================================
	
	public Cocos2dxGLSurfaceView	mGLSurfaceView;
	private Cocos2dxHandler			mHandler;
	public Handler 				mGameAppStateHandler;
	private static Context			sContext									= null;
	//
	protected boolean				mIsCocos2dxSurfaceViewCreated				= false;
	protected boolean				mIsRenderCocos2dxView						= false;
	//
	public String					mAppDataExternalStorageFullPath				= null;
	public String					mAppDataExternalStorageResourcesFullPath	= null;
	public String					mAppDataExternalStorageCacheFullPath		= null;
	
	//
	protected boolean				mIsOnPause									= false;
	/*
	 * 当短暂打开平台界面、截屏分享，本Activity被系统置后而Pause，渲染和声音可以暂停，但网络不断，免得重连
	 */
	protected boolean				mIsTempShortPause							= false;
	private long 					mLastLowMemoryNanoTime						= System.nanoTime();
	
	//
	
	public static Context getContext()
	{
		return sContext;
	}
	
	public View getCocos2dxGLSurfaceView()
	{
		return mGLSurfaceView;
	}
	
	/*
	 * 启动Activity的UI线程为进程的主线程；操作Activity的UI必须通过对其Handler发消息
	 */
	public Handler getMainThreadHandler()
	{
		return mHandler;
	}
	
	// ===========================================================
	// Constructors
	// ===========================================================
	
	@Override
	protected void onCreate(final Bundle savedInstanceState)
	{
		
		Log.d(TAG, "2		call Cocos2dxActivity.onCreate");
		
		super.onCreate(savedInstanceState);
		// 保持屏幕长亮
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON,
				WindowManager.LayoutParams.FLAG_KEEP_SCREEN_ON);
		
		sContext = this;
		
		/*
		 * UI线程即主线程
		 * */
		this.mHandler = new Cocos2dxHandler(this);
		
	}
	
	@Override
	protected void onDestroy()
	{
		super.onDestroy();
		Log.d(TAG, "call Cocos2dxActivity.onDestroy");
		//
		if (mIsCocos2dxSurfaceViewCreated)
		{
			Cocos2dxHelper.onPause();
			this.mGLSurfaceView.onPause();
			//
			//Cocos2dxHelper.nativeGameDestroy();	// 屏蔽for
												// testin，因为退出崩溃会被testin记录影响报告
		}
		//
		mIsCocos2dxSurfaceViewCreated = false;
		// 结束静态引用的生命周期
		Cocos2dxActivity.sContext = null;
		//
		// System.exit(0);//子类重写了onDestroy
	}
	
	// ===========================================================
	// Getter & Setter
	// ===========================================================
	
	// ===========================================================
	// Methods for/from SuperClass/Interfaces
	// ===========================================================
	
	@Override
	protected void onRestart()
	{
		
		Log.d(TAG, "call Cocos2dxActivity.onRestart");
		super.onRestart();
		
	}
	
	@Override
	protected void onResume()
	{
		
		Log.d(TAG, "call Cocos2dxActivity.onResume");
		Log.i(TAG, "mIsCocos2dxSurfaceViewCreated:"+mIsCocos2dxSurfaceViewCreated+"mIsCocos2dxSurfaceViewCreated"+mIsRenderCocos2dxView+"mIsOnPause"+mIsOnPause);
		super.onResume();
		//
		if (mIsCocos2dxSurfaceViewCreated && mIsRenderCocos2dxView && mIsOnPause)
		{
			mIsOnPause = false;
			mIsTempShortPause = false;
			//
			Cocos2dxHelper.onResume();
			this.mGLSurfaceView.onResume();
			//
			if (mGameAppStateHandler != null)
			{
				mGameAppStateHandler
					.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_OnActivityResume);
			}
		}
		mIsRenderCocos2dxView = true;
		//
	}
	
	@Override
	protected void onPause()
	{
		
		Log.d(TAG, "call Cocos2dxActivity.onPause");
		
		super.onPause();
		//
		if (mIsCocos2dxSurfaceViewCreated && mIsRenderCocos2dxView && !mIsOnPause)
		{
			Log.i(TAG, "mIsCocos2dxSurfaceViewCreated:"+mIsCocos2dxSurfaceViewCreated+"mIsCocos2dxSurfaceViewCreated"+mIsRenderCocos2dxView+"mIsOnPause"+mIsOnPause);
			mIsOnPause = true;
			//
			if (mGameAppStateHandler != null)
			{
				mGameAppStateHandler
					.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_OnActivityPause);
			}
			//
			Cocos2dxHelper.onPause();
			this.mGLSurfaceView.onPause();
		}
		//
		
	}
	
	@Override
	protected void onStart()
	{
		
		Log.d(TAG, "call Cocos2dxActivity.onStart");
		
		super.onStart();
		//
		if (mIsCocos2dxSurfaceViewCreated && mIsRenderCocos2dxView && mIsOnPause)
		{
			mIsOnPause = false;
			mIsTempShortPause = false;
			//
			Cocos2dxHelper.onResume();
			this.mGLSurfaceView.onResume();
			//
			if (mGameAppStateHandler != null)
			{
				mGameAppStateHandler
					.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_OnActivityResume);
			}
		}
		mIsRenderCocos2dxView = true;
		//
		
	}
	
	@Override
	protected void onStop()
	{
		
		Log.d(TAG, "call Cocos2dxActivity.onStop");
		
		super.onPause();
		//
		if (mIsCocos2dxSurfaceViewCreated && mIsRenderCocos2dxView && !mIsOnPause)
		{
			mIsOnPause = true;
			
			if (mGameAppStateHandler != null)
			{
				mGameAppStateHandler
					.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_OnActivityPause);
			}
			//
			Cocos2dxHelper.onPause();
			this.mGLSurfaceView.onPause();
		}
		//
		
	}
	
	@Override
	// Cocos2dxGLSurfaceView劫走传到Native先处理onKeyDown并且返回true中断了Event
	public boolean onKeyDown(int keyCode, KeyEvent event)
	{
		
		if (keyCode == KeyEvent.KEYCODE_BACK)
		{
			this.showQuestionDialog(
					this.getResources().getString(R.string.app_exit_title),
					this.getResources().getString(R.string.app_exit_msg),
					Cocos2dxHandler.bsQuestionDialogMsgId_Cocos2dxActivity_BackKeyPressed,
					"", "");
			return true;
		}
		if (keyCode == KeyEvent.KEYCODE_MENU)
		{
			super.onKeyDown(keyCode, event);
			return true;
		}
		
		return super.onKeyDown(keyCode, event);
	}
	
	@Override
	public void showDialog(final String pTitle, final String pMessage,
			final int msgId, final String positiveCallback)
	{
		Message msg = new Message();
		msg.what = Cocos2dxHandler.HANDLER_SHOW_DIALOG;
		msg.obj = new Cocos2dxHandler.DialogMessage(pTitle, pMessage, msgId,
				positiveCallback, "");
		this.mHandler.sendMessage(msg);
	}
	
	@Override
	public void showQuestionDialog(final String pTitle, final String pMessage,
			final int msgId, final String positiveCallback,
			final String negativeCallback)
	{
		Message msg = new Message();
		msg.what = Cocos2dxHandler.HANDLER_SHOW_QUESTION_DIALOG;
		msg.obj = new Cocos2dxHandler.DialogMessage(pTitle, pMessage, msgId,
				positiveCallback, negativeCallback);
		this.mHandler.sendMessage(msg);
	}
	
	@Override
	public void showEditTextDialog(final String pTitle, final String pContent,
			final int pInputMode, final int pInputFlag, final int pReturnType,
			final int pMaxLength)
	{
		Message msg = new Message();
		msg.what = Cocos2dxHandler.HANDLER_SHOW_EDITBOX_DIALOG;
		msg.obj = new Cocos2dxHandler.EditBoxMessage(pTitle, pContent,
				pInputMode, pInputFlag, pReturnType, pMaxLength);
		this.mHandler.sendMessage(msg);
	}
	
	@Override
	public void runOnGLThread(final Runnable pRunnable)
	{
		this.mGLSurfaceView.queueEvent(pRunnable);
	}
	
	@Override
	public void callPlatformLogin()
	{
		mGameAppStateHandler
				.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformLogin);
	}
	
	@Override
	public void callPlatformLogout()
	{
		mGameAppStateHandler
				.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformLogout);
	}
	
	@Override
	public void callPlatformAccountManage()
	{
		mGameAppStateHandler
				.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformAccountManage);
	}
	
	@Override
	public void callPlatformPayRecharge(String serial, String productId,
			String productName, float price, float orignalPrice, int count,
			String description)
	{
		Message msg = new Message();
		msg.what = Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformPayRecharge;
		msg.obj = new Cocos2dxHandler.PayRechargeMessage(serial, productId,
				productName, price, orignalPrice, count, description);
		mGameAppStateHandler.sendMessage(msg);
	}
	
	@Override
	public boolean getPlatformLoginStatus()
	{
		return true;
	}
	
	@Override
	public String getPlatformLoginUin()
	{
		return "";
	}
	
	@Override
	public String getPlatformLoginSessionId()
	{
		return "";
	}
	
	@Override
	public String getPlatformUserNickName()
	{
		return "";
	}

	public void callPlatformInit()
	{
		/*
		 * xinzheng 2013-06-21 按重构方案，在Android系统，不是Game.so发起这个
		 * */
		//this.mHandler
		//		.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformInit);
	}
	
	//
	@Override
	public String generateNewOrderSerial()
	{
		return null;
	}
	
	@Override
	public void callPlatformFeedback()
	{
		mGameAppStateHandler
				.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformFeedback);
	}
	
	@Override
	public void callPlatformSupportThirdShare(String content, String imgPath)
	{
		Message msg = new Message();
		msg.what = Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformThirdShare;
		msg.obj = new Cocos2dxHandler.ShareMessage(content, imgPath);
		mGameAppStateHandler.sendMessage(msg);
	}
	
	@Override
	public void callPlatformGameBBS(String url)
	{
		mGameAppStateHandler
			.sendEmptyMessage(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformBBS);
	}
	
	public boolean getIsOnTempShortPause()
	{
		return mIsTempShortPause;
	}
	
	public void openUrlOutside(String url)
	{
		if (url.isEmpty())
			return;
		//
		mIsTempShortPause = true;
		//
		Uri uri = Uri.parse(url);
		Intent it = new Intent(Intent.ACTION_VIEW, uri);
		startActivity(it);
	}
	
	public void showWaitingView(boolean show, int progress, String text)
	{
		if (mGameAppStateHandler != null)
		{
			Message msg = new Message();
			msg.what = Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ShowWaitingView;
			msg.obj = new Cocos2dxHandler.ShowWaitingViewMessage(show, progress,
					text);
			mGameAppStateHandler.sendMessage(msg);
		}
	}
	
	//
	// ===========================================================
	// Methods
	// ===========================================================
	public void initAndroidContext(View glView, View editText)
	{
		
		/*
		 * 注意子类Activity先调用了initAppDataPath
		 * */
		/*
		 * Music/Sound/Accelerometer
		 * */
		Cocos2dxHelper.init(this, this, this.mAppDataExternalStorageFullPath);
		
		/*
		 * GL Context/GL SurfaceView
		 * */
		this.mGLSurfaceView = (Cocos2dxGLSurfaceView)glView;
        /*
         * */
        this.mGLSurfaceView.setCocos2dxEditText((Cocos2dxEditText)editText);
        /*
         * */
        
	}
	
	protected void setOnTempShortPause(boolean pause)
	{
		//mIsTempShortPause = pause;
		//mIsRenderCocos2dxView = !pause;
		
		Log.d(TAG, "mIsTempShortPause: " + String.valueOf(pause));
	}
	
	protected void setGameAppStateHandler(Handler handler)
	{
		mGameAppStateHandler = handler;
		mIsCocos2dxSurfaceViewCreated = true;
		mIsRenderCocos2dxView = true;
	}
	
	public void onTimeToShowCocos2dxContentView()
	{
		// to Override at subclass
	}
	
	protected void destroy() {
		
		if (mGameAppStateHandler != null)
			mGameAppStateHandler.removeMessages(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_OnActivityPause);
		mGameAppStateHandler = null;
		// to Override at subclass
		//子类集成第三方SDK后，单单finish本Activity并不能发起销毁进程
		//子类finish其他activity
		super.finish();
	}
	
	public void showToastMsgImp(String msg)
	{
		
	}
	
	@Override
	public void onLowMemory()
	{
		if (mIsCocos2dxSurfaceViewCreated)
		{
			final long timestamp = System.nanoTime();
			final long timedelt = 6*60*1000*1000*1000;
			if ((timestamp-this.mLastLowMemoryNanoTime) > timedelt)
			{
				//this.showDialog("提示", "可用内存不足，正在尝试回收，请稍后！", 
				//		Cocos2dxHandler.bsDialogMsgId_Cocos2dxActivity_OnLowMemory, "");
				//Cocos2dxHelper.nativePurgeCachedData();//在显示提示框后开始长时间的这个操作，且应该runOnGLThread
				mHandler.sendEmptyMessageDelayed(Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_OnLowMemory, 1000);
				//
				this.mLastLowMemoryNanoTime = timestamp;
			}
		}
		
		super.onLowMemory();
	}
	
	public void onLowMemoryImp()
	{
		this.runOnGLThread(new Runnable()
		{

			@Override
			public void run() {
				
//				Cocos2dxHelper.nativePurgeCachedData();
			}
			
		});
	}
	
	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================
}
