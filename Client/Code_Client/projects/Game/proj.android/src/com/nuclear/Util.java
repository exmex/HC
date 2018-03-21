package com.nuclear;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.net.InetAddress;
import java.net.NetworkInterface;
import java.net.SocketException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.GregorianCalendar;
import java.util.Locale;
import java.util.Properties;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

import org.apache.http.HttpEntity;
import org.apache.http.HttpResponse;
import org.apache.http.HttpStatus;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.conn.util.InetAddressUtils;
import org.apache.http.entity.ByteArrayEntity;
import org.apache.http.impl.client.DefaultHttpClient;
import org.apache.http.params.HttpConnectionParams;
import org.apache.http.params.HttpParams;
import org.codehaus.jackson.map.DeserializationConfig;
import org.codehaus.jackson.map.ObjectMapper;

import android.app.Activity;
import android.content.Context;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.util.Log;

import com.nuclear.PlatformAndGameInfo.GameInfo;

/**
 * 工具类。
 */
public class Util {

	private static ObjectMapper objectMapper = new ObjectMapper();
	static {
		objectMapper.setDateFormat(new SimpleDateFormat("yyyy-MM-dd"));
		objectMapper
				.setDeserializationConfig(objectMapper
						.getDeserializationConfig()
						.without(
								DeserializationConfig.Feature.FAIL_ON_UNKNOWN_PROPERTIES));
	}

	/**
	 * 使用对象进行json反序列化。
	 * 
	 * @param json
	 *            json串
	 * @param pojoClass
	 *            类类型
	 * @return
	 * @throws Exception
	 */
	public static Object decodeJson(String json, Class pojoClass)
			throws Exception {
		try {
			return objectMapper.readValue(json, pojoClass);
		} catch (Exception e) {
			throw e;
		}
	}

	/**
	 * 将对象序列化。
	 * 
	 * @param o
	 *            实体对象
	 * @return 序列化后json
	 * @throws Exception
	 */
	public static String encodeJson(Object o) throws Exception {
		try {
			return objectMapper.writeValueAsString(o);
		} catch (Exception e) {
			throw e;
		}
	}

	/**
	 * 执行一个HTTP POST请求，返回请求响应的内容
	 * 
	 * @param url
	 *            请求的URL地址
	 * @param params
	 *            请求的查询参数,可以为null
	 * @return 返回请求响应的内容
	 */
	public static String doPost(String url, String body) {
		StringBuffer stringBuffer = new StringBuffer();
		HttpEntity entity = null;
		BufferedReader in = null;
		HttpResponse response = null;
		try {
			DefaultHttpClient httpclient = new DefaultHttpClient();
			HttpParams params = httpclient.getParams();
			HttpConnectionParams.setConnectionTimeout(params, 20000);
			HttpConnectionParams.setSoTimeout(params, 20000);
			HttpPost httppost = new HttpPost(url);
			httppost.setHeader("Content-Type",
					"application/x-www-form-urlencoded");

			httppost.setEntity(new ByteArrayEntity(body.getBytes("UTF-8")));
			response = httpclient.execute(httppost);
			entity = response.getEntity();
			in = new BufferedReader(new InputStreamReader(entity.getContent()));
			String ln;
			while ((ln = in.readLine()) != null) {
				stringBuffer.append(ln);
				stringBuffer.append("\r\n");
			}
			httpclient.getConnectionManager().shutdown();
		} catch (ClientProtocolException e) {
			e.printStackTrace();
		} catch (IOException e1) {
			e1.printStackTrace();
		} catch (IllegalStateException e2) {
			e2.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (null != in) {
				try {
					in.close();
					in = null;
				} catch (IOException e3) {
					e3.printStackTrace();
				}
			}
		}
		return stringBuffer.toString();
	}

