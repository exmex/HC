
package com.taobao.sdk.youai;

public class TaobaoDialogError extends Throwable {

    private static final long serialVersionUID = 1L;

    private int mErrorCode;

    private String mFailingUrl;

    public TaobaoDialogError(String message, int errorCode, String failingUrl) {
        super(message);
        mErrorCode = errorCode;
        mFailingUrl = failingUrl;
    }
    /**
     * 获取错误代码
     * @return
     */
    int getErrorCode() {
        return mErrorCode;
    }
    /**
     * 获取请求失败的url
     * @return
     */
    String getFailingUrl() {
        return mFailingUrl;
    }

}
