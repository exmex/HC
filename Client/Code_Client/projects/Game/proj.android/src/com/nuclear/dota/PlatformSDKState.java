

package com.nuclear.dota;

import android.os.Handler;
import android.os.Message;
import android.util.Log;

import com.nuclear.IGameActivity;
import com.nuclear.IGameActivityState;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.IStateManager;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.dota.PushLastLoginHelp;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;
import com.nuclear.dota.platform.DK.PlatformDuokuLoginAndPay;
import com.nuclear.dota.platform.GTV.PlatformGTVLoginAndPay;
import com.nuclear.dota.platform.anzhi.PlatformAnZhiLoginAndPay;
import com.nuclear.dota.platform.anzhi_gg.PlatformAnZhiGGLoginAndPay;
import com.nuclear.dota.platform.baidugame.PlatformBaiDuGameLoginAndPay;
import com.nuclear.dota.platform.baidumobile.PlatformBaiDuMobileGameLoginAndPay;
import com.nuclear.dota.platform.dangle.PlatformDangleLoginAndPay;
import com.nuclear.dota.platform.defaultplatform.PlatformDefaultLoginAndPay;
import com.nuclear.dota.platform.feiliu.PlatformFeiLiuLoginAndPay;
import com.nuclear.dota.platform.fiveone.PlatformFiveOneLoginAndPay;
import com.nuclear.dota.platform.game2324.PlatformJiubangLoginAndPay;
import com.nuclear.dota.platform.googleplay.PlatformGpftLoginAndPay;
import com.nuclear.dota.platform.huawei.PlatformHuaWeiLoginAndPay;
import com.nuclear.dota.platform.jifeng.PlatformJifengLoginAndPay;
import com.nuclear.dota.platform.jinli.am.PlatformJinliLoginAndPay;
import com.nuclear.dota.platform.jorgame.PlatformJorGameLoginAndPay;
import com.nuclear.dota.platform.keke.nearme.gamecenter.PlatformKekeLoginAndPay;
import com.nuclear.dota.platform.kingsoft.PlatformJinShanLoginAndPay;
import com.nuclear.dota.platform.kugou.PlatformKuGouLoginAndPay;
import com.nuclear.dota.platform.kuwo.PlatformKuWoLoginAndPay;
import com.nuclear.dota.platform.ld.PlatformLvDouGameLoginAndPay;
import com.nuclear.dota.platform.league.PlatformLeagueLoginAndPay;
import com.nuclear.dota.platform.lenovo.PlatformLenovoLoginAndPay;
import com.nuclear.dota.platform.meizu.PlatformMeizuLoginAndPay;
import com.nuclear.dota.platform.mi.PlatformXiaoMiLoginAndPay;
import com.nuclear.dota.platform.mi.hd.PlatformXiaoMihdLoginAndPay;
import com.nuclear.dota.platform.mumayi.PlatformMumayiLoginAndPay;
import com.nuclear.dota.platform.nd91.Platform91LoginAndPay;
import com.nuclear.dota.platform.nduo.PlatformNduoGameLoginAndPay;
import com.nuclear.dota.platform.nearme.gamecenter.PlatformOppoLoginAndPay;
import com.nuclear.dota.platform.oupeng.PlatformOupengGameLoginAndPay;
import com.nuclear.dota.platform.pipaw.PlatformPipawLoginAndPay;
import com.nuclear.dota.platform.puidlogin.PlatformPuidLoginAndPay;
import com.nuclear.dota.platform.punchbox.PlatformChuKongLoginAndPay;
import com.nuclear.dota.platform.qihoo360.Platform360LoginAndPay;
import com.nuclear.dota.platform.renren.PlatformRenRenLoginAndPay;
import com.nuclear.dota.platform.sijia.hzw.PlatformSjyxLoginAndPay;
import com.nuclear.dota.platform.sina_wyx.PlatformSinaLoginAndPay;
import com.nuclear.dota.platform.sougou.PlatformSouGouLoginAndPay;
import com.nuclear.dota.platform.sqw.PlatformSqwLoginAndPay;
import com.nuclear.dota.platform.sqwan.PlatformSqwanLoginAndPay;
import com.nuclear.dota.platform.sy4399.PlatformgameSSJJLoginAndPay;
import com.nuclear.dota.platform.thirdlogin.PlatformThirdLoginAndPay;
import com.nuclear.dota.platform.tianyi.PlatformTianYiGameLoginAndPay;
import com.nuclear.dota.platform.uc.PlatformUCLoginAndPay;
import com.nuclear.dota.platform.vivo.PlatformVivoLoginAndPay;
//import com.nuclear.dota.platform.unicom.PlatformUnicomLoginAndPay;
import com.nuclear.dota.platform.wandoujia.PlatformWanDouJiaLoginAndPay;
import com.nuclear.dota.platform.xunlei.PlatformXunLeiLoginAndPay;
import com.nuclear.dota.platform.yingyonghui.PlatformYingYongHuiLoginAndPay;
import com.nuclear.dota.platform.kupai.PlatformKupaiLoginAndPay;





