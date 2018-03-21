package com.nuclear.dota;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.Properties;

import org.apache.http.util.EncodingUtils;
import org.json.JSONException;
import org.json.JSONObject;
import org.json.JSONTokener;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.content.res.AssetManager;
import android.net.ConnectivityManager;
import android.net.NetworkInfo;
import android.os.Environment;
import android.os.Handler;
import android.os.Message;
import android.text.TextPaint;
import android.util.Log;
import android.view.View;
import android.view.WindowManager;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.nuclear.IGameActivity;
import com.nuclear.IGameActivityState;
import com.nuclear.IStateManager;
import com.nuclear.StorageUtil;
import com.nuclear.ZipObbUtil;
import com.nuclear.dota.GameInterface.IGameLogoStateCallback;
import com.qsds.ggg.dfgdfg.fvfvf.R;

public class GameLogoState implements IGameActivityState {

	public static final String TAG = GameLogoState.class.getSimpleName();

	@Override
	public void enter() {
		Log.d(TAG, "enter GameLogoState");
		/*
		 * 
		 * */
		mGameActivity.getActivity().setContentView(R.layout.logo_layout);
		mAssetsUnzipProgressBar = (ProgressBar) mGameActivity.getActivity()
				.findViewById(R.id.assetsUnzipProgress);
		mAssetsUnzipProgressBar.setVisibility(View.INVISIBLE);

		mHandler = new GameLogoStateHandler();
		mHandler.sendEmptyMessageDelayed(
				HANDLER_MSG_TO_MAINTHREAD_DoEnterDelay, 100);

	}

	private void doEnter() {
		Log.d(TAG, "doEnter GameLogoState");

		mAssetsUnzipTextView = (TextView) mGameActivity.getActivity()
				.findViewById(R.id.assets_unzip_textView);
		TextPaint tp = mAssetsUnzipTextView.getPaint();
		tp.setFakeBoldText(true);

		checkNetworkStatus();
		checkStorageStatus();
		if (mExternalStorageOK == false) {
			DialogMessage dlgmsg = new DialogMessage(mGameActivity
					.getActivity().getResources()
					.getString(R.string.app_dlg_title), mGameActivity
					.getActivity().getResources()
					.getString(R.string.app_dlg_externalstorage_notok_msg),
					HANDLER_MSG_TO_MAINTHREAD_ExternalStorageNotOK);

			showDialog(dlgmsg);
			return;
		} else if (mExternalStorageEnough == false) {
			DialogMessage dlgmsg = new DialogMessage(
					mGameActivity.getActivity().getResources()
							.getString(R.string.app_dlg_title),
					mGameActivity
							.getActivity()
							.getResources()
							.getString(
									R.string.app_dlg_externalstorage_nofreespace_msg),
					HANDLER_MSG_TO_MAINTHREAD_ExternalStorageNotOK);

			showDialog(dlgmsg);
			return;
		}
		//
		LastLoginHelp.setActivity(GameActivity.mGameApp);
		// AnalyticsToolHelp.onCreate(GameActivity.mGameApp,
		// GameActivity.mGameApp.getGameInfo());//call at here,it's not ok
		//
		if (mUnzipedAssets == false
				|| checkExternalStorageResourcesStatus() == false) {
			if (mUnzipedAssets == false) {

				saveConfigFileFirstTime();// 需要的，创建config.properties文件
				//
				mAssetsUnzipTextView.setText(mGameActivity.getActivity()
						.getResources().getString(R.string.unzipwait));
				// TODO 正式打包用requestUnzipAssetToExternalStorageResources
				Log.i(TAG, "解压资源");
				requestUnzipAssetToExternalStorageResources();
				unzipObb();
				ZipObbUtil.getInstance().expantionFile(mGameActivity.getActivity());
				//
				// makeSureUnzipMusicSoundFiles();
				/*
				 * { Message msg = new Message(); msg.obj = new
				 * ProgressMessage(100, ", starting game"); msg.what =
				 * HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress;
				 * mHandler.sendMessageDelayed(msg, 2000); }
				 */
			} else {
				mAssetsUnzipTextView.setText(mGameActivity.getActivity()
						.getResources().getString(R.string.clearold));
				//
				Log.i(TAG, "清出本地资源。。。。");
				removeExistDirtyFileDirectory();
				//
			}
		} else {
			makeSureUnzipMusicSoundFiles();

			if (mNetworkOK) {
				mHandler.sendEmptyMessageDelayed(
						HANDLER_MSG_TO_MAINTHREAD_ShowLogoViewDelay, 10);
			} else {
				DialogMessage dlgmsg = new DialogMessage(mGameActivity
						.getActivity().getResources()
						.getString(R.string.app_dlg_title), mGameActivity
						.getActivity().getResources()
						.getString(R.string.app_dlg_newwork_notok_msg),
						HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK);

				showDialog(dlgmsg);
			}
		}
		//
	}

	@Override
	public void exit() {
		// ---dai
		if (mAssetsUnzipProgressBar != null) {
			mAssetsUnzipProgressBar.setVisibility(View.INVISIBLE);
			mAssetsUnzipTextView.setVisibility(View.INVISIBLE);
		}

		mAssetsUnzipProgressBar = null;
		mAssetsUnzipTextView = null;
		// --end
		mStateMgr = null;
		mGameActivity = null;
		mCallback = null;

		mHandler.removeMessages(HANDLER_MSG_TO_MAINTHREAD_ShowLogoViewDelay);
		mHandler.removeMessages(HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress);
		mHandler.removeMessages(HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK);

		mHandler = null;

		Log.d(TAG, "exit GameLogoState");
	}

