package com.nuclear;


import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 *MD5签名算法 验证签名算法
 * @author pangxurui
 *
 */
public class MD5
{
  public static final String get(String s)
  {
    try
    {
      MessageDigest digest = MessageDigest.getInstance("MD5");
      digest.update(s.getBytes());
      byte[] messageDigest = digest.digest();

      StringBuffer hexString = new StringBuffer();
      for (int i = 0; i < messageDigest.length; ++i) {
        String h = Integer.toHexString(0xFF & messageDigest[i]);
        while (h.length() < 2)
          h = "0" + h;
        hexString.append(h);
      }
      return hexString.toString();
    }
    catch (NoSuchAlgorithmException e) {
      e.printStackTrace();
    }
    return "";
  }

  public static boolean check(String content, String md5) {
    return get(content).equals(md5);
  }

  public static final String sign(String content, String key)
  {
    return get(content + key);
  }

  public static boolean check(String content, String key, String md5) {
    return get(content + key).equals(md5);
  }
}