package com.nearme.gamecenter.open.api;

public interface ApiCallback {
	/**
	 * 接口调用成功,触发此方法
	 * @param content
	 * @param code
	 */
	public void onSuccess(String content, int code);
	/**
	 * 接口调用失败,触发此方法
	 * @param content
	 * @param code
	 */
	public void onFailure(String content, int code);
}