	/*
	 * 
	 * */
	public GameLogoState(IStateManager pStateMgr, IGameActivity pGameActivity,
			IGameLogoStateCallback pCallback) {
		mStateMgr = pStateMgr;
		mGameActivity = pGameActivity;
		mCallback = pCallback;
	}

	/*
	 * 
	 * */
	private void removeExistDirtyFileDirectory() {
		Log.d(TAG, "removeExistDirtyFileDirectory");
		//
		new Thread("RemoveExistDirtyFileDirectoryThread") {

			@Override
			public void run() {
				File rootfiles = new File(
						mGameActivity.getAppFilesResourcesPath());
				Log.i(TAG,"PATH:"+mGameActivity.getAppFilesResourcesPath());
				StorageUtil.removeFileDirectory(rootfiles);
				rootfiles = null;

				try {
					Thread.sleep(500);
				} catch (InterruptedException e) {

					e.printStackTrace();
				}

				System.gc();
				//
				SharedPreferences sp = mGameActivity.getActivity()
						.getSharedPreferences("ResourcesInfo",
								Context.MODE_PRIVATE);
				//
				Editor edit = sp.edit();
				edit.putBoolean("UnzipedAssets", false);
				edit.apply();
				//
				mUnzipedAssets = false;
				//
				Editor edit1 = sp.edit();
				edit1.putString("StorageFullPath", "");
				edit1.apply();
				//
				checkStorageStatus();
				//
				mCallback.initAppDataPath(mAppFilesPath);
				//
				saveConfigFileFirstTime();// 需要的，创建config.properties文件
				//
				mHandler.sendEmptyMessageDelayed(
						HANDLER_MSG_TO_MAINTHREAD_DeleteDirtyFileDirectoryDelay,
						500);
			}

		}.start();
		//
	}

	/*
	 * 
	 * */
	private void checkStorageStatus() {
		String exStorageState = Environment.getExternalStorageState();
		Log.w(TAG, "Environment.getExternalStorageState():" + exStorageState);
		if (!exStorageState.equals(Environment.MEDIA_MOUNTED)
				&& !exStorageState.equals(Environment.MEDIA_SHARED)) {
			mExternalStorageOK = false;
			return;
		}
		/*
		 * 
		 * */
		SharedPreferences sp = mGameActivity.getActivity()
				.getSharedPreferences("ResourcesInfo", Context.MODE_PRIVATE);
		String spath = sp.getString("StorageFullPath", "");
		File dir = new File(spath);
		boolean unziped = sp.getBoolean("UnzipedAssets", false);
		if (unziped == false) {
			if (!spath.equals("") && dir.exists()) {
				StorageUtil.removeFileDirectory(dir);
				System.gc();
			}
			spath = "";
		} else {
			if (dir.exists() == false || dir.isDirectory() == false) {
				spath = "";

				Editor edit = sp.edit();
				edit.putBoolean("UnzipedAssets", false);
				edit.apply();

				unziped = false;

				if (dir.exists())
					dir.delete();
			}
		}
		//
		dir = null;
		//
		if (spath.equals("")) {
			String appFilesPath = null;
			File appFilesDir = mGameActivity.getActivity().getFilesDir();

			if (Environment.getExternalStorageState().equalsIgnoreCase(
					Environment.MEDIA_MOUNTED)) {
				File externalStorageDir = Environment
						.getExternalStorageDirectory();
				if (!externalStorageDir.canRead()
						|| !externalStorageDir.canWrite()
						|| externalStorageDir.getUsableSpace() < 200 * 1024 * 1024) {
					String secondPath = StorageUtil
							.getSecondStorageWithFreeSize(250 * 1024 * 1024);
					if (secondPath != null) {
						appFilesPath = secondPath;
					} else {
						secondPath = StorageUtil
								.getSecondStorageWithFreeSize(externalStorageDir
										.getUsableSpace() * 2);
						if (secondPath != null) {
							appFilesPath = secondPath;
						} else {
							appFilesPath = externalStorageDir.getAbsolutePath();
						}

						File dir1 = new File(appFilesPath);
						if (dir1.getUsableSpace() < 10 * 1024 * 1024) {
							appFilesPath = appFilesDir.getAbsolutePath();
							mExternalStorageEnough = false;
							return;
						}
					}
				} else {
					appFilesPath = externalStorageDir.getAbsolutePath();
				}
			} else {
				appFilesPath = appFilesDir.getAbsolutePath();
				mExternalStorageOK = false;// 内更新目录不能放在内部存储，Android读写内部存储目录的私有文件，需要Android权限API，java/c/c++裸api均不可靠
				return;
			}

			if (appFilesPath.equalsIgnoreCase(appFilesDir.getAbsolutePath()) == false) {
				File file1 = new File(appFilesPath + "/Android/Data");
				File file2 = new File(appFilesPath + "/Android/data");
				if (file1.exists() && file2.exists()) {
					spath = appFilesPath + "/Android/data/"
							+ mGameActivity.getActivity().getPackageName()
							+ "/files";
				} else if (file1.exists() && !file2.exists()) {
					spath = appFilesPath + "/Android/Data/"
							+ mGameActivity.getActivity().getPackageName()
							+ "/files";
				} else if (!file1.exists() && file2.exists()) {
					spath = appFilesPath + "/Android/data/"
							+ mGameActivity.getActivity().getPackageName()
							+ "/files";
				} else {
					spath = appFilesPath + "/Android/data/"
							+ mGameActivity.getActivity().getPackageName()
							+ "/files";
				}

			} else {
				spath = appFilesPath;
			}

			Editor edit = sp.edit();
			edit.putString("StorageFullPath", spath);
			edit.apply();
		}
		//
		if (unziped == false) {
			// mAssetsUnzipTextView.setText("清除本地旧目录，请稍后");
			//
			File dir2 = new File(spath + "/config.properties");
			if (dir2.exists()) {
				dir2.delete();
				unziped = true;
				// 触发清除本地旧目录，再重新解压
			}
			dir2 = null;

			// System.gc();
		}
		//
		mCallback.initAppDataPath(spath);

		mAppFilesPath = spath;
		mUnzipedAssets = unziped;
	}

