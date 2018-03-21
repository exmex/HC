
package com.nuclear.sdk.android.api;


/**
 */
public class SdkException extends Exception {

	private static final long serialVersionUID = 475022994858770424L;
	private int statusCode = -1;
	
    public SdkException(String msg) {
        super(msg);
    }

    public SdkException(Exception cause) {
        super(cause);
    }

    public SdkException(String msg, int statusCode) {
        super(msg);
        this.statusCode = statusCode;
    }

    public SdkException(String msg, Exception cause) {
        super(msg, cause);
    }

    public SdkException(String msg, Exception cause, int statusCode) {
        super(msg, cause);
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return this.statusCode;
    }
    
    
	public SdkException() {
		super(); 
	}

	public SdkException(String detailMessage, Throwable throwable) {
		super(detailMessage, throwable);
	}

	public SdkException(Throwable throwable) {
		super(throwable);
	}

	public SdkException(int statusCode) {
		super();
		this.statusCode = statusCode;
	}

	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}
}
