package com.youai.sdk.active;

import java.io.IOException;

import org.json.JSONException;
import org.json.JSONObject;

import android.app.Activity;
import android.content.Context;
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
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.LinearLayout.LayoutParams;
import android.widget.ProgressBar;
import android.widget.TextView;
import android.widget.Toast;

import com.youai.sdk.R;
import com.youai.sdk.android.CallbackListener;
import com.youai.sdk.android.api.YouaiApi;
import com.youai.sdk.android.api.YouaiException;
import com.youai.sdk.android.config.YouaiConfig;
import com.youai.sdk.android.entry.YouaiUser;
import com.youai.sdk.android.utils.MD5;
import com.youai.sdk.android.utils.RSAUtil;
import com.youai.sdk.android.utils.Utils;
import com.youai.sdk.net.RequestListener;


public class YouaiControlCenter  extends Activity {
	
	
	
	 private final String TAG = YouaiControlCenter.this.toString();
	 protected static CallbackListener mCallBack; //打开用户中心回调
	 private Button btnleft; //Title左边按钮
	 private Button btnRight;//Title右边按钮
	 private TextView TvTitleCenter; //Title中间标题
	 ProgressBar changProgree; //改变密码的进度条
	 private static Context mFromContext;
	 protected static boolean thirdLoginFirst;
	 ClickListen clickListen ;
	 private ProgressBar loadingBar;//加载的进度条
	 private Button logoutBtn; //帐号中心的注销按钮
	 TextView accountName; //帐号名称
	 private MyListView mControlList;
	 
	 private int[] imgs = {R.drawable.accounticon,R.drawable.mainpageicon,R.drawable.logouticon,R.drawable.mainpageicon};
	 private String[] mControlText = {"修改密码","社区官网","切换用户","建议反馈"};
	 private YouaiUser nowYouaiUser;
	 
	 
	@Override
	protected void onCreate(Bundle savedInstanceState) {
	 super.onCreate(savedInstanceState);
	 nowYouaiUser = YouaiCommplatform.getInstance().getLoginUser();
	 clickListen = new ClickListen();
	 setContentView(R.layout.youai_account_man);
	 loadingBar = (ProgressBar) findViewById(R.id.loadingbar);
	 btnleft = (Button) findViewById(R.id.u2_title_bar_button_right);
	 logoutBtn = (Button) findViewById(R.id.u2_title_bar_button_logout);
	 logoutBtn.setOnClickListener(clickListen);
	 btnleft.setOnClickListener(clickListen);
	 accountName = (TextView) findViewById(R.id.u2_account_name);
	 loadingBar.setVisibility(View.VISIBLE);
	 logoutBtn.setOnClickListener(clickListen);
	 mControlList = (MyListView) findViewById(R.id.controllist);
	 TextView thirdShowTv = (TextView) findViewById(R.id.thirduser_msg);
	 
	 if(YouaiConfig.USERTYPE[1].equals(nowYouaiUser.getUserType())&(nowYouaiUser.getIsFirstThird().equals("1"))){
		thirdShowTv.setVisibility(View.VISIBLE);
	 }else{
		 thirdShowTv.setVisibility(View.INVISIBLE);
	 }
	 
	 mControlList.setAdapter(new ControlAdapter(this));
	 loadingBar.setVisibility(View.GONE);
	 mControlList.setOnItemClickListener(new ItemClickListen());
	 accountName = (TextView) findViewById(R.id.u2_account_name);
	 if(YouaiCommplatform.getInstance().getLoginNickName()!=null)
	  {
			 accountName.setText("帐号: "+YouaiCommplatform.getInstance().getLoginNickName());
	  }
	 
	 
	 
	}
	

