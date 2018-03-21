package com.youai.sdk.active;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.View.OnClickListener;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.AdapterView.OnItemClickListener;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.youai.sdk.R;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.api.YouaiApi;
import com.youai.sdk.android.api.YouaiException;
import com.youai.sdk.android.config.YouaiSdkConfig;
import com.youai.sdk.android.entry.YouaiUser;
import com.youai.sdk.android.utils.MD5;
import com.youai.sdk.android.utils.RSAUtil;
import com.youai.sdk.android.utils.Utils;
import com.youai.sdk.net.RequestListener;

public class YouaiControlCenter extends Activity {

	private final String TAG = YouaiControlCenter.this.toString();
	protected static CallbackListener mCallBack; // 打开用户中心回调
	private ImageButton btnClose;
	private TextView TvTitleCenter; // Title中间标题
	ProgressBar changProgree; // 改变密码的进度条
	private static Context mFromContext;
	protected static boolean thirdLoginFirst;
	ClickListen clickListen;
	private ProgressBar loadingBar;// 加载的进度条
	private Button logoutBtn; // 帐号中心的注销按钮
	TextView accountName; // 帐号名称
	private int[] imgs = { R.drawable.accounticon, R.drawable.passwordicon,
			R.drawable.logouticon, R.drawable.mainpageicon };
	private int[] mControlText = { R.string.controlpassword,
			R.string.controlwebsite, R.string.controluser,
			R.string.controlfeedback };
	private YouaiUser nowYouaiUser;
	private Button mIntoGameBtn, mCPassBtn;
	private TextView mCUserTv, mWebOfficalTv, mWebFBFansTv;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		nowYouaiUser = YouaiCommplatform.getInstance().getLoginUser();
		clickListen = new ClickListen();
		setContentView(R.layout.youai_center);
		loadingBar = (ProgressBar) findViewById(R.id.loadingbar);
		btnClose = (ImageButton) findViewById(R.id.u2_close_bt);
		mIntoGameBtn = (Button) findViewById(R.id.intogame);
		mCPassBtn = (Button) findViewById(R.id.u2_changepass);

		accountName = (TextView) findViewById(R.id.u2_account_name);
		loadingBar.setVisibility(View.VISIBLE);

		mCUserTv = (TextView) findViewById(R.id.switchusertv);
		mWebOfficalTv = (TextView) findViewById(R.id.officialweb);
		mWebFBFansTv = (TextView) findViewById(R.id.fbfanslink);

		mWebOfficalTv.setOnClickListener(clickListen);
		mWebFBFansTv.setOnClickListener(clickListen);
		mCUserTv.setOnClickListener(clickListen);
		btnClose.setOnClickListener(clickListen);
		mCPassBtn.setOnClickListener(clickListen);
		mIntoGameBtn.setOnClickListener(clickListen);

		TextView thirdShowTv = (TextView) findViewById(R.id.thirduser_msg);

		if (YouaiSdkConfig.USERTYPE[1].equals(nowYouaiUser.getUserType())
				& (nowYouaiUser.getIsFirstThird()
						.equals(YouaiSdkConfig.USERTYPE[1]))) {
			
			thirdShowTv.setVisibility(View.VISIBLE);

		} else {
			thirdShowTv.setVisibility(View.INVISIBLE);

		}

		loadingBar.setVisibility(View.GONE);
		