	/*
	 * */
	private void requestUnzipAssetToExternalStorageResources() {
		Log.d(TAG, "requestUnzipAssetToExternalStorageResources");
		//
		final String appFilesResourcesPath = mGameActivity
				.getAppFilesResourcesPath();
		{
			/*
			 * 存储空间不足，维持不解压缩玩
			 */
			File dir = new File(appFilesResourcesPath);
			if (dir.getUsableSpace() < 100 * 1024 * 1024) {
				Log.d(TAG, "not enough usable storage space");

				makeSureUnzipMusicSoundFiles();

				{
					Message msg = new Message();
					msg.obj = new ProgressMessage(100, ", starting game");
					msg.what = HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress;
					mHandler.sendMessageDelayed(msg, 2000);
				}

				dir = null;
				return;
			}
			dir = null;
		}
		//
		final Activity theActivity = mGameActivity.getActivity();
		final Handler theHandler = mHandler;// another realize to use
											// HandlerThread
		// final View theProgress = mAssetsUnzipProgressBar;
		//
		new Thread("MoveAssetToExternalStorageThread") {

			//
			private ArrayList<String> resFilesPath = new ArrayList<String>();

			//
			private int recursionSumAssetsFileNum(String path) {
				int num = 0;
				try {
					AssetManager assetMgr = theActivity.getAssets();
					String[] assets = assetMgr.list(path);
					//
					for (String filepath : assets) {
						if (filepath.isEmpty())
							continue;
						//
						if (!path.isEmpty())
							filepath = path + "/" + filepath;

						// 加密资源所用解压
//						String str2 = filepath.substring(filepath.length() - 6,
//								filepath.length());
						//if ("_files".equals(str2)) { //
						if (filepath.length() == 12) { //
							Log.e("GameLogoState 1", filepath);
							num += recursionSumAssetsFileNum(filepath);
							File temp = new File(appFilesResourcesPath + "/"
									+ filepath);
							if (!temp.exists())
								temp.mkdirs(); // temp = null;
							Message msg = new Message();
							msg.obj = new ProgressMessage(0, "please wait...");
							msg.what = HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResText;
							theHandler.sendMessage(msg);
						} else { //
							Log.e("GameLogoState 2", filepath);
							num++;
							resFilesPath.add(filepath);
						}

						// //////////////////不加密资源需要用/////////////////////////
	/*					int idx = filepath.lastIndexOf('/');
						int idy = filepath.lastIndexOf('.');
						if (idx == -1 && idy == -1) {
							num += recursionSumAssetsFileNum(filepath);
							File temp = new File(appFilesResourcesPath + "/"
									+ filepath);
							if (!temp.exists())
								temp.mkdirs();
							// temp = null;
							Message msg = new Message();
							msg.obj = new ProgressMessage(0,
									"Extracting resources, without flow, please wait..");
							msg.what = HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResText;
							theHandler.sendMessage(msg);
						} else if (idx > 0 && idy > idx) {
							num++;
							resFilesPath.add(filepath);
						} else if (idx == -1 && idy > 0) {
							num++;
							resFilesPath.add(filepath);
						} else if (idx > 0 && idy < idx) {
							num += recursionSumAssetsFileNum(filepath);
							File temp = new File(appFilesResourcesPath + "/"
									+ filepath);
							if (!temp.exists())
								temp.mkdirs();
							// temp = null;
							Message msg = new Message();
							msg.obj = new ProgressMessage(0,
									"Extracting resources, without flow, please wait....");
							msg.what = HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResText;
							theHandler.sendMessage(msg);
						} */
					}
					//
				} catch (IOException e) {

				} finally {

				}
				return num;
			}

			private int recursionSumAssetsFileNumByFileList(String path) {
				Message msg = new Message();
				msg.obj = new ProgressMessage(0, mGameActivity.getActivity()
						.getResources().getString(R.string.unzipwait));
				msg.what = HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResText;
				theHandler.sendMessage(msg);
				String result = "";
				AssetManager assetMgr = theActivity.getAssets();
				try {
					InputStream is = assetMgr.open(path);
					int lenght = is.available();
					byte[] buffer = new byte[lenght];
					is.read(buffer);
					result = EncodingUtils.getString(buffer, "UTF-8");
					String[] fileList = result.split(",");
					for (String filepath : fileList) {
						filepath = filepath.trim();
						if (filepath.isEmpty())
							continue;
						int idx = filepath.lastIndexOf('/');
						if (idx > 0) {
							File temp = new File(appFilesResourcesPath + "/"
									+ filepath);
							String filePath = temp.getParent();
							File tmep1 = new File(filePath);
							if (!tmep1.exists())
								tmep1.mkdirs();
						}
						resFilesPath.add(filepath);
					}
				} catch (IOException e) {
					e.printStackTrace();
				} finally {
				}
				return resFilesPath.size();
			}

			private Boolean isContainFileList(String[] files) {
				Boolean result = false;
				for (String fileName : files) {
					if (fileName.equals("filelist.txt")) {
						result = true;
						break;
					}
				}
				return result;
			}

			//
			@Override
			public void run() {
				//
				long start = System.currentTimeMillis();
				//
				AssetManager assetMgr = theActivity.getAssets();
				int idx = 0;
				BufferedInputStream in = null;
				BufferedOutputStream out = null;
				try {
					String[] array = assetMgr.list("");
					if (isContainFileList(array)) {
						recursionSumAssetsFileNumByFileList("filelist.txt");
					} else {
						recursionSumAssetsFileNum("");
					}

				} catch (IOException e) {
					e.printStackTrace();
					recursionSumAssetsFileNum("");
				}
				//
				long end1 = System.currentTimeMillis();
				long span1 = end1 - start;
				Log.e(TAG, "recursionSumAssetsFileNum cost time: " + span1
						+ " millis");
				//
				byte[] buf = null;
				if (resFilesPath.size() > 0)
					buf = new byte[10240];
				//
				for (String filepath : resFilesPath) {
					idx++;
					//
					try {
						in = new BufferedInputStream(assetMgr.open(filepath,
								AssetManager.ACCESS_STREAMING), 40960);
						out = new BufferedOutputStream(new FileOutputStream(
								appFilesResourcesPath + "/" + filepath), 40960);
						//
						int readNum = 0;
						while (true) {

							readNum = in.read(buf, 0, buf.length);
							if (readNum <= 0) {
								break;
							}

							out.write(buf, 0, readNum);

						}
						//
						out.flush();
					} catch (IOException e) {
						File tmp = new File(appFilesResourcesPath + "/"
								+ filepath);
						if (tmp.exists())
							tmp.delete();
						tmp = null;
					} catch (OutOfMemoryError omm) {
						File tmp = new File(appFilesResourcesPath + "/"
								+ filepath);
						if (tmp.exists())
							tmp.delete();
						tmp = null;
					} finally {
						try {
							if (in != null)
								in.close();
							if (out != null)
								out.close();
							//
							// in = null;
							// out = null;
							//
						} catch (IOException e) {

						}
					}
					//
					int itmp = idx % 20;
					if (itmp == 0) {
						int progress = idx * 100 / resFilesPath.size();
						String text = String.valueOf(idx) + "/"
								+ String.valueOf(resFilesPath.size());

						Message msg = new Message();
						msg.obj = new ProgressMessage(progress, text);
						msg.what = HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress;
						theHandler.sendMessage(msg);
						//
					}
					if (idx >= resFilesPath.size() && itmp > 0) {

						Message msg = new Message();
						msg.obj = new ProgressMessage(100, ", starting game");
						msg.what = HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress;
						theHandler.sendMessage(msg);
						//
						long end = System.currentTimeMillis();
						long span = end - start;
						Log.e(TAG,
								"UnzipAssetToExternalStorageResources cost time: "
										+ span + " millis");
					}
					//
				}
				//
				buf = null;
				//
				// } catch (IOException e) {

				// }
				//
			}
			//
		}.start();
		//

		//
	}

