package com.nuclear.dota.platform.kuwo;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.widget.Toast;
import cn.kuwo.game.GameResult;
import cn.kuwo.game.GameTools;
import cn.kuwo.game.KuwoGameSDK.InitCallbackListener;
import cn.kuwo.game.external.KuwoGame;
import cn.kuwo.game.external.LoginCallBack;
import cn.kuwo.game.external.PayCallBack;

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

public class PlatformKuWoLoginAndPay implements IPlatformLoginAndPay,InitCallbackListener {

	
private static final String TAG = PlatformKuWoLoginAndPay.class.getSimpleName();

private static final String Tag = PlatformKuWoLoginAndPay.class.toString();
	
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

	private boolean isLogined;
	
	
	private static PlatformKuWoLoginAndPay sInstance = null;
	public static PlatformKuWoLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformKuWoLoginAndPay();
		}
		return sInstance;
	}
	
	private PlatformKuWoLoginAndPay() {
		
	}
	@Override
	public void onLoginGame() {
			
		}
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		

		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_KuWo;
		game_info.platform_type = PlatformAndGameInfo.enPlatform_KuWo;
		this.game_info = game_info;
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		 	
		GameTools.initSdk(game_info.app_id_str, game_ctx, this);//1处填写游戏ID
		
		
		
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
		return R.layout.logo_kuwo;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		mGameActivity = null;
		mCallback1 = null;
		mCallback2 = null;
		mCallback3 = null;
		isLogined = false;
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
		
		mCallback3.showWaitingViewImp(false, -1, "正在登录");
		
		LoginCallBack mLoginCallBack = new LoginCallBack() {
			@Override
			public void onLoginResult(GameResult gameResult) {
				if(gameResult != null){
					//TODO 接收用户信息
					Toast.makeText(game_ctx, "接收到用户消息", Toast.LENGTH_SHORT).show();
					
					LoginInfo login_info = new LoginInfo();
					login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
					login_info.account_uid_str = gameResult.getUserid() ;
					login_info.account_uid = Long.valueOf(gameResult.getUserid());
					login_info.account_nick_name = gameResult.getUserid();
					notifyLoginResult(login_info);
					mCallback3.showWaitingViewImp(false, -1, "已登录");
					isLogined = true;
				}else{
					//TODO 退出程序
					Toast.makeText(game_ctx, "登录失败", Toast.LENGTH_SHORT).show();
					isLogined = false;
				}
			}
		};
		KuwoGame.getInstance().addLoginCallBack(mLoginCallBack);
		if(this.login_info==null){
			GameTools.login(game_ctx);
		}
		
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		this.login_info = null;
		this.login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_KuWo+login_info.account_uid_str;
			
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
		// TODO Auto-generated method stub
		PayCallBack mPayCallBack = new PayCallBack() {
			
			@Override
			public void onPayResult(String ordrId) {
			//	payForResult(ordrId);//处理充值返回订单
				Toast.makeText(game_ctx, "订单号:"+ordrId, Toast.LENGTH_SHORT).show();
				PlatformKuWoLoginAndPay.getInstance().pay_info.result = 0;
				notifyPayRechargeRequestResult(PlatformKuWoLoginAndPay.getInstance().pay_info);
			}

		};
		KuwoGame.getInstance().addPayCallBack(mPayCallBack);
		
		 
        String extra = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		GameTools.pay(game_ctx, pay_info.description,extra,""+this.pay_info.price,"");
		
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
			return;
		if (isLogined){
			GameTools.account(game_ctx);
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
		// TODO Auto-generated method stub
		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}
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
	public void initCallback(int code, String msg) {
		Log.d("kuwogame", "code: "+code+" msg: "+msg);
		String resule="";
		if(code==GameResult.RESULT_SUCCEED){
			resule = "初始化成功";
		}else if(code ==GameResult.RESULT_FAILED){
			resule = "初始化失败";
		}
		Toast.makeText(game_ctx, resule, Toast.LENGTH_SHORT).show();
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
