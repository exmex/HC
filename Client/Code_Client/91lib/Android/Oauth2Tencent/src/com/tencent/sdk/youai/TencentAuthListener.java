package com.tencent.sdk.youai;


public interface TencentAuthListener {

    /**
     * 认证结束后将调用此方�?     * 
     * @param values
     *            Key-value string pairs extracted from the response.
     *            从responsetext中获取的键�?对，键�?包括"access_token"�?expires_in"，�?refresh_token�?     */
    public void onComplete(String values);

    /**
     * 当认证过程中捕获到TencentException时调�?     * @param e TencentException
     * 
     */
    public void onTencentException(TencentException e);

    /**
     * Oauth2.0认证过程中，当认证对话框中的webview接收数据出现错误时调用此方法
     * @param e WeiboDialogError
     * 
     */
    public void onError(TencentDialogError e);

    /**
     * Oauth2.0认证过程中，如果认证窗口被关闭或认证取消时调�?     * 
     * 
     */
    public void onCancel();

}
