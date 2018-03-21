package org.cocos2dx.lib;

import java.io.BufferedReader;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.Reader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.List;
import java.util.Map;
import java.util.zip.GZIPInputStream;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.AsyncTask;
import android.util.Log;

public class URLConnectionHelper {
	
	
	private static URLConnectionHelper _instance = null;

	public static URLConnectionHelper getInstance() {
		if (_instance == null) {
			_instance = new URLConnectionHelper();
		}

		return _instance;
	}
	
	public static final int LOCAL_UNKNOW_ERROR = -1;
	public static final int LOCAL_IO_ERROR = -2;
	public static final int LOCAL_EXCEPTION_ERROR = -3;
	public static final int LOCAL_THROWABLE_ERROR = -4;
	public static final int LOCAL_RESPONSE_BAD_STATUS = -5;
	
	
	public static interface URLConnectionAsynCallBack {
		void onRequestResult(String result);
	}
	
	public static int getLocalError(JSONObject jo)
	{
		int x =0 ;
		if(jo.has("local_error"))
			x = jo.optInt("local_error");
		return x;
	}
	
	public static String getLocalErrorMessage(JSONObject jo)
	{
		String x = "";
		if(jo.has("local_errorMsg"))
			x = jo.optString("local_errorMsg");
		return x;
	}
	
	public static String createLocalErrorResult(int code, String message)
	{
		JSONObject jo = new JSONObject();
		try {
			jo.put("local_error", code);
			jo.put("local_errorMsg", message);
		} catch (JSONException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return jo.toString();
	}
	public static void asnycPostHttpRequest( String url,  String sendData, final URLConnectionAsynCallBack callback)
	{
		new AsyncTask<String, String, String>(){

			@Override
			protected String doInBackground(String... arg0) {
				String result= createLocalErrorResult(LOCAL_UNKNOW_ERROR,"Unknown Error");
				BufferedReader br = null;
				PrintWriter pw = null;
				try {
					URL urlObj = new URL(arg0[0]);
					HttpURLConnection conn = (HttpURLConnection)urlObj.openConnection();

					conn.setRequestProperty("accept", "*/*");
					conn.setRequestProperty("connection", "Keep-Alive");
					conn.setRequestProperty("user-agent", "com.ucool.hero.android");
					conn.setDoInput(true);
					conn.setDoOutput(true);

					pw = new PrintWriter(conn.getOutputStream());
					pw.write(arg0[1]);
					pw.flush();

					Log.i("URLConnectionHelper", "asnycPostHttpRequest url: " + arg0[0]);
			        Log.i("URLConnectionHelper", "asnycPostHttpRequest =====sendData: " + arg0[1].toString());
					
					System.out.println("Header:");
					int status = conn.getResponseCode();
					if(status!=200)
					{
						result=  createLocalErrorResult(LOCAL_RESPONSE_BAD_STATUS,"http response status "+ status); 
					}
					
					Map<String, List<String>> map = conn.getHeaderFields();
					
					for (String key : map.keySet()) {
						System.out.println(key + " : " + map.get(key));
					}
					
					List<String> f= map.get("Content-Encoding");
					List<String> f2 = map.get("Content-Type");
					//Log.d("xxxx", f2.toString());
					String contentEncoding = f!=null?f.get(0):"";
					
					InputStream input= conn.getInputStream();
					if (contentEncoding !=null && contentEncoding.equals("gzip")) {
						input = new GZIPInputStream(input);

					} else if (contentEncoding !=null && contentEncoding.equals("deflate")) {
						input = new GZIPInputStream(input);
					}
					
					
					StringBuilder into = new StringBuilder();
					Reader r = new InputStreamReader(conn.getInputStream(),  "UTF-8");
					char[] s = new char[512];
					for (int n; 0 < (n = r.read(s));) {
						into.append(s, 0, n);
					}
					
					result = into.toString();
					
					//Log.d("URLConnectionHelper", "asnycPostHttpRequest result:"+result);
					
				}
				catch(FileNotFoundException e)
				{
					e.printStackTrace();
					result=  createLocalErrorResult(LOCAL_RESPONSE_BAD_STATUS,"http response FileNotFoundException "); 
				}
				catch (IOException e)
				{
					result = createLocalErrorResult(LOCAL_IO_ERROR, e.getMessage());
					e.printStackTrace();
					
				} catch (Exception e) {
					result = createLocalErrorResult(LOCAL_EXCEPTION_ERROR, e.getMessage());
					
					Log.i("URLConnectionHelper", "sendPostHttpRequest Exception " + e);
					e.printStackTrace();
					
				} 
				catch (Throwable e)
				{
					result = createLocalErrorResult(LOCAL_THROWABLE_ERROR, "Unkonw error:" + e.getMessage());
					e.printStackTrace();
				}
				finally {
					Log.i("URLConnectionHelper", "finally ");
					try {
						if (br != null) {
							br.close();
						}
					} catch (IOException ex) {
						ex.printStackTrace();
					}
				}
				return result;
			}
			@Override
			protected void onPostExecute(String result)
			{
				if(callback!=null)
				{
					callback.onRequestResult(result);
				}
			}
			
		}.execute(url, sendData);
			
		
	}
	
	public static String sendPostHttpRequest(String url, String sendData) {
		String result = "";
		BufferedReader br = null;
		PrintWriter pw = null;
		try {
			URL urlObj = new URL(url);
			URLConnection conn = urlObj.openConnection();

			conn.setRequestProperty("accept", "*/*");
			conn.setRequestProperty("connection", "Keep-Alive");
			conn.setRequestProperty("user-agent", "com.ucool.hero.android");
			conn.setDoInput(true);
			conn.setDoOutput(true);

			pw = new PrintWriter(conn.getOutputStream());
			pw.print(sendData);
			pw.flush();

//			System.out.println("Header:");
//			Map<String, List<String>> map = conn.getHeaderFields();
//			for (String key : map.keySet()) {
//				System.out.println(key + " : " + map.get(key));
//			}

			br = new BufferedReader(
					new InputStreamReader(conn.getInputStream()));
			String line;

			while ((line = br.readLine()) != null) {
				result += "\n" + line;
			}

		} catch (Exception e) {
			Log.i("URLConnectionHelper", "sendPostHttpRequest Exception " + e);
			e.printStackTrace();
			result = "URLConnectionException";
		} finally {
			Log.i("URLConnectionHelper", "finally Exception ");
			try {
				if (br != null) {
					br.close();
				}
			} catch (IOException ex) {
				ex.printStackTrace();
			}
		}
		return result;
	}
}
