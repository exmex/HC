package com.nuclear.dota.platform.sijia.hzw;

import android.app.Activity;
import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.os.Bundle;
import android.widget.Toast;

import com.sjyxsdk.activity.Sijiu;
import com.nuclear.DeviceUtil;
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
import com.qsds.ggg.dfgdfg.fvfvf.R;

import org.cocos2dx.lib.Cocos2dxHelper;

public class PlatformSjyxLoginAndPay implements IPlatformLoginAndPay {

	
private static final String TAG = PlatformSjyxLoginAndPay.class.getSimpleName();
	
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
	private boolean isLogined = false;
	private Sijiu sijiu;
	 /**
		 * 通过广播接收登录成功后的数据
		 */
		private BroadcastReceiver mBroadcastReceiver = new BroadcastReceiver() {
			@Override
			public void onReceive(Context context, Intent intent) {
				
				String action = intent.getAction();
				if (action.equals("com.sjyx.login")) {
					Bundle db = intent.getExtras();
					String flag = db.getString("result");
					String uid = db.getString("userid");// 用户id
					String timeStamp = db.getString("timestamp");// 登录时间戳
					String sign = db.getString("sign");
					System.out.println(uid + "--" + timeStamp + "--" + sign);
					if (flag.equals("success")) {
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_Sjyx + uid;
						login_info.account_nick_name = uid;
						//
						notifyLoginResult(login_info);
						
						mCallback3.showWaitingViewImp(false, -1, "已登录");
						isLogined = true;
						System.out.println("登录成功");
					} else {
						isLogined = false;
						mCallback3.showWaitingViewImp(false, -1, "登录失败");
						System.out.println("登录失败");
					}
				}
				if(action.equals("com.sjyx.payment")){
					Bundle db = intent.getExtras();
					String flag = db.getString("result");
					System.out.println("-----支付界面返回结果---result---"+flag);
				}
			}
		};
		
	private static PlatformSjyxLoginAndPay sInstance = null;
	public static PlatformSjyxLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformSjyxLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformSjyxLoginAndPay() {
		
	}
	
	@Override
	public void onLoginGame() {
			
		}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		
		

		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_Sjyx;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_Sjyx;
		this.game_info = game_info;
		//
		
		
		
		IntentFilter myIntentFilter = new IntentFilter();
		myIntentFilter.addAction("com.sjyx.login");
		myIntentFilter.addAction("com.sjyx.payment");		
		// 注册广播
		game_ctx.registerReceiver(mBroadcastReceiver, myIntentFilter);
		sijiu = new Sijiu(game_ctx);
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
		return R.layout.logo_sjyx;
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
		if(!isLogined){
			mCallback3.showWaitingViewImp(true, -1, "正在登录");
			sijiu.Login(""+game_info.app_id, game_info.app_key ,"" ,"");
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
		// TODO Auto-generated method stub
		this.version_info = null;
		this.version_info = version_info;
		if (version_info != null) {
			mCallback2.notifyVersionCheckResult(version_info);
		}
	}

	@Override
	public int callPayRecharge(PayInfo pay_info) {
		String extraInfo = pay_info.product_id+"-"+pay_info.description+"-"+this.login_info.account_uid_str;
		/*
		 * recharge(String appid, String appkey, String order_num, String goods_name, String goods_info, String amount,
		 *  String agent, String user, String server_id, String extrainfo, String subject, int Multiple)
		 */
		sijiu.recharge(""+game_info.app_id, game_info.app_key,generateNewOrderSerial(), "mxhzw", pay_info.product_id,
				""+pay_info.price,"","",pay_info.description,extraInfo,"DreamOnePiece",10); //10币1块钱 或者写0
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
	}

	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
			return;
		sijiu.Login(""+game_info.app_id, game_info.app_key ,"" ,"");
	}

	@Override
	public String generateNewOrderSerial() {
		// TODO Auto-generated method stub
		return DeviceUtil.generateUUID().replace("-", "");
	}

	@Override
	public void callPlatformFeedback() {
		// TODO Auto-generated method stub
		//Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
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
		if (mBroadcastReceiver != null) {
			game_ctx.unregisterReceiver(mBroadcastReceiver);
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
		
	}

}
