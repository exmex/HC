package com.qlz.qlzdownloadapk;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

import android.os.AsyncTask;
import android.os.Environment;
import android.widget.ProgressBar;

public class CustomDownload extends AsyncTask<String, Integer, String> {

	ProgressBar progressBar;

	/*
	 * private CustomDownload mDownloader;
	 * 
	 * String mDownloadUrl;
	 * 
	 * private CustomDownload (){
	 * 
	 * }
	 * 
	 * public CustomDownload newInstance(String pUrl){ if (mDownloader==null) {
	 * mDownloader = new CustomDownload(); } mDownloader.mDownloadUrl = pUrl;
	 * return mDownloader; }
	 */
	
	

	@Override
	protected String doInBackground(String... params) {
		// TODO Auto-generated method stub
		HttpGet httpRequest = new HttpGet(params[0]);
		HttpClient httpClient = new DefaultHttpClient();
		try {
			HttpResponse httpResponse = httpClient.execute(httpRequest);
			HttpEntity entity = httpResponse.getEntity();
			long length = entity.getContentLength();
			progressBar.setMax((int) length);
			System.out.println("length:" + length);
			InputStream inputStream = entity.getContent();
			byte[] b = new byte[1024];
			int readedLength = -1;
			File file = new File(Environment.getExternalStorageDirectory()
					.getAbsoluteFile(), "com4love.apk");
			OutputStream outputStream = new FileOutputStream(file);
			
			int count = 0;
			while ((readedLength = inputStream.read(b)) != -1) {
				outputStream.write(b, 0, readedLength);
				count += readedLength;
				// 调用了这个方法之后会触发onProgressUpdate(Integer... values)
				publishProgress(count);
			}
			inputStream.close();
			outputStream.close();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
		}
		return null;
	}

	@Override
	protected void onProgressUpdate(Integer... values) {
		// System.out.println("onProgressUpdate");
		// 用来更新界面
		progressBar.setProgress(values[0]);
		super.onProgressUpdate(values);
	}
	
	@Override
	protected void onPostExecute(String result) {
		super.onPostExecute(result);
	}
	
	@Override
	protected void onPreExecute() {
		super.onPreExecute();
		
	}
	
}
