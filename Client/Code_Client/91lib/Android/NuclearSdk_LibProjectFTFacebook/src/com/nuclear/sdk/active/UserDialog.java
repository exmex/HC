package com.nuclear.sdk.active;

import java.util.ArrayList;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import android.app.Dialog;
import android.content.Context;
import android.content.SharedPreferences;
import android.content.SharedPreferences.Editor;
import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.view.animation.Animation;
import android.view.animation.RotateAnimation;
import android.widget.AutoCompleteTextView;
import android.widget.BaseAdapter;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CompoundButton;
import android.widget.CompoundButton.OnCheckedChangeListener;
import android.widget.EditText;
import android.widget.ImageButton;
import android.widget.ListView;
import android.widget.TextView;
import android.widget.Toast;

import com.nuclear.sdk.android.entry.SdkUser;
import com.nuclear.sdk.android.utils.DES;
import com.nuclear.sdk.android.utils.JsonUtil;
import com.nuclear.sdk.R;

public class UserDialog extends Dialog {

	private ListView mListView;
	
	private View cancelre;
	private AutoCompleteTextView usernameEd;
	private EditText passwordEd;
	private static int mSelectUser = 0;
	static ArrayList<String> users = new ArrayList<String>();
	static ArrayList<SdkUser> nuclearUsers = new ArrayList<SdkUser>();
	private SaveUserHelp savehelp ;//保存用户的工具类
	
	public UserDialog(Context context,AutoCompleteTextView pUsernameEd,EditText pPasswordEd) {
		super(context);
		usernameEd = pUsernameEd;
		passwordEd = pPasswordEd;
		
		    int count = nuclearUsers.size();
			if(count==0){
				Toast.makeText(getContext(), R.string.nothaveaccount, Toast.LENGTH_SHORT).show();
			}
			savehelp = new SaveUserHelp(context);
	}

	@Override
	protected void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		
		requestWindowFeature(Window.FEATURE_NO_TITLE);
		this.getWindow().setFeatureDrawableAlpha(Window.FEATURE_OPTIONS_PANEL,255);
		
		setContentView(R.layout.userdialog);
		this.getWindow().setBackgroundDrawableResource(android.R.color.transparent);
		cancelre = findViewById(R.id.cancelre);
		mListView = (ListView) findViewById(R.id.userlv);
		mListView.setAdapter(new UserAdapter(getContext()));
		
		
		cancelre.setOnClickListener(new View.OnClickListener() {
			
			@Override
			public void onClick(View v) {
				UserDialog.this.cancel();
			}
		});
		
		
	}
	
	 class UserAdapter extends BaseAdapter{
		Context mContext;  
		LayoutInflater inflater;
		int clickPosition = -1;
		public UserAdapter(Context pContext) {
			 mContext = pContext;
			 inflater = (LayoutInflater) mContext.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
		}
		 
		@Override
		public int getCount() {
			int count = nuclearUsers.size();
			if(count==0){
				if(users.size()<=0){
					UserDialog.this.cancel();
					return 0;					
				}else{
					return users.size();
				}
			}
			return count;
		}

		@Override
		public Object getItem(int position) {
			return null;
			
			
		}

		@Override
		public long getItemId(int position) {
			return 0;
		}

		@Override
		public View getView( int position, View convertView, ViewGroup parent) {
			Viewhoder holder = null;
			final int _position = position;
			
			if(convertView==null){
				
				convertView = inflater.inflate(R.layout.useritem, null);
				holder = new Viewhoder();
				holder.deleteBtn = (ImageButton) convertView.findViewById(R.id.deluserbt);
				holder.useitBtn = (ImageButton) convertView.findViewById(R.id.useuserbt);
				holder.usernameTv = (TextView) convertView.findViewById(R.id.usertv);
				holder.deleteTrue = (Button) convertView.findViewById(R.id.deluserbt_ture);
				convertView.setTag(holder);
			}else{
				holder = (Viewhoder) convertView.getTag();
				holder.deleteBtn = (ImageButton) convertView.findViewById(R.id.deluserbt);
				holder.useitBtn = (ImageButton) convertView.findViewById(R.id.useuserbt);
				holder.usernameTv = (TextView) convertView.findViewById(R.id.usertv);
				holder.deleteTrue = (Button) convertView.findViewById(R.id.deluserbt_ture);
			}
			
			
			
			if(position==mSelectUser){
				holder.useitBtn.setImageResource(R.drawable.ic_select_p);
			} else{
				holder.useitBtn.setImageResource(R.drawable.ic_select);
			}
			
			
			holder.usernameTv.setOnClickListener(new View.OnClickListener() {
				
				@Override
				public void onClick(View v) {
						usernameEd.setText(nuclearUsers.get(_position).getUsername());
					try {
						passwordEd.setText(nuclearUsers.get(_position).getPassword());
					} catch (Exception e) {
						e.printStackTrace();
					}
					mSelectUser = _position;
					UserDialog.this.cancel();
					
				}
			});
			
			holder.useitBtn.setOnClickListener(new View.OnClickListener() {
				
				@Override
				public void onClick(View v) {
						usernameEd.setText(nuclearUsers.get(_position).getUsername());
					try {
						passwordEd.setText(nuclearUsers.get(_position).getPassword());
					} catch (Exception e) {
						e.printStackTrace();
					}
					mSelectUser = _position;
					UserDialog.this.cancel();
					
				}
			});
			
			final View.OnClickListener  clickListenner = new View.OnClickListener() {
				
				@Override
				public void onClick(View v) {
					if(v.getId()==R.id.deluserbt_ture){
					savehelp.doDbDelete(nuclearUsers.get(_position));
					nuclearUsers.remove(_position);
					UserAdapter.this.notifyDataSetChanged();
					UserDialog.this.cancel();
					}
				}
			};

			holder.deleteTrue.setOnClickListener(clickListenner);
			
			final Button delteTrueBtn =  holder.deleteTrue;
			final ImageButton _delteBtn =  holder.deleteBtn;
			holder.deleteBtn.setOnClickListener(new View.OnClickListener() {
				
				@Override
				public void onClick(View arg0) {
					clickPosition = _position;
					
					delteTrueBtn.setVisibility(View.VISIBLE);
					_delteBtn.setVisibility(View.INVISIBLE);
					UserAdapter.this.notifyDataSetChanged();
				}
			});
			 
			if(clickPosition==_position){
				holder.deleteTrue.setVisibility(View.VISIBLE);
				holder.deleteBtn.setVisibility(View.INVISIBLE);
			}else{
				holder.deleteTrue.setVisibility(View.INVISIBLE);
				holder.deleteBtn.setVisibility(View.VISIBLE);
			}
			holder.usernameTv.setText(nuclearUsers.get(position).getUsername());
			return convertView;
			
		}
		 
	 } 
	
	
	static class Viewhoder{
		ImageButton deleteBtn;
		ImageButton useitBtn;
		Button deleteTrue;
		TextView usernameTv;
	}
	
	
}
