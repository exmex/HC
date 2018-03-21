package com.nuclear.dota.platform.nearme.gamecenter;

import org.cocos2dx.lib.Cocos2dxHelper;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.content.pm.PackageManager.NameNotFoundException;
import android.os.Bundle;
import android.widget.Toast;
import android.app.AlertDialog;
import android.app.AlertDialog.Builder;
import android.content.DialogInterface;
import android.content.DialogInterface.OnClickListener;

import com.nearme.gamecenter.open.api.ApiCallback;
import com.nearme.gamecenter.open.api.GameCenterSDK;
import com.nearme.gamecenter.open.api.GameCenterSettings;
import com.nearme.oauth.model.UserInfo;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;
import com.nuclear.dota.Config;

public class OppoActivity extends GameActivity {
	public OppoActivity()
	{
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Oppo);
	}
	
	private boolean doInitWeChat = false;
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		GameCenterSettings gameCenterSettings = new GameCenterSettings(
				mGameCfg.mGameInfo.app_key, mGameCfg.mGameInfo.app_secret) {
			
			@Override
			public void onForceReLogin() {
				// sdk由于某些原因登出,此方法通知cp,cp需要在此处清理当前的登录状态并重新请求登录.
				// 可以发广播通知页面重新登录
			}
			
			@Override 
			public void onForceUpgradeCancel() {
				// 游戏自升级，后台有设置为强制升级，用户点击取消时的回调函数。
				// 若开启强制升级模式 ，  一般要求不更新则强制退出游戏并杀掉进程。
				// System.exit(0) or kill this process
				System.exit(0);
			}

		};
		GameCenterSettings.isDebugModel = true;// 测试log开关
		GameCenterSettings.isOritationPort = true;// 控制SDK activity的横竖屏 true为竖屏
		// 游戏自身 虚拟货币和人民币的 汇率  当申请的支付类型为人民币直冲时将起作用
		//GameCenterSettings.rate = "100"; // 1元人民币兑换1000虚拟货币
		GameCenterSDK.init(gameCenterSettings, this);
		
		if(doInitWeChat==false)
		{
			ApplicationInfo appInfo = null;
			try {
				appInfo = this.getPackageManager().getApplicationInfo(this.getPackageName(),PackageManager.GET_META_DATA);
			} catch (NameNotFoundException e) {
		
			}
		
			if(appInfo!=null && appInfo.metaData != null)
			{
				String WX_APP_ID = appInfo.metaData.getString("WX_APP_ID");
				if(WX_APP_ID!=null)
				{
				Config.WX_APP_ID = WX_APP_ID;
				}
			}
			
			doInitWeChat = true;
		}
		if(null!=Config.WX_APP_ID && !Config.WX_APP_ID.equals("")){
			api = WXAPIFactory.createWXAPI(this, Config.WX_APP_ID, false);
			api.registerApp(Config.WX_APP_ID);// 将该app注册到微信
		}
		
    }
	
	@Override
	public void onResume(){
		super.onResume();
		GameCenterSDK.getInstance().doShowSprite(new ApiCallback() {
			
			@Override
			public void onSuccess(String content, int code) {
				// TODO Auto-generated method stub
				if(Cocos2dxHelper.nativeHasEnterMainFrame())
				{
	    			AlertDialog.Builder builder = new Builder(OppoActivity.this);
	    			builder.setMessage("游戏中切换账号需重启游戏");
	    			builder.setTitle("提示");
	    			builder.setPositiveButton("确认", new OnClickListener() {
	    				@Override
	    				public void onClick(DialogInterface dialog, int which) {
	    					// TODO Auto-generated method stub
	    					GameActivity.requestRestart();
	    				}
	    			});
	    			builder.create().show();
				}else{
					GameCenterSDK.getInstance().doGetUserInfo(new ApiCallback() {
						@Override
						public void onSuccess(String content, int code) {
							UserInfo ui = new UserInfo(content);
							
							Toast.makeText(OppoActivity.this,"登录成功", Toast.LENGTH_SHORT).show();

							LoginInfo login_info = new LoginInfo();
							login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
							login_info.account_uid_str = ui.id;
							login_info.account_nick_name = ui.nickname;

							PlatformOppoLoginAndPay.getInstance().isLogined = true;
							PlatformOppoLoginAndPay.getInstance().notifyLoginResult(login_info);
						}

						@Override
						public void onFailure(String content, int code) {
							Toast.makeText(OppoActivity.this,
									"获取用户信息失败:" + content, Toast.LENGTH_SHORT).show();

						}
					}, OppoActivity.this);
				}
			}
			
			@Override
			public void onFailure(String content, int code) {
				// TODO Auto-generated method stub
				Toast.makeText(OppoActivity.this, "切换账号失败", Toast.LENGTH_SHORT).show();
			}
		}, OppoActivity.this);
	}
	
	
	@Override
	public void onPause(){
		super.onPause();
		GameCenterSDK.getInstance().doDismissSprite(OppoActivity.this);
	}

}
