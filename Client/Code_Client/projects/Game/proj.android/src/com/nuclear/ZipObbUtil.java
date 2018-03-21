package com.nuclear;

import java.io.File;
import java.io.IOException;

import android.app.Activity;
import android.app.PendingIntent;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Environment;
import android.os.Messenger;
import android.provider.Settings;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.android.vending.expansion.downloader.DownloadProgressInfo;
import com.google.android.vending.expansion.downloader.DownloaderClientMarshaller;
import com.google.android.vending.expansion.downloader.DownloaderServiceMarshaller;
import com.google.android.vending.expansion.downloader.Helpers;
import com.google.android.vending.expansion.downloader.IDownloaderClient;
import com.google.android.vending.expansion.downloader.IDownloaderService;
import com.google.android.vending.expansion.downloader.IStub;
import com.nuclear.dota.oversea.MyDownloaderService;
import com.qsds.ggg.dfgdfg.fvfvf.R;

public class ZipObbUtil implements IDownloaderClient {
	private static final String TAG = ZipObbUtil.class.getSimpleName();
	private static Activity mContext = null;
	private ProgressBar mPB;
	private TextView mProgressFraction;
	private TextView mProgressPercent;
	private TextView mAverageSpeed;
	private TextView mTimeRemaining;
	private View mDashboard;
	private View mCellMessage;
	private Button mPauseButton;
	private Button mWiFiSettingsButton;
	private boolean mStatePaused;
	private int mState;
	private IDownloaderService mRemoteService;
	private IStub mDownloaderClientStub;
	private static String mVersion="";
	private static ZipObbUtil mInstance = null;
	private ZipObbUtil(){
	}
	public static ZipObbUtil getInstance() {
		if (mInstance == null) {
			mInstance = new ZipObbUtil();
		}
		return mInstance;
	}
	
	public void onResume(Activity activity) {
		if (null != mDownloaderClientStub) {
			mDownloaderClientStub.connect(activity);
		}
	}
	
	public void onStop(Activity activity) {
		if (null != mDownloaderClientStub) {
			mDownloaderClientStub.disconnect(activity);
		}
	}


	public void expantionFile(Activity context) {
		mContext = context;
		if (!expansionFilesDelivered()) {
			Log.i("xt", "11111111111");
			try {
				Intent launchIntent = context.getIntent();
				Intent intentToLaunchmContextActivityFromNotification = new Intent(
						context, context.getClass());
				intentToLaunchmContextActivityFromNotification
						.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK
								| Intent.FLAG_ACTIVITY_CLEAR_TOP);
				intentToLaunchmContextActivityFromNotification
						.setAction(launchIntent.getAction());

				if (launchIntent.getCategories() != null) {
					for (String category : launchIntent.getCategories()) {
						intentToLaunchmContextActivityFromNotification
								.addCategory(category);
					}
				}

				// Build PendingIntent used to open mContext activity from
				// Notification
				PendingIntent pendingIntent = PendingIntent.getActivity(
						context, 0, intentToLaunchmContextActivityFromNotification,
						PendingIntent.FLAG_UPDATE_CURRENT);
				// Request to start the download
				int startResult = DownloaderClientMarshaller
						.startDownloadServiceIfRequired(context, pendingIntent,
								MyDownloaderService.class);

				if (startResult != DownloaderClientMarshaller.NO_DOWNLOAD_REQUIRED) {
					// The DownloaderService has started downloading the files,
					// show progress
					initializeDownloadUI();
					return;
				} // otherwise, download not needed so we fall through to
					// starting the movie
			} catch (NameNotFoundException e) {
				Log.e(TAG, "Cannot find own package! MAYDAY!");
				e.printStackTrace();
			}

		}