	public static String makeAppsFlyerMsg(Activity context, GameInfo gameInfo,
			String installTime, String media_source, String sdkVersion,
			String click_url, String click_time, String is_paid) {
		StringBuffer datas = new StringBuffer();

		String time = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss").format(
				new Date()).toString();
		if (is_paid != null) {
			Date dat = new Date(is_paid);
			GregorianCalendar gc = new GregorianCalendar();
			gc.setTime(dat);
			SimpleDateFormat format = new SimpleDateFormat(
					"yyyy-MM-dd hh:mm:ss");
			String sb = format.format(gc.getTime());
			installTime = sb;
		}
		if (installTime == null) {
			installTime = time;
		}
		if (media_source == null) {
			media_source = "";
		}
		if (click_url == null) {
			click_url = "";
		}
		if (click_time == null) {
			click_time = time;
		}

		datas.append("android_id="
				+ Secure.getString(context.getContentResolver(), "android_id"));
		datas.append("&imei="
				+ ((TelephonyManager) context.getSystemService("phone"))
						.getDeviceId());
		datas.append("&game_id=" + gameInfo.app_key);
		datas.append("&platform=" + gameInfo.platform_type_str);
		datas.append("&package=" + context.getApplication().getPackageName());
		datas.append("&media_source=" + media_source);
		datas.append("&ip=" + getLocalIpAddress());
		datas.append("&mac=" + getLocalMacAddressFromIp(context));
		datas.append("&decvice_type="
				+ DeviceUtil.getDeviceProductName(context));
		datas.append("&sdk_version=" + sdkVersion);
		datas.append("&os_version=" + android.os.Build.VERSION.SDK_INT);
		datas.append("&click_url=" + click_url);
		datas.append("&click_time=" + click_time);
		datas.append("&install_time=" + installTime);
		Locale locale = context.getResources().getConfiguration().locale;
		datas.append("&country_code=" + locale.getCountry());
		datas.append("&city=" + "");

