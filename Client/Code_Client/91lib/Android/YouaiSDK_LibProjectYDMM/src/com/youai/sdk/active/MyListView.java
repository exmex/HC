package com.youai.sdk.active;


import com.youai.sdk.R;

import android.content.Context;
import android.util.AttributeSet;
import android.view.MotionEvent;
import android.widget.AdapterView;
import android.widget.ListView;

/***
 * 自定义listview
 * 
 * @author Administrator
 * 
 */
public class MyListView extends ListView {
	public MyListView(Context context) {
		super(context);
	}

	public MyListView(Context context, AttributeSet attrs) {
		super(context, attrs);
	}

	/****
	 * 拦截触摸事件
	 */
	@Override
	public boolean onInterceptTouchEvent(MotionEvent ev) {
		switch (ev.getAction()) {
		case MotionEvent.ACTION_DOWN:
			int x = (int) ev.getX();
			int y = (int) ev.getY();
			int itemnum = pointToPosition(x, y);
			if (itemnum == AdapterView.INVALID_POSITION)
				break;
			else {
				if (itemnum == 0) {
					if (itemnum == (getAdapter().getCount() - 1)) {
						// 只有一项
					//	setSelector(R.drawable.list_round);
					} else {
						// 第一项
						setSelector(R.drawable.cornertoplayout);
					}
				} else if (itemnum == (getAdapter().getCount() - 1)){
					// 最后一项
					setSelector(R.drawable.cornertoplayout);	
				}
				else {
					// 中间项
					setSelector(R.drawable.cornernomal);
				}
			}
			break;
		}
		return super.onInterceptTouchEvent(ev);
	}
}