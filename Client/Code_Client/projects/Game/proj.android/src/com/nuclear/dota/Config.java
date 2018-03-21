package com.nuclear.dota;

public class Config {

	public static String urlroot = "http://player.we4dota.com:6520/";// 
	
	public static String getPlayerList = urlroot +"nuclear/gameplayer/getplayerlist";
	public static String pushforclient = urlroot +"nuclear/gameplayer/pushforclient";
	public static String UrlFeedBack =  urlroot + "nuclear/feedback/querydetailbygameinfo";
	public static String userAntionInit = urlroot+"nuclear/connect/init/user/action";
	public static String md5key = "-128315";
	public static long timestamp ;
	public static boolean encryptData = true;
	
	public static void reCreate(){
		getPlayerList = urlroot +"nuclear/gameplayer/getplayerlist";
		pushforclient = urlroot +"nuclear/gameplayer/pushforclient";
		UrlFeedBack =  urlroot + "nuclear/feedback/querydetailbygameinfo";
	}
	
	public static String error_net = "net erro";
	/*
	 * 第三方平台编号（从0开始）
	 */
	public enum THIRD_PLATFORM{
		SINA,
		RENREN,
		DOUBAN,
		QQ,
		TAOBAO;
	}
	
	public static String WX_APP_ID = ""; //微信app参数
}
