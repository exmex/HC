package com.nuclear.dota.platform.kupai;

/**
 *应用接入iAppPay云支付平台sdk集成信息 
 */
public class IAppPaySDKConfig{

	/**
	 * 应用名称：
	 * 应用在iAppPay云支付平台注册的名称
	 */
	public final static  String APP_NAME = "刀塔传奇2";

	/**
	 * 应用编号：
	 * 应用在iAppPay云支付平台的编号，此编号用于应用与iAppPay云支付平台的sdk集成 
	 */
	
	public final static  String APP_ID = "";

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买100钻石送10钻石
	 */
	public final static  int WARES_ID_1=1;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买300钻石送35钻石
	 */
	public final static  int WARES_ID_2=2;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买500钻石送60钻石
	 */
	public final static  int WARES_ID_3=3;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买1000钻石送130钻石
	 */
	public final static  int WARES_ID_4=4;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买2000钻石送270钻石
	 */
	public final static  int WARES_ID_5=5;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买5000钻石送680钻石
	 */
	public final static  int WARES_ID_6=6;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买10000钻石送1500钻石
	 */
	public final static  int WARES_ID_7=7;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买20000钻石送3500钻石
	 */
	public final static  int WARES_ID_8=8;

	/**
	 * 商品编号：
	 * 应用的商品在iAppPay云支付平台的编号，此编号用于iAppPay云支付平台的sdk到iAppPay云支付平台查找商品详细信息（商品名称、商品销售方式、商品价格）
	 * 编号对应商品名称为：购买50000钻石送8500钻石
	 */
	public final static  int WARES_ID_9=9;

	/**
	 * 应用密钥：
	 * 用于保障应用与iAppPay云支付平台sdk通讯安全及sdk初始化
	 * 此应用密钥只适用集成sdk3.2.35版本及3.2.35以后的版本，3.2.35以前版本请从商户服务平台复制密钥数据（应用密钥、支付公钥、MODKEY）
	 */
	public final static String APP_KEY = "";

}