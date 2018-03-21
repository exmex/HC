package com.nuclear.sdk.active;

import android.app.Dialog;
import android.content.Context;
import android.os.Bundle;
import android.view.View;
import android.widget.Button;
import android.widget.ImageButton;
import android.widget.TextView;

import com.nuclear.sdk.R;

public class ProtocalDialog extends Dialog {

	private static final String TAG = ProtocalDialog.class.getSimpleName();


	private ImageButton backBtn;
	private TextView webTitle;
	private static final int BACKMAIN = 1;
	 
	 
	
	public void setNuclearTitle(String pText){
		webTitle.setText(pText);
	}
	public ProtocalDialog(Context context) {
		super(context, R.style.u2_AppTheme);
		
	}
	
	

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.ya_protocal);
		
		backBtn = (ImageButton)findViewById(R.id.u2_back);
		backBtn.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				onBack();
			}
		});
	}


	protected void onBack() {
		 
		dismiss();
	}
	
	/*@Override
	public void onBackPressed() {
		mSpinner.dismiss();
		super.onBackPressed();
	}*/

}