	/*
	 * 普�?的APK文件是存储压缩率（低压缩率）的zip文件�?
	 * 我们发布时的APK是标准压缩率（高压缩率）的zip文件，此时Cocos2dxMusic&Sound里面的MediaPlayer
	 * &SoundPool都不能使用压缩的声音文件�?故此保证声音文件解压缩，其他的可不解（暂时未发现问题�?
	 */
	private void makeSureUnzipMusicSoundFiles() {
		Log.d(TAG, "makeSureUnzipMusicSoundFiles");
		//
		{
			File cfg = new File(mAppFilesPath + "/config.properties");
			if (cfg.exists()) {
				Properties cfgIni = new Properties();
				String hasUnzipSound = null;
				try {
					cfgIni.load(new FileInputStream(cfg));
					hasUnzipSound = cfgIni.getProperty("hasUnzipSound", null);
					//
				} catch (FileNotFoundException e) {

				} catch (IOException e) {

				}
				//
				cfg = null;
				cfgIni = null;
				//
				if (hasUnzipSound != null
						&& hasUnzipSound.equalsIgnoreCase("true"))
					return;
			}
		}
		//
		final Activity theActivity = mGameActivity.getActivity();
		final String appFilesPath = mAppFilesPath;
		final String appFilesResourcesPath = mGameActivity
				.getAppFilesResourcesPath();
		//
		new Thread("MoveSoundFilesToExternalStorageThread") {

			//
			private ArrayList<String> soundFilesPath = new ArrayList<String>();

			private Boolean isContainFileList(String[] files) {
				Boolean result = false;
				for (String fileName : files) {
					if (fileName.equals("filelist.txt")) {
						result = true;
						break;
					}
				}
				return result;
			}

			//
			private int recursionSumAssetsFileNum(String path) {
				int num = 0;
				try {
					AssetManager assetMgr = theActivity.getAssets();
					String[] assets = assetMgr.list(path);
					//
					for (String filepath : assets) {
						if (filepath.isEmpty())
							continue;
						String strTmp = filepath.toUpperCase();
						//
						if (!path.isEmpty())
							filepath = path + "/" + filepath;
						//

						int idx = filepath.lastIndexOf('/');
						int idy = filepath.lastIndexOf('.');
						if (idx == -1 && idy == -1) {
							num += recursionSumAssetsFileNum(filepath);
							File temp = new File(appFilesResourcesPath + "/"
									+ filepath);
							if (!temp.exists())
								temp.mkdirs();
						} else if (idx > 0 && idy > idx) {
							if (strTmp.endsWith(".MP3")
									|| strTmp.endsWith(".WAV")
									|| strTmp.endsWith(".MP4")) {
								num++;
								soundFilesPath.add(filepath);
							}
						} else if (idx == -1 && idy > 0) {
							if (strTmp.endsWith(".MP3")
									|| strTmp.endsWith(".WAV")
									|| strTmp.endsWith(".MP4")) {
								num++;
								soundFilesPath.add(filepath);
							}
						} else if (idx > 0 && idy < idx) {
							num += recursionSumAssetsFileNum(filepath);
							File temp = new File(appFilesResourcesPath + "/"
									+ filepath);
							if (!temp.exists())
								temp.mkdirs();
						}
					}
					//
					soundFilesPath.add("Imageset.txt");
					soundFilesPath.add("version_android.cfg");
					soundFilesPath.add("version_android_local.cfg");
					++num;
					++num;
					++num;
					//
				} catch (IOException e) {

				} finally {

				}
				return num;
			}

			private int recursionSumAssetsFileNumByFileList(String path) {
				String result = "";
				AssetManager assetMgr = theActivity.getAssets();
				try {
					InputStream is = assetMgr.open(path);
					int lenght = is.available();
					byte[] buffer = new byte[lenght];
					is.read(buffer);
					result = EncodingUtils.getString(buffer, "UTF-8");
					String[] fileList = result.split(",");
					for (String fileName : fileList) {
						String strTmp = fileName.toUpperCase();
						if (strTmp.endsWith(".MP3") || strTmp.endsWith(".WAV")
								|| strTmp.contains("TXT/")
								|| strTmp.endsWith(".EL")
								|| strTmp.endsWith(".MP4")) {
							soundFilesPath.add(fileName);
						}
					}
					is.close();
					is = null;
					//
					soundFilesPath.add("Imageset.txt");
					soundFilesPath.add("version_android.cfg");
					soundFilesPath.add("version_android_local.cfg");
					//
				} catch (IOException e) {
					e.printStackTrace();
				}
				return soundFilesPath.size();
			}

			//
			@Override
			public void run() {
				//
				AssetManager assetMgr = theActivity.getAssets();
				int idx = 0;
				BufferedInputStream in = null;
				BufferedOutputStream out = null;
				//
				// try {
				//
				long s1 = System.currentTimeMillis();
				// int assetsFileNum = recursionSumAssetsFileNum("");
				int assetsFileNum = 0;

				try {
					String[] array = assetMgr.list("");
					if (isContainFileList(array)) {
						assetsFileNum = recursionSumAssetsFileNumByFileList("filelist.txt");
					} else {
						assetsFileNum = recursionSumAssetsFileNum("");
					}

				} catch (IOException e) {
					e.printStackTrace();
					assetsFileNum = recursionSumAssetsFileNum("");
				}

				long s2 = System.currentTimeMillis();
				System.out.println("cost time is :" + (s2 - s1));
				//
				byte[] buf = null;
				if (soundFilesPath.size() > 0)
					buf = new byte[10240];
				//
				for (String filepath : soundFilesPath) {
					filepath = filepath.trim();
					idx++;
					//
					File file_tmp = new File(appFilesResourcesPath + "/"
							+ filepath);
					if (!file_tmp.exists()) {
						try {
							in = new BufferedInputStream(assetMgr.open(
									filepath, AssetManager.ACCESS_STREAMING),
									40960);
							if (!file_tmp.exists()) {
								file_tmp.mkdirs();
								if (!file_tmp.createNewFile()) {
									file_tmp.delete();
									file_tmp.createNewFile();
								}
							}
							out = new BufferedOutputStream(
									new FileOutputStream(appFilesResourcesPath
											+ "/" + filepath), 40960);
							//
							int readNum = 0;
							while (true) {

								readNum = in.read(buf, 0, buf.length);
								if (readNum <= 0) {
									break;
								}

								out.write(buf, 0, readNum);

							}
							//
							out.flush();
						} catch (IOException e) {

						} catch (OutOfMemoryError omm) {

						} finally {
							try {
								if (in != null)
									in.close();
								if (out != null)
									out.close();
								//
								// in = null;
								// out = null;
								//
							} catch (IOException e) {

							}
						}
						//
					}
					file_tmp = null;
				}
				//
				buf = null;
				//
				if (idx >= assetsFileNum) {
					File cfg = new File(appFilesPath + "/config.properties");
					if (cfg.exists()) {
						Properties cfgIni = new Properties();
						try {
							cfgIni.load(new FileInputStream(cfg));
							cfgIni.setProperty("hasUnzipSound", "true");
							//
							cfgIni.store(new FileOutputStream(cfg),
									"last upzip sound files");
						} catch (FileNotFoundException e) {

						} catch (IOException e) {

						}
						//
						cfg = null;
						cfgIni = null;
					}

					Log.d(TAG, "UnzipedMusicSoundFiles");
				}
				//
				// } catch (IOException e) {

				// }
				//
			}
			//
		}.start();
	}