		if (nowYouaiUser.getUserType().equals("2")) {
			mCPassBtn.setText(R.string.binduser);
			accountName.setText(getString(R.string.account) + "UID: "
					+ YouaiCommplatform.getInstance().getLoginUin());
			
		}else if (YouaiCommplatform.getInstance().getLoginNickName() != null) {
			accountName.setText(getString(R.string.account) + ": "
					+ YouaiCommplatform.getInstance().getLoginNickName());
			
		}

	}

	protected void onCreate() {
		setContentView(R.layout.youai_center);
		loadingBar = (ProgressBar) findViewById(R.id.loadingbar);
		accountName = (TextView) findViewById(R.id.u2_account_name);
		btnClose = (ImageButton) findViewById(R.id.u2_close_bt);
		clickListen = new ClickListen();
		loadingBar.setVisibility(View.VISIBLE);

		loadingBar.setVisibility(View.GONE);
		accountName = (TextView) findViewById(R.id.u2_account_name);
		mIntoGameBtn = (Button) findViewById(R.id.intogame);
		mCPassBtn = (Button) findViewById(R.id.u2_changepass);
		mWebOfficalTv = (TextView) findViewById(R.id.officialweb);
		mWebFBFansTv = (TextView) findViewById(R.id.fbfanslink);
		mCUserTv = (TextView) findViewById(R.id.switchusertv);
		
		mWebOfficalTv.setOnClickListener(clickListen);
		mWebFBFansTv.setOnClickListener(clickListen);
		mCUserTv.setOnClickListener(clickListen);
		btnClose.setOnClickListener(clickListen);
		mCPassBtn.setOnClickListener(clickListen);
		mIntoGameBtn.setOnClickListener(clickListen);

		if (YouaiCommplatform.getInstance().getLoginNickName() != null) {
			accountName.setText(getString(R.string.account) + ": "
					+ YouaiCommplatform.getInstance().getLoginNickName());
		}

		TextView thirdShowTv = (TextView) findViewById(R.id.thirduser_msg);

		if (YouaiSdkConfig.USERTYPE[1].equals(nowYouaiUser.getUserType())) {
			thirdShowTv.setVisibility(View.VISIBLE);
		} else {
			thirdShowTv.setVisibility(View.INVISIBLE);
		}

	}

	public static void setFromContext(Context pContext) {
		mFromContext = pContext;
	}

	class ItemClickListen implements OnItemClickListener {

		@Override
		public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
				long arg3) {
			if (arg2 == 0) {
				setControlMan();
			} else if (arg2 == 1) {

				WebindexDialog webindexdialog = new WebindexDialog(
						YouaiControlCenter.this, YouaiSdkConfig.Webindex);
				webindexdialog.show();
			} else if (arg2 == 2) {
				if (YouaiCommplatform.getInstance().getLoginUser() == null)
					return;
				loadingBar.setVisibility(View.VISIBLE);
				YouaiCommplatform.getInstance().youaiLogoutPopu(mFromContext);
				loadingBar.setVisibility(View.GONE);
				YouaiControlCenter.this.finish();
			} else if (arg2 == 3) {
				String url = YouaiSdkConfig.UrlFeedBack + "&puid="
						+ nowYouaiUser.getUidStr() + "&nickName="
						+ YouaiCommplatform.getInstance().getLoginNickName();
				WebindexDialog webindexdialog = new WebindexDialog(
						YouaiControlCenter.this, url);
				webindexdialog.show();
			}
		}

	}

	class ClickListen implements OnClickListener {

		@Override
		public void onClick(View v) {
			if (v.getId() == R.id.u2_title_bar_button_right) {
				YouaiControlCenter.this.onBackPressed();
			} else if (v.getId() == R.id.switchusertv) {
				if (YouaiCommplatform.getInstance().getLoginUser() == null)
					return;
				loadingBar.setVisibility(View.VISIBLE);
				YouaiCommplatform.getInstance().youaiLogoutPopu(mFromContext);
				loadingBar.setVisibility(View.GONE);
				YouaiControlCenter.this.finish();
			} else if (v.getId() == R.id.intogame) {
				YouaiControlCenter.this.onBackPressed();
				
			} else if (v.getId() == R.id.u2_close_bt) {
				YouaiControlCenter.this.onBackPressed();
				
			} else if (v.getId() == R.id.u2_changepass) {
				if (nowYouaiUser.getUserType().endsWith("2")) {
					
					Intent intent = new Intent(YouaiControlCenter.this, YouaiLogin.class);
					intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
					intent.putExtra("KEY_POSITION", 2);
					startActivity(intent);
					YouaiControlCenter.this.finish();
					
				}else{
					
					setControlMan();
					
				}
				
				
			} else if (v.getId() == R.id.officialweb) {
				WebindexDialog webindexdialog = new WebindexDialog(
						YouaiControlCenter.this, YouaiSdkConfig.YouaiWebSite);
				webindexdialog.show();
			} else if (v.getId() == R.id.fbfanslink) {
				WebindexDialog webindexdialog = new WebindexDialog(
						YouaiControlCenter.this, YouaiSdkConfig.Webindex);
				webindexdialog.show();
			}
		}

	}

	protected void setControlMan() {
		YouaiControlCenter.this.setContentView(R.layout.youai_change_password);
		TextView youaiPass = (TextView) findViewById(R.id.u2_account_pass);
		View changeOldView = (View) findViewById(R.id.changeoldview);
		accountName = (TextView) findViewById(R.id.u2_account_name);
		if (YouaiCommplatform.getInstance().getLoginNickName() != null) {
			accountName.setText(getString(R.string.account) + ": "
					+ YouaiCommplatform.getInstance().getLoginNickName());
		}

		if (YouaiSdkConfig.USERTYPE[1].equals(nowYouaiUser.getUserType())
				& (!nowYouaiUser.getPassword().equals(""))
				& nowYouaiUser.getIsFirstThird().equals("1")) {
			youaiPass.setVisibility(View.VISIBLE);
			youaiPass.setText(getString(R.string.initpassword)
					+ nowYouaiUser.getPassword());
		} else {
			youaiPass.setVisibility(View.GONE);
		}

		changProgree = (ProgressBar) findViewById(R.id.changeingpass);
		Button _btnleft = (Button) findViewById(R.id.u2_title_bar_button_left);
		TextView _TvTitleCenter = (TextView) findViewById(R.id.u2_title_bar_title);
		final EditText oldpassEt = (EditText) findViewById(R.id.u2_set_password_old);
		final EditText newpassEt = (EditText) findViewById(R.id.u2_set_password_new);
		_btnleft.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				YouaiControlCenter.this.onCreate();
			}
		});
		Button btnModify = (Button) findViewById(R.id.u2_title_bar_button_right);
		btnModify.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (oldpassEt.getText().toString() == null
						|| oldpassEt.getText().toString().equals("")) {
					Toast.makeText(YouaiControlCenter.this, R.string.inputold,
							Toast.LENGTH_SHORT).show();
					return;
				}
				if (newpassEt.getText().toString() == null
						|| newpassEt.getText().toString().equals("")) {
					Toast.makeText(YouaiControlCenter.this, R.string.inputnew,
							Toast.LENGTH_SHORT).show();
					return;
				}
				changProgree.setVisibility(View.VISIBLE);
				String md5sign = null;
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject();
				try {
					data.put("youaiId", YouaiCommplatform.getInstance()
							.getLoginUin());
					data.put("youaiName", YouaiCommplatform.getInstance()
							.getLoginNickName());
					data.put("oldPassword", oldpassEt.getText().toString());
					data.put("password", newpassEt.getText().toString());
					data.put("isGuestConversion", 0);
					data.put("isInitPassword", 0);
					message.put("data", data);
					message.put("header",
							Utils.makeHead(YouaiControlCenter.this));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}

				YouaiUser _newBindUser = YouaiCommplatform.getInstance()
						.getLoginUser();
				_newBindUser.setPassword(newpassEt.getText().toString());
				_newBindUser.setIsFirstThird("0");
				final YouaiUser newBindUser = _newBindUser;

				String putmessage = "";
				try {
					putmessage = RSAUtil.encryptByPubKey(message.toString(),
							RSAUtil.pub_key_hand);
				} catch (Exception e1) {
					e1.printStackTrace();
				}

				md5sign = MD5.sign(putmessage, YouaiSdkConfig.md5key);

				YouaiApi.modify(putmessage, md5sign, new RequestListener() {

					@Override
					public void onIOException(IOException e) {
						Log.i("error", e.toString());
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								YouaiControlCenter.this.changProgree
										.setVisibility(View.INVISIBLE);
								Toast.makeText(YouaiControlCenter.this,
										R.string.httperr, Toast.LENGTH_SHORT)
										.show();
							}
						});
					}

					@Override
					public void onError(YouaiException e) {
						Log.i("error", e.toString());
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								YouaiControlCenter.this.changProgree
										.setVisibility(View.INVISIBLE);
								Toast.makeText(YouaiControlCenter.this,
										R.string.httperr, Toast.LENGTH_SHORT)
										.show();
							}
						});
					}

					@Override
					public void onComplete(String response) {
						Log.i("response", response);
						JSONObject json;
						try {
							json = new JSONObject(response);
							String error = json.getString("error");

							if (error.equals("200")) {
								YouaiCommplatform
										.getInstance()
										.getLoginUser()
										.setPassword(
												newpassEt.getText().toString());
								YouaiCommplatform.getInstance().setLoginUser(
										YouaiCommplatform.getInstance()
												.getLoginUser());
								YouaiCommplatform.getInstance().setLoginUser(
										newBindUser);
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										YouaiControlCenter.this.changProgree
												.setVisibility(View.INVISIBLE);

										Toast.makeText(YouaiControlCenter.this,
												R.string.passwordcgeok,
												Toast.LENGTH_SHORT).show();
									}
								});
							} else {
								final String errorMessage = json
										.getString("errorMessage");
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										YouaiControlCenter.this.changProgree
												.setVisibility(View.INVISIBLE);
										Toast.makeText(
												YouaiControlCenter.this,
												getString(R.string.passwordcgeerr)
														+ "：" + errorMessage,
												Toast.LENGTH_SHORT).show();
									}
								});
							}
						} catch (JSONException e) {
							e.printStackTrace();
						}

					}
				});
			}
		});
	}

	class ControlAdapter extends BaseAdapter {
		Context context;

		public ControlAdapter(Context pContext) {
			context = pContext;

		}

		@Override
		public int getCount() {
			return mControlText.length;
		}

		@Override
		public Object getItem(int arg0) {
			return null;
		}

		@Override
		public long getItemId(int arg0) {
			return 0;
		}

		@Override
		public View getView(int position, View convertView, ViewGroup parent) {

			Viewhoder holder;
			if (convertView == null) {
				final LayoutInflater inflater = (LayoutInflater) context
						.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
				convertView = inflater.inflate(R.layout.controlman_item, null);
				holder = new Viewhoder();
				holder.iconBtn = (ImageView) convertView
						.findViewById(R.id.iconbt);
				holder.iconBtn.setImageResource(imgs[position]);
				holder.iconBxt = (TextView) convertView
						.findViewById(R.id.icontxt);
				holder.iconBxt.setText(getString(mControlText[position]));
				holder.iconInBtn = (ImageView) convertView
						.findViewById(R.id.iconinbt);
				convertView.setTag(holder);
			} else {
				holder = (Viewhoder) convertView.getTag();
			}
			if (position == 0) {
				convertView.setBackgroundResource(R.drawable.cornertoplayout);
			} else if (position == 1) {
				convertView.setBackgroundResource(R.drawable.cornernomal);
			} else if (position == 2) {
				convertView.setBackgroundResource(R.drawable.cornernomal);
			} else if (position == 3) {
				convertView.setBackgroundResource(R.drawable.cornerbotomlayout);
			}
			return convertView;
		}
	}

	static class Viewhoder {
		ImageView iconBtn;
		TextView iconBxt;
		ImageView iconInBtn;
	}

}