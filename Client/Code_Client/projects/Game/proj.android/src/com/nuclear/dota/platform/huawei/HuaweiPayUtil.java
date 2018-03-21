package com.nuclear.dota.platform.huawei;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

public class HuaweiPayUtil {
	public static final int RQF_INSTALL_CHECK = 1;
	public static final int RQF_PAY_INFO = 2;
	
	public static final String	PackageName = "com.huawei.android.hwpay";
	public static final String apk_download_url = 
			"http://file.dbank.com/dl/TDS/Pay/HuaweiPayService.apk";
	
	// 华为安全支付服务apk的名称，必须与assets目录下的apk名称一致
	public static final String HWPAY_PLUGIN_NAME = "HuaweiPayService.apk";
	
	/**
	 * 对数组里的每一个值从a到z的顺序排序
	 * 
	 * @param Map
	 *            <String, String>
	 * @return String
	 * 
	 */
	public static String getSignData(Map<String, String> params) {
		StringBuffer content = new StringBuffer();

		// 按照key做排序
		List<String> keys = new ArrayList<String>(params.keySet());
		Collections.sort(keys);
		for (int i = 0; i < keys.size(); i++) {
			String key = (String) keys.get(i);
			if ("sign".equals(key)) {
				continue;
			}
			String value = (String) params.get(key);
			if (value != null) {
				content.append((i == 0 ? "" : "&") + key + "=" + value);
			} else {
				continue;
			}
		}
		return content.toString();
	}
}
