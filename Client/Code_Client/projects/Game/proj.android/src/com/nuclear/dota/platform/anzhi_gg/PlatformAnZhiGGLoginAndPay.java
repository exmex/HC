package com.nuclear.dota.platform.anzhi_gg;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.anzhi.usercenter.sdk.AnzhiCallback;
import com.anzhi.usercenter.sdk.AnzhiUserCenter;
import com.anzhi.usercenter.sdk.OfficialLoginCallback;
import com.anzhi.usercenter.sdk.item.CPInfo;
import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.FeedBackDialog;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.LastLoginHelp;
import com.nuclear.dota.Config;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;
import com.qsds.ggg.dfgdfg.fvfvf.R;


public class PlatformAnZhiGGLoginAndPay implements IPlatformLoginAndPay {
	
	private static String TAG=PlatformAnZhiGGLoginAndPay.class.getSimpleName();
	
	private IGameActivity                               mGameActivity;
	private IPlatformSDKStateCallback                   mCallback1;
	private IGameUpdateStateCallback                    mCallback2;
	private IGameAppStateCallback                       mCallback3;
	
	private Activity                                   game_ctx = null;
	private GameInfo                                    game_info = null;
	private LoginInfo                                   login_info = null;
	private VersionInfo                                 version_info = null;
	private PayInfo                                     pay_info = null;
	private boolean                                     isLogin = false;
	
	private  AnzhiUserCenter center;
	
	private static PlatformAnZhiGGLoginAndPay sInstance = null;
	public static PlatformAnZhiGGLoginAndPay getInstance(){
		if(sInstance == null){
			sInstance = new PlatformAnZhiGGLoginAndPay();
		}
		return sInstance;
	}
	@Override
	public void onLoginGame() {
		// TODO Auto-generated method stub
		
	}
	
