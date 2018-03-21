/****************************************************************************
Copyright (c) 2010-2011 cocos2d-x.org

http://www.cocos2d-x.org

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
 ****************************************************************************/

package org.cocos2dx.lib;

import java.lang.ref.WeakReference;

import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Handler;
import android.os.Message;
import android.view.WindowManager;

public class Cocos2dxHandler extends Handler {
	// ===========================================================
	// Constants
	// ===========================================================
	public final static int HANDLER_MSG_TO_MAINTHREAD_ShowCocos2dx = 0;
	public final static int HANDLER_SHOW_DIALOG = 1;
	public final static int HANDLER_SHOW_EDITBOX_DIALOG = 2;
	public final static int HANDLER_SHOW_QUESTION_DIALOG = 3;
	public final static int HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress = 4;
	public final static int HANDLER_MSG_TO_MAINTHREAD_ChangeToCocos2dx = 5;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformInit = 6;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformLogin = 7;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformLogout = 8;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformAccountManage = 9;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformPayRecharge = 10;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformFeedback = 11;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformThirdShare = 12;
	public final static int HANDLER_MSG_TO_MAINTHREAD_CallPlatformBBS = 13;
	public final static int HANDLER_MSG_TO_MAINTHREAD_ShowWaitingView = 14;
	public final static int HANDLER_MSG_TO_MAINTHREAD_OnActivityPause = 15;
	public final static int HANDLER_MSG_TO_MAINTHREAD_OnActivityResume = 16;
	public final static int HANDLER_MSG_TO_MAINTHREAD_ShowToastMsg = 17;
	public final static int HANDLER_MSG_TO_MAINTHREAD_OnLowMemory = 18;
	
	public static final int bsDialogPositiveButtonId = 1;
	public static final int bsDialogNegativeButtonId = 2;
	
	// ===========================================================
	// DialogMsgId
	public static final int bsQuestionDialogMsgId_Cocos2dxActivity_BackKeyPressed = 1;
	public static final int bsDialogMsgId_Cocos2dxActivity_NetworkNotOK = 2;
	public static final int bsDialogMsgId_Cocos2dxActivity_ExternalStorageNotOK = 3;
	public static final int bsDialogMsgId_Cocos2dxActivity_OnLowMemory = 4;
	// ===========================================================
	
	// ===========================================================
	// Fields
	// ===========================================================
	private WeakReference<Cocos2dxActivity> mActivity;
	
	// ===========================================================
	// Constructors
	// ===========================================================
	public Cocos2dxHandler(Cocos2dxActivity activity) {
		this.mActivity = new WeakReference<Cocos2dxActivity>(activity);
	}

	// ===========================================================
	// Getter & Setter
	// ===========================================================

	// ===========================================================
	// Methods for/from SuperClass/Interfaces
	// ===========================================================
	
	// ===========================================================
	// Methods
	// ===========================================================

	public void handleMessage(Message msg) {
		switch (msg.what) {
		case Cocos2dxHandler.HANDLER_SHOW_DIALOG:
			showDialog(msg);
			break;
		case Cocos2dxHandler.HANDLER_SHOW_EDITBOX_DIALOG:
			showEditBoxDialog(msg);
			break;
		case Cocos2dxHandler.HANDLER_SHOW_QUESTION_DIALOG:
			showQuestionDialog(msg);
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ShowCocos2dx:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ChangeToCocos2dx:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_UpdateMoveAssetResProgress:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformLogin:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformLogout:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformAccountManage:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformPayRecharge:
			{
				break;
			}
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformInit:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformFeedback:
			break;
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_CallPlatformThirdShare:
			{
				break;
			}
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ShowWaitingView:
			{
				break;
			}
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_ShowToastMsg:
			{
				mActivity.get().showToastMsgImp((String)msg.obj);
				break;
			}
		case Cocos2dxHandler.HANDLER_MSG_TO_MAINTHREAD_OnLowMemory:
			{
				mActivity.get().onLowMemoryImp();
				break;
			}
		}
	}
	
