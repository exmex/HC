package com.xunlei.phone.game.component.activity;

import android.app.Dialog;
import android.content.Context;

public class XLDialog extends Dialog {
	private boolean cancel = true;
	private LoginDialogSlideListener listener;

	public XLDialog(Context context, int theme) {
		super(context, theme);
	}

	public void setCancel(boolean cancel) {
		this.cancel = cancel;
	}

	public void setOnSlideListener(LoginDialogSlideListener listener) {
		this.listener = listener;
	}

	@Override
	public void onBackPressed() {
		if (cancel) {
			super.onBackPressed();
		} else {
			listener.onSlide();
			cancel = true;
		}
	}

	static interface LoginDialogSlideListener {
		public void onSlide();
	}
}