	protected void onCreate(){
		 setContentView(R.layout.youai_account_man);
		 loadingBar = (ProgressBar) findViewById(R.id.loadingbar);
		 accountName = (TextView) findViewById(R.id.u2_account_name);
		 btnleft = (Button) findViewById(R.id.u2_title_bar_button_right);
		 Button logout = (Button) findViewById(R.id.u2_title_bar_button_logout);
		 clickListen = new ClickListen();
		 logout.setOnClickListener(clickListen);
		 btnleft.setOnClickListener(clickListen);
		 loadingBar.setVisibility(View.VISIBLE);
		 logout.setOnClickListener(clickListen);
		 
		 loadingBar.setVisibility(View.GONE);
		 mControlList = (MyListView) findViewById(R.id.controllist);
		 mControlList.setAdapter(new ControlAdapter(this));
		 mControlList.setOnItemClickListener(new ItemClickListen());
		 accountName = (TextView) findViewById(R.id.u2_account_name);
		  if(YouaiCommplatform.getInstance().getLoginNickName()!=null)
		  {
				accountName.setText("帐号: "+YouaiCommplatform.getInstance().getLoginNickName());
		  }
		
		TextView thirdShowTv = (TextView) findViewById(R.id.thirduser_msg);
			 
		if(YouaiConfig.USERTYPE[1].equals(nowYouaiUser.getUserType())){
				thirdShowTv.setVisibility(View.VISIBLE);
			 }else{
				 thirdShowTv.setVisibility(View.INVISIBLE);
		 }
	}
		 public  static void setFromContext(Context pContext){
			 mFromContext = pContext;
		 }
		 
		 class ItemClickListen implements OnItemClickListener{

			@Override
			public void onItemClick(AdapterView<?> arg0, View arg1, int arg2,
					long arg3) {
					if(arg2== 0){
						setControlMan();
					}else if(arg2 == 1){
						WebindexDialog webindexdialog = new WebindexDialog(YouaiControlCenter.this, YouaiConfig.Webindex);
						webindexdialog.show();
					}else if(arg2 == 2){
						if(YouaiCommplatform.getInstance().getLoginUser()==null)return;
						loadingBar.setVisibility(View.VISIBLE);
						YouaiCommplatform.getInstance().youaiLogoutPopu(mFromContext);
						loadingBar.setVisibility(View.GONE);
						YouaiControlCenter.this.finish();
					}else if(arg2 == 3){
						String url = YouaiConfig.UrlFeedBack + "&puid="+nowYouaiUser.getUidStr();
						WebindexDialog webindexdialog = new WebindexDialog(YouaiControlCenter.this, url);
						webindexdialog.show();
					}
			}
			 
		 }
	  class ClickListen implements OnClickListener{

