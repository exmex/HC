
/*
 * utf-8
 * */

package com.nuclear.dota.platform.qihoo360;

import java.util.UUID;

import org.cocos2dx.lib.Cocos2dxHelper;

import android.app.Activity;
import android.app.ProgressDialog;
import android.content.DialogInterface;
import android.content.DialogInterface.OnCancelListener;
import android.graphics.BitmapFactory;
import android.renderscript.Sampler.Value;
import android.util.Log;
import android.widget.Toast;

import com.nuclear.IGameActivity;
import com.nuclear.IPlatformLoginAndPay;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.PlatformAndGameInfo.PayInfo;
import com.nuclear.PlatformAndGameInfo.ShareInfo;
import com.nuclear.PlatformAndGameInfo.VersionInfo;
import com.nuclear.dota.GameInterface.IGameAppStateCallback;
import com.nuclear.dota.GameInterface.IGameUpdateStateCallback;
import com.nuclear.dota.GameInterface.IPlatformSDKStateCallback;
import com.nuclear.dota.platform.qihoo360.bean.QihooPayInfo;
import com.nuclear.dota.platform.qihoo360.bean.QihooUserInfo;
import com.nuclear.dota.platform.qihoo360.bean.TokenInfo;
import com.nuclear.dota.platform.qihoo360.utils.ProgressUtil;