		return datas.toString();
	}

	// 根据IP获取本地Mac
	public static String getLocalMacAddressFromIp(Context context) {
		String mac_s = "";
		try {
			byte[] mac;
			NetworkInterface ne = NetworkInterface.getByInetAddress(InetAddress
					.getByName(getLocalIpAddress()));
			mac = ne.getHardwareAddress();
			mac_s = byte2hex(mac);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return mac_s;
	}

	public static String byte2hex(byte[] b) {
		StringBuffer hs = new StringBuffer(b.length);
		String stmp = "";
		int len = b.length;
		for (int n = 0; n < len; n++) {
			stmp = Integer.toHexString(b[n] & 0xFF);
			if (stmp.length() == 1)
				hs = hs.append("0").append(stmp);
			else {
				hs = hs.append(stmp);
			}
		}
		return String.valueOf(hs);
	}

	public static String getLocalIpAddress() {
		try {
			for (Enumeration<NetworkInterface> en = NetworkInterface
					.getNetworkInterfaces(); en.hasMoreElements();) {
				NetworkInterface intf = en.nextElement();
				for (Enumeration<InetAddress> enumIpAddr = intf
						.getInetAddresses(); enumIpAddr.hasMoreElements();) {
					InetAddress inetAddress = enumIpAddr.nextElement();
					if (!inetAddress.isLoopbackAddress()
							&& InetAddressUtils.isIPv4Address(inetAddress
									.getHostAddress())) {
						if (!inetAddress.getHostAddress().toString()
								.equals("null")
								&& inetAddress.getHostAddress() != null) {
							return inetAddress.getHostAddress().toString()
									.trim();
						}
					}
				}
			}
		} catch (SocketException ex) {
			Log.e("WifiPreference IpAddress", ex.toString());
		}
		return "";
	}

	/*
      * 
      * */
	public static String doGet(String url) {
		StringBuffer stringBuffer = new StringBuffer();
		//
		DefaultHttpClient httpclient = new DefaultHttpClient();
		// HttpParams params = httpclient.getParams();
		// HttpConnectionParams.setConnectionTimeout(params, 2000);
		// HttpConnectionParams.setSoTimeout(params, 2000);

		HttpGet httpget = new HttpGet(url);
		httpget.setHeader("Content-Type", "application/x-www-form-urlencoded");

		try {
			HttpResponse response = httpclient.execute(httpget);

			if (response.getStatusLine().getStatusCode() == HttpStatus.SC_OK) {
				HttpEntity entity = response.getEntity();
				BufferedReader in = new BufferedReader(new InputStreamReader(
						entity.getContent()));
				String ln;
				while ((ln = in.readLine()) != null) {
					stringBuffer.append(ln);
					stringBuffer.append("\r\n");
				}
				httpclient.getConnectionManager().shutdown();
			}

		} catch (ClientProtocolException e) {

			// e.printStackTrace();
		} catch (IOException e) {

			// e.printStackTrace();
		} catch (Exception e) {

		} finally {

		}

		//
		return stringBuffer.toString();
	}

	/**
	 * MD5 加密
	 */
	public static String getMD5Str(String str) {
		MessageDigest messageDigest = null;

		try {
			messageDigest = MessageDigest.getInstance("MD5");

			messageDigest.reset();

			messageDigest.update(str.getBytes("UTF-8"));
		} catch (NoSuchAlgorithmException e) {
			System.out.println("NoSuchAlgorithmException caught!");
			System.exit(-1);
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		}

		byte[] byteArray = messageDigest.digest();

		StringBuffer md5StrBuff = new StringBuffer();

		for (int i = 0; i < byteArray.length; i++) {
			if (Integer.toHexString(0xFF & byteArray[i]).length() == 1)
				md5StrBuff.append("0").append(
						Integer.toHexString(0xFF & byteArray[i]));
			else
				md5StrBuff.append(Integer.toHexString(0xFF & byteArray[i]));
		}

		return md5StrBuff.toString();
	}

	/**
	 * 读取配置信息。
	 * 
	 * @param key
	 *            Key值
	 * @return
	 * @throws Exception
	 */
	public static String getConfig(String key) throws Exception {
		try {
			InputStream in = Util.class.getResourceAsStream("/conf.Properties");
			Properties p = new Properties();
			p.load(in);
			return p.get(key).toString().trim();
		} catch (Exception e) {
			System.out.println("配置文件不存在" + e.toString());
		}
		return "";
	}

	public static void unzip(String zipFileName, String outputDirectory)
			throws IOException {
		ZipFile zipFile = null;
		try {
			zipFile = new ZipFile(zipFileName);
			Log.i("111111", zipFileName);
			Enumeration e = zipFile.entries();
			ZipEntry zipEntry = null;
			File dest = new File(outputDirectory);
			dest.mkdirs();
			while (e.hasMoreElements()) {
				zipEntry = (ZipEntry) e.nextElement();
				String entryName = zipEntry.getName();
				InputStream in = null;
				FileOutputStream out = null;
				try {
					if (zipEntry.isDirectory()) {
						String name = zipEntry.getName();
						name = name.substring(0, name.length() - 1);
						File f = new File(outputDirectory + File.separator
								+ name);
						f.mkdirs();
					} else {
						int index = entryName.lastIndexOf("\\");
						if (index != -1) {
							File df = new File(outputDirectory + File.separator
									+ entryName.substring(0, index));
							df.mkdirs();
						}
						index = entryName.lastIndexOf("/");
						if (index != -1) {
							File df = new File(outputDirectory + File.separator
									+ entryName.substring(0, index));
							df.mkdirs();
						}
						File f = new File(outputDirectory + File.separator
								+ zipEntry.getName());
						// f.createNewFile();
						in = zipFile.getInputStream(zipEntry);
						out = new FileOutputStream(f);
						int c;
						byte[] by = new byte[1024];
						while ((c = in.read(by)) != -1) {
							out.write(by, 0, c);
						}
						out.flush();
					}
				} catch (IOException ex) {
					ex.printStackTrace();
					throw new IOException("解压失败：" + ex.toString());
				} finally {
					if (in != null) {
						try {
							in.close();
						} catch (IOException ex) {
						}
					}
					if (out != null) {
						try {
							out.close();
						} catch (IOException ex) {
						}
					}
				}
			}
		} catch (IOException ex) {
			ex.printStackTrace();
			throw new IOException("解压失败：" + ex.toString());
		} finally {
			if (zipFile != null) {
				try {
					zipFile.close();
				} catch (IOException ex) {
				}
			}
		}
	}

}
