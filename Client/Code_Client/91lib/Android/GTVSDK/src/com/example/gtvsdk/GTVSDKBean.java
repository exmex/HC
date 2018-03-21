package com.example.gtvsdk;

import java.io.Serializable;
import java.util.HashMap;

public class GTVSDKBean implements Serializable {

	private static final long serialVersionUID = 1L;
	private String url;
	private HashMap<String, Object> map;
	private GTVAuthorizeViewInterface mAuthorizeViewInterface;

	public GTVSDKBean(String url, HashMap<String, Object> map,
			GTVAuthorizeViewInterface mAuthorizeViewInterface) {
		this.url = url;
		this.map = map;
		this.mAuthorizeViewInterface = mAuthorizeViewInterface;
	}

	public String getUrl() {
		return url;
	}

	public void setUrl(String url) {
		this.url = url;
	}

	public HashMap<String, Object> getMap() {
		return map;
	}

	public void setMap(HashMap<String, Object> map) {
		this.map = map;
	}

	public GTVAuthorizeViewInterface getmAuthorizeViewInterface() {
		return mAuthorizeViewInterface;
	}

	public void setmAuthorizeViewInterface(
			GTVAuthorizeViewInterface mAuthorizeViewInterface) {
		this.mAuthorizeViewInterface = mAuthorizeViewInterface;
	}

}