public class Platform360LoginAndPay extends SdkUserBaseActivity 
					implements IPlatformLoginAndPay {
	
	private static final String TAG = Platform360LoginAndPay.class.getSimpleName();
	
	private IGameActivity 				mGameActivity;
	private IPlatformSDKStateCallback	mCallback1;
	private IGameUpdateStateCallback	mCallback2;
	private IGameAppStateCallback		mCallback3;
	
	private Activity 					game_ctx = null;
	private GameInfo 					game_info = null;
	private LoginInfo 					login_info = null;
	private VersionInfo 				version_info = null;
	private PayInfo 					pay_info = null;
	
	//登录返回解析得到的信息数
	private TokenInfo mTokenInfo;
    private QihooUserInfo mQihooUserInfo;
    private ProgressDialog mProgress;
    
	private static Platform360LoginAndPay sInstance = null;
	public static Platform360LoginAndPay getInstance() {
		if (sInstance == null) {
			sInstance = new Platform360LoginAndPay();
		}
		return sInstance;
	}
	
	private Platform360LoginAndPay() {
		
	}
	
	/*
	 * 返回值：
	 * -1：标示本SDK的init内部会切换view
	 * 0：标示本SDK的init内部不会切换view，也不需要单独指定显示平台logo的view，沿用GameLogo即可
	 * 其他值：是一个R.layout.value，标示本SDK的init内部不会切换view，但�?��单独指定显示平台logo的view layout
	 * */
	public int getPlatformLogoLayoutId()
	{
		return 0;
	}
	
	@Override
	public void onLoginGame() {

	}
	
	@Override
	public void init(IGameActivity game_acitivity, GameInfo game_info) {
		
		mGameActivity = game_acitivity;
		this.game_ctx = game_acitivity.getActivity();
		this.game_info = game_info;
		this.game_info.debug_mode = PlatformAndGameInfo.enDebugMode_Release;
		this.game_info.screen_orientation  = PlatformAndGameInfo.enScreenOrientation_Portrait;
		super.setActivityContext(game_ctx);
		mCallback1.notifyInitPlatformSDKComplete();
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
		
		Platform360LoginAndPay.sInstance = null;
	}

	@Override
	public GameInfo getGameInfo() {
		return this.game_info;
	}

	@Override
	public void callLogin() {
		
		Log.d(TAG, "callLogin");
		
		mCallback3.showWaitingViewImp(true, -1, "正在登录");
		super.doSdkLogin(false);
		mCallback3.showWaitingViewImp(false, -1, "正在登录");
	}

	@Override
	public void notifyLoginResult(LoginInfo login_result) {
		
		login_info = null;
		login_info = login_result;
		if (login_result != null) {
			login_info.account_uid_str = PlatformAndGameInfo.enPlatformShort_360+login_info.account_uid_str;
			Toast.makeText(game_ctx, "登录成功，点击进入游戏", Toast.LENGTH_SHORT).show();
			mCallback3.notifyLoginResut(login_result);
		}
	}

	@Override
	public LoginInfo getLoginInfo() {
		if (login_info != null) {
			
		}
		return login_info;
	}

	@Override
	public void callLogout() {
        mTokenInfo = null;
        mQihooUserInfo = null;
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
    protected QihooPayInfo getQihooPayInfo(boolean isFixed) {
        QihooPayInfo payInfo = null;
        if (isFixed) {
            payInfo = getQihooPay(Constants.DEMO_FIXED_PAY_MONEY_AMOUNT);
        }
        else {
            payInfo = getQihooPay(Constants.DEMO_NOT_FIXED_PAY_MONEY_AMOUNT);
        }

        return payInfo;
    }
    
    /***
     * @param moneyAmount 金额数，使用者可以自由设定数额。金额数为100的整数倍，360SDK运行定额支付流程；
     *            金额数为0，360SDK运行不定额支付流程。
     * @return QihooPay
     */
    private QihooPayInfo getQihooPay(String moneyAmount) {
        // 创建QihooPay
        QihooPayInfo qihooPay = new QihooPayInfo();

        // 登录得到AccessToken和UserId，用于支付。
        String accessToken = this.login_info.login_session;
        String qihooUserId = Long.toString(this.login_info.account_uid);

        qihooPay.setAccessToken(accessToken);
        qihooPay.setQihooUserId(qihooUserId);

        qihooPay.setMoneyAmount(String.valueOf((int)pay_info.price*100));
        qihooPay.setExchangeRate("10");

        qihooPay.setProductName(pay_info.product_name);
        qihooPay.setProductId(pay_info.product_id);

        qihooPay.setNotifyUri(Constants.DEMO_APP_SERVER_NOTIFY_URI);

        qihooPay.setAppName("刀塔传奇2");
        qihooPay.setAppUserName(this.login_info.account_nick_name);
        qihooPay.setAppUserId(this.login_info.account_uid_str);

        // 可选参数
        qihooPay.setAppExt1(this.pay_info.description);
        qihooPay.setAppExt2(this.pay_info.product_name);
        qihooPay.setAppOrderId(this.pay_info.order_serial);

        return qihooPay;
    }

	@Override
	public int callPayRecharge(PayInfo pay_info) {

		this.pay_info = null;
		this.pay_info = pay_info;

		super.doSdkPay(mIsLandscape, true, false);
		return 0;
	}

	@Override
	public void notifyPayRechargeRequestResult(PayInfo pay_info) {
		mCallback3.notifyPayRechargeResult(pay_info);
	}
	
	@Override
	public void callAccountManage() {
		if (Cocos2dxHelper.nativeHasEnterMainFrame())
		{
			mGameActivity.showToastMsg("暂未开通,敬请期待!");
			return;
		}
		super.doSdkSwitchAccount(false);
	}

	@Override
	public String generateNewOrderSerial() {
		return UUID.randomUUID().toString();
	}

	@Override
	public void callPlatformFeedback() {
		super.doSdkCustomerService(false);
	}

	@Override
	public void callPlatformSupportThirdShare(ShareInfo share_info) {
		
		if (share_info.bitmap == null) {
			share_info.bitmap = BitmapFactory.decodeFile(share_info.img_path);
		}
		
		
	}
	
	@Override
	public void callPlatformGameBBS() {
		super.doSdkBBS(false);
	}

	@Override
	public void setPlatformSDKStateCallback(IPlatformSDKStateCallback callback1) {
		mCallback1 = callback1;
	}

	@Override
	public void setGameUpdateStateCallback(IGameUpdateStateCallback callback2) {
		mCallback2 = callback2;
	}

	@Override
	public void setGameAppStateCallback(IGameAppStateCallback callback3) {
		mCallback3 = callback3;
	}

	@Override
	public int isSupportInSDKGameUpdate() {
		return PlatformAndGameInfo.DoNotSupportUpdate;
	}

	@Override
	public void onGameExit() {
		super.doSdkQuit(false);
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
	public void onGotUserInfo(QihooUserInfo userInfo)
	{
		ProgressUtil.dismiss(mProgress);

        if (userInfo != null && userInfo.isValid()) {
            // 保存QihooUserInfo
            mQihooUserInfo = userInfo;

            LoginInfo login_info = new LoginInfo();
            login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
            login_info.account_uid = Integer.parseInt(mQihooUserInfo.getQid());//qihoo user id
            login_info.account_uid_str = mQihooUserInfo.getQid();//will change at notifyLoginResult
            login_info.account_nick_name = mQihooUserInfo.getName();
            login_info.account_user_name = mQihooUserInfo.getNick();
            login_info.login_session = mTokenInfo.getAccessToken();
            
            notifyLoginResult(login_info);

        } else {
            Toast.makeText(game_ctx, R.string.get_user_fail, Toast.LENGTH_LONG).show();
        }
	}

	@Override
	public void onGotTokenInfo(TokenInfo tokenInfo)
	{
		// 这里是TokenInfoTask.doRequest的回�?
		if (tokenInfo == null || !tokenInfo.isValid()) {
            ProgressUtil.dismiss(mProgress);
            Toast.makeText(game_ctx, R.string.get_token_fail, Toast.LENGTH_LONG).show();
        } else {
            // 保存TokenInfo
            mTokenInfo = tokenInfo;
            // 提示用户进度
            ProgressUtil.setText(mProgress, game_ctx.getString(R.string.get_user_title), 
            		game_ctx.getString(R.string.get_user_message), new OnCancelListener() {
                
                @Override
                public void onCancel(DialogInterface dialog) {

                }
            });
            super.doSdkQueryUserInfo(tokenInfo.getAccessToken());
        }
	}
}
