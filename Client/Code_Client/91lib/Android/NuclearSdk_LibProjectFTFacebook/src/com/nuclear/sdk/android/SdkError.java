package com.nuclear.sdk.android;

public class SdkError {
	
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

	public SdkError() {
	}

	public SdkError(int mErrorCode, String mErrorMessage) {
		this.mErrorCode = mErrorCode;
		this.mErrorMessage = mErrorMessage;
	}

	public SdkError(String string) {
		// TODO Auto-generated constructor stub
	}
	
	

	public int getMErrorCode() {
		return this.mErrorCode;
	}

	public String getMErrorMessage() {
		return this.mErrorMessage;
	}
}
