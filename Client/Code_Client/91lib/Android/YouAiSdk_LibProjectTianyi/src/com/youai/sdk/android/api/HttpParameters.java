package com.youai.sdk.android.api;

import java.util.ArrayList;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import com.youai.sdk.android.utils.MD5;

import android.text.TextUtils;


public class HttpParameters {
	private ArrayList<String> mKeys = new ArrayList<String>();
	private ArrayList<String> mValues=new ArrayList<String>();
	
	private ArrayList<String> mKeysSort = new ArrayList<String>();
	
	
	public HttpParameters(){
		
	}
	
	
	public void add(String key, String value){
	    if(!TextUtils.isEmpty(key)&&!TextUtils.isEmpty(value)){
	        this.mKeys.add(key);
	        mValues.add(value);
	    }
	   
	}
	
	/**
	 * 将Map组装成待签名数据。 待签名的数据必须按照一定的顺序排列 这个是支付宝提供的服务的规范，否则调用支付宝的服务会通不过签名验证
	 * 
	 * @param params
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public  String getSignData(String appsecret) {
		StringBuffer content = new StringBuffer();
		mKeysSort = new ArrayList<String>();
		mKeysSort = (ArrayList<String>) mKeys.clone();
		Collections.sort(mKeysSort);
		for (int i = 0; i < mKeysSort.size(); i++) {
			String key = (String) mKeysSort.get(i);
			if ("signature".equals(key)) {
				continue;
			}
			String value = (String) this.getValue(key);
			if (value != null) {
				content.append((i == 0 ? "" : "&") + key + "=" + value);
			} else {
				content.append((i == 0 ? "" : "&") + key + "=");
			}
		}
		return MD5.sign(content.toString(), appsecret);
	}
	
	public void add(String key, int value){
	    this.mKeys.add(key);
        this.mValues.add(String.valueOf(value));
	}
	public void add(String key, long value){
	    this.mKeys.add(key);
        this.mValues.add(String.valueOf(value));
    }
	
	public void remove(String key){
	    int firstIndex=mKeys.indexOf(key);
	    if(firstIndex>=0){
	        this.mKeys.remove(firstIndex);
	        this.mValues.remove(firstIndex);
	    }
	  
	}
	
	public void remove(int i){
	    if(i<mKeys.size()){
	        mKeys.remove(i);
	        this.mValues.remove(i);
	    }
		
	}
	
	
	private int getLocation(String key){
		if(this.mKeys.contains(key)){
			return this.mKeys.indexOf(key);
		}
		return -1;
	}
	
	public String getKey(int location){
		if(location >= 0 && location < this.mKeys.size()){
			return this.mKeys.get(location);
		}
		return "";
	}
	
	
	public String getValue(String key){
	    int index=getLocation(key);
	    if(index>=0 && index < this.mKeys.size()){
	        return  this.mValues.get(index);
	    }
	    else{
	        return null;
	    }
		
		
	}
	
	public String getValue(int location){
	    if(location>=0 && location < this.mKeys.size()){
	        String rlt = this.mValues.get(location);
	        return rlt;
	    }
	    else{
	        return null;
	    }
		
	}
	
	
	public int size(){
		return mKeys.size();
	}
	
	
	public void clear(){
		this.mKeys.clear();
		this.mValues.clear();
	}
}
