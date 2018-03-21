package com.youai.sdk.android.entry;

public class YouaiUser {

	private String username = "";
	private String password = "";
	private String uidStr = "";
	private String userType = "";//NORMAL:0 THIRD_PARTY 1 GUEST:2 GUEST_BOUND:3
	private String isLocalLogout ="1"; //本地是否注销，1 ：是    0 ：否   用户判定是否自动登录，默认都加密记住密码
	private String lastlogintime = "";
	private String email = "";
	private int IsCreate = 0;
	private String IsFirstThird = "0";
	 
	public String getIsFirstThird() {
		return IsFirstThird;
	}
	public void setIsFirstThird(String isFirstThird) {
		IsFirstThird = isFirstThird;
	}
	public int getIsCreate() {
		return IsCreate;
	}
	public void setIsCreate(int isCreate) {
		IsCreate = isCreate;
	}
	public String getUserType() {
		return userType;
	}
	public void setUserType(String userType) {
		this.userType = userType;
	}
	public String getIsLocalLogout() {
		return isLocalLogout;
	}
	public void setIsLocalLogout(String isLocalLogout) {
		this.isLocalLogout = isLocalLogout;
	}
	public String getLastlogintime() {
		return lastlogintime;
	}
	public void setLastlogintime(String lastlogintime) {
		this.lastlogintime = lastlogintime;
	}
	public String getUidStr() {
		return uidStr;
	}
	public void setUidStr(String uidStr) {
		this.uidStr = uidStr;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	
	
}
