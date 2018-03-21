package com.example.gtvsdk;


import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URI;
import java.net.URISyntaxException;
import java.net.URL;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import org.apache.http.NameValuePair;
import org.apache.http.client.utils.URLEncodedUtils;
import org.apache.http.protocol.HTTP;
import org.json.JSONException;
import org.json.JSONObject;

import android.util.Log;

public class GTVRequest {

	GTVSDK mGTVSDK;
	String url;
	String httpMethod;
	HashMap<String, Object> params;
	// HashMap<String, Object>connection;

	HttpURLConnection connection;

	// NSMutableData *responseData; 少一个参数

	GTVRequestInterface delegate;

	public GTVRequest(String url, String httpMethod,
			HashMap<String, Object> params, GTVRequestInterface delegate,
			GTVSDK mGTGtvsdk) {
		this.url = serializeURL(params, url);
		this.httpMethod = httpMethod;
		this.params = params;
		this.delegate = delegate;
		this.mGTVSDK = mGTGtvsdk;

	}

	public static String getParamValueFromUrl(String url, String key) {
		String value = null;
		List<NameValuePair> parameters;
		try {

			parameters = URLEncodedUtils.parse(new URI(url), HTTP.UTF_8);
			for (NameValuePair p : parameters) {
				if (p.getName().equals(key)) {
					value = p.getValue();
					return value;
				}
			}
		} catch (URISyntaxException e) {
			e.printStackTrace();
		}
		return value;
	}

	public static String serializeURL(HashMap<String, Object> params, String url) {
		//Log.e("----->", url);
		HashMap<String, Object> map = params;
		Iterator iter = map.entrySet().iterator();
		StringBuilder sb = new StringBuilder(url);
		sb.append("?");
		while (iter.hasNext()) {
			sb.append("&");
			Map.Entry entry = (Entry) iter.next();
			Object key = entry.getKey();
			// 每个val需要进行转义
			Object val = entry.getValue();
			sb.append(key + "=" + val);
		}
		String _sb = sb.toString().replace("?&", "?");
		return _sb;
	}

	public void connect() {
		final String _url = this.url;
		final String _httpMethod = this.httpMethod;
		new Thread() {
			@Override
			public void run() {
				try {
					URL url = new URL(_url);
					//Log.e("提交地址是：", url.toString());
					connection = (HttpURLConnection) url.openConnection();
					connection.setRequestMethod(_httpMethod);
					int state = connection.getResponseCode();
					if (state == 200) {
						//Log.e("----->", "在GTVRequest中,网络连接成功");
						connectionDidFinishLoading(connection);
					} else {
						Log.e("----->", "网络连接出现问题");
						delegate.didFailWithError("网络连接出现问题");
					}
				} catch (Exception e) {
					Log.e("----->", "网络连接出现问题");
					delegate.didFailWithError("网络连接出现问题");
					e.printStackTrace();
				}
			}
		}.start();

	}

	public void disconnect() {

		// 少一个参数

		if (connection != null) {
			connection = null;
		}
	}

	// 数据接收完毕
	private void connectionDidFinishLoading(HttpURLConnection connection) {
		String _dataStr = getConnectString(connection);
		if (_dataStr == null) {
			// 执行request的接口函数

			if (this.connection != null) {
				this.connection = null;
			}
			mGTVSDK.requestDidFinish(this);

		} else {
			//Log.e("----->", _dataStr);
			JSONObject _data = getJsonObject(_dataStr);
			handleResponseData(_data);
			if (this.connection != null) {
				this.connection = null;
			}
			// mGTVSDK.requestDidFinish(this);
		}
	}

	private String getConnectString(HttpURLConnection connection) {
		String conString = null;
		try {
			InputStream is = connection.getInputStream();
			BufferedReader br = new BufferedReader(new InputStreamReader(is));
			StringBuilder sb = new StringBuilder();
			String respStr = null;
			while ((respStr = br.readLine()) != null) {
				sb.append(respStr);
			}
			conString = new String(sb);
			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}
		return conString;
	}

	private JSONObject getJsonObject(String str) {
		try {
			Log.e("-------->",str);
			return new JSONObject(str);
		} catch (JSONException e) {
			e.printStackTrace();
			return null;
		}
	}

	private void handleResponseData(JSONObject data) {
		if (data != null) {
			HashMap map = parseJSONData(data);
			if (delegate != null && delegate instanceof GTVRequestInterface) {
				delegate.didFinishLoadingWithResult(map, this);
			}
		}
	}

	private HashMap parseJSONData(JSONObject data) {
		HashMap<String, Object> map = new HashMap<String, Object>();
		try {
			map.put("result", data.getString("result"));
			if (data.getString("result").equals("T")) {
				map.put("uid", data.getString("uid"));
			} else {
				map.put("msg", data.getString("msg"));
				map.put("code", data.getString("code"));
			}

		} catch (JSONException e) {
			Log.e("----->", "解析json出错了10");
			e.printStackTrace();
		}
		return map;

	}

}

