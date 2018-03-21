package com.nuclear.sdk.android.config;

public class SdkConfig {
	public static String urlroot = "http://player.we4dota.com:6520/";//首次链接域名地址，如果访问不通，会使用ip地址
	public static String urlroot_back = "http://203.195.147.31:6520/";	
	
	public static String createUser_url = urlroot+"nuclear/users/create";
	public static String init_url = urlroot+"nuclear/connect/init";
	public static String login_url = urlroot+"nuclear/users/login";
	public static String modify_url = urlroot +"nuclear/users/modify";
	public static String precreate_url = urlroot +"nuclear/users/precreate";
	public static String nameexists_url = urlroot +"nuclear/users/nameexists";
	public static String getPlayerList = urlroot +"nuclear/gameplayer/getplayerlist";
	public static String pushforclient = urlroot +"nucealr/gameplayer/pushforclient";
	public static String Thirdlogin_url = urlroot + "nuclear/thirdUser/createorlogin"; 
	public static String WebsiteIndex = urlroot + "jsp/public/help";
	
	public static String GetnuclearList = urlroot + "nuclear/connect/users" ;//put 返回names根据机器信息，获取曾登录的账号  返回 names 
	public static String createOrLoginTry = urlroot + "nuclear/guest/createorlogin"; //游客登录或者创建登录
	public static String TryBinding = urlroot + "nuclear/guest/binding"; //绑定 guest	nuclearId - 游客账号的Id	boundnuclearName - 被绑定的账号的userName  boundPassword - 被绑定的账号的密码
	public static String TryToOk = urlroot + "nuclear/users/modify"; //试玩转正接口   
	
	public static String FindPass = urlroot + "nuclear/users/resetPwd";    
	
	public static String Tenpay = urlroot +"tenpay/trade";
	public static String Yibao = urlroot +"yeepay/trade";
	public static String Alipay = urlroot +"alipay/trade";
	public static String AlipayWeb = urlroot +"alipayweb/trade";
	public static String nuclearWebSite = "www.baidu.com";
	public static String UrlFeedBack = urlroot +"nuclear/feedback/querylist";
	public static String PlatformStr = "Android_nuclearGGXMT";
	public static String md5key = "-128315";
	
	
	public static long timestamp ;
	public static String statuCode = "200";
	
	
	public static boolean encryptData = true;
	
	
	public static String error_net = "網絡錯誤";
	
	/*
	 * 第三方平台编号（从0开始）
	 */
	public enum THIRD_PLATFORM{
		SINA,
		RENREN,
		DOUBAN,
		QQ,
		TAOBAO,
		THIRD_STORE,
		FACKBOOK,
		GOOGLE;
		
	}
	
	/**NORMAL:0 THIRD_PARTY 1 GUEST:2 GUEST_BOUND:3*/
	public static String USERTYPE[] = {"0","1","2","3"};
	
	
}
