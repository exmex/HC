package com.youai.sdk.android.utils;


import javax.crypto.Cipher;
import javax.crypto.spec.IvParameterSpec;
import javax.crypto.spec.SecretKeySpec;

import android.util.Base64;

/**
 * DES 加解密的算法
 * 加密的key必须为8位或者8的倍数，否则在java加密过程中会报错
 * @author chunjiang.shieh
 *
 */
public class DES {

	
	private static byte[] iv = {1,2,3,4,5,6,7,8};

	/**
	 * CBC是工作模式
	 * PKCS5Padding是填充模式，还有其它的填充模式
	 */
	private static final String ALGORITHM_DES = "DES/CBC/PKCS5Padding";  

	/** 
	 * DES算法，加密 
	 * @param encryptKey  加密私钥，长度不能够小于8位  
	 * @param encryptString 待加密字符串 
	 * @return 加密后的结果一般都会用base64编码进行传输
	 * @throws CryptException 异常 
	 */  
	public static String encryptDES(String encryptKey,String encryptString) throws Exception{  
		IvParameterSpec zeroIv = new IvParameterSpec(iv);  
		SecretKeySpec key = new SecretKeySpec(encryptKey.getBytes(),
				"DES");
		Cipher cipher = Cipher.getInstance(ALGORITHM_DES); 
		/**
		 * zeroIv初始化向量，注意：必须设置，否则会调用平台默认的 不通平台不一样
		 */
		cipher.init(Cipher.ENCRYPT_MODE, key, zeroIv);
		byte[] encryptedData = cipher.doFinal(encryptString.getBytes());
		return Base64.encodeToString(encryptedData,0);  
	}  


	
	/**
	 * DES算法，解密 
	 * @param decryptString 解密私钥，长度不能够小于8位
	 * @param decryptKey 待解密字符串
	 * @return  解密后的字符串（明文）
	 * @throws Exception
	 */
	public static String decryptDES(String decryptKey,String decryptString) throws Exception {
		byte[] byteMi = Base64.decode(decryptString,0);
		IvParameterSpec zeroIv = new IvParameterSpec(iv);
		SecretKeySpec key = new SecretKeySpec(decryptKey.getBytes(), "DES");
		Cipher cipher = Cipher.getInstance(ALGORITHM_DES);
		cipher.init(Cipher.DECRYPT_MODE, key, zeroIv);
		byte decryptedData[] = cipher.doFinal(byteMi);
		return new String(decryptedData);
	}
    
}
