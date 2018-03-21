package com.youai.sdk.android;

public class YouaiError {
	
	private static final long serialVersionUID = 1L;
	private int mErrorCode;
	/**
	 * @param mErrorCode the mErrorCode to set
	 */
	public void setmErrorCode(int mErrorCode) {
		this.mErrorCode = mErrorCode;
	}

	/**
	 * @param mErrorMessage the mErrorMessage to set
	 */
	public void setmErrorMessage(String mErrorMessage) {
		this.mErrorMessage = mErrorMessage;
	}

	private String mErrorMessage;

	public YouaiError() {
	}

	public YouaiError(int mErrorCode, String mErrorMessage) {
		this.mErrorCode = mErrorCode;
		this.mErrorMessage = mErrorMessage;
	}

	public YouaiError(String string) {
		// TODO Auto-generated constructor stub
	}
	
	

	public int getMErrorCode() {
		return this.mErrorCode;
	}

	public String getMErrorMessage() {
		return this.mErrorMessage;
	}
}
