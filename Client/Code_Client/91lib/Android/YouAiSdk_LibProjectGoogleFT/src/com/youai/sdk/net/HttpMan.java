package com.youai.sdk.net;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.zip.GZIPInputStream;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.StatusLine;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.client.methods.HttpUriRequest;
import org.apache.http.impl.client.DefaultHttpClient;

import com.youai.sdk.android.api.HttpParameters;
import com.youai.sdk.android.api.YouaiException;
import com.youai.sdk.android.utils.MD5;
import com.youai.sdk.android.utils.RSAUtil;

import android.os.SystemClock;
import android.util.Log;


public class HttpMan {

	
	private static final String HTTPMETHOD_POST = "POST";
	public static final String HTTPMETHOD_GET = "GET";
	public static final String HTTPMETHOD_PUT = "PUT";
	private static final int SET_CONNECTION_TIMEOUT = 5 * 1000;
	private static final int SET_SOCKET_TIMEOUT = 20 * 1000;
	
	public String TAG = HttpMan.this.toString();

	
	public String requestMan(String urlStr,String method, String param)throws YouaiException {
		StringBuilder tempStr = null;
		URL url;
		HttpURLConnection url_con = null;
		
		String encryparam = "";
		try {
			encryparam = RSAUtil.encryptByPriKey(param, RSAUtil.pub_key_hand);
		} catch (Exception e1) {
			e1.printStackTrace();
		}
		try {
			url = new URL(urlStr);
			url_con = (HttpURLConnection) url.openConnection();
			url_con.setRequestMethod("PUT");
			String sign = MD5.sign(param, "-com4loves");
			url_con.setRequestProperty("Game-Checksum", sign);
			url_con.setDoOutput(true);
			url_con.getOutputStream().write(param.getBytes());
			url_con.getOutputStream().flush();
			url_con.getOutputStream().close();
			Log.i(TAG, "status" + url_con.getResponseCode());
			InputStream in = url_con.getInputStream();
			BufferedReader rd = new BufferedReader(new InputStreamReader(in));
			tempStr = new StringBuilder();
			while (rd.read() != -1) {
				tempStr.append(rd.readLine());
			}

		} catch (MalformedURLException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (url_con != null)
				url_con.disconnect();
		}
		return new String(tempStr);
	}

	public String  requestHttp(String urlStr,String method, String param)throws YouaiException {

		String response = "";
		HttpClient httpclient = new DefaultHttpClient();
		HttpUriRequest request = null;
		
		if(method.equals(HTTPMETHOD_GET)){
			HttpGet get = new HttpGet(urlStr);
			request = get;
		}else if(method.equals(HTTPMETHOD_POST)){
			HttpPost post = new HttpPost(urlStr);
			request = post;
		}else if(method.equals(HTTPMETHOD_PUT)){
			HttpPut put = new HttpPut(urlStr);
			request = put;
			SystemClock.currentThreadTimeMillis();
		}
		
		 
		request.addHeader("Game-Checksum","-com4loves");
		HttpResponse httpResponse = null;
		int statusCode = 0 ;
		try {
			httpResponse = httpclient.execute(request);
			StatusLine status = httpResponse.getStatusLine();
			statusCode = status.getStatusCode();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}
		
		
		if (statusCode != 200) {
			response = readHttpResponse(httpResponse);
			throw new YouaiException(response, statusCode);
		}
		response = readHttpResponse(httpResponse);
		return response;
		
	}
	
	
	private static String readHttpResponse(HttpResponse response) {
		String result = "";
		HttpEntity entity = response.getEntity();
		InputStream inputStream;
		try {
			inputStream = entity.getContent();
			ByteArrayOutputStream content = new ByteArrayOutputStream();

			Header header = response.getFirstHeader("Content-Encoding");
			if (header != null && header.getValue().toLowerCase().indexOf("gzip") > -1) {
				inputStream = new GZIPInputStream(inputStream);
			}

			int readBytes = 0;
			byte[] sBuffer = new byte[512];
			while ((readBytes = inputStream.read(sBuffer)) != -1) {
				content.write(sBuffer, 0, readBytes);
			}
			result = new String(content.toByteArray());
			return result;
		} catch (IllegalStateException e) {
		} catch (IOException e) {
		}
		return result;
	}

}