	/*
	 * */
	private void checkNetworkStatus() {

		ConnectivityManager cm = (ConnectivityManager) mGameActivity
				.getActivity().getSystemService(Context.CONNECTIVITY_SERVICE);
		NetworkInfo niWiFi = cm.getNetworkInfo(ConnectivityManager.TYPE_WIFI);
		NetworkInfo niMobile = cm
				.getNetworkInfo(ConnectivityManager.TYPE_MOBILE);
		//
		if ((!niWiFi.isAvailable() && !niMobile.isAvailable())
				|| (!niWiFi.isConnected() && !niMobile.isConnected())) {
			/*

		   */
			mNetworkOK = false;
		} else {
			mNetworkOK = true;
		}
	}

	/**
	 * 返回true将要求解压缩资源覆盖 安装包版本高返回true ExternalStorageResources版本高返回false
	 * 主要用于检测当前版本资源号与本地资源版本号是否匹配，通过对比后判定是否需要清除本地Old Resource
	 * 
	 * @return boolean
	 */
	private boolean checkExternalStorageResourcesVersion() {

		File version_cfg = new File(mGameActivity.getAppFilesResourcesPath()
				+ "/version_android_local.cfg");
		if (!version_cfg.exists()) {
			version_cfg = null;
			return true;
		}

		byte[] buf1 = new byte[4096];// 会自动初始化0
		try {
			FileInputStream inp1 = new FileInputStream(version_cfg);
			inp1.read(buf1);// utf8文本
			inp1.close();
			inp1 = null;
		} catch (Exception e) {
			// e.printStackTrace();
			Log.d(TAG,
					"local unzip storage version_android_local.cfg file not exist!");
			return true;
		}
		// 获取本地资源版本号
		String str1 = new String(buf1);
		Log.i(TAG, "local Version:"+str1);
		String local_version = "";

		{
			JSONTokener jsonParser = new JSONTokener(str1);
			try {
				JSONObject version = (JSONObject) jsonParser.nextValue();
				local_version = version.getString("localVerson");
			} catch (JSONException e) {
				// e.printStackTrace();
				Log.d(TAG,
						"local unzip storage version.cfg file json parse failed!");
				return true;
			}
			jsonParser = null;
		}

		str1 = null;
		buf1 = null;

		byte[] buf2 = new byte[4096];
		AssetManager assetMgr = mGameActivity.getActivity().getAssets();
		try {
			InputStream inp2 = assetMgr.open("version_android_local.cfg");
			inp2.read(buf2);
			inp2.close();
			inp2 = null;
		} catch (IOException e) {
			// e.printStackTrace();
			Log.d(TAG,
					"apk assets version_android_local_local.cfg file not exist!");
			return false;
		}
		// 获取应用资源版本号
		String str2 = new String(buf2);
		String apk_version = "";
		Log.i(TAG, "apk_version:"+str2);

		{
			JSONTokener jsonParser = new JSONTokener(str2);
			try {
				JSONObject version = (JSONObject) jsonParser.nextValue();
				apk_version = version.getString("localVerson");
			} catch (JSONException e) {
				// e.printStackTrace();
				Log.d(TAG,
						"apk assets version_android_local.cfg file parse failed!");
				return false;
			}
			jsonParser = null;
		}

		str2 = null;
		buf2 = null;
		// 本地与应用资源进行切割对比
		String apkVer[] = apk_version.split("\\.");
		Log.e(TAG, apkVer[0] + "." + apkVer[1] + "." + apkVer[2]);
		String localVer[] = local_version.split("\\.");
		Log.e(TAG, localVer[0] + "." + localVer[1] + "." + localVer[2]);
		try {
			if (Integer.valueOf(apkVer[0]) > Integer.valueOf(localVer[0])) {
				return true;
			} else if (Integer.valueOf(apkVer[0]) < Integer
					.valueOf(localVer[0])) {
				return false;
			}
			if (Integer.valueOf(apkVer[1]) > Integer.valueOf(localVer[1])) {
				return true;
			} else if (Integer.valueOf(apkVer[1]) < Integer
					.valueOf(localVer[1])) {
				return false;
			}
			if (Integer.valueOf(apkVer[2]) > Integer.valueOf(localVer[2])) {
				return true;
			} else {

			}
		} catch (Exception e) {
			Log.d(TAG, "compare apkversion and localversion failed");
			return false;
		}
		Log.e(TAG, "apk_version:" + apk_version + ", local_version:"
				+ local_version);
		// if (apk_version.compareTo(local_version) > 0)
		// return true;

		return false;
	}

