package com.nuclear.dota.platform.xunlei;  
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.Charset;
import java.util.Map;
import java.util.Properties;
import java.util.Vector;
    
/** 
* @ClassName: HttpRequester 
* @Description: http请求
* @author 古海威 
* date 2012-12-24  
*/
public class HttpReqUtil {  
    /** 
    * @Fields defaultContentEncoding : 默认编码 
    */ 
    private static String defaultContentEncoding =  Charset.defaultCharset().name();  
   
   
    /** 
     * 发送GET请求 
     *  
     * @param urlString 
     *            URL地址 
     * @return 响应对象 
     * @throws IOException 
     */  
    public static HttpResponse sendGet(String urlString, String encoding) throws IOException {  
        return send(urlString, "GET", null, null, encoding);  
    }  
   
    /** 
     * 发送GET请求 
     *  
     * @param urlString 
     *            URL地址 
     * @param params 
     *            参数集合 
     * @return 响应对象 
     * @throws IOException 
     */  
    public static HttpResponse sendGet(String urlString, Map<String, String> params, String encoding)  
            throws IOException {  
        return send(urlString, "GET", params, null, encoding);  
    }  
   
    /** 
     * 发送GET请求 
     *  
     * @param urlString 
     *            URL地址 
     * @param params 
     *            参数集合 
     * @param propertys 
     *            请求属性 
     * @return 响应对象 
     * @throws IOException 
     */  
    public static HttpResponse sendGet(String urlString, Map<String, String> params,  
            Map<String, String> propertys, String encoding) throws IOException {  
        return send(urlString, "GET", params, propertys, encoding);  
    }  
   
    /** 
     * 发送POST请求 
     *  
     * @param urlString 
     *            URL地址 
     * @return 响应对象 
     * @throws IOException 
     */  
    public static HttpResponse sendPost(String urlString, String encoding) throws IOException {  
        return send(urlString, "POST", null, null, encoding);  
    }  
   
    /** 
     * 发送POST请求 
     *  
     * @param urlString 
     *            URL地址 
     * @param params 
     *            参数集合 
     * @return 响应对象 
     * @throws IOException 
     */  
    public static HttpResponse sendPost(String urlString, Map<String, String> params, String encoding)  
            throws IOException {  
        return send(urlString, "POST", params, null, encoding);  
    }  
   
    /** 
     * 发送POST请求 
     *  
     * @param urlString 
     *            URL地址 
     * @param params 
     *            参数集合 
     * @param propertys 
     *            请求属性 
     * @return 响应对象 
     * @throws IOException 
     */  
    public static HttpResponse sendPost(String urlString, Map<String, String> params,  
            Map<String, String> propertys, String encoding) throws IOException {  
        return send(urlString, "POST", params, propertys, encoding);  
    }  
   
    /** 
     * 发送HTTP请求 
     *  
     * @param urlString 
     * @return 响映对象 
     * @throws IOException 
     */  
    private static HttpResponse send(String urlString, String method,  
            Map<String, String> parameters, Map<String, String> propertys, String encoding)  
            throws IOException {  
        HttpURLConnection urlConnection = null;  
        /*如果是get请求*/
        if (method.equalsIgnoreCase("GET") && parameters != null) {  
            StringBuffer param = new StringBuffer();  
            int i = 0;
            /*根据参数Map对象组装URL*/
            for (String key : parameters.keySet()) {  
                if (i == 0)  
                    param.append("?");  
                else  
                    param.append("&");  
                /*对value值进行编码转换*/
                param.append(key).append("=").append(URLEncoder.encode(parameters.get(key), encoding));  
                i++;  
            }  
            urlString += param;
        }  
        URL url = new URL(urlString);  
        urlConnection = (HttpURLConnection) url.openConnection();  
        urlConnection.setRequestMethod(method);
        //int connTimeOut = Integer.valueOf(PropertiesUtil.getPropertiesObj("/msg.properties").getProperty("connTimeOut", "2000"));
//        urlConnection.setConnectTimeout(2000);
       // int readTimeOut = Integer.valueOf(PropertiesUtil.getPropertiesObj("/msg.properties").getProperty("readTimeOut", "2000"));
//        urlConnection.setReadTimeout(2000);
        urlConnection.setDoOutput(true);  
        urlConnection.setDoInput(true);  
        urlConnection.setUseCaches(false);
   
        if (propertys != null)  
            for (String key : propertys.keySet()) {  
                urlConnection.addRequestProperty(key, propertys.get(key));  
            }  
        /*如果是Post类型*/
        if (method.equalsIgnoreCase("POST") && parameters != null) {  
            StringBuffer param = new StringBuffer();  
            for (String key : parameters.keySet()) {  
                param.append("&");  
                param.append(key).append("=").append(URLEncoder.encode(parameters.get(key), encoding));  
            }  
            urlConnection.getOutputStream().write(param.toString().getBytes());  
            urlConnection.getOutputStream().flush();
            urlConnection.getOutputStream().close();
        }  
   
        return makeContent(urlString, urlConnection);  
    }  
   
    /** 
     * 得到响应对象 
     *  
     * @param urlConnection 
     * @return 响应对象 
     * @throws IOException 
     */  
    private static HttpResponse makeContent(String urlString,  
            HttpURLConnection urlConnection) throws IOException {  
        HttpResponse httpResponser = new HttpResponse();  
        try {  
            InputStream in = urlConnection.getInputStream();  
            BufferedReader bufferedReader = new BufferedReader(  
                    new InputStreamReader(in));  
            httpResponser.contentCollection = new Vector<String>();  
            StringBuffer temp = new StringBuffer();  
            String line = bufferedReader.readLine();  
            while (line != null) {  
                httpResponser.contentCollection.add(line);  
                temp.append(line).append("\r\n");  
                line = bufferedReader.readLine();  
            }  
            bufferedReader.close();  
   
            String ecod = urlConnection.getContentEncoding();  
            if (ecod == null)  
                ecod = defaultContentEncoding;  
   
            httpResponser.urlString = urlString;  
   
            httpResponser.defaultPort = urlConnection.getURL().getDefaultPort();  
            httpResponser.file = urlConnection.getURL().getFile();  
            httpResponser.host = urlConnection.getURL().getHost();  
            httpResponser.path = urlConnection.getURL().getPath();  
            httpResponser.port = urlConnection.getURL().getPort();  
            httpResponser.protocol = urlConnection.getURL().getProtocol();  
            httpResponser.query = urlConnection.getURL().getQuery();  
            httpResponser.ref = urlConnection.getURL().getRef();  
            httpResponser.userInfo = urlConnection.getURL().getUserInfo();  
            String str = new String(temp.toString().getBytes(), ecod);
            String[] params = str.split("&");
            Properties properties = new Properties();
            for(String param : params){
            	String[] kv = param.split("=");
            	if(kv.length == 2){
            		properties.setProperty(kv[0], kv[1]);
            	}
            }
            httpResponser.content = properties;  
            httpResponser.contentEncoding = ecod;  
            httpResponser.code = urlConnection.getResponseCode();  
            httpResponser.message = urlConnection.getResponseMessage();  
            httpResponser.contentType = urlConnection.getContentType();  
            httpResponser.method = urlConnection.getRequestMethod();
            httpResponser.connectTimeout = urlConnection.getConnectTimeout();  
            httpResponser.readTimeout = urlConnection.getReadTimeout();  
   
            return httpResponser;  
        } catch (IOException e) {  
        	e.printStackTrace();
            throw e;  
        } finally {  
            if (urlConnection != null)  
                urlConnection.disconnect();  
        }  
    }  
   
   
} 