package com.nuclear.dota.platform.puidlogin;

import java.util.Random;

import com.qsds.ggg.dfgdfg.fvfvf.R;

import android.app.Activity;
import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;

public class PuidLoginDialog extends Dialog {

	protected static final String Login_ACCOUNT_PUID = "";
	private EditText puidEditText;
	private Button loginBtn;
	PuidLoginResult mLoginResultListen;
	private String[] user_name = {"uc_218055959","91_430409085","91_437500950","91_368427114","91_403376727","91_453207151","91_170588176","sina_1785540380","uc_176980649","uc_218281760"};
	
	
	public PuidLoginDialog(Context context) {
		super(context);
	}

	public PuidLoginDialog(Activity pAcitivity, int theme){
        super(pAcitivity, theme);
    }

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		// TODO Auto-generated method stub
		super.onCreate(savedInstanceState);
		this.setContentView(R.layout.puidlogin);
		puidEditText = (EditText) findViewById(R.id.editpuid);
		Random random = new Random();
		puidEditText.setHint(user_name[random.nextInt(10)]);
		loginBtn = (Button) findViewById(R.id.puidlogin);
		
		loginBtn.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View arg0) {
				String puidStr = "";
				if(puidEditText.getText().toString() != null && !"".equals(puidEditText.getText().toString())){
					puidStr = puidEditText.getText().toString();
				}else{
					puidStr = puidEditText.getHint().toString();
				}
				
				if (!puidStr.equals("")){
					mLoginResultListen.onPuidLoginSuccess(puidStr);
				}else{
					mLoginResultListen.onPuidLoginCancel();
				}
			}
		});
	}
	
	
	public void CallLogin(PuidLoginResult pResult){
		this.show();
		mLoginResultListen = pResult;
		
	}
	
	
	interface PuidLoginResult{
		public void onPuidLoginSuccess(String pPuid);
		public void onPuidLoginCancel(); 
	}
	
}