	@Override
	public void init(IGameActivity game_ctx, GameInfo game_info) {
		// TODO Auto-generated method stub
		
		mGameActivity = game_ctx;
		this.game_ctx = game_ctx.getActivity();
		this.game_info = game_info;
		
		game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation = PlatformAndGameInfo.enScreenOrientation_Portrait;
		this.game_info.platform_type_str = PlatformAndGameInfo.enPlatformName_AnZhiGG;
		this.game_info.platform_type = PlatformAndGameInfo.enPlatform_AnZhiGG;
		
		final CPInfo info = new CPInfo();
//		final CPAppInfo info = new CPAppInfo();
		
		info.setAppKey(game_info.app_key); 
		info.setSecret(game_info.app_secret); 
		info.setChannel(PlatformAndGameInfo.enPlatformName_AnZhiGG); 
		info.setGameName("刀塔传奇2");
		info.setOpenOfficialLogin(false);    //是否开启官方账号登录功能，默认为关闭 
		center = AnzhiUserCenter.getInstance();//(this.game_ctx);
		center.setCPInfo(info);
		
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
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public int getPlatformLogoLayoutId() {
		// TODO Auto-generated method stub
		return R.layout.logo_anzhi;
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
		
		this.isLogin = false;
		
		
		//
		//
		PlatformAnZhiGGLoginAndPay.sInstance = null;
		
		//AnzhiUserCenter.getInstance().logout(game_ctx);
	}

	@Override
	public GameInfo getGameInfo() {
		// TODO Auto-generated method stub
		return this.game_info;
	}
	
	 Handler mHandler = new Handler() {

	        @Override
	        public void handleMessage(Message msg) {
	            switch (msg.what) {
	            case 0:
	            	
	                break;
	            case 1:
	                Toast.makeText(PlatformAnZhiGGLoginAndPay.getInstance().game_ctx, (String) msg.obj, Toast.LENGTH_SHORT).show();
	                break;
	            case 2:
	                center.login(game_ctx);
	                break;
	            }
	        }
	    };

	@Override
	public void callLogin() {
		// TODO Auto-generated method stub
		/**
		 * 跳转到sdk登陆界面
		 */
		final IGameAppStateCallback callback = mCallback3;
		callback.showWaitingViewImp(false, -1, "");
			
			if(isLogin){
				center.setCallback(mCallback);
				center.setOfficialCallback(mOfficialCall);
				//center.viewUserInfo(game_ctx);
				return;
			}

			 center.setCallback(mCallback);
			 center.setOfficialCallback(mOfficialCall);
			 new Thread() {
		            public void run() {
		                try {
		                    Thread.sleep(1000);
		                } catch (InterruptedException e) {
		                    e.printStackTrace();
		                }
		                if (PlatformAnZhiGGLoginAndPay.getInstance().game_ctx.isFinishing()) {
		                    return;
		                }
		                mHandler.obtainMessage(2, center).sendToTarget();
		            }
		        }.start();
	}
	
AnzhiCallback mCallback = new AnzhiCallback() {
		
		@Override
		public void onCallback(final CPInfo cpInfo, final String result) {
			mHandler.post(new Runnable(){
				@Override
				public void run() {
					// TODO Auto-generated method stub
					 try {
			                JSONObject json = new JSONObject(result);
							Log.e("AAAAAAAAAAAAAAAAA", "json = " + json.toString());
			                String key = json.optString("callback_key");
			                if ("key_login".equals(key)) {
			                    int code = json.optInt("code");
			                    String desc = json.optString("code_desc");
			                    String sid = json.optString("sid");
			                    String uid = json.optString("uid");
			                    String login_name = json.optString("login_name");
			                    if (code == 200) {

			                    	//登陆成功
			                    	LoginInfo login_info = new LoginInfo();
			        				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
			        				login_info.login_session = sid;
			        				login_info.account_uid_str = uid;
			        				login_info.account_nick_name = login_name;
			        				
			        				Log.i("INFO", login_info.account_uid_str+":ppppppppppppppppppp");
			        				
			        				isLogin = true;
			        				PlatformAnZhiGGLoginAndPay.getInstance().notifyLoginResult(login_info);
			        				return;
			                    } else {
			                    	mGameActivity.showToastMsg(desc);
			                        mHandler.obtainMessage(1, desc);
			                    }
			                }
			                else if("key_pay".equals(key))
			                {
			                	int code = json.optInt("code");
		                        String desc = json.optString("desc");
		                        String orderId = json.optString("order_id");
		                        String price = json.optString("price");
		                        String time = json.optString("time");
		                        Log.e("anzhi_sdk", "code = " + code);
		                        if (code == 200) {
		                            Log.e("anzhi_sdk", "支付成功 ,订单号: " + orderId + " 金额: " + price + " 时间: " + time);
		                            mGameActivity.showToastMsg("支付成功 \n订单号: " + orderId + "\n金额: " + price + "\n时间: " + time);
		                            PlatformAnZhiGGLoginAndPay.getInstance().pay_info.result = 0;
		                            PlatformAnZhiGGLoginAndPay.getInstance().notifyPayRechargeRequestResult(PlatformAnZhiGGLoginAndPay.getInstance().pay_info);
		                        } else {
		                            Log.e("anzhi_sdk", "支付失败 ,订单号: " + orderId + " 金额: " + price + " 时间: " + time);
		                            mGameActivity.showToastMsg(desc);
		                        }
			                }
			                else if("key_logout".equals(key))
			                {
			                	callLogout();
			                	
			                	if(Cocos2dxHelper.nativeHasEnterMainFrame())
			            		{
			                		GameActivity.requestRestart();
			            		}
			            		else
			            		{
			            			 Log.e("anzhi_sdk", "logout");
				                	 center.viewUserInfo(game_ctx);
			            		}
			                }
			            } catch (JSONException e) {
			                e.printStackTrace();
			            }
				}
			});
		}
	};
	
	//官方登录（可选）
OfficialLoginCallback mOfficialCall = new OfficialLoginCallback() {
	        
	    	String sessiontoken = null;
	    	
	        @Override
	        public void onOfficialLoginResult(String result) {
	            //result内容： 
//	        	{”callback_key”:”key_login”, 
//	        	”ver”:”1.0”, 
//	        	”code”:状态码,200登录成功，非200登录失败, 
//	        	”code_desc”:状态描述信息”, 
//	        	”sid”:”sid” } 
	        	JSONObject json;
				try {
					json = new JSONObject(result);
					Log.e("AAAAAAAAAAAAAAAAA", "json = " + json.toString());
					String key = json.optString("callback_key");
					 if ("key_login".equals(key)) {
		                    int code = json.optInt("code");
		                    String desc = json.optString("code_desc");
		                    String sid = json.optString("sid");
		                    String uid = json.optString("uid");
		                    String login_name = json.optString("nick_name");
		                    Log.i("DDDDDDDDDDDD", "code:"+code);
		                    if(code == 200)
		                    {
		                    	//登陆成功
		                    	LoginInfo login_info = new LoginInfo();
		        				login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
		        				login_info.login_session = sid;
		        				login_info.account_uid_str = uid;
		        				login_info.account_nick_name =login_name+"更换账号";
		        				
		        				Log.i("INFO", login_info.account_uid_str+":ppppppppppppppppppp:::"+sessiontoken);
		        				
		        				isLogin = true;
		        				PlatformAnZhiGGLoginAndPay.getInstance().notifyLoginResult(login_info);
		        				
		        				return;
		                    }
		                    else
		                    {
		                    	mGameActivity.showToastMsg(desc);
		                    }
					 }
				} catch (JSONException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
	        }
	        
	        @Override
	        public String login(String user, String password) {
	            try {
	                Thread.sleep(2000);
	            } catch (InterruptedException e) {
	                e.printStackTrace();
	            }
	            return sessiontoken;
	        }
	    };

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		// TODO Auto-generated method stub
		this.login_info = null;
		this.login_info = login_result;
		//
		if (login_result != null) {
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_AnZhiGG+login_info.account_uid_str;
			mGameActivity.showToastMsg("登录成功，点击进入游戏");
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
		isLogin = false;
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
		int aError = 0;
		this.pay_info = null;
		this.pay_info = pay_info;
		
		String callBackInfo = pay_info.description + "-" + pay_info.product_id + "-" + this.login_info.account_uid_str;//区号-物品ID-ouruserid
		center.pay(game_ctx, Integer.parseInt(this.pay_info.description), this.pay_info.price, this.pay_info.product_name, callBackInfo);
		center.setCallback(mCallback);
		return aError;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		// TODO Auto-generated method stub
		mCallback3.notifyPayRechargeResult(pay_info);
	}

	@Override
	public void callAccountManage() {
		// TODO Auto-generated method stub
		center.viewUserInfo(game_ctx);
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
