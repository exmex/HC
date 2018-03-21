package com.nuclear.dota.platform.puidlogin;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.os.Build;

import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.FeedBackDialog;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.LastLoginHelp;
import com.nuclear.dota.Config;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;
//import com.nuclear.dota.platform.nd91.R;
//import com.nuclear.dota.platform.puidlogin.PuidLoginDialog.PuidLoginResult;

public class PlatformPuidLoginAndPay implements IPlatformLoginAndPay {

	
private static final String TAG = PlatformPuidLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	private int 						auto_recalllogin_count = 0;
	
	
	private static PlatformPuidLoginAndPay sInstance = null;
	public static PlatformPuidLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformPuidLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformPuidLoginAndPay() {
		
	}
	
	@Override
	public void onLoginGame() {
			
		}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		

		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		 	
		//
		mCallback1.notifyInitPlatformSDKComplete();
		//
		
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		// TODO Auto-generated method stub

		this.mCallback1 = callback1;
		
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		// TODO Auto-generated method stub
		this.mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		// TODO Auto-generated method stub
		this.mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		// TODO Auto-generated method stub
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		mGameActivity = null;
		mCallback1 = null;
		mCallback2 = null;
		mCallback3 = null;
		//
		this.game_ctx = null;
		this.game_info = null;
		this.login_info = null;
		this.version_info = null;
		this.pay_info = null;

	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

//	private PuidLoginDialog loginDialog ;
	
	@Override
	public void callLogin() {
		
		String temp = Build.MANUFACTURER + Build.MODEL;
		temp = temp.replaceAll(" ", "-");
		String ret = temp + "_" + Build.VERSION.SDK_INT;
		//
		LoginInfo login_info = new LoginInfo();
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
		login_info.login_session = "";
		login_info.account_uid_str = ret;
		login_info.account_uid = 0l;
		login_info.account_nick_name = ret;
		//
		notifyLoginResult(login_info);
		
		/*mCallback3.showWaitingViewImp(false, -1, "正在登录");
		
		loginDialog = new PuidLoginDialog(game_ctx,R.style.PuidDialog);
		
		loginDialog.CallLogin(new PuidLoginResult() {
			
			@Override
			public void onPuidLoginSuccess(String pPuid) {
				
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = "";
				parsePlatformByPuid(pPuid);
				login_info.account_uid_str = pPuid;
				login_info.account_uid = 0l;
				login_info.account_nick_name = pPuid;
				
				notifyLoginResult(login_info);
				loginDialog.dismiss();
				mCallback3.showWaitingViewImp(false, -1, "已登录");
			}

			@Override
			public void onPuidLoginCancel() {
				LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
				notifyLoginResult(login_info);
			}
		});
		*/
	}

	public void parsePlatformByPuid(String puid){
		 if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_91)){
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_91;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_91;
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformName_360)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_360;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_360;
			 
		 }else if(puid.startsWith("ya_")){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_Youai;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Youai;
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_UC)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_UC;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_UC;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_DangLe)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_DangLe;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_DangLe;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_XiaoMi)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_XiaoMi;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_XiaoMi;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_DangLe)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_DangLe;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_DangLe;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_BaiduDuoKu)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_BaiduDuoKu;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_BaiduDuoKu;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_BaiduAppCenter)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_BaiduAppCenter;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_BaiduAppCenter;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_AndroidMarket91)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_AndroidMarket91;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_AndroidMarket91;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_KuWo)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_KuWo;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_KuWo;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_FeiLiu)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_FeiLiu;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_FeiLiu;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_JiFeng)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_JiFeng;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_JiFeng;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_AnZhi)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_AnZhi;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_AnZhi;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_RenRen)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_RenRen;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_RenRen;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_Sina)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_Sina;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Sina;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_Game4399)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_Game4399;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Game4399;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_YingYongHui)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_YingYongHui;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_YingYongHui;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_JinShan)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_JinShan;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_JinShan;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_BaiDuGame)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_BaiDuGame;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_BaiDuGame;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_LvDou)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_LvDouGame;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_LvDouGame;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_Oppo)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_Oppo;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Oppo;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_ChuKong)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_ChuKong;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_ChuKong;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_GTV)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_GTV;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_GTV;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_XunLei)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_XunLei;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_XunLei;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_KuGou)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_KuGou;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_KuGou;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_HuaWei)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_HuaWei;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_HuaWei;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_SouGou)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_SouGou;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_SouGou;
			 
		 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_Default)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_Default;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Default;
			 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_ThirdLogin)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_ThirdLogin;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_ThirdLogin;
			 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_BaiDuMobileGame)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_BaiDuMobileGame;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_BaiDuMobileGame;
			 
		 }else if(puid.startsWith(PlatformAndGameInfo.enPlatformShort_CMGE)){
			 
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_CMGE;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_CMGE;
			 
		 }else {
			 game_info.platform_type = PlatformAndGameInfo.enPlatform_Default;
			 game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Default;
		 
		 }
		 
	}
	
	
	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = login_info.account_uid_str;
			
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		return login_info;
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub

	}

	@Override
	public void callCheckVersionUpate() {
		// TODO Auto-generated method stub

	}

	@Override
	public void notifyVersionUpateInfo(VersionInfo version_info) {
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			mCallback2.notifyVersionCheckResult(version_info);
		}
	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		// TODO Auto-generated method stub
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub

	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		callLogin();
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public void callPlatformFeedback() {
		// TODO Auto-generated method stub
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			String _url = Config.UrlFeedBack + "?puid="+LastLoginHelp.mPuid+"&gameId="+LastLoginHelp.mGameid
					 	+"&serverId="+LastLoginHelp.mServerID+"&playerId="+LastLoginHelp.mPlayerId+"&playerName="
					 	+LastLoginHelp.mPlayerName+"&vipLvl="+LastLoginHelp.mVipLvl+"&platformId="+LastLoginHelp.mPlatform;
			FeedBackDialog.getInstance(game_ctx, _url).show();
		}
	}

	@Override
	public void callPlatformSupportThirdShare(ShareInfo share_info) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void callPlatformGameBBS() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onGamePause() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onGameExit() {
		// TODO Auto-generated method stub

	}

	@Override
	public void callToolBar(boolean visible) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public boolean isTryUser() {
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	public void callBindTryToOkUser() {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void receiveGameSvrBindTryToOkUserResult(int result) {
		// TODO Auto-generated method stub
		
	}

}
