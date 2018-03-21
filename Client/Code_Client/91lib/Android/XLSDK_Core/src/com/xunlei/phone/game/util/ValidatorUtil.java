package com.xunlei.phone.game.util;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class ValidatorUtil {

	private static final Pattern pnumber = Pattern.compile("\\d+");

	public static boolean isValidUserName(String username) {
		if (username == null) {
			return false;
		}

		return username.matches("^[a-zA-Z0-9_]{6,16}$") && username.matches("[^0-9](.)*");
	}

	public static boolean isValidPassword(String password) {
		return (password != null && isLetterOrNumberString(password) && password.length() >= 6 && password.length() <= 16);
	}

	/**
	 * 字母数字组合
	 * 
	 * @param string
	 * @return
	 */
	public static boolean isletterAndNumberString(String string) {
		if (string == null || string.length() == 0) {
			return false;
		}
		if (string.matches("[0-9]+")) {
			return false;
		} else {
			return string.matches("[a-zA-Z0-9]+");
		}
	}

	/**
	 * 字母或数字组合
	 * 
	 * @param string
	 * @return
	 */
	public static boolean isLetterOrNumberString(String string) {
		if (string == null || string.length() == 0) {
			return false;
		}
		return string.matches("[a-zA-Z0-9]+");
	}

	public static boolean hasChinese(String string) {
		if (string != null && string.matches("[\u0000-\u00ff]*")) {
			return false;
		}
		if (string == null) {
			return false;
		} else {
			return true;
		}
	}

	public static boolean isEmpty(String s)
	{
		return (s == null) || (s.trim().equals(""));
	}

	public static boolean isNumber(String s)
	{
		if (isEmpty(s)) {
			return false;
		}
		Matcher m = pnumber.matcher(s);
		return m.matches();
	}

	/**
	 * 是否手机号 11位整数
	 * 
	 * @param phone
	 * @return
	 */
	public static boolean isPhone(String phone) {
		return isNumber(phone) && phone.length() == 11 && phone.startsWith("1");
	}

	public static void main(String[] args) {
		// System.out.println(hasChinese("@*+-=@+-*/= 陈"));
		System.out.println(isValidUserName(""));
		System.out.println("abc--->" + isValidUserName("abc"));
		System.out.println("abcdef--->" + isValidUserName("abcdef"));
		System.out.println("abcdef_--->" + isValidUserName("abcdef_"));
		System.out.println("abc123--->" + isValidUserName("abc123"));
		System.out.println("123456--->" + isValidUserName("123456"));
		System.out.println("123_abc--->" + isValidUserName("123_abc"));
		System.out.println("______--->" + isValidUserName("______"));
	}
}
