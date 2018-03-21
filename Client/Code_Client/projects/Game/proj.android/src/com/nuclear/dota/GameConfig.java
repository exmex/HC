
package com.nuclear.dota;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Properties;

import org.json.JSONException;
import org.json.JSONObject;

import android.text.TextUtils;
import android.util.Log;

import com.nuclear.IGameActivity;
import com.nuclear.PlatformAndGameInfo;
import com.nuclear.PlatformAndGameInfo.GameInfo;



public class GameConfig
{
	/*
	 * 
	 * */
	public GameConfig(IGameActivity gameActivity, final int platform_type)
	{
		long start = System.currentTimeMillis();
		
		mGameActivity = gameActivity;
		mGameInfo = new GameInfo();
		
		mGameInfo.platform_type = platform_type;
		mGameInfo.platform_type_str = PlatformAndGameInfo.getPlatformTypeStr(platform_type);
		loadGameConfig();

		String jstr = GameConfig.nativeReadGamePlatformInfo(platform_type);
		parseGamePlatformInfo(jstr);
		//调用initPush
		PushLastLoginHelp.initPushHeader(mGameInfo.platform_type_str);
		//
		long end = System.currentTimeMillis();
		long span = end - start;
		Log.e("GameConfig",
				"GameConfig cost time: "
						+ span + " millis");
	}
	/*
	 * not use
	 * */
	public static native int nativeReadGameAppID(int platformType);
	public static native String nativeReadGameAppKey(int platformType);
	public static native String nativeReadGameAppSecret(int platformType);
	/*
	 * using
	 * 返回json格式的字符串，具体解析各个platformType不同
	 * */
	public static native String nativeReadGamePlatformInfo(int platformType);
	/*
	 * 
	 * */
	private void parseGamePlatformInfo(String infoStr)
	{
		if (!TextUtils.isEmpty(infoStr)) {
			
			try {
				
                JSONObject dataJsonObj = new JSONObject(infoStr);
			
				if (mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_91 || 
						mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_XiaoMi || 
						mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_WanDouJia || 
						mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_XiaoMi_hd)
				{
	                mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
				}
				else if (mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_UC || 
							mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_DangLe)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.cp_id = dataJsonObj.getInt("cpid");
	                mGameInfo.svr_id = dataJsonObj.getInt("svrid");
				}
				else if (mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_BaiduDuoKu || 
						mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_RenRen )
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_League)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_YingYongHui)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.pay_addr = dataJsonObj.getString("payaddr");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_AnZhi)
				{
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_JinShan)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Game4399)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_KuWo)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_BaiDuGame)
				{
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Oppo
						||mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Keke)
				{
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
					mGameInfo.pay_addr = dataJsonObj.getString("payaddr");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_LvDouGame)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.pay_addr = dataJsonObj.getString("payaddr");
				}else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_ChuKong)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_GTV)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
	                mGameInfo.svr_id = dataJsonObj.getInt("svrid");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_ChuKong)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_XunLei)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_id_str = dataJsonObj.getString("cpid");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_KuGou)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
					mGameInfo.gameid = dataJsonObj.getInt("gameid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_HuaWei)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.cp_id_str = dataJsonObj.getString("cpid");
					mGameInfo.app_secret = dataJsonObj.getString("buoykey");
					mGameInfo.pay_id_str = dataJsonObj.getString("payid");
					mGameInfo.private_str = dataJsonObj.getString("private");
					mGameInfo.public_str = dataJsonObj.getString("public");
					mGameInfo.pay_addr = dataJsonObj.getString("payaddr");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_SouGou)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
					mGameInfo.pay_addr = dataJsonObj.getString("payaddr");
				}else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Ydmm)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
	                mGameInfo.pay_id_str = dataJsonObj.getString("payid");
	                mGameInfo.private_str = dataJsonObj.getString("private");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_BaiDuMobileGame)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.pay_addr = dataJsonObj.getString("payaddr");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_CMGE)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Pipaw)
				{
					mGameInfo.cp_id=dataJsonObj.getInt("cpid");
					mGameInfo.gameid=dataJsonObj.getInt("gameid");
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.private_str=dataJsonObj.getString("privateKey");
					
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Nduo)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("waresid");
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}else if(mGameInfo.platform_type==PlatformAndGameInfo.enPlatform_Lenovo){
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.pay_id_str = dataJsonObj.getString("pay_id_str");
					mGameInfo.public_str=dataJsonObj.getString("public_str");
					mGameInfo.pay_addr=dataJsonObj.getString("payaddr");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Oupeng)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Sjyx){
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
				}
				else if (mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Sqwan){
				
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_AnZhiGG)
				{
					mGameInfo.app_key = dataJsonObj.getString("appkey");
					mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Meizu)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_TianYi)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.app_secret = dataJsonObj.getString("appsecret");
	                mGameInfo.pay_id_str = dataJsonObj.getString("pay_id_str");
	                mGameInfo.private_str = dataJsonObj.getString("privateKey");
				}else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Sqw){
					mGameInfo.app_id = dataJsonObj.getInt("appid");
		            mGameInfo.app_key = dataJsonObj.getString("appkey");
		            mGameInfo.app_secret = dataJsonObj.getString("appsecret");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_JorGame)
				{
					mGameInfo.app_id_str = dataJsonObj.getString("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.private_str = dataJsonObj.getString("private");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Jinli)
				{
					 
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Game2324)
				{
					mGameInfo.app_id = dataJsonObj.getInt("appid");
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.cp_id = dataJsonObj.getInt("cpid");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_FiveOne)
				{
	                mGameInfo.app_key = dataJsonObj.getString("appkey");
	                mGameInfo.public_str = dataJsonObj.getString("publicKey");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Mumayi)
				{
					mGameInfo.app_key = dataJsonObj.getString("appkey");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_GoogleFT)
				{
					 mGameInfo.app_id_str = dataJsonObj.getString("appid");
		             mGameInfo.app_key = dataJsonObj.getString("appkey");
		             mGameInfo.app_secret = dataJsonObj.getString("appsecret");
		             mGameInfo.pay_addr = dataJsonObj.getString("rechargeurl");
		             mGameInfo.public_str = dataJsonObj.getString("public_str");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_GoogleNUS)
				{
					 mGameInfo.app_id_str = dataJsonObj.getString("appid");
		             mGameInfo.app_key = dataJsonObj.getString("appkey");
		             mGameInfo.app_secret = dataJsonObj.getString("appsecret");
		             mGameInfo.pay_addr = dataJsonObj.getString("rechargeurl");
		             mGameInfo.public_str = dataJsonObj.getString("public_str");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_GoogleGER)
				{
					 mGameInfo.app_id_str = dataJsonObj.getString("appid");
		             mGameInfo.app_key = dataJsonObj.getString("appkey");
		             mGameInfo.app_secret = dataJsonObj.getString("appsecret");
		             mGameInfo.pay_addr = dataJsonObj.getString("rechargeurl");
		             mGameInfo.public_str = dataJsonObj.getString("public_str");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_GoogleENG)
				{
					 mGameInfo.app_id_str = dataJsonObj.getString("appid");
		             mGameInfo.app_key = dataJsonObj.getString("appkey");
		             mGameInfo.app_secret = dataJsonObj.getString("appsecret");
		             mGameInfo.pay_addr = dataJsonObj.getString("rechargeurl");
		             mGameInfo.public_str = dataJsonObj.getString("public_str");
		   
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_GoogleKOR)
				{
					 mGameInfo.app_id_str = dataJsonObj.getString("appid");
		             mGameInfo.app_key = dataJsonObj.getString("appkey");
		             mGameInfo.app_secret = dataJsonObj.getString("appsecret");
		             mGameInfo.pay_addr = dataJsonObj.getString("rechargeurl");
		             mGameInfo.public_str = dataJsonObj.getString("public_str");
		   
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Vivo){
					
					mGameInfo.app_id = dataJsonObj.getInt("appid");
					mGameInfo.app_key = dataJsonObj.getString("storekey"); 
					mGameInfo.app_secret = dataJsonObj.getString("storeid"); 
					mGameInfo.pay_addr = dataJsonObj.getString("payaddr");
				}
				else if(mGameInfo.platform_type == PlatformAndGameInfo.enPlatform_Kupai)
				{
					 mGameInfo.app_id = dataJsonObj.getInt("appid");
		             mGameInfo.app_key = dataJsonObj.getString("appkey");
		             mGameInfo.app_secret=dataJsonObj.getString("appsecret");
		             mGameInfo.app_id_str=dataJsonObj.getString("appid_cool");
		             mGameInfo.public_str=dataJsonObj.getString("appkey_cool");
		             mGameInfo.pay_addr = dataJsonObj.getString("rechargeurl");
				}
			} catch (JSONException e) {
                e.printStackTrace();
            }
        }
	}
	/*
	 * 
	 * */
	private IGameActivity mGameActivity;
	/*
	 * 
	 * */
	public GameInfo mGameInfo;
	/*
	 * 
	 * */
	public void loadGameConfig() {
		
		File cfg = new File(mGameActivity.getAppFilesRootPath()+"/game.properties");
		if (cfg.exists()) {
			Properties cfgIni = new Properties();
			String platformType = null;
			String usePlatformSdkType = null;
			try {
				cfgIni.load(new FileInputStream(cfg));
				platformType = cfgIni.getProperty("platformType", null);
				usePlatformSdkType = cfgIni.getProperty("usePlatformSdkType", null);
				//
			} catch (FileNotFoundException e) {
				
			} catch (IOException e) {
				
			}
			//
			cfg = null;
			cfgIni = null;
		
			mGameInfo.platform_type = PlatformAndGameInfo.readGameInfoPlatformType(platformType, mGameInfo.platform_type);
			mGameInfo.use_platform_sdk_type = PlatformAndGameInfo.readGameInfoUsePlatformSdkType(usePlatformSdkType, 
					mGameInfo.platform_type, mGameInfo.use_platform_sdk_type);
			
			
			
		}
	}
}

