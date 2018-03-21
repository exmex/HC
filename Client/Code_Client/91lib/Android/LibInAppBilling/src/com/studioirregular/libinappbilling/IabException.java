package com.studioirregular.libinappbilling;

@SuppressWarnings("serial")
public class IabException extends Exception {

	public final ServerResponseCode errorCode;
	
	public IabException(ServerResponseCode errorCode) {
		this.errorCode = errorCode;
	}

	@Override
	public String toString() {
		return super.toString() + ": errorCode:" + errorCode;
	}
	
}
