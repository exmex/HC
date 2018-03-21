package com.youai.sdk.android.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.PrintWriter;
import java.net.Socket;
import java.net.UnknownHostException;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;

public class HttpUitlTest {

	public static void main(String[] args)
	{
	try {
	Socket cl=new Socket("119.75.216.30", 80);
	PrintWriter out=new PrintWriter(cl.getOutputStream());
	BufferedReader in=new BufferedReader(new InputStreamReader(cl.getInputStream()));
	String line;
	out.println("GET / HTTP/1.1\r\n\r\n");
	out.println("Accept:image/jpeg,application/x-ms-application,image/gif,application/xaml+xml,image/pjpeg,application/x-ms-xbap,application/x-shockwave-flash,application/vnd.ms-excel,application/vnd.ms-powerpoint,application/msword,*/*");
	out.println("Accept-Language:zh-CN");
	out.println("User-Agent:Mozilla/4.0"); 
	out.println("Accept-Encoding:gzip,deflate");
	out.println("Host:www.baidu.com");
	out.println("Connection:Keep-Alive");
	out.flush();
	System.out.println("Send Succeeded!");
	int maxWait = 3000 * 12;
	int wait = 0;
	while(!in.ready() && wait <= maxWait) {
	Thread.sleep(3000);
	wait += 3000;
	}
	if (in.ready()) {
	line=in.readLine();
	while(line!=null)
	{
	System.out.println(line);
	line=in.readLine();
	}
	System.out.println("Finished Receiving!");
	} else {
	System.out.println("Not ready");
	}
	out.close();
	in.close();
	} catch (UnknownHostException e) {
	e.printStackTrace();
	} catch (IOException e) {
	e.printStackTrace();
	} catch (InterruptedException e) {
	e.printStackTrace();	 }
	}
	
	
	
	
	
	public static void requestPut(String urlStr, String param,String pMd5sign){
		
		HttpClient http = new DefaultHttpClient();
		HttpPut put = new HttpPut(urlStr);
		 
		put.addHeader("Game-Checksum", pMd5sign);
		try {
			http.execute(put);

			
			
		} catch (ClientProtocolException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		
		
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
