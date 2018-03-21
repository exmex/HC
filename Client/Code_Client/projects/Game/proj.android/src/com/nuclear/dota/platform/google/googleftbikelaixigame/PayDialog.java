package com.nuclear.dota.platform.google.googleftbikelaixigame;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.net.wifi.WifiInfo;
import android.net.wifi.WifiManager;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;

import com.qsds.ggg.dfgdfg.fvfvf.R;

public class PayDialog extends Dialog {

	
	private ImageButton mMyCardBillBtn;
	private ImageButton mGashPayBtn;
	private ImageButton mGGPayBtn;
	private ImageButton mMyCardMemberBtn;
	private ImageButton mMyCardIngameBtn;
	
	PayClickResult mPayClickResultListen;
	OnPayClickListen mPayClickListen;
	
	
	protected  static enum payType{mycard_billing,mycard_ingame,mycard_member,gash,google};
	
	public PayDialog(Context context) {
		super(context);
	}

	public PayDialog(Activity pAcitivity, int theme){
        super(pAcitivity, theme);
    }
	
	
	class OnPayClickListen implements View.OnClickListener{
	
		@Override
		public void onClick(View v) {
			if (v.getId()==R.id.pay_google) {
				mPayClickResultListen.onPayClick(payType.google.ordinal());
			} else if (v.getId()==R.id.pay_mycard_billing) {
				mPayClickResultListen.onPayClick(payType.mycard_billing.ordinal());
			} else if (v.getId()==R.id.pay_mycard_ingame) {
				mPayClickResultListen.onPayClick(payType.mycard_ingame.ordinal());
			} else if (v.getId()==R.id.pay_mycard_member) {
				mPayClickResultListen.onPayClick(payType.mycard_member.ordinal());
			} else if (v.getId()==R.id.pay_gash) {
				mPayClickResultListen.onPayClick(payType.gash.ordinal());
			} 
		}
		
	}
	
	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.ftpay_dialog);
		mGGPayBtn = (ImageButton) findViewById(R.id.pay_google);
		mMyCardBillBtn = (ImageButton) findViewById(R.id.pay_mycard_billing);
		mMyCardIngameBtn = (ImageButton) findViewById(R.id.pay_mycard_ingame);
		mMyCardMemberBtn = (ImageButton) findViewById(R.id.pay_mycard_member);
		mGashPayBtn = (ImageButton) findViewById(R.id.pay_gash);
		mPayClickListen = new OnPayClickListen();
		
		mGGPayBtn.setOnClickListener(mPayClickListen);
		mMyCardBillBtn.setOnClickListener(mPayClickListen);
		mMyCardIngameBtn.setOnClickListener(mPayClickListen);
		mMyCardMemberBtn.setOnClickListener(mPayClickListen);
		mGashPayBtn.setOnClickListener(mPayClickListen);
	}
	
	
	public void callShowPay(PayClickResult pResult){
		this.show();
		mPayClickResultListen = pResult;
		
	}
	
	
	interface PayClickResult{
		public void onPayClick(int pPayType);
		public void onPayCancel(); 
	}


	
}
