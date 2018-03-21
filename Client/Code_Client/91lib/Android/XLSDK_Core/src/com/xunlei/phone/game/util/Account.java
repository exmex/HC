package com.xunlei.phone.game.util;

public class Account implements Comparable<Account> {
	private String username;
	private String password;
	private String lastTime;

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

	public String getLastTime() {
		return lastTime;
	}

	public void setLastTime(String lastTime) {
		this.lastTime = lastTime;
	}

	@Override
	public int compareTo(Account another) {
		return this.lastTime.compareTo(another.lastTime);
	}
}