	private void saveConfigFileFirstTime() {
		File cfg = new File(mAppFilesPath + "/config.properties");
		Properties cfgIni = new Properties();
		cfgIni.setProperty("forceUnzipAssets", "false");
		try {
			cfgIni.store(new FileOutputStream(cfg), "auto save, default false");
		} catch (FileNotFoundException e) {

		} catch (IOException e) {

		}
		//
		cfg = null;
		cfgIni = null;
	}

	/*
	 * return false将要求解压缩apk资源覆盖本地资源目录
	 */
	private boolean checkExternalStorageResourcesStatus() {
		// �?��config.properties
		// true默认首次运行解压缩Assets资源到外部存�?
		boolean isForceUnzipAssets = true;
		File cfg = new File(mAppFilesPath + "/config.properties");
		if (cfg.exists()) {
			Properties cfgIni = new Properties();
			String forceUnzip = null;
			try {
				cfgIni.load(new FileInputStream(cfg));
				forceUnzip = cfgIni.getProperty("forceUnzipAssets", null);
				//
				if (forceUnzip != null && forceUnzip.equalsIgnoreCase("true")) {
					cfgIni.setProperty("forceUnzipAssets", "false");
					cfgIni.store(new FileOutputStream(cfg),
							"auto save, change from true to false");
				}
				//
			} catch (FileNotFoundException e) {

			} catch (IOException e) {

			}
			//
			cfg = null;
			cfgIni = null;
			//
			if (forceUnzip != null && forceUnzip.equalsIgnoreCase("true")) {
				isForceUnzipAssets = true;
			} else {
				isForceUnzipAssets = false;
			}
		} else {
			Properties cfgIni = new Properties();
			cfgIni.setProperty("forceUnzipAssets", "false");
			try {
				cfgIni.store(new FileOutputStream(cfg),
						"auto save, default false");
			} catch (FileNotFoundException e) {

			} catch (IOException e) {

			}
			//
			cfg = null;
			cfgIni = null;
		}
		//
		//
		File resources = new File(mGameActivity.getAppFilesResourcesPath());
		if (!resources.exists() || !resources.canRead()
				|| !resources.canWrite()) {
			Log.e(TAG, "AppDataExternalStorageResourcesFullPath: "
					+ mGameActivity.getAppFilesResourcesPath() + " is not OK!");
			resources.mkdirs();
			resources = null;
			if (isForceUnzipAssets)
				return false;
			else
				return true;
		}
		//
		// 确保高版本资源能覆盖
		if (isForceUnzipAssets == false /* && mUnzipedAssets == false */) {
			isForceUnzipAssets = checkExternalStorageResourcesVersion();
			Log.i(TAG, "isForceUnzipAssets"+isForceUnzipAssets);
		}
		//
		AssetManager assetMgr = mGameActivity.getActivity().getAssets();
		//
		try {

			String[] assets = assetMgr.list("");// "/"apk根目�?""assets根目�?
			String[] files = resources.list();
			//
			resources = null;
			//
			Log.d(TAG, "assets.length: " + String.valueOf(assets.length)
					+ " resources.length: " + String.valueOf(files.length));
			//
			if (files.length < assets.length) {
				if (isForceUnzipAssets)
					return false;
				else
					return true;
			}
			// TODO �?��换检查二者不�?��的策�?
			// �?��策略：资源目录放版本号文件resver.txt，版本号+文件MD5(CRC32)列表
			// asset版本大时，返回false，重新解压缩覆盖
			// 版本号相等时，可�?��比较文件个数，或者�?�?��较MD5(CRC32)
			// asset版本小时，返回true，相信游戏内更新了资�?
			// 内更新如果检查资源版本时做校验的�?
		} catch (IOException e) {

			// e.printStackTrace();
			if (isForceUnzipAssets)
				return false;
			else
				return true;
		}
		//
		if (isForceUnzipAssets)
			return false;
		else
			return true;
	}

