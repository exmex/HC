package com.nuclear;


import com.tencent.mm.sdk.openapi.BaseReq;
import com.tencent.mm.sdk.openapi.BaseResp;
import com.tencent.mm.sdk.openapi.ConstantsAPI;
import com.tencent.mm.sdk.openapi.ShowMessageFromWX;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.tencent.mm.sdk.openapi.IWXAPIEventHandler;
import com.tencent.mm.sdk.openapi.WXAPIFactory;
import com.tencent.mm.sdk.openapi.WXAppExtendObject;
import com.tencent.mm.sdk.openapi.WXMediaMessage;
import com.nuclear.dota.GameActivity;
import com.nuclear.dota.Config;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

public class WXEntryActivity extends Activity implements IWXAPIEventHandler{
	
	
	// IWXAPI 是第三方app和微信通信的openapi接口
	
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        if(null!=getIntent())
        GameActivity.api.handleIntent(getIntent(), this);
    }

	@Override
	protected void onNewIntent(Intent intent) {
		super.onNewIntent(intent);
		
		setIntent(intent);
		if(null!=intent)
		GameActivity.api.handleIntent(intent, this);
	}

	//接受微信请求game
	@Override
	public void onReq(BaseReq arg0) {
		
		/*
		switch (req.getType()) {
		case ConstantsAPI.COMMAND_GETMESSAGE_FROM_WX:
			goToGetMsg();		
			break;
		case ConstantsAPI.COMMAND_SHOWMESSAGE_FROM_WX:
			goToShowMsg((ShowMessageFromWX.Req) req);
			break;
		default:
			break;
		}*/
	}

	//接受相应结果
	@Override
	public void onResp(BaseResp resp) {
//		int result = 0;
		Log.i("WXEntryActivity", "onResp"+resp.errCode);
		switch (resp.errCode) {
		case BaseResp.ErrCode.ERR_OK:
			//result = R.string.errcode_success;
			GameActivity.weChatHave = true;
			GameActivity.isShareSuccess = true;
//			GameActivity.nativeOnShareEngineMessage(true);
			break;
		case BaseResp.ErrCode.ERR_USER_CANCEL:
//			result = R.string.errcode_cancel;
			GameActivity.weChatHave = true;
			GameActivity.isShareSuccess = false;
//			GameActivity.nativeOnShareEngineMessage(false,"ffffff");
			break;
		case BaseResp.ErrCode.ERR_AUTH_DENIED:
//			result = R.string.errcode_deny;
			GameActivity.weChatHave = true;
			GameActivity.isShareSuccess = false;
//			GameActivity.nativeOnShareEngineMessage(false,"ffffff");
			break;
		default:
//			result = R.string.errcode_unknown;
			GameActivity.weChatHave = true;
			GameActivity.isShareSuccess = false;
//			GameActivity.nativeOnShareEngineMessage(false,"ffffff");
			break;
		}
//		if(result!=0)
//		{
//			Toast.makeText(this, result, Toast.LENGTH_LONG).show();
//		}
		finish();
	}

	
 
}