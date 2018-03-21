package com.nuclear.dota;

import android.media.MediaPlayer;
import android.media.MediaPlayer.OnCompletionListener;
import android.media.MediaPlayer.OnErrorListener;
import android.net.Uri;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.view.View;
import android.widget.ImageView;

import com.nuclear.IGameActivity;
import com.nuclear.IGameActivityState;
import com.nuclear.IStateManager;
import com.nuclear.LogoVideoView;
import com.nuclear.WorldVideoView;
import com.nuclear.dota.GameInterface.IGameLogoStateCallback;
import com.qsds.ggg.dfgdfg.fvfvf.R;

public class GameLogoMovieState implements IGameActivityState,
		OnCompletionListener {

	public static final String TAG = GameLogoMovieState.class.getSimpleName();

	private static GameActivity mActivity;

	private static LogoVideoView videoWorldView;

	/*
	 * 
	 * */
	public GameLogoMovieState(IStateManager pStateMgr,
			IGameActivity pGameActivity, IGameLogoStateCallback pCallback) {
		mStateMgr = pStateMgr;
		mGameActivity = pGameActivity;
		mActivity = (GameActivity) pGameActivity.getActivity();

	}

	private void playMovieEnd() {
		videoWorldView.setVisibility(View.INVISIBLE);
		videoWorldView.stopPlayback();
		if (mHandler != null) {
			mGameActivity.getActivity().setContentView(R.layout.logo_layout);
			ImageView mImageView = (ImageView) mGameActivity.getActivity()
					.findViewById(R.id.imageView_logo);

			// mImageView.setImageResource(R.drawable.logo_nuclear);
			mImageView.setVisibility(mImageView.VISIBLE);
			mHandler.sendEmptyMessageDelayed(
					HANDLER_MSG_TO_MAINTHREAD_MOVIEEND, 100);
		}

	}

	@Override
	public void enter() {
		Log.d(TAG, "enter GameLogoMovieState");
		/*
		 * 
		 * */
		mHandler = new GameLogoMovieStateHandler();

		mActivity.getActivity().setContentView(R.layout.logo_layout);
		videoWorldView = (LogoVideoView) mActivity
				.findViewById(R.id.logovideoview);

		// playMovieEnd();

		videoWorldView.setVisibility(View.VISIBLE);
		// String uri = "android.resource://" + mActivity.getPackageName()+ "/"
		// + R.raw.gamelogo;
		// videoWorldView.setVideoURI (Uri.parse(uri));
		// videoWorldView.setVideoURI(Uri.parse(spath+"/movie/gamelogo.mp4"));
		videoWorldView.setOnCompletionListener(GameLogoMovieState.this);
		videoWorldView.setOnErrorListener(new OnErrorListener() {
			@Override
			public boolean onError(MediaPlayer mp, int what, int extra) {
				playMovieEnd();
				return true;
			}
		});

		videoWorldView.start();

		mActivity.getMainHandler().postDelayed(new Runnable() {

			@Override
			public void run() {
				// TODO Auto-generated method stub
				if (!videoWorldView.isPlaying())
					playMovieEnd();
			}
		}, 1);

	}

	@Override
	public void exit() {
		mHandler.removeMessages(HANDLER_MSG_TO_MAINTHREAD_MOVIEEND);
		mHandler = null;

		//

		//
		mStateMgr = null;
		mGameActivity = null;

		videoWorldView.stopPlayback();
		videoWorldView.setVisibility(View.INVISIBLE);

		Log.d(TAG, "exit GameLogoMovieState");
	}

	/*
	 * 
	 * */
	private IStateManager mStateMgr;
	private IGameActivity mGameActivity;

	private static final int HANDLER_MSG_TO_MAINTHREAD_MOVIEEND = 9;

	/*
	 * 在主线程创建，实际默认就是MainLooper
	 */
	private class GameLogoMovieStateHandler extends Handler {

		public GameLogoMovieStateHandler() {
			super(mGameActivity.getActivity().getMainLooper());
		}

		public void handleMessage(Message msg) {
			if (msg.what == HANDLER_MSG_TO_MAINTHREAD_MOVIEEND) {
				mStateMgr.changeState(GameInterface.GameLogoStateID);
			}
		}
	}

	private GameLogoMovieStateHandler mHandler = null;

	@Override
	public void onCompletion(MediaPlayer arg0) {
		playMovieEnd();
	}
}
