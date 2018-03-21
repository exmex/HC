
package com.nuclear.dota.platform.punchbox;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.URL;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.impl.client.DefaultHttpClient;

/***
 * 通过http访问应用服务器，获取http返回结果
 */
public class SdkHttpTask {

    

    private static String convertStreamToString(InputStream is) {
        BufferedReader reader = new BufferedReader(new InputStreamReader(is));
        StringBuilder sb = new StringBuilder();
        String line = null;
        try {
            while ((line = reader.readLine()) != null) {
                sb.append(line);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                is.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
        return sb.toString();
    }

    
/*public static void doGet(final SdkHttpListener sdkHttpListener,  String url) {
		
		final String uil_str = url;
	new Thread() {
			@Override
			public void run() {
		
		
		String result = null;
		URL urlGet = null;
		HttpURLConnection connection = null;
		InputStreamReader in = null;
		try {
			urlGet = new URL(uil_str);
			
			connection=(HttpURLConnection) urlGet.openConnection();
			connection.setReadTimeout(30000);
			connection.setRequestMethod("GET");
			connection.setDoInput(true);
			connection.connect();
			int status = connection.getResponseCode();
			Log.i("status", "status:"+status);
			in = new InputStreamReader(connection.getInputStream());
			BufferedReader bufferedReader = new BufferedReader(in);
			StringBuffer strBuffer = new StringBuffer();
			String line = "";
			while ((line = bufferedReader.readLine()) != null) {
				strBuffer.append(line);
			}
			result = strBuffer.toString();
			sdkHttpListener.onResponse(result);
		} catch (MalformedURLException e) {
			sdkHttpListener.onCancelled();
		} catch (IOException e) {
			sdkHttpListener.onCancelled();
		} finally {
			if (connection != null) {
				connection.disconnect();
			}
			if (in != null) {
				try {
					in.close();
				} catch (IOException e) {
					sdkHttpListener.onCancelled();
				}
			}
		}
	}

		}.start();
	}*/

	public static void doGet(final SdkHttpListener sdkHttpListener,  String url) {
		final String uil_str = url;
	new Thread() {
			@Override
			public void run() {
		
		
		URL urlGet = null;
		BufferedReader in = null;
		HttpClient client;
		String content;
		try {
			urlGet = new URL(uil_str);
			client = new DefaultHttpClient();
			
			 // 实例化HTTP方法  
            HttpGet request = new HttpGet(uil_str); 
            HttpResponse response = client.execute(request);  
			
            in = new BufferedReader(new InputStreamReader(response.getEntity()  
                    .getContent()));  
            StringBuffer sb = new StringBuffer("");  
            String line = "";  
            while ((line = in.readLine()) != null) {  
                sb.append(line);  
            }  
            in.close();  
            content = sb.toString();  
            
            if(response.getStatusLine().getStatusCode()!=200)
            	sdkHttpListener.onError();
            sdkHttpListener.onResponse(content);
        } catch (IOException e) {
			e.printStackTrace();
			 sdkHttpListener.onCancelled();
		} finally {  
            if (in != null) {  
                try {  
                    in.close();// 最后要关闭BufferedReader  
                } catch (Exception e) {  
                    e.printStackTrace();  
                    sdkHttpListener.onCancelled();
                }  
            }  
             
        }  
	 }

		}.start();
	}
}