	private void showDialog(Message msg) {
		Cocos2dxActivity theActivity = this.mActivity.get();
		DialogMessage dialogMessage = (DialogMessage)msg.obj;
		final int tag = dialogMessage.msgId;
		
		AlertDialog dlg = new AlertDialog.Builder(theActivity)
								.setTitle(dialogMessage.titile)
								.setMessage(dialogMessage.message)
								.setPositiveButton("OK", 
										new DialogInterface.OnClickListener() {
											
											@Override
											public void onClick(DialogInterface dialog, int which) {
												
												if (tag >= 0)
													Cocos2dxHelper.nativeDialogOkCallback(tag);
												
											}
										})
								.setOnCancelListener(new DialogInterface.OnCancelListener()
								{
				
									@Override
									public void onCancel(DialogInterface dialog)
									{
										if (tag == 110 || tag == 100)
										{
											mActivity.get().showToastMsgImp("You to cancel the update confirmation");
											mActivity.get().showWaitingView(true, -1, "The game needs to be updated, you cancel the update confirmation, please restart it！");
										}
									}
							
								}).create();
		
		dlg.setCanceledOnTouchOutside(false);
		//
		
		WindowManager.LayoutParams lp = dlg.getWindow().getAttributes();
        //lp.alpha = 0.6f;
        dlg.getWindow().setAttributes(lp);
        dlg.show();
	}
	
	private void showQuestionDialog(Message msg) {
		final Cocos2dxActivity theActivity = this.mActivity.get();
		final DialogMessage dialogMessage = (DialogMessage)msg.obj;
		AlertDialog dlg = new AlertDialog.Builder(theActivity)
								.setTitle(dialogMessage.titile)
								.setMessage(dialogMessage.message)
								.setPositiveButton("OK", 
										new DialogInterface.OnClickListener() {
											
											@Override
											public void onClick(DialogInterface dialog, int which) {
												
												if (dialogMessage.msgId == Cocos2dxHandler.bsQuestionDialogMsgId_Cocos2dxActivity_BackKeyPressed) {
													theActivity.destroy();
												}
												
											}
										})
								.setNegativeButton("Cancel", 
										new DialogInterface.OnClickListener() {
											
											@Override
											public void onClick(DialogInterface dialog, int which) {
												
												
												
											}
										})
								.setOnCancelListener(new DialogInterface.OnCancelListener()
								{
				
									@Override
									public void onCancel(DialogInterface dialog)
									{
										
									}
							
								})
								.create();
		dlg.setCanceledOnTouchOutside(false);
		//
		WindowManager.LayoutParams lp = dlg.getWindow().getAttributes();
        //lp.alpha = 0.6f;
        dlg.getWindow().setAttributes(lp);
        dlg.show();
	}
	
	private void showEditBoxDialog(Message msg) {
		EditBoxMessage editBoxMessage = (EditBoxMessage)msg.obj;
		new Cocos2dxEditBoxDialog(this.mActivity.get(),
				editBoxMessage.title,
				editBoxMessage.content,
				editBoxMessage.inputMode,
				editBoxMessage.inputFlag,
				editBoxMessage.returnType,
				editBoxMessage.maxLength).show();
	}
	
	// ===========================================================
	// Inner and Anonymous Classes
	// ===========================================================
	
	public static class DialogMessage {
		public String titile;
		public String message;
		public int msgId;
		public String positiveCallback;
		public String negativeCallback;
		
		public DialogMessage(String title, String message, 
				int msgId, String positiveCallback, String negativeCallback) {
			this.titile = title;
			this.message = message;
			this.msgId = msgId;
			this.positiveCallback = positiveCallback;
			this.negativeCallback = negativeCallback;
		}
	}
	
	public static class EditBoxMessage {
		public String title;
		public String content;
		public int inputMode;
		public int inputFlag;
		public int returnType;
		public int maxLength;
		
		public EditBoxMessage(String title, String content, int inputMode, int inputFlag, int returnType, int maxLength){
			this.content = content;
			this.title = title;
			this.inputMode = inputMode;
			this.inputFlag = inputFlag;
			this.returnType = returnType;
			this.maxLength = maxLength;
		}
	}  
	
	public static class ProgressMessage {
		public int 			progress;	//百分之几十
		public String 		text;
		
		public ProgressMessage(int progress, String text) {
			this.progress = progress;
			this.text = text;
		}
	}
	
	public static class ShareMessage {
		public String 		content;
		public String 		imgPath;
		
		public ShareMessage(String content, String imgPath) {
			this.content = content;
			this.imgPath = imgPath;
		}
	}
	
	public static class PayRechargeMessage {
		
		public String serial;
		public String productId;
		public String productName;
		public float price;
		public float orignalPrice;
		public int count;
		public String description;
		
		public PayRechargeMessage(String serial, String productId, String productName, 
	    		float price, float orignalPrice, int count, String description) {
			this.serial = serial;
			this.productId = productId;
			this.productName = productName;
			this.price = price;
			this.orignalPrice = orignalPrice;
			this.count = count;
			this.description = description;
		}
	}
	
	public static class ShowWaitingViewMessage {
		
		public boolean show;
		public int progress;
		public String text;
		
		public ShowWaitingViewMessage(boolean show, int progress, String text) {
			this.show = show;
			this.progress = progress;
			this.text = text;
		}
	}
	
}
