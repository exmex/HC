package com.nuclear.dota.platform.sina_wyx;


import android.content.Intent;

import com.nuclear.PlatformAndGameInfo;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.GameConfig;

public class SinaActivity extends GameActivity {
	
	public SinaActivity()
	{
		super.mGameCfg = new GameConfig(this, PlatformAndGameInfo.enPlatform_Sina);
	}
	
	/**
	 * 支持SSO 需要重写onActivityResult函数，并在里面调用authorizeCallBack，示例如下：
	 */
	@Override
	protected void onActivityResult(int requestCode, int resultCode, Intent data) {
		super.onActivityResult(requestCode, resultCode, data);

		/**
		 * SSO登录回调代码
		 */
		if(PlatformSinaLoginAndPay.getInstance().mWyx!=null)
		{
			PlatformSinaLoginAndPay.getInstance().mWyx.authorizeCallBack(requestCode, resultCode, data);
		}
	}
	
	
}
