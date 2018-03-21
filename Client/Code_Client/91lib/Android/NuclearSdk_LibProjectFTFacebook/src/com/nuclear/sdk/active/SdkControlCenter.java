package com.nuclear.sdk.active;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.os.Build.VERSION;
import android.os.Bundle;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.Window;
import android.view.WindowManager;
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

import com.nuclear.sdk.android.CallbackListener;
import com.nuclear.sdk.android.api.SdkApi;
import com.nuclear.sdk.android.api.SdkException;
import com.nuclear.sdk.android.config.SdkConfig;
import com.nuclear.sdk.android.entry.SdkUser;
import com.nuclear.sdk.android.utils.MD5;
import com.nuclear.sdk.android.utils.RSAUtil;
import com.nuclear.sdk.android.utils.Utils;
import com.nuclear.sdk.net.RequestListener;
import com.nuclear.sdk.R;

public class SdkControlCenter extends Activity {

	private final String TAG = SdkControlCenter.this.toString();
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
	private SdkUser nownuclearUser;
	private Button mIntoGameBtn, mCPassBtn;
	private TextView mCUserTv, mWebOfficalTv, mWebFBFansTv;
	private boolean ischecked;

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		if(VERSION.SDK_INT>=11){
			setFinishOnTouchOutside(false);
		}
		SdkProtocal.mIsAgree = false;
		// 设置无标题
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		// 设置全屏
		getWindow().setFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN,
				WindowManager.LayoutParams.FLAG_FULLSCREEN);
		nownuclearUser = SdkCommplatform.getInstance().getLoginUser();
		clickListen = new ClickListen();
		setContentView(R.layout.ya_center);

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

		if (SdkConfig.USERTYPE[1].equals(nownuclearUser.getUserType())
				& (nownuclearUser.getIsFirstThird()
						.equals(SdkConfig.USERTYPE[1]))) {

			thirdShowTv.setVisibility(View.VISIBLE);

		} else {
			thirdShowTv.setVisibility(View.INVISIBLE);

		}

		loadingBar.setVisibility(View.GONE);

		if (nownuclearUser.getUserType().equals("2")) {
			mCPassBtn.setText(R.string.binduser);
			accountName.setText(SdkCommplatform.getInstance().getLoginUin());

		} else if (SdkCommplatform.getInstance().getLoginNickName() != null) {
			accountName.setText(SdkCommplatform.getInstance()
					.getLoginNickName());

		}

	}

	@Override
	protected void onResume() {
		// TODO Auto-generated method stub
		super.onResume();
		if(SdkProtocal.mIsAgree){
			ischecked=true;
		}
	}

	protected void onCreate() {
		setContentView(R.layout.ya_center);
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

		if (SdkCommplatform.getInstance().getLoginNickName() != null) {
			accountName.setText(SdkCommplatform.getInstance()
					.getLoginNickName());
		}

		TextView thirdShowTv = (TextView) findViewById(R.id.thirduser_msg);

		if (SdkConfig.USERTYPE[1].equals(nownuclearUser.getUserType())) {
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
						SdkControlCenter.this, "");
				webindexdialog.show();
			} else if (arg2 == 2) {
				if (SdkCommplatform.getInstance().getLoginUser() == null)
					return;
				loadingBar.setVisibility(View.VISIBLE);
				SdkCommplatform.getInstance().nuclearLogoutPopu(mFromContext);
				loadingBar.setVisibility(View.GONE);
				SdkControlCenter.this.finish();
			} else if (arg2 == 3) {
				String url = SdkConfig.UrlFeedBack + "&puid="
						+ nownuclearUser.getUidStr() + "&nickName="
						+ SdkCommplatform.getInstance().getLoginNickName();
				WebindexDialog webindexdialog = new WebindexDialog(
						SdkControlCenter.this, url);
				webindexdialog.show();
			}
		}

	}

	class ClickListen implements OnClickListener {

		@Override
		public void onClick(View v) {
			if (v.getId() == R.id.u2_title_bar_button_right) {
				SdkControlCenter.this.onBackPressed();
			} else if (v.getId() == R.id.switchusertv) {
				if (SdkCommplatform.getInstance().getLoginUser() == null)
					return;
				loadingBar.setVisibility(View.VISIBLE);
				SdkCommplatform.getInstance().nuclearLogoutPopu(mFromContext);
				loadingBar.setVisibility(View.GONE);
				SdkControlCenter.this.finish();
			} else if (v.getId() == R.id.intogame) {
				SdkControlCenter.this.onBackPressed();

			} else if (v.getId() == R.id.u2_close_bt) {
				SdkControlCenter.this.onBackPressed();

			} else if (v.getId() == R.id.u2_changepass) {
				if (nownuclearUser.getUserType().endsWith("2")) {

					Intent intent = new Intent(SdkControlCenter.this,
							SdkRegistBind.class);
					startActivity(intent);
					SdkControlCenter.this.finish();

				} else {

					setControlMan();

				}

			} else if (v.getId() == R.id.officialweb) {
				WebindexDialog webindexdialog = new WebindexDialog(
						SdkControlCenter.this, SdkConfig.nuclearWebSite);
				webindexdialog.show();
			} else if (v.getId() == R.id.fbfanslink) {
				WebindexDialog webindexdialog = new WebindexDialog(
						SdkControlCenter.this, "");
				webindexdialog.show();
			}
		}

	}

	protected void setControlMan() {
		SdkControlCenter.this.setContentView(R.layout.ya_change_password);
		TextView nuclearPass = (TextView) findViewById(R.id.u2_account_pass);
		View changeOldView = (View) findViewById(R.id.changeoldview);
		accountName = (TextView) findViewById(R.id.u2_account_name);
		if (SdkCommplatform.getInstance().getLoginNickName() != null) {
			accountName.setText(SdkCommplatform.getInstance()
					.getLoginNickName());
		}

		if (SdkConfig.USERTYPE[1].equals(nownuclearUser.getUserType())
				& (!nownuclearUser.getPassword().equals(""))
				& nownuclearUser.getIsFirstThird().equals("1")) {
			nuclearPass.setVisibility(View.VISIBLE);
			nuclearPass.setText(getString(R.string.initpassword)
					+ nownuclearUser.getPassword());
		} else {
			nuclearPass.setVisibility(View.GONE);
		}

		changProgree = (ProgressBar) findViewById(R.id.changeingpass);
		Button _btnleft = (Button) findViewById(R.id.u2_title_bar_button_left);
		TextView _TvTitleCenter = (TextView) findViewById(R.id.u2_title_bar_title);
		final EditText oldpassEt = (EditText) findViewById(R.id.u2_set_password_old);
		final EditText newpassEt = (EditText) findViewById(R.id.u2_set_password_new);
		_btnleft.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View arg0) {
				SdkControlCenter.this.onCreate();
			}
		});
		Button btnModify = (Button) findViewById(R.id.u2_title_bar_button_right);
		btnModify.setOnClickListener(new OnClickListener() {

			@Override
			public void onClick(View v) {
				if (oldpassEt.getText().toString() == null
						|| oldpassEt.getText().toString().equals("")) {
					Toast.makeText(SdkControlCenter.this, R.string.inputold,
							Toast.LENGTH_SHORT).show();
					return;
				}
				if (newpassEt.getText().toString() == null
						|| newpassEt.getText().toString().equals("")) {
					Toast.makeText(SdkControlCenter.this, R.string.inputnew,
							Toast.LENGTH_SHORT).show();
					return;
				}
				changProgree.setVisibility(View.VISIBLE);
				String md5sign = null;
				JSONObject message = new JSONObject();
				JSONObject data = new JSONObject();
				try {
					data.put("nuclearId", SdkCommplatform.getInstance()
							.getLoginUin());
					data.put("nuclearName", SdkCommplatform.getInstance()
							.getLoginNickName());
					data.put("oldPassword", oldpassEt.getText().toString());
					data.put("password", newpassEt.getText().toString());
					data.put("isGuestConversion", 0);
					data.put("isInitPassword", 0);
					message.put("data", data);
					message.put("header", Utils.makeHead(SdkControlCenter.this));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}

				SdkUser _newBindUser = SdkCommplatform.getInstance()
						.getLoginUser();
				_newBindUser.setPassword(newpassEt.getText().toString());
				_newBindUser.setIsFirstThird("0");
				final SdkUser newBindUser = _newBindUser;

				String putmessage = "";
				try {
					putmessage = RSAUtil.encryptByPubKey(message.toString(),
							RSAUtil.pub_key_hand);
				} catch (Exception e1) {
					e1.printStackTrace();
				}

				md5sign = MD5.sign(putmessage, SdkConfig.md5key);

				SdkApi.modify(putmessage, md5sign, new RequestListener() {

					@Override
					public void onIOException(IOException e) {
						Log.i("error", e.toString());
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								SdkControlCenter.this.changProgree
										.setVisibility(View.INVISIBLE);
								Toast.makeText(SdkControlCenter.this,
										R.string.httperr, Toast.LENGTH_SHORT)
										.show();
							}
						});
					}

					@Override
					public void onError(SdkException e) {
						Log.i("error", e.toString());
						runOnUiThread(new Runnable() {
							@Override
							public void run() {
								SdkControlCenter.this.changProgree
										.setVisibility(View.INVISIBLE);
								Toast.makeText(SdkControlCenter.this,
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
								SdkCommplatform
										.getInstance()
										.getLoginUser()
										.setPassword(
												newpassEt.getText().toString());
								SdkCommplatform.getInstance().setLoginUser(
										SdkCommplatform.getInstance()
												.getLoginUser());
								SdkCommplatform.getInstance().setLoginUser(
										newBindUser);
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										SdkControlCenter.this.changProgree
												.setVisibility(View.INVISIBLE);

										Toast.makeText(SdkControlCenter.this,
												R.string.passwordcgeok,
												Toast.LENGTH_SHORT).show();
										SdkControlCenter.this.finish();
									}
								});
							} else {
								final String errorMessage = json
										.getString("errorMessage");
								runOnUiThread(new Runnable() {
									@Override
									public void run() {
										SdkControlCenter.this.changProgree
												.setVisibility(View.INVISIBLE);
										Toast.makeText(
												SdkControlCenter.this,
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