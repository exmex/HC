package com.youai.sdk.android.config;

public class YouaiConfig {
	public static String urlroot = "http://pc.com4loves.com:6520/";
	public static String urlroot_back = "http://203.195.147.31:6520/";//http://pc.com4loves.com   //http://203.195.147.31	
	
	public static String createUser_url = urlroot+"youaiuser/create";
	public static String init_url = urlroot+"connect/init";
	public static String login_url = urlroot+"youaiuser/login";
	public static String modify_url = urlroot +"youaiuser/modify";
	public static String precreate_url = urlroot +"youaiuser/precreate";
	public static String nameexists_url = urlroot +"youaiuser/nameexists";
	public static String getPlayerList = urlroot +"gameplayer/getplayerlist";
	public static String pushforclient = urlroot +"gameplayer/pushforclient";
	public static String Thirdlogin_url = urlroot + "third/createorlogin"; 
	public static String WebsiteIndex = urlroot + "jsp/public/help";
	
	public static String GetYouaiList = urlroot + "connect/getyouainames" ;//put 返回names根据机器信息，获取曾登录的账号  返回 names 
	public static String createOrLoginTry = urlroot + "guest/createorlogin"; //游客登录或者创建登录
	public static String TryBinding = urlroot + "guest/binding"; //绑定 guest	YouaiId - 游客账号的有爱Id	boundYouaiName - 被绑定的账号的userName  boundPassword - 被绑定的账号的密码
	public static String TryToOk = urlroot + "youaiuser/modify"; //试玩转正接口   
	
	public static String Tenpay = urlroot +"tenpay/trade";
	public static String Yibao = urlroot +"yeepay/trade";
	public static String Alipay = urlroot +"alipay/trade";
	public static String AlipayWeb = urlroot +"alipayweb/trade";
	public static String Webindex = "https://www.facebook.com/NCDragon";
	public static String UrlFeedBack = urlroot +"lzfeedback/querylist";
	public static String PlatformStr = "Android_GoogleFT";
	public static String md5key = "-com4loves";
	
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
		FACKBOOK;
		
	}
	
	/**NORMAL:0 THIRD_PARTY 1 GUEST:2 GUEST_BOUND:3*/
	public static String USERTYPE[] = {"0","1","2","3"};
	
	

	
}
