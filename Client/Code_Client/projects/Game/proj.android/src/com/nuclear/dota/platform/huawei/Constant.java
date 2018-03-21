package com.nuclear.dota.platform.huawei;

import java.util.HashMap;

public class Constant {

	public static final String HWID_PLUS_NAME = "hwIDOpenSDK";
	public static final String  HiAnalytics_PLUS_NAME = "HiAnalytics";
	//public static final String HuaweiPayPlugin = "HuaweiPaySDK";
	public static final String HuaweiPayPlugin = "hwIDOpenSDK";
	
	public static final HashMap<String, String> allPluginName = new HashMap<String, String>()
	{
		{
			put(HWID_PLUS_NAME, "华为帐号");
			put(HiAnalytics_PLUS_NAME, "华为统计");
			put(HuaweiPayPlugin, "华为支付");
		}
	};
	
}