public class PlatformSDKState implements IGameActivityState
{
	public static final String	TAG	= PlatformSDKState.class.getSimpleName();

	@Override
	public void enter()
	{
		Log.d(TAG, "enter PlatformSDKState");
		
		mGameInfo = mGameActivity.getGameInfo();
		
		mPlatform = createPlatformSDKByType(mGameInfo.platform_type);
		
		mCallback.initPlatformSDK(mPlatform);
		
		mPlatform.setPlatformSDKStateCallback(new PlatformSDKStateCallback());
		
		mHandler = new PlatformSDKStateHandler();
		
		int layoutId = mPlatform.getPlatformLogoLayoutId();
		if (layoutId == -1)
		{
			mPlatform.init(mGameActivity, mGameInfo);
		}
		else if (layoutId == 0)
		{
			mPlatform.init(mGameActivity, mGameInfo);
		}
		else
		{
			mGameActivity.getActivity().setContentView(layoutId);
			
			mHandler.sendEmptyMessageDelayed(PlatformSDKState_MainThreadMsg_DoInitAfterSetView, 100);
		}
		
		
	}

	@Override
	public void exit()
	{
		
		mStateMgr = null;
		mGameActivity = null;
		mCallback = null;
		
		mPlatform.setPlatformSDKStateCallback(null);
		mPlatform = null;
		
		mGameInfo = null;
		mHandler.removeMessages(PlatformSDKState_MainThreadMsg_DoInitAfterSetView);
		mHandler = null;
		
		Log.d(TAG, "exit PlatformSDKState");
	}
	
