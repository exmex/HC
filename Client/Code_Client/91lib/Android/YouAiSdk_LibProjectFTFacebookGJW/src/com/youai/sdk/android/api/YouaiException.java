
package com.youai.sdk.android.api;


/**
 */
public class YouaiException extends Exception {

	private static final long serialVersionUID = 475022994858770424L;
	private int statusCode = -1;
	
    public YouaiException(String msg) {
        super(msg);
    }

    public YouaiException(Exception cause) {
        super(cause);
    }

    public YouaiException(String msg, int statusCode) {
        super(msg);
        this.statusCode = statusCode;
    }

    public YouaiException(String msg, Exception cause) {
        super(msg, cause);
    }

    public YouaiException(String msg, Exception cause, int statusCode) {
        super(msg, cause);
        this.statusCode = statusCode;
    }

    public int getStatusCode() {
        return this.statusCode;
    }
    
    
	public YouaiException() {
		super(); 
	}

	public YouaiException(String detailMessage, Throwable throwable) {
		super(detailMessage, throwable);
	}

	public YouaiException(Throwable throwable) {
		super(throwable);
	}

	public YouaiException(int statusCode) {
		super();
		this.statusCode = statusCode;
	}

	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}
}
