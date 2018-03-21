package com.nuclear.dota.platform.dangle;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.widget.Toast;

import com.downjoy.CallbackListener;
import com.downjoy.Downjoy;
import com.downjoy.DownjoyError;
import com.downjoy.util.Util;
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

public class PlatformDangleLoginAndPay implements IPlatformLoginAndPay {

private static final String TAG = PlatformDangleLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	private Downjoy 					downjoy;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	private boolean						isLogin = false;
	
	
	private static PlatformDangleLoginAndPay sInstance = null;
	public static PlatformDangleLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformDangleLoginAndPay();
		}
		return sInstance;
	}
	
	@Override
	public void onLoginGame() {
			
		}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		//game_info.app_id = 498;
		//game_info.app_key = "cOPRIXPv";
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_DangLe;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_DangLe;
		
		final String merchantId = String.valueOf(game_info.cp_id);//"323"
        final String appId = String.valueOf(game_info.app_id); 
        final String serverSeqNum = String.valueOf(game_info.svr_id);//目前都配1，意味着当乐后台只能配1个支付服务器地址
        final String appKey = game_info.app_key;

        downjoy=Downjoy.getInstance(this.game_ctx, merchantId, appId, serverSeqNum, appKey);
        downjoy.showDownjoyIconAfterLogined(false);
        isLogin = false;
        mCallback1.notifyInitPlatformSDKComplete();
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		// TODO Auto-generated method stub
		mCallback1 = callback1;
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		// TODO Auto-generated method stub
		mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		// TODO Auto-generated method stub
		mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		// TODO Auto-generated method stub
		/*
		 *
		 * */
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return R.layout.logo_dangle;
	}

	@Override
	public void unInit() {
		// TODO Auto-generated method stub
		if(downjoy != null) {
			downjoy.logout(this.game_ctx, new CallbackListener(){
				@Override
				public void onLogoutSuccess(){
					downjoy.destroy();
		            downjoy=null;
				}
			});
            
        }
		
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
		
		this.isLogin = false;
		
		
		//
		//
		PlatformDangleLoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		
		if(this.isLogin)
		{
			Log.w(TAG, "Logined");
			return;
		}
        downjoy.openLoginDialog(this.game_ctx, new CallbackListener() {

            @Override
            public void onLoginSuccess(Bundle bundle) {
                String memberId=bundle.getString(Downjoy.DJ_PREFIX_STR + "mid");
                String username=bundle.getString(Downjoy.DJ_PREFIX_STR + "username");
                String nickname=bundle.getString(Downjoy.DJ_PREFIX_STR + "nickname");
                String token=bundle.getString(Downjoy.DJ_PREFIX_STR + "token");
                
                LoginInfo login_info = new LoginInfo();
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
				login_info.login_session = token;
				login_info.account_uid_str = memberId;
				login_info.account_uid = Long.parseLong(login_info.account_uid_str);
				login_info.account_nick_name =nickname;
				//
				isLogin = true;
				PlatformDangleLoginAndPay.getInstance().notifyLoginResult(login_info);

            }

            @Override
            public void onLoginError(DownjoyError error) {
            	if(error.getMErrorCode()==100)
            	{
            		callLogin();
            	}
            }

            @Override
            public void onError(Error error) {
                String errorMessage=error.getMessage();
                Toast.makeText(game_ctx,errorMessage, Toast.LENGTH_SHORT)
    			.show();
            }
        });
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_DangLe+login_info.account_uid_str;
			Toast.makeText(game_ctx, "登录成功，点击进入游戏", Toast.LENGTH_SHORT)
			.show();
			
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		// TODO Auto-generated method stub
		if (login_info != null) {
			if (isLogin)
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			else
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}
		
		return login_info;
	}

	@Override
	public void callLogout() {
		// TODO Auto-generated method stub
		if(downjoy != null) {
			downjoy.logout(this.game_ctx, new CallbackListener(){
				@Override
				public void onLogoutSuccess(){
					
					isLogin = false;
				}
			});
            
        }
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
		// TODO Auto-generated method stub
		this.pay_info = null;
		this.pay_info = pay_info;
		 if(!Util.isLogined(this.game_ctx)) {
             Toast.makeText(game_ctx, "用户信息无效，请您重新登录游戏！", Toast.LENGTH_SHORT).show();
             return 0;
         }
         float money=pay_info.price; // 商品价格，单位：元
         String productName=pay_info.product_name; // 商品名称
         String extInfo=pay_info.order_serial; // CP自定义信息，多为CP订单号
         extInfo = pay_info.description + "-" + pay_info.product_id;//区号-物品id，我们自己的订单号不是必须

         // 打开支付界面,获得订单号
         downjoy.openPaymentDialog(this.game_ctx, money, productName, extInfo, new CallbackListener() {

             @Override
             public void onPaymentSuccess(String orderNo) {
            	 Toast.makeText(game_ctx, "购买成功", Toast.LENGTH_SHORT)
      			.show();
            	 
            	 PlatformDangleLoginAndPay.getInstance().pay_info.result = 0;
            	 PlatformDangleLoginAndPay.getInstance()
 					.notifyPayRechargeRequestResult(PlatformDangleLoginAndPay.getInstance().pay_info);
             }

             @Override
             public void onPaymentError(DownjoyError error, String orderNo) {
                 int errorCode=error.getMErrorCode();
                 String errorMsg=error.getMErrorMessage();
                 //Toast.makeText(game_ctx, "onPaymentError:" + errorCode + "|" + errorMsg + "\n orderNo:" + orderNo, Toast.LENGTH_SHORT)
                // Toast.makeText(game_ctx, "取消购买", Toast.LENGTH_SHORT).show();
             }

             @Override
             public void onError(Error error) {
                 Toast.makeText(game_ctx,"购买失败：" + error.getMessage(), Toast.LENGTH_SHORT)
        			.show();
             }
             
         });
         
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		 downjoy.openMemberCenterDialog(this.game_ctx, new CallbackListener() {

             @Override
             public void onError(Error error) {
             }
         });
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

	}

	@Override
	public void callPlatformGameBBS() {
		// TODO Auto-generated method stub

	}

	@Override
	public void onGameExit() {
		
	}


	@Override
	public void onGamePause() {
		// TODO Auto-generated method stub
		if (downjoy != null) {
			downjoy.pause();
		}
	}


	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub
		if (downjoy != null) {
			downjoy.resume(game_ctx);
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
