package com.youai.sdk.android.utils;


public class ToolsUtil {
	public static String REGEX_PHONE_NUMBER = "^((13[0-9])|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";

	  public static String REGEX_EMAIL = "^([a-zA-Z0-9_\\-\\.]+)@((\\[[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.)|(([a-zA-Z0-9\\-]+\\.)+))([a-zA-Z]{2,4})(\\]?)$";

	  public static String REGEX_IP_ADDRESS = "\\b((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\.((?!\\d\\d\\d)\\d+|1\\d\\d|2[0-4]\\d|25[0-5])\\b";

	  public static String REGEX_DATE_TIME = "^((\\d{2}(([02468][048])|([13579][26]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])))))|(\\d{2}(([02468][1235679])|([13579][01345789]))[\\-\\/\\s]?((((0?[13578])|(1[02]))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(3[01])))|(((0?[469])|(11))[\\-\\/\\s]?((0?[1-9])|([1-2][0-9])|(30)))|(0?2[\\-\\/\\s]?((0?[1-9])|(1[0-9])|(2[0-8]))))))(\\s(((0?[0-9])|([1-2][0-3]))\\:([0-5]?[0-9])((\\s)|(\\:([0-5]?[0-9])))))?$";

	  public static String REGEX_ACCOUNT_NAME = "^[a-zA-Z0-9_@.]{6,16}$";//"^[a-zA-Z0-9_@.]{6,12}$";

	//  public static String REGEX_ACCOUNT_NAME_UNPASS = "^\\d{4,20}$";

	  public static String REGEX_PASSWORD = "^[a-zA-Z0-9_]{6,12}$";//最少6位数字或字母

	  public static boolean checkAccount(String accountName)
	  {

	    if (accountName.matches(REGEX_ACCOUNT_NAME))
	    {
	  //    return !accountName.matches(REGEX_ACCOUNT_NAME_UNPASS);
	    	return true;
	    }

	    return false;
	  }

	  public static boolean checkPassword(String password)
	  {
	    return password.matches(REGEX_PASSWORD);
	  }

	  public static boolean checkPhoneAndEmail(String accountBound)
	  {
	    return (accountBound.matches(REGEX_PHONE_NUMBER)) || (accountBound.matches(REGEX_EMAIL));
	  }
	  public static boolean checkEmail(String accountEmail)
	  {
	    return (accountEmail.matches(REGEX_EMAIL));
	  }
	  
	  public static String getPopenType(String popen)
	  {
	    if (popen.matches(REGEX_PHONE_NUMBER))
	      return "0";
	    if (popen.matches(REGEX_EMAIL)) {
	      return "1";
	    }
	    return "";
	  }
}
