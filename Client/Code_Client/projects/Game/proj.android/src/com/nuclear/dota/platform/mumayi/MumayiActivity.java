package com.nuclear.dota.platform.mumayi;

import java.util.ArrayList;
import java.util.List;

import org.apache.http.HttpResponse;
import org.apache.http.NameValuePair;
import org.apache.http.client.HttpClient;
import org.apache.http.client.entity.UrlEncodedFormEntity;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.message.BasicNameValuePair;
import org.apache.http.util.EntityUtils;

import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.util.Log;
import android.widget.Toast;

import com.mumayi.paymentcenter.business.dao.onLoginListener;
import com.mumayi.paymentcenter.ui.pay.MMYInstance;
import com.mumayi.paymentcenter.ui.pay.MMYPayHome;
import com.mumayi.paymentcenter.ui.util.MyDialog;
import com.mumayi.paymentcenter.util.PaymentLog;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.LoginInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class MumayiActivity extends GameActivity implements onLoginListener{

	private static final int		CHECK_SUCCESS	= 0;
	private static final int		CHECK_ERROR		= 1;
	private static final int 		Login_TOKEN = 2;
	private static final int		Login_TOKEN_SUCCESS		= 3;
	private static final int		Login_TOKEN_FAILED		= 4;
	private static final int		Login_TOKEN_ERROR		= 5;
	
	
	public static  LoginAndPayHandler				mLoginAndPayHandler		= null;	
	private MyDialog				dialog			= null;
	private static final String TOKEN_URL = "http://pay.mumayi.com/user/index/validation";
	
	private Thread mTokenThread = null;
	public static String mUid = "";
	public static String mToken = "";
	public static String mSession;
	public static String mUserName;
	
	private LoginInfo mLoginInfo;
	
	/*
	 * 
	 * */
	public MumayiActivity()
	{
		/*
		 * */
		mLoginAndPayHandler = new LoginAndPayHandler();
		
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Mumayi);
		
	}
	
	
	private void sendMessage(int type)
	{
		mLoginAndPayHandler.sendEmptyMessage(type);
	}

	class LoginAndPayHandler extends Handler
	{

		@Override
		public void handleMessage(Message msg)
		{
			super.handleMessage(msg);
			switch (msg.what)
			{
				case Login_TOKEN:
					if (dialog != null)
					{
						dialog.dismiss();
						dialog = null;
					}
					
					if(msg.arg1==Login_TOKEN_SUCCESS)
					{
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
						login_info.account_uid_str = mUid;
						login_info.account_nick_name = mUserName;
						PlatformMumayiLoginAndPay.getInstance().notifyLoginResult(login_info);
					}else if(msg.arg1==Login_TOKEN_FAILED)
					{
						PlatformMumayiLoginAndPay.getInstance().callLoginGoto();
						
					}else if(msg.arg1==Login_TOKEN_ERROR)
					{
						LoginInfo login_info = new LoginInfo();
						login_info.login_result = PlatformAndGameInfo.enLoginResult_Failed;
						login_info.account_uid_str = "";
						login_info.account_nick_name = "";
						PlatformMumayiLoginAndPay.getInstance().notifyLoginResult(login_info);
					}
					
					break;
				case CHECK_ERROR:
					if (dialog != null)
					{
						dialog.dismiss();
						dialog = null;
					}
					PlatformMumayiLoginAndPay.getInstance().callLoginGoto();
					// 没有找到用户数据 这里可以选择使用木蚂蚁注册界面也可以使用开发者自己的，
					// 如果要用木蚂蚁定制界面则直接调用instance.go2Login()进入登录注册界面
					// 如果使用开发者自己的则在开发者的界面中调用注册接口
					break;

				case CHECK_SUCCESS:
					mTokenThread = new Thread(mTokenRun);
					mTokenThread.start();
					
					break;
				case 10000:
					String tradeInfo = msg.getData().getString("tradeInfo");
					Toast.makeText(MumayiActivity.this, tradeInfo, Toast.LENGTH_SHORT).show();
					break;
			}
		}
	}
	
	
	@Override
	public void onLoginFinish(String uname, String uid, String token, String session){
	
		PaymentLog.getInstance().d("成功  token>>" + token + "\n session>>" + session);
		// uname 是用户名， uid是用户ID ,token 是用来服务器验证登录，注册是不是成功，用seesion来解签,解签方法见文档
		// 所有注册，一键注册，登录的接口成功最后都会走这个回调接口
		// 在这里进入游戏
		mUid = uid;
		mToken = token;
		mSession = session;
		mUserName = uname;
		LoginInfo login_info = new LoginInfo();
		login_info.login_result = PlatformAndGameInfo.enLoginResult_Success;
		login_info.account_uid_str = mUid;
		login_info.account_nick_name = mUserName;
		PlatformMumayiLoginAndPay.getInstance().notifyLoginResult(login_info);
	}

	
	private Runnable mTokenRun = new Runnable() {

		@Override
		public void run() {
			String backStr = "";
			Message tokenMsg = new Message();
			tokenMsg.what = Login_TOKEN;
			try {
				backStr = sendPostRequest(mUid,mToken);
				
			} catch (Exception e) {
				Log.e("MumayiActivity", e.toString());
				//e.printStackTrace();
			}
			
			if(backStr.equals("success"))
			{
				tokenMsg.arg1 = Login_TOKEN_SUCCESS;
				mLoginAndPayHandler.sendMessage(tokenMsg);
			}else if(backStr.equals("fail"))
			{
				tokenMsg.arg1 = Login_TOKEN_FAILED;
				mLoginAndPayHandler.sendMessage(tokenMsg);
			}else if(backStr.endsWith("error"))
			{
				tokenMsg.arg1 = Login_TOKEN_ERROR;
				mLoginAndPayHandler.sendMessage(tokenMsg);
			}
		}
	};
	
	interface MyLoginCallback {
		public void onSuccess(String strUid);
		public void onFailed(String strUid);
	}
	
	
	/**
	 * 发送请求验证token
	 * @throws Exception
	 */
	public  String sendPostRequest(String _uid,String _token) throws Exception {
		HttpClient client = new DefaultHttpClient();
		HttpPost post= new HttpPost(TOKEN_URL);
		String result;
		List<NameValuePair> paramList = new ArrayList<NameValuePair>(); 
        BasicNameValuePair param = new BasicNameValuePair("token",mToken);
        BasicNameValuePair param1 = new BasicNameValuePair("uid",mUid);
        paramList.add(param);
        paramList.add(param1);
        post.setEntity(new UrlEncodedFormEntity(paramList));   
        HttpResponse httpResponse =  client.execute(post);
        
        if(httpResponse.getStatusLine().getStatusCode() == 200)
        { 
        	 result = EntityUtils.toString(httpResponse.getEntity());
        }else
        {
        	 result = "error";
        }
		
		
		return result;
	}
	
	
	
	/*
	 * (non-Javadoc)
	 * @see com.mumayi.paymentcenter.business.dao.onLoginCallback#onLoginOut(java.lang.String)
	 */
	@Override
	public void onLoginOut(String arg0)
	{
		if (arg0.equals("success"))
		{
			// 注销成功
			PaymentLog.getInstance().d("注销成功噢>>" + arg0);
		}
		else
		{
			// 注销失败
			PaymentLog.getInstance().d("注销成功噢>>" + arg0);
		}
		
		
	}
	
	
	
	

	
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data)
	{
		// TODO Auto-generated method stub
		super.onActivityResult(requestCode, resultCode, data);
		
		if (requestCode == MMYInstance.PAY_RESULT_REQUEST)
		{
			// 如果返回的是空值
			if (null == data)
			{
				return;
			}
			// 可在此处获取到提交的商品信息
			android.os.Bundle bundle = data.getExtras();
			String orderId = "";
			String productName = "";
			String productPrice = ""; // 产品价格
			String productDesc = "";
			String payType = "";
			try
			{
				payType = MMYPayHome.PAY_TYPE;
				orderId = bundle.getString("orderId");
				productName = bundle.getString("productName");
				productPrice = bundle.getString("productPrice");
				productDesc = bundle.getString("productDesc");
			} catch (Exception e)
			{
				e.printStackTrace();
			}
			if (resultCode == MMYInstance.PAY_RESULT_SUCCESS || resultCode == 10)
			{
				PaymentLog.getInstance().d("支付成功");
				if (payType.equals("3"))// mo9支付
				{
					// mo9支付下，如果是单机游戏，直接根据上述支付信息即可完成操作
					// 如果是网络游戏，则在此提醒用户充值成功即可，给用户金币或道具在服务器操作
					Toast.makeText(this, productName + " 支付成功,支付金额：" + productPrice + "元", 0).show();
				}
				else if (payType.equals("2"))
				{

					// 因为运营商的通道费，微派支付真正实际充值的金额只有充值金额的一半 比如充值2元，实际只能充值1元
					// 在这里要做好相应的操作，避免给用户发放错误的金币或道具
					double actualPay = Double.valueOf(productPrice) * 2;
					Toast.makeText(this, productName + " 支付成功,支付金额：" + actualPay + "元，实际充值为" + productPrice, 0).show();
				}
				else
				// 其它支付
				{
					Toast.makeText(this, productName + " 支付成功,支付金额：" + productPrice, 0).show();
					// 在此添加支付成功时的处理操作
				}
			}
			else if (resultCode == MMYInstance.PAY_RESULT_FAILED)
			{
				PaymentLog.getInstance().d("支付失败");
				Toast.makeText(this, productName + " 支付失败", 0).show();
				// 在此添加支付失败时的处理操作
			}
		}
	}
	
	
}

