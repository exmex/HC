package com.youai.sdk.android.api;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.zip.GZIPInputStream;

import org.apache.http.Header;
import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.methods.HttpPut;
import org.apache.http.impl.client.DefaultHttpClient;
import org.json.JSONException;
import org.json.JSONObject;

import com.loopj.android.http.AsyncHttpClient;
import com.loopj.android.http.AsyncHttpResponseHandler;
import com.youai.sdk.active.YouaiLogin;
import com.youai.sdk.android.config.YouaiConfig;
import com.youai.sdk.android.utils.MD5;
import com.youai.sdk.android.utils.RSAUtil;
import com.youai.sdk.android.utils.Utils;
import com.youai.sdk.net.HttpManager;
import com.youai.sdk.net.RequestListener;

import android.content.Context;
import android.util.Log;

public class YouaiApi {
	public static String TAG = "YouaiApi";
	
	public static void preCreate(final Context pContext,final RequestListener listener){
		new Thread(){
			public void run() {
				
				 String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        
			        JSONObject message = new JSONObject();
					JSONObject data = new JSONObject(); 
					try {
						message.put("data", data);
						message.put("header", Utils.makeHead(pContext));
					} catch (JSONException e1) {
						e1.printStackTrace();
					}
					String putmessage = "";
					try {
						putmessage = RSAUtil.encryptByPubKey(message.toString(),RSAUtil.pub_key_hand);
					} catch (Exception e1) {
						e1.printStackTrace();
					}
					
					String md5sign = MD5.sign(putmessage, "-com4loves");
			        try {
			            url = new URL(YouaiConfig.precreate_url);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", md5sign);
			            url_con.setDoOutput(true);
			            url_con.getOutputStream().write(putmessage.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            Log.i(TAG, "status"+url_con.getResponseCode());
			            if(url_con.getResponseCode()==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            String strdecript = RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand);
			            listener.onComplete(strdecript);
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
			        
			};
		}.start();
		
	}
	
	
	public static void modify(final String param,final String checksum,final RequestListener listener){
		 
		new Thread(){
			public void run() {
				 String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        try {
			            url = new URL(YouaiConfig.modify_url);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", checksum);
			            url_con.setDoOutput(true);
			            url_con.getOutputStream().write(param.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            int code = url_con.getResponseCode();
			            Log.i(TAG, "status"+url_con.getResponseCode());
			            if(code==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            String backjson = RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand);
			            listener.onComplete(backjson);
			            }else{
			            	listener.onError(new YouaiException(code));
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
			};
		}.start();
	}
	
	
	public static void getUserList(final String param,final RequestListener listener){
				    String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        try {
			        	final String checksum;
			    		final String encript;
			    		encript = RSAUtil.encryptByPubKey(param, RSAUtil.pub_key_hand);
			    		checksum = MD5.sign(encript, YouaiConfig.md5key);
			            url = new URL(YouaiConfig.GetYouaiList);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", checksum);
			            url_con.setDoOutput(true);
			            url_con.setConnectTimeout(2000);
			            url_con.setReadTimeout(2000);
			            url_con.getOutputStream().write(encript.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            int code = url_con.getResponseCode();
			            Log.i(TAG, "status"+code);
			            if(code==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
			            }else{
			            	listener.onError(new YouaiException(code));
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} catch (Exception e) {
						listener.onError(new YouaiException(e));
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
	}
	
	
	public static void CreateOrLoginTry(final String param,final RequestListener listener){
	    String tempStr = null;
        URL url;
        HttpURLConnection url_con = null;
        try {
        	final String checksum;
    		final String encript;
    		encript = RSAUtil.encryptByPubKey(param, RSAUtil.pub_key_hand);
    		checksum = MD5.sign(encript, YouaiConfig.md5key);
            url = new URL(YouaiConfig.createOrLoginTry);
            url_con = (HttpURLConnection) url.openConnection();
            url_con.setRequestMethod("PUT");
            url_con.addRequestProperty("Game-Checksum", checksum);
            url_con.setDoOutput(true);
            url_con.setConnectTimeout(2000);
            url_con.setReadTimeout(2000);
            url_con.getOutputStream().write(encript.getBytes());
            url_con.getOutputStream().flush();
            url_con.getOutputStream().close();
            int code = url_con.getResponseCode();
            Log.i(TAG, "status"+code);
            if(code==200){
            InputStream in = url_con.getInputStream();
            tempStr = readHttpInput(in);
            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
            }else{
            	listener.onError(new YouaiException(code));
            }
        } catch (MalformedURLException e) {
        	listener.onError(new YouaiException(e));
		} catch (IOException e) {
			listener.onIOException(e);
		} catch (Exception e) {
			listener.onError(new YouaiException(e));
		} finally {
            if (url_con != null)
                url_con.disconnect();
        }
}
	
	public static void getYouaiNames(final String param,final RequestListener listener){
		new Thread(){
			public void run() {
		 String tempStr = null;
	        URL url;
	        HttpURLConnection url_con = null;
	        try {
	        	final String checksum;
	    		checksum = MD5.sign(param, YouaiConfig.md5key);
	            url = new URL(YouaiConfig.GetYouaiList);
	            url_con = (HttpURLConnection) url.openConnection();
	            url_con.setRequestMethod("PUT");
	            url_con.addRequestProperty("Game-Checksum", checksum);
	            url_con.setDoOutput(true);
	            url_con.setConnectTimeout(2000);
	            url_con.setReadTimeout(2000);
	            url_con.getOutputStream().write(param.getBytes());
	            url_con.getOutputStream().flush();
	            url_con.getOutputStream().close();
	            int code = url_con.getResponseCode();
	            Log.i(TAG, "status"+code);
	            if(code==200){
	            InputStream in = url_con.getInputStream();
	            tempStr = readHttpInput(in);
	            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
	            }else{
	            	 listener.onError(new YouaiException(code));
	            }
	        } catch (MalformedURLException e) {
	        	listener.onError(new YouaiException(e));
			} catch (IOException e) {
				listener.onIOException(e);
			} catch (Exception e) {
				listener.onError(new YouaiException(e));
			} finally {
	            if (url_con != null)
	                url_con.disconnect();
	        }
			}
			}.start();
}
	
	public static void pushforclient(final String param,final RequestListener listener){
		new Thread(){
			public void run() {
				 String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        try {
			        	final String checksum;
			    		final String encript;
			    		encript = RSAUtil.encryptByPubKey(param, RSAUtil.pub_key_hand);
			    		checksum = MD5.sign(encript, YouaiConfig.md5key);
			            url = new URL(YouaiConfig.pushforclient);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", checksum);
			            url_con.setDoOutput(true);
			            url_con.getOutputStream().write(encript.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            int code = url_con.getResponseCode();
			            Log.i(TAG, "status"+code);
			            if(code==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
			            }else{
			            	listener.onError(new YouaiException(code));
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
			};
		}.start();
	}

	public static void Login(final String param,final RequestListener listener){
		
		
		new Thread(){
			public void run() {
				 String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        try {
			        	final String checksum;
			    		final String encript;
			    		encript = RSAUtil.encryptByPubKey(param, RSAUtil.pub_key_hand);
			    		checksum = MD5.sign(encript, YouaiConfig.md5key);
			            url = new URL(YouaiConfig.login_url);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", checksum);
			            url_con.setDoOutput(true);
			            url_con.getOutputStream().write(encript.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            int code = url_con.getResponseCode();
			            Log.i(TAG, "status"+code);
			            if(code==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
			            }else{
			            	listener.onError(new YouaiException(code));
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
			};
		}.start();
	}
	
	
public static void TryBinding(final String param,final RequestListener listener){
		
		
		new Thread(){
			public void run() {
				 String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        try {
			        	final String checksum;
			    		final String encript;
			    		encript = RSAUtil.encryptByPubKey(param, RSAUtil.pub_key_hand);
			    		checksum = MD5.sign(encript, YouaiConfig.md5key);
			            url = new URL(YouaiConfig.TryBinding);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", checksum);
			            url_con.setDoOutput(true);
			            url_con.getOutputStream().write(encript.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            int code = url_con.getResponseCode();
			            Log.i(TAG, "status"+code);
			            if(code==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
			            }else{
			            	listener.onError(new YouaiException(code));
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
			};
		}.start();
	}

public static void TryToOk(final String param,final RequestListener listener){
	
	
	new Thread(){
		public void run() {
			 String tempStr = null;
		        URL url;
		        HttpURLConnection url_con = null;
		        try {
		        	final String checksum;
		    		final String encript;
		    		encript = RSAUtil.encryptByPubKey(param, RSAUtil.pub_key_hand);
		    		checksum = MD5.sign(encript, YouaiConfig.md5key);
		            url = new URL(YouaiConfig.TryToOk);
		            url_con = (HttpURLConnection) url.openConnection();
		            url_con.setRequestMethod("PUT");
		            url_con.addRequestProperty("Game-Checksum", checksum);
		            url_con.setDoOutput(true);
		            url_con.getOutputStream().write(encript.getBytes());
		            url_con.getOutputStream().flush();
		            url_con.getOutputStream().close();
		            int code = url_con.getResponseCode();
		            Log.i(TAG, "status"+code);
		            if(code==200){
		            InputStream in = url_con.getInputStream();
		            tempStr = readHttpInput(in);
		            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
		            }else{
		            	listener.onError(new YouaiException(code));
		            }
		        } catch (MalformedURLException e) {
		        	listener.onError(new YouaiException(e));
				} catch (IOException e) {
					listener.onIOException(e);
				} catch (Exception e) {
					e.printStackTrace();
				} finally {
		            if (url_con != null)
		                url_con.disconnect();
		        }
		};
	}.start();
}
	
public static void thirdLogin( String param,final RequestListener listener){
		final String  params = param;
		
		new Thread(){
			public void run() {
				 String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        try {
			        	final String checksum;
			    		final String encript;
			    		encript = RSAUtil.encryptByPubKey(params, RSAUtil.pub_key_hand);
			    		checksum = MD5.sign(encript, YouaiConfig.md5key);
			            url = new URL(YouaiConfig.Thirdlogin_url);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", checksum);
			            url_con.setDoOutput(true);
			            url_con.getOutputStream().write(encript.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            int code = url_con.getResponseCode();
			            Log.i(TAG, "status"+code);
			            if(url_con.getResponseCode()==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            listener.onComplete(RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand));
			            }else{
			            	listener.onError(new YouaiException(code));
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} catch (Exception e) {
						e.printStackTrace();
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
			};
		}.start();
	}
	
	
	public static void Register(final String Checksum,final String param,final RequestListener listener){
		new Thread(){
			public void run() {
				 String tempStr = null;
			        URL url;
			        HttpURLConnection url_con = null;
			        try {
			            url = new URL(YouaiConfig.createUser_url);
			            url_con = (HttpURLConnection) url.openConnection();
			            url_con.setRequestMethod("PUT");
			            url_con.addRequestProperty("Game-Checksum", Checksum);
			            url_con.setDoOutput(true);
			            url_con.getOutputStream().write(param.getBytes());
			            url_con.getOutputStream().flush();
			            url_con.getOutputStream().close();
			            int statuscode = url_con.getResponseCode();
			            Log.i(TAG, "status"+statuscode);
			            if(statuscode==200){
			            InputStream in = url_con.getInputStream();
			            tempStr = readHttpInput(in);
			            listener.onComplete(tempStr);
			            }else {
			            	listener.onError(new YouaiException(statuscode));
			            }
			        } catch (MalformedURLException e) {
			        	listener.onError(new YouaiException(e));
					} catch (IOException e) {
						listener.onIOException(e);
					} finally {
			            if (url_con != null)
			                url_con.disconnect();
			        }
			};
		}.start();
	}
	
	
	public static void Init(final Context pContext,final String appid,final String appKey,final String channelName,final RequestListener listener){
		
		new Thread() {
			public void run() {
				String tempStr = null;
		        URL url;
		        HttpURLConnection url_con = null;
		        
		        JSONObject message = new JSONObject();
				JSONObject data = new JSONObject(); 
				try {
					data.put("appid", appid);
					data.put("appKey", appKey);
					data.put("channel", channelName);
					message.put("data", data);
					message.put("header", Utils.makeHead(pContext));
				} catch (JSONException e1) {
					e1.printStackTrace();
				}
				String putmessage = "";
				try {
					putmessage = RSAUtil.encryptByPubKey(message.toString(),RSAUtil.pub_key_hand);
				} catch (Exception e1) {
					e1.printStackTrace();
				}
				
				String md5sign = MD5.sign(putmessage, "-com4loves");
		        try {
		            url = new URL(YouaiConfig.init_url);
		            url_con = (HttpURLConnection) url.openConnection();
		            url_con.setRequestMethod("PUT");
		            url_con.addRequestProperty("Game-Checksum", md5sign);
		            url_con.setConnectTimeout(6000);
		            url_con.setReadTimeout(6000);
		            url_con.setDoOutput(true);
		            url_con.getOutputStream().write(putmessage.getBytes());
		            url_con.getOutputStream().flush();
		            url_con.getOutputStream().close();
		            int code = url_con.getResponseCode();
		            Log.i(TAG, "init : status"+code);
		            if(code==200){
		            InputStream in = url_con.getInputStream();
		            tempStr = readHttpInput(in);
		            String strdecript = RSAUtil.decryptByPubKey(tempStr, RSAUtil.pub_key_hand);
		            listener.onComplete(strdecript);
		            }else{
		            	listener.onError(new YouaiException(code));	
		            }
		        } catch (MalformedURLException e) {
		        	listener.onError(new YouaiException(e));
				} catch (IOException e) {
					listener.onIOException(e);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				} finally {
		            if (url_con != null)
		                url_con.disconnect();
		        }
		        
			};
		 
		}.start();
			
	}
	
	public  String requestPut(String urlStr, String param,String pMd5sign) throws Exception {
		        StringBuilder tempStr;
		        URL url;
		        HttpURLConnection url_con = null;
		        try {
		            url = new URL(urlStr);
		            url_con = (HttpURLConnection) url.openConnection();
		            url_con.setRequestMethod("PUT");
		            url_con.setRequestProperty("Game-Checksum", pMd5sign);
		            url_con.setDoOutput(true);
		            url_con.getOutputStream().write(param.getBytes());
		            url_con.getOutputStream().flush();
		            url_con.getOutputStream().close();
		            Log.i(TAG, "status"+url_con.getResponseCode());
		            InputStream in = url_con.getInputStream();
		            BufferedReader rd = new BufferedReader(new InputStreamReader(in));
		            tempStr = new StringBuilder();
		            while (rd.read() != -1) {
		                tempStr.append(rd.readLine());
		            }

		        } finally {
		            if (url_con != null)
		                url_con.disconnect();
		        }
		        return new String(tempStr);
	}
	
	
	
public static void requestTest(){
		
	new Thread() {
		public void run() {
			HttpClient http = new DefaultHttpClient();
			HttpPut post = new HttpPut(YouaiConfig.precreate_url);
			try {
				HttpResponse response  = http.execute(post);
				Log.i("status",""+response.getStatusLine());
				String back = readHttpResponse(response);
				
				Log.i("response test:","back"+back);
				
			} catch (ClientProtocolException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}
		};
	 
	}.start();
	
		
		
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

private static String readHttpInput(InputStream response) {
	String result = "";
	try {
		ByteArrayOutputStream content = new ByteArrayOutputStream();

	 	 
		int readBytes = 0;
		byte[] sBuffer = new byte[512];
		while ((readBytes = response.read(sBuffer)) != -1) {
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
