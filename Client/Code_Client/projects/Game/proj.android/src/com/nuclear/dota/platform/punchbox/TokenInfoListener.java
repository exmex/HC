
package com.nuclear.dota.platform.punchbox;

/**
 */
public interface TokenInfoListener {

    public void onGotTokenInfo(String tokenInfo);

    public void onGotError(String error);
}
