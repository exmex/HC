package com.youai.sdk.android.utils;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

import android.util.Log;

import com.youai.sdk.alipay.Base64;
import com.youai.sdk.android.config.YouaiSdkConfig;

/**
 * Rsa加解密
 */
public class RSAUtil {

	public static final String pub_key_hand = "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDIYMeruGjt8VREeGaC2rGz5lLD"
			+ "\r"
			+ "RrViyx7YYKvRF+036b6CnyFuVyQvl0Q+rZPtA4LidMhbHKQz9C5EhtXdhrKwgqt0"
			+ "\r"
			+ "loWYnzYef7i6tvVoCowI1tHBuiTJruekDyCQwAwqAttEKt/FNGpKhMBjCAj9xIWL"
			+ "\r" + "eaC0xySsOY6JzDtokQIDAQAB";

	// 数字签名，密钥算法
	private static final String RSA_KEY_ALGORITHM = "RSA";

	/**
	 * 用公钥加密
	 * 
	 * @return
	 * @throws Exception
	 */
	public static String encryptByPubKey(String data, String pPubkey)
			throws Exception {
		if (!YouaiSdkConfig.encryptData)
			return data;
		byte[] pub_key = Base64.decode(pPubkey);
		X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(pub_key);
		KeyFactory keyFactory = KeyFactory.getInstance(RSA_KEY_ALGORITHM);
		PublicKey publicKey = keyFactory.generatePublic(x509KeySpec);
		Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding");
		cipher.init(Cipher.ENCRYPT_MODE, publicKey);

		InputStream ins = new ByteArrayInputStream(data.getBytes());
		ByteArrayOutputStream writer = new ByteArrayOutputStream();
		byte[] buf = new byte[100];
		int bufl;

		while ((bufl = ins.read(buf)) != -1) {
			byte[] block = null;

			if (buf.length == bufl) {
				block = buf;
			} else {
				block = new byte[bufl];
				for (int i = 0; i < bufl; i++) {
					block[i] = buf[i];
				}
			}

			writer.write(cipher.doFinal(block));
		}

		return Base64.encode(writer.toByteArray());

	}

	/**
	 * 用私钥加密
	 * 
	 * @return
	 * @throws Exception
	 */
	public static String encryptByPriKey(String data, String pPrikey)
			throws Exception {
		if (!YouaiSdkConfig.encryptData)
			return data;

		byte[] pri_key = Base64.decode(pPrikey);// Base64.decodeBase64(pPrikey);
		PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(pri_key);
		KeyFactory keyFactory = KeyFactory.getInstance(RSA_KEY_ALGORITHM);
		PrivateKey privateKey = keyFactory.generatePrivate(pkcs8KeySpec);
		Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding");
		cipher.init(Cipher.ENCRYPT_MODE, privateKey);

		InputStream ins = new ByteArrayInputStream(data.getBytes());
		ByteArrayOutputStream writer = new ByteArrayOutputStream();
		byte[] buf = new byte[100];
		int bufl;

		while ((bufl = ins.read(buf)) != -1) {
			byte[] block = null;

			if (buf.length == bufl) {
				block = buf;
			} else {
				block = new byte[bufl];
				for (int i = 0; i < bufl; i++) {
					block[i] = buf[i];
				}
			}

			writer.write(cipher.doFinal(block));
		}

		return Base64.encode(writer.toByteArray());
	}

	/**
	 * 用公钥解密
	 * 
	 * @return
	 * @throws Exception
	 */
	public static String decryptByPubKey(String data, String pPubkey)
			throws Exception {
		if (!YouaiSdkConfig.encryptData)
			return data;

		byte[] pub_key = Base64.decode(pPubkey);// Base64.decodeBase64(pPubkey);
		X509EncodedKeySpec x509KeySpec = new X509EncodedKeySpec(pub_key);

		KeyFactory keyFactory = KeyFactory.getInstance(RSA_KEY_ALGORITHM);
		PublicKey publicKey = keyFactory.generatePublic(x509KeySpec);
		Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding");
		cipher.init(Cipher.DECRYPT_MODE, publicKey);

		byte[] _data = Base64.decode(data);// Base64.decodeBase64(data);

		InputStream ins = new ByteArrayInputStream(_data);
		ByteArrayOutputStream writer = new ByteArrayOutputStream();
		byte[] buf = new byte[128];
		int bufl;

		while ((bufl = ins.read(buf)) != -1) {
			byte[] block = null;

			if (buf.length == bufl) {
				block = buf;
			} else {
				block = new byte[bufl];
				for (int i = 0; i < bufl; i++) {
					block[i] = buf[i];
				}
			}

			writer.write(cipher.doFinal(block));
		}

		return new String(writer.toByteArray());

	}

	/**
	 * 用私钥解密
	 * 
	 * @return
	 * @throws Exception
	 */
	public static String decryptByPriKey(String data, String pPrikey)
			throws Exception {
		if (!YouaiSdkConfig.encryptData)
			return data;

		byte[] pri_key = Base64.decode(pPrikey);
		PKCS8EncodedKeySpec pkcs8KeySpec = new PKCS8EncodedKeySpec(pri_key);
		KeyFactory keyFactory = KeyFactory.getInstance(RSA_KEY_ALGORITHM);
		PrivateKey privateKey = keyFactory.generatePrivate(pkcs8KeySpec);
		Cipher cipher = Cipher.getInstance("RSA/None/PKCS1Padding");
		cipher.init(Cipher.DECRYPT_MODE, privateKey);

		byte[] _data = Base64.decode(data);

		InputStream ins = new ByteArrayInputStream(_data);
		ByteArrayOutputStream writer = new ByteArrayOutputStream();
		byte[] buf = new byte[128];
		int bufl;

		while ((bufl = ins.read(buf)) != -1) {
			byte[] block = null;

			if (buf.length == bufl) {
				block = buf;
			} else {
				block = new byte[bufl];
				for (int i = 0; i < bufl; i++) {
					block[i] = buf[i];
				}
			}

			writer.write(cipher.doFinal(block));
		}
		return new String(writer.toByteArray());
	}

	public static void main() throws Exception {
		String str = "xI9dZDFZZ4Oq7fcpx3W+jlrxee8IcVl/htPT+XsO3m8QTpwqQG6wzYk9NK1i8Lq49UZbtLYo/q2kSouU0szpQccAwkxDUUE3S7373ihru5boabtpzyePCwoO1ghQ1I3GgdCQ40Caej3J1rGzUHot42Zy2Rc06qoyDJlnmKHIJrQ=";
		Log.i("str:", str);
		String strencrypbypubkey = decryptByPubKey(str, RSAUtil.pub_key_hand);
		Log.i("strencrypbypubkey:", strencrypbypubkey);

		/*
		 * String strdecryptByPrikey = decryptByPriKey(strencrypbypubkey,
		 * RSAUtil.pri_key_hand);
		 * 
		 * Log.i("strdecryptByPrikey:", strdecryptByPrikey);
		 */

	}

}