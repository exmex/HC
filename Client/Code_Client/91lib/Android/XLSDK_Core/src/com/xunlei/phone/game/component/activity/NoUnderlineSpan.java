package com.xunlei.phone.game.component.activity;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.provider.Browser;
import android.text.TextPaint;
import android.text.style.ClickableSpan;
import android.view.View;

public class NoUnderlineSpan extends ClickableSpan {
	String text;

	public NoUnderlineSpan(String text) {
		super();
		this.text = text;
	}

	@Override
	public void updateDrawState(TextPaint ds) {
		// ds.setColor(ds.linkColor);
		ds.setUnderlineText(false); // eliminate underline
	}

	@Override
	public void onClick(View widget) {
		Uri uri = Uri.parse(text);
		Context context = widget.getContext();
		Intent intent = new Intent(Intent.ACTION_VIEW, uri);
		intent.putExtra(Browser.EXTRA_APPLICATION_ID, context.getPackageName());
		context.startActivity(intent);
	}
}