	/*
	 * 
	 * */
	private IStateManager mStateMgr;
	/*
	 * 
	 * */
	private IGameActivity mGameActivity;
	/*
	 * 
	 * */
	private IGameLogoStateCallback mCallback;
	/*
	 * */
	private String mAppFilesPath = null;
	/*
	 * */
	private boolean mUnzipedAssets = false;
	/*
	 * */
	private boolean mNetworkOK = false;
	/*  
	 * */
	private boolean mExternalStorageOK = true;
	private boolean mExternalStorageEnough = true;
	/*
	 * */
	private ProgressBar mAssetsUnzipProgressBar = null;
	private TextView mAssetsUnzipTextView = null;
	/*
	 * 
	 * */
	private static final int HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress = 0;
	private static final int HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK = 1;
	private static final int HANDLER_MSG_TO_MAINTHREAD_ShowLogoViewDelay = 3;
	private static final int HANDLER_MSG_TO_MAINTHREAD_DeleteDirtyFileDirectoryDelay = 4;
	private static final int HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResText = 5;
	private static final int HANDLER_MSG_TO_MAINTHREAD_ExternalStorageNotOK = 6;
	private static final int HANDLER_MSG_TO_MAINTHREAD_DoEnterDelay = 7;

	/*
	 * 在主线程创建，实际默认就是MainLooper
	 */
	private class GameLogoStateHandler extends Handler {

		public GameLogoStateHandler() {
			super(mGameActivity.getActivity().getMainLooper());
		}

