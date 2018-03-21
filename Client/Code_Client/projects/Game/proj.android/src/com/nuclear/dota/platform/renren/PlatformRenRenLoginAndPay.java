package com.nuclear.dota.platform.renren;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;

import android.app.Activity;
import android.graphics.BitmapFactory;
import android.util.Log;
import android.widget.Toast;

import com.renn.rennsdk.RennClient;
import com.renn.rennsdk.RennClient.LoginListener;
import com.renn.rennsdk.RennExecutor.CallBack;
import com.renn.rennsdk.RennResponse;
import com.renn.rennsdk.exception.RennException;
import com.renn.rennsdk.param.GetLoginUserParam;
import com.renn.rennsdk.pay.PayParam;
import com.renn.rennsdk.pay.RennPayClient;
import com.renn.rennsdk.pay.RennPayClient.PayListener;
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


public class PlatformRenRenLoginAndPay implements IPlatformLoginAndPay {

	private static final String Tag = PlatformRenRenLoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	
	private static PlatformRenRenLoginAndPay sInstance = null;
	private RennPayClient payClient;
	private RennClient rennClient;
	public PlatformRenRenLoginAndPay (){
		
	}
	
	public static PlatformRenRenLoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new PlatformRenRenLoginAndPay();
		}
		return sInstance;
	}

	@Override
	public void onLoginGame() {
		
	}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:init");
		
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;
		game_info.use_platform_sdk_type = 1;//0逻辑需要再调
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		//
		if (game_info.debug_mode == PlatformAndGameInfo.enDebugMode_Debug) {
			rennClient = RennClient.getInstance(game_ctx);
		}else{
			rennClient = RennClient.getInstance(game_ctx);
		}
		 
		rennClient.init(String.valueOf(this.game_info.app_id), this.game_info.app_key, this.game_info.app_secret);
		rennClient
				.setScope("read_user_blog  read_user_status ");
		
		rennClient.setTokenType("bearer");
		//rennClient.isAuthorizeExpired();
		//rennClient.isAuthorizeValid();
		
		final IPlatformSDKStateCallback callback1 = mCallback1;
		
		//if(!RennClient.getInstance(game_ctx).isLogin()){
		
		callback1.notifyInitPlatformSDKComplete();
		
		//RennClient.getInstance(game_ctx).login(game_ctx);
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		Log.d(Tag, "PlatformRenRenLoginAndPay:setPlatformSDKStateCallback");
		mCallback1 = callback1;
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		Log.d(Tag, "PlatformRenRenLoginAndPay:setGameUpdateStateCallback");
		this.mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		Log.d(Tag, "PlatformRenRenLoginAndPay:setGameAppStateCallback");
		this.mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:isSupportInSDKGameUpdate");
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:getPlatformLogoLayoutId");
		//return R.layout.logo_nuclear;
		return 0;
	}

	@Override
	public void unInit() {
		Log.d(Tag, "PlatformRenRenLoginAndPay:uninit");
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
		rennClient.logout();
	}

	@Override
	public GameInfo getGameInfo() {
		Log.d(Tag, "PlatformRenRenLoginAndPay:getGameInfo");
		return this.game_info;
	}

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:callLogin");
		
		//if(RennClient.getInstance(game_ctx).isLogin())
		//return;
		rennClient = RennClient.getInstance(game_ctx);
		
		
		final IGameAppStateCallback callback = mCallback3;
		
		callback.showWaitingViewImp(false, -1, "正在登录");
		
		rennClient.setLoginListener(new LoginListener() {
			@Override
			public void onLoginSuccess() {
				// TODO Auto-generated method stub
				Toast.makeText(game_ctx, "登录成功",
						Toast.LENGTH_SHORT).show();
				 GetLoginUserParam param5 = new GetLoginUserParam();
				  try {
					  rennClient.getRennService().sendAsynRequest(param5, new CallBack() {    
	                         @Override
	                         public void onSuccess(RennResponse response) {
	                       	  
	             				// 玩家点击社区注销账号按钮输入新的账号并登录成功时可捕捉该状�?，此时可初始化新玩家的游戏数�?
	             				LoginInfo login_info = new LoginInfo();
	             				
	             				
	             				login_info.account_uid_str = String.valueOf(rennClient.getUid());
	             				login_info.account_uid = rennClient.getUid();
	             				
	             				Log.i(Tag, ""+login_info.account_uid );
	             				
	             				login_info.login_session = "";
								try {
									login_info.account_nick_name = response.getResponseObject().getString("name");
								} catch (JSONException e) {
									// TODO Auto-generated catch block
									e.printStackTrace();
								}
	             				
								Log.i("account_nick_name", login_info.account_nick_name);
								login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
	             				notifyLoginResult(login_info);
	             				mCallback3.showWaitingViewImp(false, -1, "已登录");
	             				
	             				
	                         }
	                         
	                         @Override
	                         public void onFailed(String errorCode, String errorMessage) {
	                        	Toast.makeText(game_ctx, "登录失败",Toast.LENGTH_SHORT).show();

	     						LoginInfo login_info = new LoginInfo();
	     						login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
	     						notifyLoginResult(login_info);
	     						callback.showWaitingViewImp(false, -1, "登录失败 ");
	     						
	                         }
	                     });
	                 } catch (RennException e1) {
	                     // TODO Auto-generated catch block
	                     e1.printStackTrace();
	                 }
				
			}

			@Override
			public void onLoginCanceled() {
				Toast.makeText(game_ctx, "登录取消",Toast.LENGTH_SHORT).show();
				callback.showWaitingViewImp(false, -1, "");
			}
		});
		
		if(!rennClient.isLogin()){
			
			
			rennClient.login(game_ctx);
			// 玩家点击社区注销账号按钮输入新的账号并登录成功时可捕捉该状�?，此时可初始化新玩家的游戏数�?
				
		}else{
			rennClient.login(game_ctx);
			
		}
		 
		
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:notifyLoginResult");

		login_info = null;
		login_info = login_result;
		//
		if (login_result != null) {
			
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_RenRen+login_info.account_uid_str;
		//	Log.i("account_nick_name", login_result.account_nick_name);
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		Log.d(Tag, "PlatformRenRenLoginAndPay:getLoginInfo");
		if (login_info != null) {
			if (rennClient.isLogin())
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			else
				login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
		}
		return login_info;
	}

	@Override
	public void callLogout() {
		rennClient.logout();
		Log.d(Tag, "PlatformRenRenLoginAndPay:callLogout");
	}

	@Override
	public void callCheckVersionUpate() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:callCheckVersionUpate");
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
		Log.d(Tag, "PlatformRenRenLoginAndPay:callPayRecharge");
		
		payClient = RennPayClient.getInstance(game_ctx);
		payClient.init(String.valueOf(game_info.app_id),"nuclearrr1");
		 String product_name = pay_info.product_name;
         String appBid = pay_info.order_serial;
         int goodsCount = pay_info.count;
         int price =  (int) pay_info.price;
        
         this.pay_info = null;
         this.pay_info = pay_info;
         if(appBid == null){
             Toast.makeText(game_ctx, "流水号不能为空", Toast.LENGTH_SHORT).show();
         }
         if(product_name == null){
             Toast.makeText(game_ctx, "货物名称不能为空", Toast.LENGTH_SHORT).show();
         }
         if(price == 0 || goodsCount == 0){
             Toast.makeText(game_ctx, "价格或数量不能为0", Toast.LENGTH_SHORT).show();
         }
         
         /*********  begin pay  ***********/
         PayParam param = new PayParam();
         param.setAppBid(appBid);
         param.setAmount(price);
         
         param.addGoodsInfo(product_name, 1);
         param.addGoodsInfo("count",pay_info.count);
         param.addGoodsInfo(pay_info.description, 3);
         param.addGoodsInfo(pay_info.product_id,4);
         param.addGoodsInfo(login_info.account_uid_str,5);
        // param.setNotifyUrl("");
         payClient.pay(game_ctx, param, new PayListener() {
             
             @Override
             public void onPaySuccess() {
                 Toast.makeText(game_ctx, "支付订单提交成功", Toast.LENGTH_SHORT).show();
             }
             
             @Override
             public void onPayCancled() {
                 Toast.makeText(game_ctx, "支付订单提交失败", Toast.LENGTH_SHORT).show();
             }
         });
         
	        
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
		Log.d(Tag, "PlatformRenRenLoginAndPay:notifyPayRechargeRequestResult");
	}

	@Override
	public void callAccountManage() {
		Log.d(Tag, "PlatformRenRenLoginAndPay:callAccountManage");
		if (Cocos2dxHelper.nativeHasEnterMainFrame()) {
			Toast.makeText(game_ctx, "暂未开通", Toast.LENGTH_SHORT).show();
			return;
		}
		callLogout();
		callLogin();
	}

	@Override
	public String generateNewOrderSerial() {
		Log.d(Tag, "PlatformRenRenLoginAndPay:generateNewOrderSerial");
		// TODO Auto-generated method stub
		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:callPlatformFeedback");
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
		
		
		Log.d(Tag, "PlatformRenRenLoginAndPay:callPlatformSupportThirdShare");
	}

	@Override
	public void callPlatformGameBBS() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:callPlatformGameBBSinit");
	}

	@Override
	public void onGamePause() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:onGamePause");
	}

	@Override
	public void onGameResume() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:onGameResume");
	}

	@Override
	public void onGameExit() {
		// TODO Auto-generated method stub
		Log.d(Tag, "PlatformRenRenLoginAndPay:onGameExit");
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
