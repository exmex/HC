package com.xunlei.phone.game.util;

import java.io.Serializable;

/**
 * call back of client
 * @author Davis Yang
 * 上午9:48:34
 */
public interface ICallBack extends Serializable {
    /**
     * call back
     * 
     * @param resultCode 
     * @param resultData 
     */
    public void onCallBack(int resultCode, Object resultData);
}
