package com.nearme.gamecenter.open.api;

import java.net.URLDecoder;
import java.security.KeyFactory;
import java.security.PublicKey;
import java.security.spec.X509EncodedKeySpec;
import java.util.HashMap;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

public class RsaUtil {

	/**
	 * rsa 的 公钥，public key
	 */
	public static final String PUB_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCmreYIkPwVovKR8rLHWlFVw7YDfm9uQOJKL89Smt6ypXGVdrAKKl0wNYc3/jecAoPi2ylChfa2iRu5gunJyNmpWZzlCNRIau55fxGW0XEu553IiprOZcaw5OuYGlf60ga8QT6qToP0/dpiL/ZbmNUO9kUhosIjEu22uFgR+5cYyQIDAQAB";
	/**
	 * 模拟的一段可币支付回调数据（消耗了0.01可币（元））
	 */
	public static final String DATA_KEBI = "sign=kHKXA7brp%2B2G1Sys3fT7JEcK13dukRLNoK0LBFi1BdKpngw2WAr8sEcP37UBfIAaRT4UXOb5dXnfzc0WIrfrWxfE%2BTXqfgFMBAIV6Nk2wQinZ2I45pt3zTYo3I2NFfU2IehqA%2BVOmgTG8uWDhjOL63HHfm1pv7CFzFedd3OM9kA%3D&partnerOrder=1383896624538&productDesc=%E5%95%86%E5%93%81%E6%8F%8F%E8%BF%B0&price=1&count=1&attach=%E8%87%AA%E5%AE%9A%E4%B9%89%E5%AD%97%E6%AE%B5&notifyId=GC2013110815435301400004525090&productName=%E7%BA%A2%E9%92%BB";

	public static void main(String[] args) {

		checkKebiResult();
	}

	@SuppressWarnings("deprecation")
	private static void checkKebiResult() {
		System.out.println("public key :" + PUB_KEY);
		System.out.println("get data form callback server : "
				+ URLDecoder.decode(DATA_KEBI));
		String content = getKebiContentString(DATA_KEBI);
		System.out.println("get content : " + URLDecoder.decode(content));
		String sign = getSign(DATA_KEBI);
		System.out.println("get sign : " + URLDecoder.decode(sign));
		System.out.println("check result :"
				+ doCheck(URLDecoder.decode(content), URLDecoder.decode(sign)));

	}

	/**
	 * 
	 * @param url
	 * @return
	 */
	private static String getKebiContentString(String url) {
		final String[] strings = url.split("&");
		final Map<String, String> data = new HashMap<String, String>();
		for (String string : strings) {
			final String[] keyAndValue = string.split("=");
			data.put(keyAndValue[0], keyAndValue[1]);
		}
		final StringBuilder baseString = new StringBuilder();
		baseString.append("notifyId=");
		baseString.append(data.get("notifyId"));
		baseString.append("&");
		baseString.append("partnerOrder=");
		baseString.append(data.get("partnerOrder"));
		baseString.append("&");
		baseString.append("productName=");
		baseString.append(data.get("productName"));
		baseString.append("&");
		baseString.append("productDesc=");
		baseString.append(data.get("productDesc"));
		baseString.append("&");
		baseString.append("price=");
		baseString.append(data.get("price"));
		baseString.append("&");
		baseString.append("count=");
		baseString.append(data.get("count"));
		baseString.append("&");
		baseString.append("attach=");
		baseString.append(data.get("attach"));
		return baseString.toString();
	}

	private static String getSign(String url) {
		final String[] strings = url.split("&");
		final StringBuilder sb = new StringBuilder();
		for (String string : strings) {
			if (string.startsWith("sign=")) {
				sb.append(string.split("=")[1]);
			}
		}
		return sb.toString();
	}

	/**
	 * 验证签名的方法
	 * @param content
	 * @param sign
	 * @return
	 */
	public static boolean doCheck(String content, String sign) {
		String charset = "utf-8";
		try {
			KeyFactory keyFactory = KeyFactory.getInstance("RSA");
			byte[] encodedKey = Base64.decodeBase64(PUB_KEY.getBytes());
			PublicKey pubKey = keyFactory
					.generatePublic(new X509EncodedKeySpec(encodedKey));
			java.security.Signature signature = java.security.Signature
					.getInstance("SHA1WithRSA");
			signature.initVerify(pubKey);
			signature.update(content.getBytes(charset));
			boolean bverify = signature.verify(Base64.decodeBase64(sign
					.getBytes()));
			return bverify;
		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}
}
