

package com.nuclear.dota;

import com.nuclear.IGameActivityState;
import com.nuclear.IStateManager;
import com.nuclear.dota.GameInterface.Idota;





public class GameStateManager implements IStateManager
{

	@Override
	public void changeState(int stateID)
	{
		if (stateID < GameInterface.GameStateIDMin || 
				stateID >= GameInterface.GameStateIDMax)
		{
			return;
		}
		
		if (mStates[stateID] == null)
		{
			mStates[stateID] = createStateByID(stateID);
		}
		
		if (mStates[mCurrentStateID] != null)
		{
			mStates[mCurrentStateID].exit();
			/*
			 * 顺序切换，可以置null
			 * 不能置null了，因为update没等回调而直接切换了
			 * */
			//mStates[mCurrentStateID] = null;
		}
		
		mCurrentStateID = stateID;
		if (mStates[stateID] != null)
		{
			mStates[stateID].enter();
		}
	}
	
	/*
	 * 
	 * */
	public GameStateManager(int count, Idota pGameActivity)
	{
		mStates = new IGameActivityState[count];
		mGameActivity = pGameActivity;
	}
	/*
	 * 
	 * */
	private IGameActivityState createStateByID(int stateID)
	{
		IGameActivityState pState = null;
		switch (stateID)
		{
			case GameInterface.GameLogoMovieState:
			{
				pState = new GameLogoMovieState(this, mGameActivity, mGameActivity);				
				break;
			}
			case GameInterface.GameLogoStateID:
			{
				pState = new GameLogoState(this, mGameActivity, mGameActivity);
				break;
			}
			case GameInterface.LeagueUpdateStateID:
			{
				pState = new UpdateState(this, mGameActivity, mGameActivity);
				break;
			}
			case GameInterface.PlatformSDKStateID:
			{
				pState = new PlatformSDKState(this, mGameActivity, mGameActivity);
				break;
			}
			case GameInterface.GameUpdateStateID:
			{
				pState = new GameUpdateState(this, mGameActivity, mGameActivity);
				break;
			}
			case GameInterface.GameContextStateID:
			{
				pState = new GameContextState(this, mGameActivity, mGameActivity);
				break;
			}
			case GameInterface.GameAppStateID:
			{
				pState = new GameAppState(this, mGameActivity, mGameActivity);
				break;
			}
		}
		return pState;
	}
	/*
	 * 
	 * */
	private IGameActivityState[] mStates = null;
	/*
	 * 
	 * */
	private int mCurrentStateID = 0;
	/*
	 * 
	 * */
	private Idota mGameActivity = null;
}

