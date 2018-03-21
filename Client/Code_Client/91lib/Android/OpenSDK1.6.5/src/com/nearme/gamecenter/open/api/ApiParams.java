package com.nearme.gamecenter.open.api;

import android.webkit.WebView.FindListener;

import com.nearme.wappay.util.PackageUtil;

public class ApiParams {
	//全局状态相关的返回码
	public final static int GLOBAL_CODE_OK = 1001;//正常
	
	

	public final static int GLOBAL_CODE_NOT_LOGIN = 1002;//未登录
	public final static int GLOBAL_CODE_NET_ERROR = 1003;//网络异常
	public final static int GLOBAL_CODE_SYSTEM_ERROR = 1004;//系统内部错误
	public final static int GLOBAL_CODE_TOKEN_TIMEOUT = 1005;//token过期
	public final static int GLOBAL_CODE_REQUEST_ERROR = 1006;//请求错误
	public final static int GLOBAL_CODE_SYSTEM_UNKNOW = 1007;//未知错误
	public final static int GLOBAL_CODE_USER_CANCEL = 1008;//用户取消
	
	public final static int GLOBAL_CODE_NOT_JSON = 1009;//返回消息格式不是JSON
	
	//登录相关返回的状态码
	public final static int LOGIN_CODE_ALREADY_LOGIN = 2001;
	
	//消费游戏中心货币相关接口的返回码
	public final static int PAYMENT_CODE_USER_BALANCE_NOT_ENOUGH = 3001;//用户余额不足.
	public final static int CHARGE_CODE_FAILURE = 4001;//充值失败 
	
	//消耗N豆 doPaymentForNdou
	public final static int PAYMENT_CODE_NDOU_NOT_ENOUGH = 5001;//用户N豆余额不足.
	public final static int PAYMENT_CODE_NDOU_ORDER_REPEAT = 5002;//订单重复
	
	//非游客状态测试步骤tag
	public final static String YI = "1";
	public final static String ER = "2";
	public final static String SAN = "3";
	public final static String SI = "4";
	public final static String WU = "5";
	public final static String LIU = "6";
	public final static String QI = "7";
	public final static String BA = "8";
	public final static String JIU = "9";
	public final static String SHI = "10";
	public final static String SHIYI ="11";
	
	public static boolean RELOGIN_STATUS = false;
	public static boolean SWITCH_DIA_ON = false;
	
	

}
