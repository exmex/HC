package com.nuclear.dota.platform.sy4399;

import java.util.UUID;

import org.apache.commons.codec.digest.DigestUtils;
import org.cocos2dx.lib.Cocos2dxHandler;
import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.graphics.BitmapFactory;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.ssjjsy.net.DialogError;
import com.ssjjsy.net.Ssjjsy;
import com.ssjjsy.net.SsjjsyDialogListener;
import com.ssjjsy.net.SsjjsyException;
import com.ssjjsy.net.SsjjsyVersionUpdateListener;
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

public class PlatformgameSSJJLoginAndPay implements IPlatformLoginAndPay {

	
private static final String TAG = PlatformgameSSJJLoginAndPay.class.getSimpleName();
	
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
	private static final String Tag = PlatformgameSSJJLoginAndPay.class.toString();
	
	private static PlatformgameSSJJLoginAndPay sInstance = null;
	public static PlatformgameSSJJLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformgameSSJJLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformgameSSJJLoginAndPay() {
		
	}
	
	@Override
	public void onLoginGame() {
			
	}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Game4399;
		game_info.platform_type =PlatformAndGameInfo.enPlatform_Game4399;
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		
		this.game_info = game_info;
		
	
		Ssjjsy.init(game_ctx,game_info.app_id_str, game_info.app_key);
		Ssjjsy.getInstance().activityOpenLog(this.game_ctx);
		
		final IPlatformSDKStateCallback callback1 = mCallback1;
		
		callback1.notifyInitPlatformSDKComplete();
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
		//return PlatformAndGameInfo.SupportUpdateCheckAndDownload;
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

	@Override
	public void callLogin() {
		Ssjjsy.getInstance().activityBeforeLoginLog(game_ctx);
		final IGameAppStateCallback callback = mCallback3;
		
		callback.showWaitingViewImp(false, -1, "正在登录");
		
		Ssjjsy.getInstance().authorize(game_ctx,new SsjjLoginDialog());
		 
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Game4399+login_info.account_uid_str;
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
	}

	@Override
	public void callCheckVersionUpate() {
		// TODO Auto-generated method stub
		Ssjjsy.getInstance().versionUpdate(game_ctx,new SsjjsyVersionUpdateListener() {
			
			@Override
			public void onNotNewVersion() {
				// 无新版本时会调用此方法
				Toast.makeText(game_ctx,
						"没有发现新版本", Toast.LENGTH_LONG).show();
			}

			@Override
			public void onNotSDCard() {
				// 未安装SD卡时会调用此方法
				Toast.makeText(game_ctx,
						"没有检查到SD卡", Toast.LENGTH_LONG).show();
			}

			@Override
			public void onCancelForceUpdate() {
				// 用户取消强制更新时会调用此方法
				game_ctx.finish();
				Toast.makeText(game_ctx,
						"取消强制更新", Toast.LENGTH_LONG).show();
			}

			@Override
			public void onCancelNormalUpdate() {
				/**
				 * 根据用户的需求来登录。
				 */
				// 用户取消普通更新时会调用此方法
				Ssjjsy.getInstance().authorize(game_ctx, new SsjjLoginDialog());
				Toast.makeText(game_ctx,
						"取消一般更新", Toast.LENGTH_LONG).show();
			}

			@Override
			public void onCheckVersionFailure() {
				// 新版本检测失败时会调用此方法
				Toast.makeText(game_ctx,
						"版本检查失败", Toast.LENGTH_LONG).show();
			}

			@Override
			public void onForceUpdateLoading() {
				// 强制更新正在下载时会调用此方法
				Toast.makeText(game_ctx,
						"强制更新中", Toast.LENGTH_LONG).show();
			}

			@Override
			public void onNormalUpdateLoading() {
				// 普通更新正在下载时会调用此方法
				Toast.makeText(game_ctx,
						"一般更新中", Toast.LENGTH_LONG).show();
			}
			
			@Override
			public void onNetWorkError() {
				// 网络链接错误时调用
				Toast.makeText(game_ctx,
						"网络异常", Toast.LENGTH_LONG).show();
			}

			@Override
			public void onSsjjsyException(SsjjsyException e) {
				// 其它异常
				Toast.makeText(game_ctx,
						"异常", Toast.LENGTH_LONG).show();
			}
		} );
	}

	@Override
	public void notifyVersionUpateInfo(VersionInfo version_info) {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:notifyVersionUpateInfo");
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			
			mCallback2.notifyVersionCheckResult(version_info);
		}
		
	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		this.pay_info = null;
		this.pay_info = pay_info;
			
	    Ssjjsy.getInstance().setServerId(pay_info.description); 
	    
	    String extra = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
	    
	    Ssjjsy.getInstance().excharge(game_ctx,(int)pay_info.price,extra);
		
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			callPlatformGameBBS();
			return;
		}
		if (Ssjjsy.getInstance().isLogin()){
			Ssjjsy.getInstance().loginGameCenter(game_ctx);
		}else{
		callLogin();
		}
		
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString();
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
		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}
	}

	@Override
	public void callPlatformGameBBS() {
		// TODO Auto-generated method stub
		Ssjjsy.getInstance().loginForum(game_ctx);
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


	class SsjjLoginDialog implements SsjjsyDialogListener{
		
		@Override
		public void onError(DialogError e) {
			Toast.makeText(game_ctx,"登录错误 : " + e.getMessage(), Toast.LENGTH_LONG).show();
		}

		@Override
		public void onCancel() {
			Toast.makeText(game_ctx, "登录取消",Toast.LENGTH_LONG).show();
		}

		@Override
		public void onSsjjsyException(SsjjsyException e) {
			Toast.makeText(game_ctx,"登录异常 : " + e.getMessage(), Toast.LENGTH_LONG).show();
		}
			
			@Override
			public void onComplete(Bundle values) {
				// 获取用户名：
				String username = values.getString("username");
				// 授权时服务器时间戳：
				String timestamp = values.getString("timestamp");
				// 签名字符串：
				String signStr = values.getString("signStr");
				//游戏中将要使用到的唯一id，这个id将取代 username
				String suid = values.getString("suid");
				
				// 导量服的id
				String targetServerId = values.getString("targetServerId");
				
				//comeFrom "2"表示是网游大厅点击进入，“1”表示是由其他方式进入游戏。
				String comeFrom = values.getString("comeFrom");
				//Log.i(Tag, "username: "+ username+ "  suid: "+ suid+" timestamp: "+ timestamp+" comeFrom: "+ comeFrom+" signStr: "+signStr+" targetServerId:"+targetServerId);
				
		        LoginInfo login_info = new LoginInfo();
		   		login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
		   		login_info.account_uid_str =values.getString("suid"); ;
		   		login_info.account_uid = Long.valueOf(values.getString("suid"));
		   		login_info.account_nick_name = values.getString("username");
		   		
		   		
		   		String nowsignStr = DigestUtils.md5Hex(suid+"&"+timestamp+"&"+PlatformgameSSJJLoginAndPay.this.game_info.app_secret);
		   		
		   		if(nowsignStr.equals(signStr)){
		   			login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;	
			   		notifyLoginResult(login_info);
			   		
		   		}else{
		   			login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		   			
		   			Ssjjsy.getInstance().cleanLocalData(game_ctx);
		   			notifyLoginResult(login_info);
		   		}
		   		
		   		
			}
			 
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
		
	};
		

}

