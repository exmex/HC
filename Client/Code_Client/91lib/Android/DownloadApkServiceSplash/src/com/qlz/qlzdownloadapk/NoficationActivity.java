package com.qlz.qlzdownloadapk;

import android.app.Activity;
import android.app.Notification;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.view.View.OnClickListener;
import android.widget.Button;
import android.widget.RemoteViews;
import android.widget.RemoteViews.RemoteView;
import android.widget.Toast;
import com.qlz.qlzdownloadapk.R;

public class NoficationActivity extends Activity implements OnClickListener {

    private static final int NOTIFICATION_ID = 0x12;
    private Notification notification = null;
    private NotificationManager manager = null;

    public Handler handler;
    private int _progress = 0;
    private Thread thread = null;
    private boolean isStop = false;

    // 当界面处理停止的状态 时，设置让进度条取消
    @Override
    protected void onPause() {
        // TODO Auto-generated method stub
        isStop = false;
        manager.cancel(NOTIFICATION_ID);

        super.onPause();
    }

    /** Called when the activity is first created. */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.notification_main);

        Button btn = (Button) findViewById(R.id.Button01);
        btn.setOnClickListener(this);
        notification = new Notification(R.drawable.ic_launcher, "带进条的提醒", System
                .currentTimeMillis());
        notification.icon = R.drawable.ic_launcher;

        // 通过RemoteViews 设置notification中View 的属性
        notification.contentView = new RemoteViews(getApplication()
                .getPackageName(), R.layout.custom_dialog);
        notification.contentView.setProgressBar(R.id.pb, 100, 0, false);
        notification.contentView.setTextViewText(R.id.tv, "进度" + _progress
                + "%");
        // 通过PendingIntetn
        // 设置要跳往的Activity，这里也可以设置发送一个服务或者广播，
        // 不过在这里的操作都必须是用户点击notification之后才触发的
        notification.contentIntent = PendingIntent.getActivity(this, 0,
                new Intent(this, RemoteView.class), 0);
        // 获得一个NotificationManger 对象，此对象可以对notification做统一管理，只需要知道ID
        manager = (NotificationManager) getSystemService(NOTIFICATION_SERVICE);

    }

    @Override
    public void onClick(View v) {
        // TODO Auto-generated method stub
        isStop = true;
        manager.notify(NOTIFICATION_ID, notification);
        thread = new Thread(new Runnable() {

            @Override
            public void run() {
                Thread.currentThread();
                // TODO Auto-generated method stub
                while (isStop) {
                    _progress += 10;
                    Message msg = handler.obtainMessage();
                    msg.arg1 = _progress;
                    msg.sendToTarget();

                    try {
                        Thread.sleep(500);
                    } catch (InterruptedException e) {
                        // TODO Auto-generated catch block
                        e.printStackTrace();
                    }
                }
            }
        });
        thread.start();

        handler = new Handler() {
            @Override
            public void handleMessage(Message msg) {
                // TODO Auto-generated method stub
                notification.contentView.setProgressBar(R.id.pb, 100, msg.arg1,
                        false);
                notification.contentView.setTextViewText(R.id.tv, "进度"
                        + msg.arg1 + "%");
                manager.notify(NOTIFICATION_ID, notification);

                if (msg.arg1 == 100) {
                    _progress = 0;
                    manager.cancel(NOTIFICATION_ID);
                    isStop = false;
                    Toast.makeText(NoficationActivity.this, "下载完毕", 1000)
                            .show();
                }
                super.handleMessage(msg);
            }
        };
    }
}