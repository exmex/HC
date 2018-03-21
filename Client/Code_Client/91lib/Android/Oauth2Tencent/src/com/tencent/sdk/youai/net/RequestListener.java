package com.tencent.sdk.youai.net;

import java.io.IOException;

import com.tencent.sdk.youai.TencentException;

/**
 * ������ʽӿڵ�����ʱ����Ļص��ӿ�
 * @author luopeng (luopeng@staff.sina.com.cn)
 */
public interface RequestListener {
    /**
     * ���ڻ�ȡ���������ص���Ӧ����
     * @param response
     */
	public void onComplete(String response);

	public void onIOException(IOException e);

	public void onError(TencentException e);

}