		public void handleMessage(Message msg) {
			if (msg.what == HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress) {
				ProgressMessage obj = (ProgressMessage) msg.obj;
				if (obj.progress < 100) {
					Log.d(TAG, "uncompressing resources to external storage "
							+ obj.text);

					mAssetsUnzipProgressBar.setVisibility(View.VISIBLE);
					mAssetsUnzipProgressBar.setProgress(obj.progress);
					if (obj.progress < 92) {
						String str = mGameActivity.getActivity().getResources()
								.getString(R.string.assets_unzip_msg)
								+ obj.text;
						mAssetsUnzipTextView.setText(str);
					} else {
						mAssetsUnzipTextView.setText(mGameActivity
								.getActivity().getResources()
								.getString(R.string.starting_game));
					}
				} else {
					//
					SharedPreferences sp = mGameActivity.getActivity()
							.getSharedPreferences("ResourcesInfo",
									Context.MODE_PRIVATE);
					Editor edit = sp.edit();
					edit.putBoolean("UnzipedAssets", true);
					edit.apply();

					mUnzipedAssets = true;
					//
					if (mNetworkOK) {
						mStateMgr
								.changeState(GameInterface.LeagueUpdateStateID);
						// mStateMgr.changeState(GameInterface.GameLogoMovieState);
					} else {
						/*
						 * Message msg1 = new Message(); msg1.obj = new
						 * DialogMessage(
						 * mGameActivity.getActivity().getResources()
						 * .getString(R.string.app_dlg_title), mGameActivity
						 * .getActivity() .getResources() .getString(
						 * R.string.app_dlg_newwork_notok_msg),
						 * HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK); msg1.what =
						 * HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK;
						 * 
						 * mHandler.sendMessage(msg1);
						 */
						DialogMessage dlgmsg = new DialogMessage(
								mGameActivity.getActivity().getResources()
										.getString(R.string.app_dlg_title),
								mGameActivity
										.getActivity()
										.getResources()
										.getString(
												R.string.app_dlg_newwork_notok_msg),
								HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK);

						showDialog(dlgmsg);
					}
				}
			} else if (msg.what == HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK) {
				// showDialog(msg);
			} else if (msg.what == HANDLER_MSG_TO_MAINTHREAD_ShowLogoViewDelay) {
				mStateMgr.changeState(GameInterface.LeagueUpdateStateID);
				// mStateMgr.changeState(GameInterface.GameLogoMovieState);
			} else if (msg.what == HANDLER_MSG_TO_MAINTHREAD_DeleteDirtyFileDirectoryDelay) {
				mAssetsUnzipTextView.setText("waiting...");
				//
				requestUnzipAssetToExternalStorageResources();
				unzipObb();
				ZipObbUtil.getInstance().expantionFile(mGameActivity.getActivity());
			} else if (msg.what == HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResText) {
				ProgressMessage obj = (ProgressMessage) msg.obj;
				mAssetsUnzipTextView.setText(obj.text);
			} else if (msg.what == HANDLER_MSG_TO_MAINTHREAD_DoEnterDelay) {
				doEnter();
			}
		}
	}

	private GameLogoStateHandler mHandler = null;

	/*
	 * 
	 * */
	private void showDialog(DialogMessage msg) {
		final IGameActivity theActivity = mGameActivity;
		final int tag = msg.msgId;

		AlertDialog dlg = new AlertDialog.Builder(theActivity.getActivity())
				.setTitle(msg.titile).setMessage(msg.message)
				.setPositiveButton("确定", new DialogInterface.OnClickListener() {

					@Override
					public void onClick(DialogInterface dialog, int which) {

						if (tag == HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK
								|| tag == HANDLER_MSG_TO_MAINTHREAD_ExternalStorageNotOK) {
							theActivity.requestDestroy();
						}

					}
				}).setOnCancelListener(new DialogInterface.OnCancelListener() {

					@Override
					public void onCancel(DialogInterface dialog) {
						if (tag == HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK
								|| tag == HANDLER_MSG_TO_MAINTHREAD_ExternalStorageNotOK) {
							theActivity.requestDestroy();
						}
					}

				})
				/*
				 * .setOnDismissListener(new DialogInterface.OnDismissListener()
				 * { // need api level 17
				 * 
				 * @Override public void onDismiss(DialogInterface dialog) { if
				 * (tag == HANDLER_MSG_TO_MAINTHREAD_NetwrokNotOK) {
				 * theActivity.requestDestroy(); } }
				 * 
				 * })
				 */.create();
		WindowManager.LayoutParams lp = dlg.getWindow().getAttributes();
		// lp.alpha = 0.6f;
		dlg.getWindow().setAttributes(lp);
		dlg.show();
	}

	/*
	 * 
	 * */
	private static class ProgressMessage {

		public int progress; // 百分之几�?
		public String text;

		public ProgressMessage(int progress, String text) {
			this.progress = progress;
			this.text = text;
		}
	}

	/*
	 * 
	 * */
	private static class DialogMessage {

		public String titile;
		public String message;
		public int msgId;

		public DialogMessage(String title, String message, int msgId) {
			this.titile = title;
			this.message = message;
			this.msgId = msgId;
		}
	}

	/*
	 * 覆盖安装之后删除SharePreferences里面的数据
	 */
	private void unzipObb() {
		Activity context = null;
		if (mGameActivity != null) {
			context = mGameActivity.getActivity();
		} else {
			return;
		}
	}
}
