
/*
 * utf-8 encoding
 * */

package com.nuclear.dota.platform.wandoujia;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.graphics.BitmapFactory;
import android.widget.Toast;
import android.content.Intent;
import android.net.Uri;

import com.wandoujia.mariosdk.plugin.api.api.WandouGamesApi;
import com.wandoujia.mariosdk.plugin.api.model.callback.OnCheckLoginCompletedListener;
import com.wandoujia.mariosdk.plugin.api.model.callback.OnLoginFinishedListener;
import com.wandoujia.mariosdk.plugin.api.model.callback.OnLogoutFinishedListener;
import com.wandoujia.mariosdk.plugin.api.model.callback.OnPayFinishedListener;
import com.wandoujia.mariosdk.plugin.api.model.model.LoginFinishType;
import com.wandoujia.mariosdk.plugin.api.model.model.LogoutFinishType;
import com.wandoujia.mariosdk.plugin.api.model.model.PayResult;
import com.wandoujia.mariosdk.plugin.api.model.model.UnverifiedPlayer;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.FeedBackDialog;
import com.nuclear.dota.LastLoginHelp;
import com.nuclear.dota.Config;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;

public class PlatformWanDouJiaLoginAndPay implements IPlatformLoginAndPay {
	
	private static final String TAG = PlatformWanDouJiaLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	public GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	private boolean						is_logined = false;
	private boolean 					wdjIsLogin = false;
	
	 // 需要配置的部分- 结束
	private WandouGamesApi wandouGamesApi = MarioPluginApplication.getWandouGamesApi();

	private static PlatformWanDouJiaLoginAndPay sInstance = null;
	public static PlatformWanDouJiaLoginAndPay getInstance()
	{
		if (sInstance == null)
		{
			sInstance = new PlatformWanDouJiaLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformWanDouJiaLoginAndPay() 
	{
		
	}
	
	public int getPlatformLogoLayoutId()
	{
		return -1;
	}

	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info)
	{
		
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;

		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		
		is_logined = false;
		final IPlatformSDKStateCallback callback1 = mCallback1;
		callback1.notifyInitPlatformSDKComplete();
		
	}

	@Override
	public void unInit() {
		
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
		//
		PlatformWanDouJiaLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		
		return this.game_info;
	}

	@Override
	public void callLogin() {
		
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(true, -1, "正在登录");
		wandouGamesApi.isLoginned(new OnCheckLoginCompletedListener() {
		      @Override
		      public void onCheckCompleted(boolean isLogin) {
		        wdjIsLogin = isLogin;
		      }
		});
		if(is_logined == true || wdjIsLogin == true){
			callback.showWaitingViewImp(false, -1, "");
			return;
		}
		wandouGamesApi.login(new OnLoginFinishedListener() {
			
			@Override
			public void onLoginFinished(LoginFinishType loginFinishType, UnverifiedPlayer unverifiedPlayer) {
				// TODO Auto-generated method stub
				
				if(loginFinishType == LoginFinishType.LOGIN || loginFinishType == LoginFinishType.AUTO_LOGIN){
	                LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.login_session = unverifiedPlayer.getToken();
					login_info.account_uid_str =PlatformAndGameInfo.enPlatformShort_WanDouJia + 
							unverifiedPlayer.getId().toString();
					login_info.account_uid = Long.parseLong(unverifiedPlayer.getId());
					login_info.account_nick_name = unverifiedPlayer.getId().toString();
					is_logined = true;
					PlatformWanDouJiaLoginAndPay.getInstance().notifyLoginResult(login_info);
				}else if(loginFinishType == LoginFinishType.CANCEL){
	                LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
					login_info.login_session = "";
					login_info.account_uid_str = "";
					login_info.account_uid = 0;
					login_info.account_nick_name = "";
					PlatformWanDouJiaLoginAndPay.getInstance().notifyLoginResult(login_info);
				}
			}
		});
        
        callback.showWaitingViewImp(false, -1, "");
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		if(is_logined) {
			login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
		}else{
			login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}
		return login_info;
	}

	@Override
	public void callLogout() 
	{
		wandouGamesApi.logout(new OnLogoutFinishedListener() {
			
			@Override
			public void onLoginFinished(LogoutFinishType arg0) {
				// TODO Auto-generated method stub
				wdjIsLogin = false;
			}
		});
		wdjIsLogin = false;
        is_logined = false;
	}

	@Override
	public void callCheckVersionUpate() {

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
	public int callPayRecharge(PayInfo pay_info)
	{
		this.pay_info = null;
		this.pay_info = pay_info;
		String cpprivateinfo = pay_info.description + "-" + pay_info.product_id + "-" + 
				this.login_info.account_uid_str;//区号-物品ID-orderserial
		wandouGamesApi.pay(game_ctx, pay_info.product_name, ((long)pay_info.price)*100, cpprivateinfo, 
				new OnPayFinishedListener() {
					
					@Override
					public void onPaySuccess(PayResult arg0) {
						// TODO Auto-generated method stub
						PlatformWanDouJiaLoginAndPay.this.pay_info.result = 0;
						notifyPayRechargeRequestResult(PlatformWanDouJiaLoginAndPay.this.pay_info);
					}
					
					@Override
					public void onPayFail(PayResult arg0) {
						// TODO Auto-generated method stub
						
					}
				});

		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) 
	{

	}
	
	@Override
	public void callAccountManage() 
	{
		if (Cocos2dxHelper.nativeHasEnterMainFrame()){
			Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
			return;
		}
		if (is_logined) {
			callLogout();
		}
		callLogin();
	}

	@Override
	public String generateNewOrderSerial() {
		
		return UUID.randomUUID().toString();//字符串带横杠字符-
	}

	@Override
	public void callPlatformFeedback() {
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
		
		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}
	}
	
	@Override
	public void callPlatformGameBBS() {
		Intent intent = new Intent();        
		intent.setAction("android.intent.action.VIEW");    
		Uri content_url = Uri.parse("http://bbs.wandoujia.com/forum.php?mod=forumdisplay&fid=43");   
		intent.setData(content_url);  
		game_ctx.startActivity(intent);
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1)
	{
		
		mCallback1 = callback1;
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2)
	{
		
		mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3)
	{
		
		mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate()
	{
		/*
		 * 2013-06-23 Ver3.2.5.1SDK的init自动发起了更新检查，但没有单独的回调，所以我们仍�?��己请求一�?
		 * */
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public void onGameExit() {

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

	@Override
	public void onLoginGame() {
		// TODO Auto-generated method stub
		
	}
}