		@Override
		public void onClick(View v) {
			if(v.getId()==R.id.u2_title_bar_button_right){
				YouaiControlCenter.this.onBackPressed();
			}else if(v.getId()==R.id.u2_title_bar_button_logout){
				if(YouaiCommplatform.getInstance().getLoginUser()==null)return;
				loadingBar.setVisibility(View.VISIBLE);
				YouaiCommplatform.getInstance().youaiLogoutPopu(mFromContext);
				loadingBar.setVisibility(View.GONE);
				YouaiControlCenter.this.finish();
			}
		}
		  
	  }
	 
	  
	  protected void setControlMan(){
					YouaiControlCenter.this.setContentView(R.layout.youai_change_password);
					TextView youaiPass = (TextView) findViewById(R.id.u2_account_pass);
					View changeOldView = (View) findViewById(R.id.changeoldview);
					accountName = (TextView) findViewById(R.id.u2_account_name);
					if(YouaiCommplatform.getInstance().getLoginNickName()!=null)
					 {
							accountName.setText("帐号: "+YouaiCommplatform.getInstance().getLoginNickName());
					 }
					
					if(YouaiConfig.USERTYPE[1].equals(nowYouaiUser.getUserType())&(!nowYouaiUser.getPassword().equals(""))
							&nowYouaiUser.getIsFirstThird().equals("1")){
						youaiPass.setVisibility(View.VISIBLE);
						youaiPass.setText("系统为您设置的初始密码："+nowYouaiUser.getPassword());
					}else{
						youaiPass.setVisibility(View.GONE);
					}
					
					changProgree = (ProgressBar) findViewById(R.id.changeingpass);
					Button	 _btnleft = (Button) findViewById(R.id.u2_title_bar_button_left);
					TextView _TvTitleCenter = (TextView) findViewById(R.id.u2_title_bar_title);
					final EditText oldpassEt = (EditText) findViewById(R.id.u2_set_password_old) ;
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
								if(oldpassEt.getText().toString()==null||oldpassEt.getText().toString().equals("")){
									Toast.makeText(YouaiControlCenter.this, "请填写原密码", Toast.LENGTH_SHORT).show();
									return;
								}
								if(newpassEt.getText().toString()==null||newpassEt.getText().toString().equals("")){
									Toast.makeText(YouaiControlCenter.this, "请填写新密码", Toast.LENGTH_SHORT).show();
									return;
								}
								changProgree.setVisibility(View.VISIBLE);
								String md5sign = null;
								JSONObject message = new JSONObject();
								JSONObject data = new JSONObject();
								try {
									data.put("youaiId", YouaiCommplatform.getInstance().getLoginUin());
									data.put("youaiName", YouaiCommplatform.getInstance().getLoginNickName()); 
									data.put("oldPassword", oldpassEt.getText().toString());
									data.put("password",newpassEt.getText().toString());
									data.put("isGuestConversion", 0);
									data.put("isInitPassword", 0);
									message.put("data", data);
									message.put("header",Utils.makeHead(YouaiControlCenter.this));
								} catch (JSONException e1) {
									e1.printStackTrace();
								}
								
								YouaiUser _newBindUser = YouaiCommplatform.getInstance().getLoginUser();
								_newBindUser.setPassword(newpassEt.getText().toString());
								_newBindUser.setIsFirstThird("0");
								final YouaiUser newBindUser = _newBindUser;
								
								
								String putmessage="";
								try {
									putmessage = RSAUtil.encryptByPubKey(message.toString(),RSAUtil.pub_key_hand);
								} catch (Exception e1) {
									e1.printStackTrace();
								}
								
								md5sign = MD5.sign(putmessage, YouaiConfig.md5key);
								
								YouaiApi.modify(putmessage, md5sign,new RequestListener() {
									
									@Override
									public void onIOException(IOException e) {
										Log.i("error", e.toString());
										runOnUiThread(new Runnable() {
											@Override
											public void run() {
												YouaiControlCenter.this.changProgree.setVisibility(View.INVISIBLE);
												Toast.makeText(YouaiControlCenter.this, "网络访问错误", Toast.LENGTH_SHORT).show();		
											}
										});
									}
									
									@Override
									public void onError(YouaiException e) {
										Log.i("error", e.toString());
										runOnUiThread(new Runnable() {
											@Override
											public void run() {
												YouaiControlCenter.this.changProgree.setVisibility(View.INVISIBLE);
												Toast.makeText(YouaiControlCenter.this, "网络访问错误", Toast.LENGTH_SHORT).show();		
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
											
											if(error.equals("200")){
												YouaiCommplatform.getInstance().getLoginUser().setPassword(newpassEt.getText().toString());
												YouaiCommplatform.getInstance().setLoginUser(YouaiCommplatform.getInstance().getLoginUser());
												YouaiCommplatform.getInstance().setLoginUser(newBindUser);
												runOnUiThread(new Runnable() {
													@Override
													public void run() {
														YouaiControlCenter.this.changProgree.setVisibility(View.INVISIBLE);
														
														Toast.makeText(YouaiControlCenter.this, "密码修改成功", Toast.LENGTH_SHORT).show();		
													}
												});
											}else{
												final String errorMessage = json.getString("errorMessage");
												runOnUiThread(new Runnable() {
													@Override
													public void run() {
														YouaiControlCenter.this.changProgree.setVisibility(View.INVISIBLE);
														Toast.makeText(YouaiControlCenter.this, "密码修改失败："+errorMessage, Toast.LENGTH_SHORT).show();		
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
	  
	  class ControlAdapter extends BaseAdapter{
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
				if(convertView==null){
					final LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
					convertView = inflater.inflate(R.layout.controlman_item, null);
					holder = new Viewhoder();
					holder.iconBtn = (ImageView) convertView.findViewById(R.id.iconbt);
					holder.iconBtn.setImageResource(imgs[position]);
					holder.iconBxt = (TextView) convertView.findViewById(R.id.icontxt);
					holder.iconBxt.setText(mControlText[position]);
					holder.iconInBtn = (ImageView) convertView.findViewById(R.id.iconinbt);
					convertView.setTag(holder);
				}else{
					holder = (Viewhoder) convertView.getTag();
				}
				if(position==0){
					convertView.setBackgroundResource(R.drawable.cornertoplayout);
				}else if(position==1){
					convertView.setBackgroundResource(R.drawable.cornernomal);
				}else if(position==2){
					convertView.setBackgroundResource(R.drawable.cornernomal);
				}else if(position==3){
					convertView.setBackgroundResource(R.drawable.cornerbotomlayout);
				}
				return convertView;
			}
	}
	static class Viewhoder{
		ImageView iconBtn;
		TextView iconBxt;
		ImageView iconInBtn;
	}
	  
	  
	  
}