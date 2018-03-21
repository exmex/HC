package com.xunlei.phone.game.component.activity;

import com.xunlei.phone.game.util.RR;

import android.app.Activity;
import android.content.DialogInterface;
import android.view.KeyEvent;
import android.view.animation.Animation;
import android.view.animation.AnimationUtils;
import android.widget.ViewFlipper;

public abstract class XLBaseActivity {
    protected XLDialog mCurrent;
    protected Activity mActivity;
    protected ViewFlipper mViewFlipper;
    protected int mCurrentPage = 1;

    public XLBaseActivity(XLDialog mCurrent, Activity mActivity) {
        this.mActivity = mActivity;
        this.mCurrent = mCurrent;
    }

    public void create() {
        mCurrent.setOnSlideListener(new XLDialog.LoginDialogSlideListener() {

            @Override
            public void onSlide() {
                System.out.println(mCurrentPage);
                if (mCurrentPage == 1) {
                    finish();
                } else {
                    mCurrentPage--;
                    Animation rInAnim = AnimationUtils.loadAnimation(mCurrent.getContext(), RR.anim(mActivity, "xl_push_left_in"));
                    Animation rOutAnim = AnimationUtils.loadAnimation(mCurrent.getContext(), RR.anim(mActivity, "xl_push_right_out"));

                    mViewFlipper.setInAnimation(rInAnim);
                    mViewFlipper.setOutAnimation(rOutAnim);
                    mViewFlipper.showPrevious();
                }
            }
        });

        mCurrent.setOnKeyListener(new DialogInterface.OnKeyListener() {

            @Override
            public boolean onKey(DialogInterface dialogInterface, int keyCode, KeyEvent keyEvent) {
                if (keyEvent.getAction() == KeyEvent.ACTION_UP && keyCode == KeyEvent.KEYCODE_BACK) {
                    mCurrent.setCancel(false);
                }

                return false;
            }
        });

        mCurrent.show();
        onCreate();
    }

    abstract void onCreate();

    void finish() {
        mCurrent.dismiss();
    }
}
