/*
 * 
 * 
 * 
 * 
 * 
 * */

package com.nuclear.dota;

import java.io.File;
import java.util.ArrayList;
import java.util.TimeZone;

import org.cocos2dx.lib.Cocos2dxActivity;
import org.cocos2dx.lib.Cocos2dxHandler;
import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.ActivityManager;
import android.app.ActivityManager.RunningServiceInfo;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ActivityInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.media.MediaPlayer;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.os.StrictMode;
import android.util.Log;
import android.view.KeyEvent;
import android.view.View;
import android.widget.ImageButton;
import android.widget.Toast;

import com.nuclear.DeviceUtil;
import com.nuclear.GameActivityHelper;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.IStateManager;
import com.nuclear.NetworkUtil;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.ShakeLisenter;
import com.nuclear.WXUtil;
import com.nuclear.WorldVideoView;
import com.nuclear.dota.GameInterface.Idota;
import com.qsds.ggg.dfgdfg.fvfvf.R;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.SendMessageToWX;
import com.tencent.mm.sdk.openapi.WXImageObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;
import com.tencent.mm.sdk.openapi.WXTextObject;

//

public class GameActivity extends Cocos2dxActivity implements Idota,
		MediaPlayer.OnCompletionListener {
	// ////////////////////////////////////////////////////////////////////////
	static {
		System.loadLibrary("cocos2dlua");
	}
	// ////////////////////////////////////////////////////////////////////////

	public static IWXAPI api;// 微信api调用

	private static final String TAG = GameActivity.class.getSimpleName();

	//
	protected GameConfig mGameCfg = null;
	private IStateManager mStateMgr = new GameStateManager(
			GameInterface.GameStateIDMax, this);
	protected IPlatformLoginAndPay mPlatform = null;
	//
	private Handler mGameContextStateHandler;
	//
	private long mLastMenuKeyDownTimeMillis = 0;
	private long mRecentPressMenuKeyDownCount = 0;
	//
	private boolean mHaveEnteredGameAppState = false;
	private VersionInfo mVersionResult;
	private DownloadApk updateApk;

	private ShakeLisenter mShakeListener = null;// 微信摇一摇监听器
	private boolean videoWorldViewPause = false;

	private static boolean canPressBack = true;// 点击返回键是否有效
	public static boolean weChatHave = false;
	public static boolean isShareSuccess = false;

	public static void setWeChat(boolean pWeChat) {
		weChatHave = pWeChat;
	}

	public static void setShareSuccess(boolean pShareSuccess) {
		isShareSuccess = pShareSuccess;
	}

	// 重启Activity程序
	public static void requestRestart() {
		GameActivityHelper.requestRestart(getContext(), mHandler);
	}

	// 存在：打开微信程序 ，不存在：弹出安装微信
	public static void openWeChat() {
		GameActivityHelper.openWeChat(mContext, mHandler);
	}

	//
	public static int getMobileNetType() {
		int type = NetworkUtil.getMobileNetType(mContext);
		Log.e(TAG, "getMobileNetType:" + type);
		return type;
	}

	//
	public static int getMobileNetISP() {
		int isp = NetworkUtil.getMobileNetISP(mContext);
		Log.e(TAG, "getMobileNetISP:" + isp);
		return isp;
	}

	//
	/**
	 * 添加平台工具栏工具栏
	 * 
	 * @param visible
	 */
	public static void callToolBar(boolean visible) {
		Message msg = new Message();
		Bundle bundle = new Bundle();
		bundle.putBoolean(
				GameAppState.HANDLER_MSG_TO_MAINTHREAD_CallNd91_TOOLBAR_KEY,
				visible);
		msg.setData(bundle);
		msg.what = GameAppState.HANDLER_MSG_TO_MAINTHREAD_CallNd91_TOOLBAR;
		mGameApp.mGameAppStateHandler.sendMessage(msg);

	}

	static Handler mHandler;
	static Context mContext;
	static GameActivity mGameApp;
	private static WorldVideoView videoWorldView;
	private static ImageButton buttonStopMovie;
	private static ImageButton discipleCardStopMovie;
	private boolean isLogined = false;

	//
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		isLogined = true;
		long start = System.currentTimeMillis();

		super.onCreate(savedInstanceState);
		changeScreen();
		mHandler = GameActivity.this.getMainHandler();
		mContext = GameActivity.this;
		mGameApp = GameActivity.this;
		// mStateMgr.changeState(GameInterface.GameLogoStateID);
		mStateMgr.changeState(GameInterface.GameLogoMovieState);
		startService(new Intent(GameActivity.this, NotificationService.class));

		// LastLoginHelp.setActivity(this);//耗时操作延迟在GameLogoState的doEnter

		//
		StrictMode.setThreadPolicy(new StrictMode.ThreadPolicy.Builder()
		/* .detectDiskReads().detectDiskWrites() */.detectNetwork()
		/* .penaltyLog() */.build());

		// StrictMode.setVmPolicy(new StrictMode.VmPolicy.Builder()
		// .detectLeakedSqlLiteObjects().penaltyLog().penaltyDeath()
		// .build());
		//

		AnalyticsToolHelp.onCreate(this, getGameInfo());// must call here,for
														// onResume/onPause

		// Thread.setDefaultUncaughtExceptionHandler(handler)
		//
		long end = System.currentTimeMillis();
		long span = end - start;
		Log.e(TAG, "onCreate cost time: " + span + " millis");
	}

	private void changeScreen() {
		this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_SENSOR_LANDSCAPE);
		if (getRequestedOrientation() == ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE);
		}
		// 横屏反方向
		else if (getRequestedOrientation() == ActivityInfo.SCREEN_ORIENTATION_REVERSE_LANDSCAPE) {
			setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
		}
		// // 纵屏正方向
		// else if (getRequestedOrientation() ==
		// ActivityInfo.SCREEN_ORIENTATION_PORTRAIT) {
		// setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT);
		// }
		// // 纵屏反方向
		// else if (getRequestedOrientation() ==
		// ActivityInfo.SCREEN_ORIENTATION_REVERSE_PORTRAIT) {
		// setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
		// }
	}

	@Override
	protected void onDestroy() {
		//
		super.onDestroy();
		if (updateApk != null) {
			updateApk.onDestroy();
			updateApk = null;
		}
		//
		Log.d(TAG, "call onDestroy and System exit");
		/*
		 * OpenGL ES Context 没有能正确释放，只得System.exit了！不然影响重启
		 */
		// System.exit(0);

		android.os.Process.killProcess(android.os.Process.myPid());

	}

	@Override
	protected void destroy() {

		Log.d(TAG, "call destroy");
		//
		AnalyticsToolHelp.onStop();
		//
		if (mPlatform != null) {
			Log.d(TAG, "mPlatform.unInit");
			// 要求mPlatform里的Activities进行finish
			mPlatform.unInit();
			mPlatform = null;
		}
		//
		super.destroy();
		//
		mStateMgr.changeState(GameInterface.GameStateIDMin);
		mStateMgr = null;

	}

	@Override
	protected void onStart() {
		// home键会调游戏程序进入后台，渲染跳过、网络断�?��但程序并未unInitiated，再次点击应用图标会立即调出进入后台前的界面，并尝试连网登录
		super.onStart();
		AnalyticsToolHelp.onStart();
		//
		Log.d(TAG, "call onStart");
		//

	}

	@Override
	protected void onResume() {
		Log.i(TAG, "onResume");
		super.onResume();
		AnalyticsToolHelp.onResume();
		if (weChatHave) {
			if (isShareSuccess) {
				mGameApp.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Log.e(TAG, isShareSuccess + "SUCCESS" + weChatHave);
						nativeOnShareEngineMessage(true, "ssss");
					}
				});
			} else {
				mGameApp.runOnGLThread(new Runnable() {
					@Override
					public void run() {
						Log.e(TAG, isShareSuccess + "FAILED" + weChatHave);
						nativeOnShareEngineMessage(false, "ff");
					}
				});
			}
		}
		weChatHave = false;
	}

	@Override
	protected void onPause() {
		Log.i(TAG, "onPause");
		if (videoWorldView != null && videoWorldView.isPlaying())
			stopMovie();
		super.onPause();
		AnalyticsToolHelp.onPause();
	}

	@Override
	protected void onStop() {

		super.onStop();
		AnalyticsToolHelp.onStop();

		Log.d(TAG, "call onStop");

	}

	@Override
	public boolean onKeyDown(int keyCode, KeyEvent event) {
		Log.d(TAG, "onKeyDown, keyCode: " + String.valueOf(keyCode)
				+ " getDownTime: " + String.valueOf(event.getDownTime()));

		if (keyCode == KeyEvent.KEYCODE_POWER) {
			if (event.isLongPress()) {
				Log.d(TAG, "KEYCODE_POWER isLongPress");
				if (!mIsCocos2dxSurfaceViewCreated)
					super.onLowMemory();

				return true;
			}
		} else if (keyCode == KeyEvent.KEYCODE_MENU) {

			if (mIsTempShortPause || mIsOnPause
					|| !mIsCocos2dxSurfaceViewCreated)
				return super.onKeyDown(keyCode, event);

			final long nowtime = android.os.SystemClock.elapsedRealtime();

			if ((nowtime - mLastMenuKeyDownTimeMillis) < 3000 // 3秒之内再按第2�?
					&& mRecentPressMenuKeyDownCount > 0) {

				mRecentPressMenuKeyDownCount = 0;
//				Toast.makeText(this, "正在截屏", Toast.LENGTH_SHORT).show();

				final GameActivity theActivity = this;
				//
				// if (repeatCount == 1) {
				super.runOnGLThread(new Runnable() {

					@Override
					public void run() {

						String png_file = Cocos2dxHelper.nativeGameSnapshot();
						//
						ShareInfo share = new ShareInfo();
						share.content = "#刀塔传奇2##dota#@刀塔传奇2Online";
						share.img_path = png_file;
						// share.bitmap = bmp;
						theActivity.callSystemShare(share);
					}

				});
				// }
				//
				return true;
			}

			if ((nowtime - mLastMenuKeyDownTimeMillis) < 3000)// 两次截屏之间�?�?
				return super.onKeyDown(keyCode, event);

			mLastMenuKeyDownTimeMillis = nowtime;

			if (mRecentPressMenuKeyDownCount < 1) {

//				Toast.makeText(this, "再按一次截屏分享", Toast.LENGTH_SHORT).show();
				// mLastMenuKeyDownTimeMillis -= 2500;
				mRecentPressMenuKeyDownCount++;
				//
				return super.onKeyDown(keyCode, event);
			} else {
				// Toast.makeText(this, "再按一次截屏分享", Toast.LENGTH_SHORT).show();
				return super.onKeyDown(keyCode, event);
			}
		} else if (keyCode == KeyEvent.KEYCODE_BACK) {

			if (mGameCfg.mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_91) {
				//
				if (mGameCfg.mGameInfo.use_platform_sdk_type == 0)
					super.onKeyDown(keyCode, event);
				else if (mGameCfg.mGameInfo.use_platform_sdk_type == 1) {
					if (mPlatform != null) {
						super.setOnTempShortPause(true);
						mPlatform.onGameExit();
					}
				}
				//
			} else if (mGameCfg.mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_360) {
				if (mPlatform != null) {
					super.setOnTempShortPause(true);
					mPlatform.onGameExit();
					return true;
				} else {
					super.onKeyDown(keyCode, event);
				}
			} else if (mGameCfg.mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_UC) {
				if (mPlatform != null) {
					super.setOnTempShortPause(true);
					mPlatform.onGameExit();
					return true;
				} else {
					super.onKeyDown(keyCode, event);
				}
			} else if (mGameCfg.mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_SouGou) {
				if (mPlatform != null) {
					super.setOnTempShortPause(true);
					mPlatform.onGameExit();
					return true;
				} else {
					super.onKeyDown(keyCode, event);
				}
			} else {
				super.onKeyDown(keyCode, event);
			}
			return true;
		}
		return super.onKeyDown(keyCode, event);
	}

	@Override
	public boolean onKeyLongPress(int keyCode, KeyEvent event) {
		Log.d(TAG, "onKeyLongPress, keyCode: " + String.valueOf(keyCode));

		if (mIsTempShortPause || mIsOnPause)
			return super.onKeyDown(keyCode, event);

		if (keyCode == KeyEvent.KEYCODE_MENU) {
			final GameActivity theActivity = (GameActivity) Cocos2dxActivity
					.getContext();
			//
			super.runOnGLThread(new Runnable() {

				@Override
				public void run() {
					{
						String png_file = Cocos2dxHelper.nativeGameSnapshot();
						//
						theActivity.callPlatformSupportThirdShare(
								"#刀塔传奇2##dota#@刀塔传奇2Online", png_file);
					}
				}

			});
			//
			return true;
		}

		return super.onKeyLongPress(keyCode, event);
	}

	public void callSystemShare(final ShareInfo share) {

		if (share == null)
			return;

		super.setOnTempShortPause(true);

		final GameActivity theActivity = this;

		new Thread(new Runnable() {

			@Override
			public void run() {

				// theActivity.onPause();

				// share.img_path =
				// theActivity.mAppDataExternalStorageCacheFullPath +
				// "/share.png";

				Intent intent1 = new Intent(Intent.ACTION_SEND);// 微信的单张图片分享失败，报读取资源失败，没找到解决方�?
				Intent intent = new Intent(Intent.ACTION_SEND_MULTIPLE);
				intent.setType("image/png");
				intent1.setType("image/png");
				// intent.setType("text/plain");
				intent.putExtra(Intent.EXTRA_SUBJECT, "share");
				intent.putExtra(Intent.EXTRA_TEXT, share.content);
				//
				intent1.putExtra(Intent.EXTRA_SUBJECT, "share");
				intent1.putExtra(Intent.EXTRA_TEXT, share.content);

				intent1.putExtra(Intent.EXTRA_STREAM,
						Uri.parse("file:///" + share.img_path));

				{
					ArrayList<Uri> arrayUri = new ArrayList<Uri>();
					arrayUri.add(Uri.parse("file:///" + share.img_path));

					intent.putExtra(Intent.EXTRA_STREAM, arrayUri);
				}

				intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				intent1.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				/*
				 * { ArrayList<Intent> arrayIntent = new ArrayList<Intent>();
				 * 
				 * //arrayIntent.add(intent); arrayIntent.add(intent1);
				 * 
				 * Intent intent3 =Intent.createChooser(intent, "分享");
				 * intent3.putExtra(Intent.EXTRA_INITIAL_INTENTS,
				 * arrayIntent.toArray(new Parcelable[]{}));
				 * intent3.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
				 * 
				 * Cocos2dxActivity.getContext().startActivity(intent3);
				 * 
				 * { //arrayIntent.add(intent);
				 * //Cocos2dxActivity.getContext().startActivity( //
				 * GameActivity.myCreateChooser(arrayIntent, "分享")); } }
				 */
				// Cocos2dxActivity.getContext().startActivity(
				// Intent.createChooser(intent, "分享至微�?));
				//
				Cocos2dxActivity.getContext().startActivity(
						Intent.createChooser(intent1, "share"));
				//
				Log.d("callSystemShare", "android.intent.action.SEND");

				// theActivity.onResume();
			}

		}).start();
	}

	@Override
	public boolean getPlatformLoginStatus() {

		if (mPlatform == null)
			return false;
		//
		// return true;//for testin
		//
		LoginInfo login_info = mPlatform.getLoginInfo();
		if (login_info == null)
			return false;

		if (login_info.login_result == PlatformAndGameInfo.enLoginResult_Success)
			return true;
		else
			return false;
	}

	@Override
	public String getPlatformLoginUin() {

		if (mPlatform == null) {
			return DeviceUtil.getDeviceUUID(this);
		}

		LoginInfo login_info = mPlatform.getLoginInfo();
		if (login_info == null) {
			return DeviceUtil.getDeviceUUID(this);
		}

		return login_info.account_uid_str;
	}

	@Override
	public String getPlatformLoginSessionId() {

		if (mPlatform == null) {
			return DeviceUtil.generateUUID();
		}

		LoginInfo login_info = mPlatform.getLoginInfo();
		if (login_info == null) {
			return DeviceUtil.generateUUID();
		}

		return login_info.login_session;
	}

	@Override
	public String getPlatformUserNickName() {

		if (mPlatform == null) {
			return DeviceUtil.getDeviceProductName(this);
		}

		LoginInfo login_info = mPlatform.getLoginInfo();
		if (login_info == null) {
			return DeviceUtil.getDeviceProductName(this);
		}

		return login_info.account_nick_name;
	}

	@Override
	public String generateNewOrderSerial() {

		return mPlatform.generateNewOrderSerial();
	}

	@Override
	public void openUrlOutside(String url) {

		if (url.isEmpty())
			return;
		//
		if (url.endsWith(".apk")) {
			updateApk = new DownloadApk(getActivity(), url);
		} else {
			super.openUrlOutside(url);
		}
	}

	@Override
	public void onTimeToShowCocos2dxContentView() {
		mGameContextStateHandler.sendEmptyMessageDelayed(
				Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ShowCocos2dx, 100);
	}

	@Override
	public GameActivity getActivity() {

		return this;
	}

	@Override
	public IPlatformLoginAndPay getPlatformSDK() {

		return mPlatform;
	}

	@Override
	public void initAppDataPath(String fullPath) {

		mAppDataExternalStorageFullPath = fullPath;
		mAppDataExternalStorageResourcesFullPath = mAppDataExternalStorageFullPath
				+ "/Assets";
		mAppDataExternalStorageCacheFullPath = mAppDataExternalStorageFullPath
				+ "/Cache";
		//

		// xiaomi
		// 2S上getExternalCacheDir指向/storage/sdcard0/Android/data/PackageName/cache
		//
		File tempDir = new File(mAppDataExternalStorageFullPath);
		if (!tempDir.exists())
			tempDir.mkdirs();
		//
		if (!tempDir.exists())
			Log.e(TAG,
					"mAppDataExternalStorageFullPath: "
							+ tempDir.getAbsolutePath() + " is not OK!");
		else
			Log.d(TAG,
					"mAppDataExternalStorageFullPath: "
							+ tempDir.getAbsolutePath());

		//
		tempDir = null;
		//
		tempDir = new File(mAppDataExternalStorageCacheFullPath);
		if (!tempDir.exists())
			tempDir.mkdirs();
		//
		if (!tempDir.exists())
			Log.e(TAG,
					"AppDataExternalStorageCacheFullPath: "
							+ tempDir.getAbsolutePath() + " is not OK!");
		else
			Log.d(TAG,
					"AppDataExternalStorageCacheFullPath: "
							+ tempDir.getAbsolutePath());
		//
		tempDir = null;
		//
		tempDir = new File(mAppDataExternalStorageResourcesFullPath);
		if (!tempDir.exists())
			tempDir.mkdirs();
		//
		if (!tempDir.exists())
			Log.e(TAG,
					"AppDataExternalStorageResourcesFullPath: "
							+ tempDir.getAbsolutePath() + " is not OK!");
		else
			Log.d(TAG,
					"AppDataExternalStorageResourcesFullPath: "
							+ tempDir.getAbsolutePath());
		//
		tempDir = null;
		//
	}

	@Override
	public String getAppFilesRootPath() {
		return this.mAppDataExternalStorageFullPath;
	}

	@Override
	public String getAppFilesResourcesPath() {
		return this.mAppDataExternalStorageResourcesFullPath;
	}

	@Override
	public String getAppFilesCachePath() {
		return this.mAppDataExternalStorageCacheFullPath;
	}

	@Override
	public void requestDestroy() {
		/*
		 * 去onDestroy干了其他destroy事情
		 */
		this.destroy();
	}

	@Override
	public GameInfo getGameInfo() {

		return mGameCfg.mGameInfo;
	}

	@Override
	public void initPlatformSDK(IPlatformLoginAndPay platform) {

		mPlatform = platform;
	}

	@Override
	public void notifyInitPlatformSDKComplete() {
		Log.d(TAG, "notifyInitPlatformSDKComplete");
	}

	@Override
	public void notifyVersionCheckResult(VersionInfo versionInfo) {
		Log.d(TAG, "notifyVersionCheckResult");

		if (mHaveEnteredGameAppState) {
			if (versionInfo.update_info == PlatformAndGameInfo.enUpdateInfo_No) {
				Cocos2dxHelper.nativeNotifyPlatformGameUpdateResult(
						versionInfo.update_info, versionInfo.max_version_code,
						versionInfo.local_version_code,
						versionInfo.download_url);
			} else if (versionInfo.update_info == PlatformAndGameInfo.enUpdateInfo_Suggest) {
				Cocos2dxHelper.nativeNotifyPlatformGameUpdateResult(
						versionInfo.update_info, versionInfo.max_version_code,
						versionInfo.local_version_code,
						versionInfo.download_url);
			} else if (versionInfo.update_info == PlatformAndGameInfo.enUpdateInfo_Force) {
				Log.w(TAG, "notifyVersionCheckResult: enUpdateInfo_Force");

				showWaitingView(true, -1,
						"Need to enforce version update, please download the new version ");
			}
		} else {
			/*
			 * 等进入GameAppState再处�?
			 */
			mVersionResult = versionInfo;
		}
	}

	@Override
	public void initCocos2dxAndroidContext(View glView, View editText,
			Handler handler) {

		mGameContextStateHandler = handler;
		super.initAndroidContext(glView, editText);
	}

	@Override
	public Handler getMainHandler() {

		return super.getMainThreadHandler();
	}

	/*
	 * 总有�?��特殊处理! 正常情况�?显示平台登录界面�?Cocos2dx被onPause�?
	 * 360的登录框背景透明,挡不住处于不渲染状�?的Cocos2dxGLSurfaceView,�?��特殊处理让其不onPause
	 */
	@Override
	public void callPlatformLogin() {
		super.callPlatformLogin();

		if (mPlatform.getGameInfo().platform_type == PlatformAndGameInfo.enPlatform_RenRen) {
			super.mIsRenderCocos2dxView = false;
		}

	}

	@Override
	public void notifyEnterGameAppState(Handler handler) {
		Log.d(TAG, "notifyEnterGameAppState");

		mHaveEnteredGameAppState = true;
		if (mVersionResult != null) {
			notifyVersionCheckResult(mVersionResult);
			mVersionResult = null;
		}

		super.setGameAppStateHandler(handler);

	}

	@Override
	public void notifyOnTempShortPause() {

		super.setOnTempShortPause(true);
	}

	@Override
	public void notifyLoginResut(LoginInfo result) {
		Log.d(TAG, "notifyLoginResut");

		super.setOnTempShortPause(false);

		/*
		 * 平台账号登录成功�?允许玩家进入游戏
		 */
		Cocos2dxHelper.nativeNotifyPlatformLoginResult(
				PlatformAndGameInfo.enLoginResult_Success,
				String.valueOf(result.account_uid), result.login_session,
				result.account_nick_name);
	}

	@Override
	public void notifyPayRechargeResult(PayInfo result) {
		Log.d(TAG, "notifyPayRechargeResult");
		// super.setOnTempShortPause(false);

		/*
		 * 订单参数正确,result.result�?标示提交成功
		 */
		// 通知进去没用，最多提示下“正在打开平台充值页面”
		Cocos2dxHelper.nativeNotifyPlatformPayResult(result.result,
				result.order_serial, result.product_id, result.product_name,
				result.price, result.orignal_price, result.count,
				result.description);

	}

	@Override
	public void showWaitingViewImp(boolean show, int progress, String text) {
		super.showWaitingView(show, progress, text);
	}

	@Override
	public String getDeviceID() {
		return DeviceUtil.getDeviceUUID(this);
	}

	@Override
	public String getPlatformInfo() {
		if (mPlatform != null) {
			String temp = Build.MANUFACTURER + Build.MODEL;
			temp = temp.replaceAll(" ", "-");
			String ret = temp + "#" + Build.VERSION.SDK_INT;
			// ret = ret + "_" + mPlatform.getGameInfo().platform_type_str;
			ret = ret + "#sSystemName#Android";
			return ret;
		}

		return "splatform#sSystemVersion#sSystemName#Android";
	}

	@Override
	public String getDeviceInfo() {
		// TODO Auto-generated method stub
		String deviceRAM = DeviceUtil.getTotalMemory(mContext); // RAM大小
		int cpuNumCores = DeviceUtil.getNumCores(); // 核数
		String maxCpuFreq = DeviceUtil.getMaxCpuFreq(); // cpu最大频率

		if (deviceRAM == null || deviceRAM.length() <= 0 || maxCpuFreq == null
				|| maxCpuFreq.length() <= 0) {
			return "";
		}
		double maxCpuFreqDouble = Double.parseDouble(maxCpuFreq) / 1048576;
		return cpuNumCores + "#" + maxCpuFreqDouble + "#" + deviceRAM;// "deviceRAM#cpuCores#maxCpuFreq";
	}

	@Override
	public String getClientChannel() {

		if (mPlatform != null) {

			return mPlatform.getGameInfo().platform_type_str /*
															 * + "#" +
															 * mPlatform.
															 * getGameInfo().
															 * platform_channel_str
															 */;
		}

		return "Android_Store";// #sChannelID
	}

	@Override
	public void notifyEnterGame() {

	}

	@Override
	public void showToastMsg(String str) {

		Message msg = new Message();
		msg.obj = str;
		msg.what = Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ShowToastMsg;

		super.getMainThreadHandler().sendMessage(msg);
	}

	@Override
	public void showToastMsgImp(String msg) {
		Toast.makeText(this, msg, Toast.LENGTH_SHORT * 5).show();
	}

	@Override
	public int getPlatformId() {
		// TODO Auto-generated method stub
		if (mPlatform != null) {
			return mPlatform.getGameInfo().platform_type;
		}
		return 0;
	}

	public static void stopMovieClick() {
		buttonStopMovie.setVisibility(View.INVISIBLE);
		discipleCardStopMovie.setVisibility(View.INVISIBLE);
		mGameApp.mGLSurfaceView.setVisibility(View.VISIBLE);
		videoWorldView.stopPlayback();
		mGameApp.mGLSurfaceView.queueEvent(new Runnable() {
			@Override
			public void run() {
				nativeOnPlayMovieEnd();
			}
		});
		videoWorldView.setVisibility(View.INVISIBLE);

	}

	public static void stopMovie() {

		buttonStopMovie.setVisibility(View.INVISIBLE);
		discipleCardStopMovie.setVisibility(View.INVISIBLE);
		mGameApp.mGLSurfaceView.setVisibility(View.VISIBLE);
		videoWorldView.stopPlayback();
		mGameApp.mGLSurfaceView.queueEvent(new Runnable() {
			@Override
			public void run() {
				nativeOnPlayMovieEnd();
			}
		});
		videoWorldView.setVisibility(View.INVISIBLE);
	}

	public static int getSecondsFromGMT() {
		return TimeZone.getDefault().getRawOffset() / 1000;
	}

	public static void playMovie(final String fileName, final int needSkip) {
		nativeOnPlayMovieEnd();
		/*
		 * mGameApp.getMainHandler().post(new Runnable() {
		 * 
		 * @Override public void run() { Log.i(TAG, fileName); Log.i(TAG,
		 * needSkip+"");
		 * 
		 * videoWorldView =
		 * (WorldVideoView)mGameApp.findViewById(R.id.worldvideoview); //
		 * if(videoWorldView==null){ // String uri = "android.resource://" +
		 * mGameApp.getPackageName()+ "/" + R.raw.movie; //
		 * videoWorldView.setVideoURI(Uri.parse(uri)); // }
		 * 
		 * buttonStopMovie = (ImageButton)
		 * mGameApp.findViewById(R.id.buttonstopmovie); discipleCardStopMovie =
		 * (ImageButton) mGameApp.findViewById(R.id.disciplestopmovie); //
		 * if(!fileName.equals("tutorial")){
		 * videoWorldView.setVideoURI(Uri.parse
		 * (mGameApp.mAppDataExternalStorageResourcesFullPath
		 * +"/movie/"+fileName+".mp4")); // }
		 * videoWorldView.setVisibility(View.VISIBLE);
		 * videoWorldView.setOnCompletionListener(mGameApp);
		 * videoWorldView.setOnErrorListener(new OnErrorListener() {
		 * 
		 * @Override public boolean onError(MediaPlayer mp, int what, int extra)
		 * { stopMovieClick(); return true; } });
		 * 
		 * if (needSkip == 1) {
		 * discipleCardStopMovie.setVisibility(View.VISIBLE);
		 * discipleCardStopMovie.setOnClickListener(new OnClickListener() {
		 * 
		 * @Override public void onClick(View v) { stopMovieClick(); } }); }
		 * 
		 * if(needSkip == 2) { buttonStopMovie.setVisibility(View.VISIBLE);
		 * buttonStopMovie.setOnClickListener(new OnClickListener() {
		 * 
		 * @Override public void onClick(View v) { stopMovieClick(); } }); }
		 * 
		 * videoWorldView.start();
		 * mGameApp.mGLSurfaceView.setVisibility(View.INVISIBLE); } });
		 */
		mGameApp.getMainHandler().postDelayed(new Runnable() {

			@Override
			public void run() {
				if (!videoWorldView.isPlaying())
					stopMovieClick();
			}
		}, 2000);

	}

	/**
	 * 分享給朋友 文字
	 * 
	 * @shareStr 分享文字
	 */
	private static void shareToPerson(String shareContent) {
		if (!GameActivityHelper.isInstallWeChat(mContext, mHandler)) {
			GameActivityHelper.noWeChatDialog(mContext, mHandler);
			return;
		}
		if (null == api)
			return;
		WXTextObject textObj = new WXTextObject();
		textObj.text = shareContent;
		WXMediaMessage msg = new WXMediaMessage();
		msg.mediaObject = textObj;
		msg.description = shareContent;
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = String.valueOf(System.currentTimeMillis());
		req.message = msg;
		req.scene = SendMessageToWX.Req.WXSceneSession;
		;
		api.sendReq(req);
	}

	/** 分享給朋友 图片 */
	private static void shareToPerson(String shareImgPath, String shareContent) {
		if (null == api)
			return;
		if (!GameActivityHelper.isInstallWeChat(mContext, mHandler)) {
			GameActivityHelper.noWeChatDialog(mContext, mHandler);
			return;
		}
		Log.e(TAG, "============>" + shareImgPath);
		final int THUMB_SIZE = 100;// 缩略图
		WXImageObject imgObj = new WXImageObject();
		imgObj.setImagePath(shareImgPath);
		WXMediaMessage msg = new WXMediaMessage();

		msg.mediaObject = imgObj;
		msg.description = shareContent;
		msg.title = "test title";
		Bitmap bmp = BitmapFactory.decodeFile(shareImgPath);
		Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE,
				THUMB_SIZE, true);
		bmp.recycle();
		msg.thumbData = WXUtil.bmpToByteArray(thumbBmp, true);
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = String.valueOf(System.currentTimeMillis());
		req.message = msg;
		req.scene = SendMessageToWX.Req.WXSceneSession;
		;
		api.sendReq(req);

	}

	/** 分享给朋友圈 图片 */
	public static void shareToFriends(String shareImgPath, String shareContent) {
		if (!GameActivityHelper.isInstallWeChat(mContext, mHandler)) {
			GameActivityHelper.noWeChatDialog(mContext, mHandler);
			return;
		}
		if (null == api)
			return;
		Log.e(TAG, "============>" + shareImgPath);
		final int THUMB_SIZE = 100;// 缩略图
		WXImageObject imgObj = new WXImageObject();
		imgObj.setImagePath(shareImgPath);
		WXMediaMessage msg = new WXMediaMessage();
		msg.mediaObject = imgObj;
		msg.description = shareContent;
		msg.title = "test title";
		Bitmap bmp = BitmapFactory.decodeFile(shareImgPath);
		Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, THUMB_SIZE,
				THUMB_SIZE, true);
		bmp.recycle();
		msg.thumbData = WXUtil.bmpToByteArray(thumbBmp, true);
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = String.valueOf(System.currentTimeMillis());
		req.message = msg;
		req.scene = SendMessageToWX.Req.WXSceneTimeline;
		;
		api.sendReq(req);
	}

	/** 分享给朋友圈 文字 */
	public static void shareToFriends(final String shareContent) {

		if (!GameActivityHelper.isInstallWeChat(mContext, mHandler)) {
			GameActivityHelper.noWeChatDialog(mContext, mHandler);
			return;
		}
		if (null == api)
			return;
		WXTextObject textObj = new WXTextObject();
		textObj.text = shareContent;
		WXMediaMessage msg = new WXMediaMessage();
		msg.mediaObject = textObj;
		msg.description = shareContent;
		SendMessageToWX.Req req = new SendMessageToWX.Req();
		req.transaction = String.valueOf(System.currentTimeMillis());
		req.message = msg;
		req.scene = SendMessageToWX.Req.WXSceneTimeline;
		api.sendReq(req);
	}

	public void fbAttention() {

//		Log.i(TAG, "去关注吧骚年");
		mHandler.post(new Runnable() {
			
			@Override
			public void run() {
				Uri uri = Uri.parse("http://www.facebook.com/we4dota");
				Intent intent = new Intent(Intent.ACTION_VIEW, uri);
				mContext.startActivity(intent);
			}
		});
		
	}

	/**
	 * 推送广告通知到安卓的通知消息 pTitle 标题 msg 消息内容 pInstantMinite 延迟分钟
	 * */
	@Override
	public void pushSysNotification(final String pTitle, final String msg,
			final int pInstantMinite) {

		final String strTitle = getString(R.string.app_name);
		boolean switcher = false;
		// if (!isWorked()) {
		// startService(new Intent(GameActivity.this,
		// NotificationService.class));
		Intent i = new Intent(GameActivity.this, NotificationService.class);
		i.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
		startService(i);

		Runnable pushRunable = new Runnable() {
			@Override
			public void run() {
				Intent myIntent = new Intent();// 创建Intent对象
				myIntent.setAction("com.nuclear.dota.notificationservice");
				myIntent.putExtra("message", msg);
				myIntent.putExtra("title", strTitle);
				myIntent.putExtra("delayminite", pInstantMinite);
				sendBroadcast(myIntent);// 发送广播
				Log.i("GameActivity", "pushSysNotification");
			}
		};
		getMainHandler().post(pushRunable);
		/*
		 * }else { Intent myIntent = new Intent();// 创建Intent对象
		 * myIntent.setAction("com.nuclear.dota.notificationservice");
		 * myIntent.putExtra("message", msg); myIntent.putExtra("title",
		 * strTitle); myIntent.putExtra("delayminite", pInstantMinite);
		 * sendBroadcast(myIntent);// 发送广播 Log.i("GameActivity",
		 * "pushSysNotification"); }
		 */
		/*
		 * Timer timer = new Timer(); timer.schedule(new NotificationTask(msg,
		 * pTitle),new Date());
		 */
	}

	/** service是否已经启动 */
	public boolean isWorked() {
		ActivityManager myManager = (ActivityManager) GameActivity.this
				.getSystemService(Context.ACTIVITY_SERVICE);
		ArrayList<RunningServiceInfo> runningService = (ArrayList<RunningServiceInfo>) myManager
				.getRunningServices(Integer.MAX_VALUE);
		for (int i = 0; i < runningService.size(); i++) {
			if (runningService.get(i).service.getClassName().toString()
					.equals("com.nuclear.dota.notificationservice")) {
				return true;
			}
		}
		return false;
	}

	/**
	 * 推送广告通知到安卓的通知消息 pAnnounceUrl 显示公告地址
	 * */
	@Override
	public void ShowAnnounce(final String pAnnounceUrl) {
		// Runnable dialogRun = new Runnable() {
		// @Override
		// public void run() {
		// GameAnnounceDialog dialog = new GameAnnounceDialog(
		// getActivity(), pAnnounceUrl);
		//
		// }
		// };
		// getMainHandler().post(dialogRun);

	}

	@Override
	public void clearSysNotification() {
		Log.i("GameActivity", "clearSysNotification");
		// if (!isWorked()) {
		startService(new Intent(GameActivity.this, NotificationService.class));

		Runnable pushRunable = new Runnable() {
			@Override
			public void run() {
				Intent myIntent = new Intent();// 创建Intent对象
				myIntent.setAction("com.nuclear.dota.notificationservice");
				myIntent.putExtra("clear", true);
				sendBroadcast(myIntent);// 发送广播
			}
		};
		getMainHandler().post(pushRunable);
		/*
		 * } else { Intent myIntent = new Intent();// 创建Intent对象
		 * myIntent.setAction("com.nuclear.dota.notificationservice");
		 * myIntent.putExtra("clear", true); sendBroadcast(myIntent);// 发送广播 }
		 */
	}

	/*
	 * 
	 * */
	@Override
	public void requestBindTryToOkUser(String tryUin, String okUin) {
		GameActivity.nativeRequestGameSvrBindTryToOkUser(tryUin, okUin);
	}

	/*
	 * 
	 * */
	public static boolean isPlatformTryUser() {
		return mGameApp.getPlatformSDK().isTryUser();
	}

	/*
	 * 
	 * */
	public static void callPlatformBindUser() {
		mGameApp.getPlatformSDK().callBindTryToOkUser();
	}

	@Override
	public void onCompletion(MediaPlayer mp) {
		Log.i(TAG, "nativeOnPlayMovieEnd");
		buttonStopMovie.setVisibility(View.INVISIBLE);
		mGameApp.mGLSurfaceView.setVisibility(View.VISIBLE);
		videoWorldView.stopPlayback();
		mGameApp.mGLSurfaceView.queueEvent(new Runnable() {

			@Override
			public void run() {
				nativeOnPlayMovieEnd();
			}
		});
		videoWorldView.setVisibility(View.INVISIBLE);
	}

	/*
	 * 
	 * */
	public static native void nativeRequestGameSvrBindTryToOkUser(
			String tryUser, String okUser);

	/*
	 * 
	 * */
	public static void receiveGameSvrBindTryToOkUserResult(int result) {
		mGameApp.getPlatformSDK().receiveGameSvrBindTryToOkUserResult(result);
	}

	@Override
	public void notifyTryUserRegistSuccess() {
		GameActivity.nativeNotifyTryUserRegistSuccess();
	}

	/*
	 * */
	public static native void nativeNotifyTryUserRegistSuccess();

	public static native void nativeOnShareEngineMessage(boolean _result,
			String _resultStr);

	public static native void nativeOnPlayMovieEnd();

	public static native void nativeOnMotionShake();

	public static native void nativeOnAndroidDeviceMessage(
			String _deviceIdMessage, String _deviceNameMessage);

}