		initializeDownloadUI();
		mContext.setContentView(R.layout.logo_layout);
		validateXAPKZipFiles();
	}
	
	/**
	 * Go through each of the Expansion APK files defined in the project and
	 * determine if the files are present and match the required size. Free
	 * applications should definitely consider doing mContext, as mContext allows the
	 * application to be launched for the first time without having a network
	 * connection present. Paid applications that use LVL should probably do at
	 * least one LVL check that requires the network to be present, so mContext is
	 * not as necessary.
	 * 
	 * @return true if they are present.
	 */
	boolean expansionFilesDelivered() {
		for (XAPKFile xf : xAPKS) {
			String fileName = Helpers.getExpansionAPKFileName(mContext, xf.mIsMain,
					xf.mFileVersion);
			if (!Helpers.doesFileExist(mContext, fileName, xf.mFileSize, false))
				return false;
		}
		return true;
	}
	
	/**
	 * mContext is a little helper class that demonstrates simple testing of an
	 * Expansion APK file delivered by Market. You may not wish to hard-code
	 * things such as file lengths into your executable... and you may wish to
	 * turn mContext code off during application development.
	 */
	private static class XAPKFile {
		public final boolean mIsMain;
		public final int mFileVersion;
		public final long mFileSize;

		XAPKFile(boolean isMain, int fileVersion, long fileSize) {
			mIsMain = isMain;
			mFileVersion = fileVersion;
			mFileSize = fileSize;
			
		}
	}


	private static final XAPKFile[] xAPKS = { new XAPKFile(true, 2, 50295223L)
	// main file only
	};

	private void setState(int newState) {
		if (mState != newState) {
			mState = newState;
			Toast.makeText(mContext,
					Helpers.getDownloaderStringResourceIDFromState(newState),
					Toast.LENGTH_SHORT).show();
		}
	}

	private void setButtonPausedState(boolean paused) {
		mStatePaused = paused;
		int stringResourceID = paused ? R.string.text_button_resume
				: R.string.text_button_pause;
		mPauseButton.setText(stringResourceID);
	}

	void validateXAPKZipFiles() {
		for (XAPKFile xf : xAPKS) {
			String fileName = Helpers.getExpansionAPKFileName(mContext, xf.mIsMain,
					xf.mFileVersion);
			String inFileName = Helpers.generateSaveFileName(mContext, fileName);
			String outFileName = Environment.getExternalStorageDirectory()
					+ File.separator + "Android" + File.separator + "data"
					+ File.separator + mContext.getPackageName() + File.separator
					+ "files" + File.separator + "Assets";
			try {
				Log.i("333333333333", outFileName);
				Util.unzip(inFileName, outFileName);
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	/**
	 * If the download isn't present, we initialize the download UI. mContext ties
	 * all of the controls into the remote service calls.
	 */
	private void initializeDownloadUI() {
		mDownloaderClientStub = DownloaderClientMarshaller.CreateStub(mInstance, MyDownloaderService.class);
		mContext.setContentView(R.layout.main);
		mPB = (ProgressBar) mContext.findViewById(R.id.progressBar);
		mProgressFraction = (TextView) mContext.findViewById(R.id.progressAsFraction);
		mProgressPercent = (TextView) mContext.findViewById(R.id.progressAsPercentage);
		mAverageSpeed = (TextView) mContext.findViewById(R.id.progressAverageSpeed);
		mTimeRemaining = (TextView) mContext.findViewById(R.id.progressTimeRemaining);
		mDashboard = mContext.findViewById(R.id.downloaderDashboard);
		mCellMessage = mContext.findViewById(R.id.approveCellular);
		mPauseButton = (Button) mContext.findViewById(R.id.pauseButton);
		mWiFiSettingsButton = (Button) mContext.findViewById(R.id.wifiSettingsButton);
		mPauseButton.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				if (mStatePaused) {
					mRemoteService.requestContinueDownload();
				} else {
					mRemoteService.requestPauseDownload();
				}
				setButtonPausedState(!mStatePaused);
			}
		});

		mWiFiSettingsButton.setOnClickListener(new View.OnClickListener() {

			@Override
			public void onClick(View v) {
				mContext.startActivity(new Intent(Settings.ACTION_WIFI_SETTINGS));
			}
		});

		Button resumeOnCell = (Button) mContext.findViewById(R.id.resumeOverCellular);
		resumeOnCell.setOnClickListener(new View.OnClickListener() {
			@Override
			public void onClick(View view) {
				mRemoteService
						.setDownloadFlags(IDownloaderService.FLAGS_DOWNLOAD_OVER_CELLULAR);
				mRemoteService.requestContinueDownload();
				mCellMessage.setVisibility(View.GONE);
			}
		});
	}

	@Override
	public void onServiceConnected(Messenger m) {
		mRemoteService = DownloaderServiceMarshaller.CreateProxy(m);
		mRemoteService.onClientUpdated(mDownloaderClientStub.getMessenger());		
	}

	@Override
	public void onDownloadStateChanged(int newState) {
		setState(newState);
		boolean showDashboard = true;
		boolean showCellMessage = false;
		boolean paused;
		boolean indeterminate;
		switch (newState) {
		case IDownloaderClient.STATE_IDLE:
			// STATE_IDLE means the service is listening, so it's
			// safe to start making calls via mRemoteService.
			paused = false;
			indeterminate = true;
			break;
		case IDownloaderClient.STATE_CONNECTING:
		case IDownloaderClient.STATE_FETCHING_URL:
			showDashboard = true;
			paused = false;
			indeterminate = true;
			break;
		case IDownloaderClient.STATE_DOWNLOADING:
			paused = false;
			showDashboard = true;
			indeterminate = false;
			break;

		case IDownloaderClient.STATE_FAILED_CANCELED:
		case IDownloaderClient.STATE_FAILED:
		case IDownloaderClient.STATE_FAILED_FETCHING_URL:
		case IDownloaderClient.STATE_FAILED_UNLICENSED:
			paused = true;
			showDashboard = false;
			indeterminate = false;
			break;
		case IDownloaderClient.STATE_PAUSED_NEED_CELLULAR_PERMISSION:
		case IDownloaderClient.STATE_PAUSED_WIFI_DISABLED_NEED_CELLULAR_PERMISSION:
			showDashboard = false;
			paused = true;
			indeterminate = false;
			showCellMessage = true;
			break;
		case IDownloaderClient.STATE_PAUSED_BY_REQUEST:
			paused = true;
			indeterminate = false;
			break;
		case IDownloaderClient.STATE_PAUSED_ROAMING:
		case IDownloaderClient.STATE_PAUSED_SDCARD_UNAVAILABLE:
			paused = true;
			indeterminate = false;
			break;
		case IDownloaderClient.STATE_COMPLETED:
			showDashboard = false;
			paused = false;
			indeterminate = false;
			validateXAPKZipFiles();
			return;
		default:
			paused = true;
			indeterminate = true;
			showDashboard = true;
		}
		int newDashboardVisibility = showDashboard ? View.VISIBLE : View.GONE;
		if (mDashboard.getVisibility() != newDashboardVisibility) {
			mDashboard.setVisibility(newDashboardVisibility);
		}
		int cellMessageVisibility = showCellMessage ? View.VISIBLE : View.GONE;
		if (mCellMessage.getVisibility() != cellMessageVisibility) {
			mCellMessage.setVisibility(cellMessageVisibility);
		}
		mPB.setIndeterminate(indeterminate);
		setButtonPausedState(paused);
		
	}

	@Override
	public void onDownloadProgress(DownloadProgressInfo progress) {
		mAverageSpeed.setText(mContext.getString(R.string.kilobytes_per_second,
				Helpers.getSpeedString(progress.mCurrentSpeed)));
		mTimeRemaining.setText(mContext.getString(R.string.time_remaining,
				Helpers.getTimeRemaining(progress.mTimeRemaining)));

		progress.mOverallTotal = progress.mOverallTotal;
		mPB.setMax((int) (progress.mOverallTotal >> 8));
		mPB.setProgress((int) (progress.mOverallProgress >> 8));
		mProgressPercent.setText(Long.toString(progress.mOverallProgress * 100
				/ progress.mOverallTotal)
				+ "%");
		mProgressFraction.setText(Helpers.getDownloadProgressString(
				progress.mOverallProgress, progress.mOverallTotal));		
	}
	
}
