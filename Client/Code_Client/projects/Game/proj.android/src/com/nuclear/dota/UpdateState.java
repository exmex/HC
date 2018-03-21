

package com.nuclear.dota;

import android.util.Log;

import com.nuclear.IGameActivity;
import com.nuclear.IGameActivityState;
import com.nuclear.IStateManager;
import com.nuclear.dota.GameInterface.ILeagueUpdateStateCallback;




public class UpdateState implements IGameActivityState
{
	public static final String	TAG	= UpdateState.class.getSimpleName();
	
	@Override
	public void enter()
	{
		// TODO Auto-generated method stub
		mStateMgr.changeState(GameInterface.PlatformSDKStateID);
		
	}

	@Override
	public void exit()
	{
		// TODO Auto-generated method stub
		mStateMgr = null;
		mGameActivity = null;
		mCallback = null;
		
	}
	
	/*
	 * 
	 * */
	public UpdateState(IStateManager pStateMgr, IGameActivity pGameActivity, ILeagueUpdateStateCallback pCallback)
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
	private ILeagueUpdateStateCallback mCallback;
}


