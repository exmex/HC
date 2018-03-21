package com.nearme.gamecenter.open.api;

import java.net.URLDecoder;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import org.apache.commons.codec.binary.Base64;

public class RsaUtil {

	/**
	 * rsa 的 公钥，public key
	 */
	public static final String PUB_KEY = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDCFVNJgbaXqvQMWlrbifOUt75WQKr4LreG2gCUz7P+IEJNx2IbuTApfGbITiMUVn7WCtXTNHiT2wsuj600KwGi9o1J9V+jDN/C/WfQXCT4ijBssujwqPcS4Yu+s3ItgzadAGY/EMWV7jMVBy2F+tGjL2iU8KU0Yp4BcC2Wue+hcQIDAQAB";
	/**
	 * 模拟的一段N宝支付回调数据（amount=1.0，消耗了1元宝）
	 */
	public static final String DATA_NBAO = "notify_id=2507&partner_code=c5217trjnrmU6gO5jG8VvUFU0&partner_order=1372750927530&orders=%E6%9C%BA%E5%99%A8%E4%BA%BA%E5%B8%811.011372750927530&pay_result=OK&sign=aFdd%2FIIByga7s6dxSa7HbRWpxdTddDRe0H3wEuxwBWp17LRCbEp1oCtOWqjWu68FM5XxnXt6LSPT5hfoiodddJunfHnJ1V47FJCGGK5a6vZzsG5saKEon4V3IewSTGTwp4CKodjuXObrxg7pHrP%2BDBifzlb75jBGAsY4vVO6KSw%3D&amount=1.0";

	/**
	 * 模拟的一段RMB支付回调数据（消耗了0.01元）
	 */
	public static final String DATA_RMB = "notify_id=2532&partner_code=c5217trjnrmU6gO5jG8VvUFU0&partner_order=CZ2013070911364927131152126350&orders=0.01%262713115%26%E6%9C%BA%E5%99%A8%E4%BA%BA%E5%B8%81%26%E5%A5%B3%E5%8F%8B%E6%9C%BA%E5%99%A8%E4%BA%BA&pay_result=OK&sign=qRWIG8w9vG8IU9OlClPmJoMJuPYxUiHch3ABSQzpUJC646ac%2Be1CapHuuDZaeuaFqpgi3z5fl4YrLzw21sbq0t5i7wRADjUDSdwCw3c%2BrBrGRx4GwQitGPVJQa%2FutvgPjsE3IdE8vi52efH%2FrugjZOODaIBUC17k%2BqfB2ma2zzs%3D&amount=0.01";

	public static void main(String[] args) {

		checkNBaoResult();

		checkRMBResult();
	}

	/**
	 * RMB支付回调验证
	 */
	private static void checkRMBResult() {

		System.out.println("get data form callback server : "
				+ URLDecoder.decode(DATA_RMB));
		String content = getRMBContentString(DATA_RMB);
		System.out.println("get content : " + URLDecoder.decode(content));
		String sign = getSign(DATA_RMB);
		System.out.println("get sign : " + sign);
		System.out.println("check result :"
				+ doCheck(URLDecoder.decode(content), URLDecoder.decode(sign)));

	}

	/**
	 * N宝支付回调验证
	 */
	private static void checkNBaoResult() {

		System.out.println("get data form callback server : "
				+ URLDecoder.decode(DATA_NBAO));
		String content = getNBaoContentString(DATA_NBAO);
		System.out.println("get content : " + URLDecoder.decode(content));
		String sign = getSign(DATA_NBAO);
		System.out.println("get sign : " + sign);
		System.out.println("check result :"
				+ doCheck(URLDecoder.decode(content), URLDecoder.decode(sign)));

	}

	/**
	 * notify_id=value&partner_code=value
	 * &partner_order=value&orders=value&pay_result=value
	 * 
	 * @param url
	 * @return
	 */
	private static String getNBaoContentString(String url) {
		final String[] strings = url.split("&");
		final StringBuilder sb = new StringBuilder();
		for (String string : strings) {
			if (string.startsWith("notify_id=")
					|| string.startsWith("partner_code=")
					|| string.startsWith("partner_order=")
					|| string.startsWith("orders=")) {
				sb.append(string).append("&");
			} else if (string.startsWith("pay_result=")) {
				sb.append(string);
			}
		}
		return sb.toString();
	}

	/**
	 * notify_id=value&partner_code=value&partner_order=value&orders=value&
	 * pay_result=value&amount=value&openid=value
	 * 
	 * @param url
	 * @return
	 */
	private static String getRMBContentString(String url) {
		final String[] strings = url.split("&");
		final StringBuilder sb = new StringBuilder();
		String amount = null;
		String openid = null;
		String productName;
		String productDesc;
		for (String string : strings) {
			if (string.startsWith("notify_id=")
					|| string.startsWith("partner_code=")
					|| string.startsWith("partner_order=")
					|| string.startsWith("orders=")) {
				sb.append(string).append("&");
				if (string.startsWith("orders=")) {
					// orders=amount&openid&productName&productDesc
					final String orders = URLDecoder
							.decode(string.split("=")[1]);
					final String[] orderss = orders.split("&");
					amount = orderss[0];
					openid = orderss[1];
					productName = orderss[2];
					productDesc = orderss[3];
					// do some thing for productName and productDesc
				}
			} else if (string.startsWith("pay_result=")) {
				sb.append(string);
			}
		}

		sb.append("&" + "amount=" + amount);
		sb.append("&" + "openid=" + openid);
		return sb.toString();
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
	 * 
	 * content :
	 * notify_id=value&partner_code=value&partner_order=value&orders=value
	 * &pay_result=value 字段之间使用&连接
	 * 
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

	public static String sign(String content, String privateKey) {
		String charset = "utf-8";
		try {
			PKCS8EncodedKeySpec priPKCS8 = new PKCS8EncodedKeySpec(
					Base64.decodeBase64(privateKey.getBytes()));
			KeyFactory keyf = KeyFactory.getInstance("RSA");
			PrivateKey priKey = keyf.generatePrivate(priPKCS8);
			java.security.Signature signature = java.security.Signature
					.getInstance("SHA1WithRSA");
			signature.initSign(priKey);
			signature.update(content.getBytes(charset));
			byte[] signed = signature.sign();
			return new String(Base64.encodeBase64(signed), charset);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}
}
