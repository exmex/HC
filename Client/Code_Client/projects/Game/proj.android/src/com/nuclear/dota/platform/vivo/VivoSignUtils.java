package com.nuclear.dota.platform.vivo;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VivoSignUtils {

	private static final String TAG = "VIVO";
	// 签名key
	public final static String SIGNATURE = "signature";
	// 签名方法key
	public final static String SIGN_METHOD = "signMethod";
	// =
	public static final String QSTRING_EQUAL = "=";
	// &
	public static final String QSTRING_SPLIT = "&";
	
	
	/**
	 * 拼接请求字符串
	 * @param req 	请求要素
	 * @param key	vivo分配给商户的密钥
	 * @return 请求字符串
	 */
	public static String buildReq(Map<String, String> req, String key) {
	    // 除去数组中的空值和签名参数
        Map<String, String> filteredReq = paraFilter(req);
		// 根据参数获取vivo签名
		String signature = getVivoSign(filteredReq, key);
		// 签名结果与签名方式加入请求提交参数组中
		filteredReq.put(SIGNATURE, signature);
		filteredReq.put(SIGN_METHOD, "MD5");

		return createLinkString(filteredReq, false, true);		//请求字符串，key不需要排序，value需要URL编码
	}

	/**
     * 异步通知消息验签
     * @param para	异步通知消息
     * @param key	vivo分配给商户的密钥
     * @return 验签结果
     */
    public static boolean verifySignature(Map<String, String> para, String key) {
        // 除去数组中的空值和签名参数
        Map<String, String> filteredReq = paraFilter(para);
        // 根据参数获取vivo签名
        String signature = getVivoSign(filteredReq, key);
        // 获取参数中的签名值
        String respSignature = para.get(SIGNATURE);
        System.out.println("服务器签名：" + signature + " | 请求消息中的签名：" + respSignature);
        // 对比签名值
        if (null != respSignature && respSignature.equals(signature)) {
			return true;
		}else {
            return false;
        }
    }
	
	/**
	 * 获取vivo签名
	 * @param para	参与签名的要素<key,value>
	 * @param key	vivo分配给商户的密钥
	 * @return 签名结果
	 */
	public static String getVivoSign(Map<String,String> para, String key) {
		// 除去数组中的空值和签名参数
        Map<String, String> filteredReq = paraFilter(para);
		
        String prestr = createLinkString(filteredReq, true, false);	//得到待签名字符串 需要对map进行sort，不需要对value进行URL编码
		prestr = prestr + QSTRING_SPLIT + md5Summary(key);
		
		return md5Summary(prestr);
	}

	/** 
     * 除去请求要素中的空值和签名参数
     * @param para 请求要素
     * @return 去掉空值与签名参数后的请求要素
     */
    public static Map<String, String> paraFilter(Map<String, String> para) {

        Map<String, String> result = new HashMap<String, String>();

        if (para == null || para.size() <= 0) {
            return result;
        }

        for (String key : para.keySet()) {
            String value = para.get(key);
            if (value == null || value.equals("") || key.equalsIgnoreCase(SIGNATURE)
                || key.equalsIgnoreCase(SIGN_METHOD)) {
                continue;
            }
            result.put(key, value);
        }

        return result;
    }
    
    /**
     * 把请求要素按照“参数=参数值”的模式用“&”字符拼接成字符串
     * @param para 请求要素
     * @param sort 是否需要根据key值作升序排列
     * @param encode 是否需要URL编码
     * @return 拼接成的字符串
     */
    public static String createLinkString(Map<String, String> para, boolean sort, boolean encode) {

        List<String> keys = new ArrayList<String>(para.keySet());
        
        if (sort)
        	Collections.sort(keys);

        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            String value = para.get(key);
            
            if (encode) {
				try {
					value = URLEncoder.encode(value, "utf-8");
				} catch (UnsupportedEncodingException e) {
				}
            }
            
            if (i == keys.size() - 1) {//拼接时，不包括最后一个&字符
                sb.append(key).append(QSTRING_EQUAL).append(value);
            } else {
                sb.append(key).append(QSTRING_EQUAL).append(value).append(QSTRING_SPLIT);
            }
        }
        return sb.toString();
    }
    
    /**
     * 对传入的参数进行MD5摘要
     * @param str	需进行MD5摘要的数据
     * @return		MD5摘要值
     */
    public static String md5Summary(String str) {

		if (str == null) {
			return null;
		}

		MessageDigest messageDigest = null;

		try {
			messageDigest = MessageDigest.getInstance("MD5");
			messageDigest.reset();
			messageDigest.update(str.getBytes("utf-8"));
		} catch (NoSuchAlgorithmException e) {

			return str;
		} catch (UnsupportedEncodingException e) {
			return str;
		}

		byte[] byteArray = messageDigest.digest();

		StringBuffer md5StrBuff = new StringBuffer();

		for (int i = 0; i < byteArray.length; i++) {
			if (Integer.toHexString(0xFF & byteArray[i]).length() == 1)
				md5StrBuff.append("0").append(Integer.toHexString(0xFF & byteArray[i]));
			else
				md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));
		}

		return md5StrBuff.toString();
	}
    
}