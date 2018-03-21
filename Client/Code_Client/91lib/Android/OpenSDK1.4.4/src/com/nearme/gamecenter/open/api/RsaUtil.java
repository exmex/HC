package com.nearme.gamecenter.open.api;


import java.security.KeyFactory;
import java.security.PrivateKey;
import java.security.PublicKey;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import org.apache.commons.codec.binary.Base64;

public class RsaUtil {

    /**
     * 验证签名的方法
     *
     * content : notify_id=value&partner_code=value&partner_order=value&orders=value&pay_result=value
     * 字段之间使用&连接
     *
     * @param content
     * @param sign
     * @return
     */
    public static boolean doCheck(String content, String sign) {
        String charset = "utf-8";
        try {
            KeyFactory keyFactory = KeyFactory.getInstance("RSA");
            byte[] encodedKey = Base64.decodeBase64("这里为公钥,在pay_rsa_public_key.pem文件中".getBytes());
            PublicKey pubKey = keyFactory.generatePublic(new X509EncodedKeySpec(encodedKey));
            java.security.Signature signature = java.security.Signature.getInstance("SHA1WithRSA");
            signature.initVerify(pubKey);
            signature.update(content.getBytes(charset));
            boolean bverify = signature.verify(Base64.decodeBase64(sign.getBytes()));
            return bverify;
        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
    
    public static String sign(String content , String privateKey) {
		String charset = "utf-8";
		try {
			PKCS8EncodedKeySpec priPKCS8 = new PKCS8EncodedKeySpec(Base64.decodeBase64(privateKey.getBytes()));
			KeyFactory keyf = KeyFactory.getInstance("RSA");
			PrivateKey priKey = keyf.generatePrivate(priPKCS8);
			java.security.Signature signature = java.security.Signature.getInstance("SHA1WithRSA");
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