	/*
	 * 
	 * */
	public PlatformSDKState(IStateManager pStateMgr, IGameActivity pGameActivity, IPlatformSDKStateCallback pCallback)
	{
		mStateMgr = pStateMgr;
		mGameActivity = pGameActivity;
		mCallback = pCallback;
	}
	/*
	 * 
	 * */
	private IPlatformLoginAndPay createPlatformSDKByType(int type)
	{
		IPlatformLoginAndPay platform = null;
		
		switch (type)
		{
		case PlatformAndGameInfo.enPlatform_91:
			platform = Platform91LoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_360:
			platform = Platform360LoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_UC:
			platform = PlatformUCLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_WanDouJia:
			platform = PlatformWanDouJiaLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_XiaoMi:
			platform = PlatformXiaoMiLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_DangLe:
			platform = PlatformDangleLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_BaiduDuoKu:
			platform = PlatformDuokuLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Sina:
			platform = PlatformSinaLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_RenRen:
			platform = PlatformRenRenLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Default:
			platform = PlatformDefaultLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_ThirdLogin:
			platform = PlatformThirdLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_JiFeng:
			platform = PlatformJifengLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_League:
			platform = PlatformLeagueLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_YingYongHui:
			platform = PlatformYingYongHuiLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_FeiLiu:
			platform = PlatformFeiLiuLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_AnZhi:
			platform = PlatformAnZhiLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_AnZhiGG:
			platform = PlatformAnZhiGGLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_JinShan:
		    platform = PlatformJinShanLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_BaiDuGame:
			platform = PlatformBaiDuGameLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Game4399:
		    platform = PlatformgameSSJJLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_KuWo:
		    platform = PlatformKuWoLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Oppo:
		    platform = PlatformOppoLoginAndPay.getInstance();
		    break;
		case PlatformAndGameInfo.enPlatform_LvDouGame:
			platform = PlatformLvDouGameLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_ChuKong:
			platform = PlatformChuKongLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_XunLei:
			platform = PlatformXunLeiLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_KuGou:
			platform = PlatformKuGouLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_GTV:
			platform = PlatformGTVLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_HuaWei:
			platform = PlatformHuaWeiLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_SouGou:
			platform = PlatformSouGouLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_PuidLogin:
			platform = PlatformPuidLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Ydmm:
//			platform = PlatformMMLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Nduo:
			platform = PlatformNduoGameLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Pipaw:
			platform = PlatformPipawLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Lenovo:
			platform=PlatformLenovoLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Oupeng:
			platform = PlatformOupengGameLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Sjyx:
			platform = PlatformSjyxLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Keke:
			platform=PlatformKekeLoginAndPay.getInstance();
			break;
		//case PlatformAndGameInfo.enPlatform_Unicom:
		//	platform=PlatformUnicomLoginAndPay.getInstance();
		//	break;
		case PlatformAndGameInfo.enPlatform_Sqwan:
			platform = PlatformSqwanLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_TianYi:
			platform = PlatformTianYiGameLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Meizu:
			platform = PlatformMeizuLoginAndPay.getInstance();
			break;
			
		case PlatformAndGameInfo.enPlatform_Sqw:
			platform=PlatformSqwLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_BaiDuMobileGame:
			platform=PlatformBaiDuMobileGameLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_JorGame:
			platform = PlatformJorGameLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Jinli:
			platform = PlatformJinliLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Game2324:
			platform = PlatformJiubangLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_FiveOne:
			platform = PlatformFiveOneLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Mumayi:
			platform = PlatformMumayiLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_GoogleFT:
			platform = PlatformGpftLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_GoogleENG:
			platform = PlatformGpftLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_GoogleNUS:
			platform = PlatformGpftLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_XiaoMi_hd:
			platform = PlatformXiaoMihdLoginAndPay.getInstance();
			break;

		case PlatformAndGameInfo.enPlatform_Vivo:
			platform = PlatformVivoLoginAndPay.getInstance();
			break;
		case PlatformAndGameInfo.enPlatform_Kupai:
			platform = PlatformKupaiLoginAndPay.getInstance();
			break;
		}
		
		//调用initPush
		//YouaiLastLoginHelp.initPushHeader(PlatformAndGameInfo.enPlatform_UC);
		
		return platform;
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
	private IPlatformSDKStateCallback mCallback;
	/*
	 * */
	private IPlatformLoginAndPay mPlatform;
	/*
	 * 
	 * */
	private GameInfo mGameInfo;
	/*
	 * SDK的init操作耗时，先切换view，再执行init
	 * */
	private static final int PlatformSDKState_MainThreadMsg_DoInitAfterSetView = 0;
	private class PlatformSDKStateHandler extends Handler
	{
		/*
		 * 在主线程
		 * */
		public void handleMessage(Message msg)
		{
			if (msg.what == PlatformSDKState_MainThreadMsg_DoInitAfterSetView)
			{
				mPlatform.init(mGameActivity, mGameInfo);
			}
		}
	}
	private PlatformSDKStateHandler mHandler;
	/*
	 * */
	private class PlatformSDKStateCallback implements IPlatformSDKStateCallback
	{

		@Override
		public void initPlatformSDK(IPlatformLoginAndPay platform)
		{
			// none
			
		}

		@Override
		public void notifyInitPlatformSDKComplete()
		{
			
			mCallback.notifyInitPlatformSDKComplete();
			
			mStateMgr.changeState(GameInterface.GameUpdateStateID);
		}
		
	}
}


