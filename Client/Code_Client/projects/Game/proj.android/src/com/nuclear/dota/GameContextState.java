

package com.nuclear.dota;

import org.cocos2dx.lib.Cocos2dxEditText;
import org.cocos2dx.lib.Cocos2dxGLSurfaceView;
import org.cocos2dx.lib.Cocos2dxHandler;

import android.os.Handler;
import android.os.Message;
import android.text.TextPaint;
import android.util.Log;
import android.view.View;
import android.widget.ProgressBar;
import android.widget.TextView;

import com.nuclear.IGameActivity;
import com.nuclear.IGameActivityState;
import com.nuclear.IStateManager;
import com.nuclear.dota.GameInterface.IGameContextStateCallback;
import com.qsds.ggg.dfgdfg.fvfvf.R;




public class GameContextState implements IGameActivityState
{
	public static final String	TAG	= GameContextState.class.getSimpleName();

	@Override
	public void enter()
	{
 		Log.d(TAG, "enter GameContextState");
		
		mGameActivity.getActivity().setContentView(R.layout.activity_game);
		
		mText = (TextView)mGameActivity.getActivity().findViewById(R.id.loading_game_textView);
		TextPaint tp = mText.getPaint(); 
		tp.setFakeBoldText(true);
		
		if (mText != null)
		{
			mGameActivity.getMainHandler().postDelayed(mUpdate, 300);
		}
		
		//LayoutInflater inflater = (LayoutInflater) mGameActivity.getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		//FrameLayout layout = (FrameLayout) inflater.inflate(R.layout.activity_game, null);
		
		//View waitingView = mGameActivity.getActivity().findViewById(R.id.GameApp_WaitingFrameLayout);
		//waitingView.setBackgroundColor(0x000f0f0f);
		
		Cocos2dxGLSurfaceView glView = (Cocos2dxGLSurfaceView)mGameActivity.getActivity().findViewById(R.id.GameApp_Cocos2dxGLSurfaceView);
		Cocos2dxEditText editText = (Cocos2dxEditText)mGameActivity.getActivity().findViewById(R.id.GameApp_Cocos2dxEditText);
		
		//Cocos2dxGLSurfaceView glView = new Cocos2dxGLSurfaceView(mGameActivity.getActivity());
		//layout.addView(glView, 1);
		/*
		 * Cocos2dx内部初始化完毕的地方,通过我们送过去的Handler发消息给我们处理
		 * */
		mCallback.initCocos2dxAndroidContext(glView, editText, mHandler);

		//mGameActivity.getActivity().setContentView(layout);
	}

	@Override
	public void exit()
	{
		mGameActivity.getMainHandler().removeCallbacks(mUpdate);
		mUpdate = null;
		if (mText != null)
		{
			mText.setVisibility(View.INVISIBLE);
			mText = null;
		}
		
		mStateMgr = null;
		mGameActivity = null;
		mCallback = null;
		
		mHandler = null;
		
		Log.d(TAG, "exit GameContextState");
	}
	
	/*
	 * 
	 * */
	public GameContextState(IStateManager pStateMgr, IGameActivity pGameActivity, IGameContextStateCallback pCallback)
	{
		mStateMgr = pStateMgr;
		mGameActivity = pGameActivity;
		mCallback = pCallback;
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
	private IGameContextStateCallback mCallback;
	/*
	 * */
	//private ProgressBar mProgress;
	/*
	 * */
	private TextView mText;
	/*
	 * 
	 * */
	private class GameContextStateHandler extends Handler
	{
		public void handleMessage(Message msg)
		{
			if (msg.what == Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ShowCocos2dx)
			{
				mStateMgr.changeState(GameInterface.GameAppStateID);
			}
		}
	}
	private GameContextStateHandler mHandler = new GameContextStateHandler();
	/*
	 * 
	 * */
	private Runnable mUpdate = new Runnable()
	{
		private int ict = 0;

		@Override
		public void run() {
			
			if(ict == 0)
			{
				mText.setText("starting game.");
				ict = 1;
			}
			else if(ict == 1)
			{
				mText.setText("starting game..");
				ict = 2;
			}
			else if(ict == 2)
			{
				mText.setText("starting game...");
				ict = 0;
			}
			
			mGameActivity.getMainHandler().postDelayed(this, 300);
			
		}
		
	};
}


