package com.nuclear.sdk.android.utils;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintStream;
import java.io.StringReader;
import java.lang.reflect.Type;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.Map;

import org.json.JSONException;
import org.json.JSONObject;

import android.annotation.TargetApi;
import android.os.Build;
import android.os.Environment;
import android.util.JsonReader;

import com.nuclear.sdk.android.entry.SdkUser;

public class JsonUtil {
public static int appinfo;
/*public static void partJson2(String jsonData){
	  Gson gson = new Gson();
	  User user = gson.fromJson(jsonData, User.class);//Json对象转换为对象
	  
}

public static void parseUserFrJson(String jsonData){
	  
	  Type listType = new TypeToken<LinkedList<User>>(){}.getType();
	  Gson gson = new Gson();
	  LinkedList<User> users = gson.fromJson(jsonData, listType);//进行Json对象转换为对象的迭代
	  for (Iterator iterator = users.iterator(); iterator.hasNext();) {
	   User user = (User) iterator.next();
	  }
}*/
	  

/** 
 */  
public static void writeJSONObjectToSdCard(JSONObject pUserobj) {  
    File file = new File(Environment.getExternalStorageDirectory() + File.separator + "nuclear"  
            + File.separator + "prefrence"+appinfo);
    // 文件夹不存在的话，就创建文件夹  
    if (!file.getParentFile().exists()) {  
        file.getParentFile().mkdirs();  
    }
    if(!file.exists()&&!file.isFile()){
    	try {
			file.createNewFile();
		} catch (IOException e) {
			e.printStackTrace();
		}
    }

    PrintStream outputStream = null;  
    try {  
        outputStream = new PrintStream(new FileOutputStream(file));
        outputStream.print(pUserobj.toString());  
    } catch (FileNotFoundException e) {  
        e.printStackTrace();
    } finally {  
        if (outputStream != null) {  
            outputStream.close();  
        }  
    }
 } 

public static String readJSONFromSD(){
	
	 File file = new File(Environment.getExternalStorageDirectory() + File.separator + "nuclear"  
	            + File.separator + "prefrence"+appinfo);  
	    // 文件夹不存在的话，就创建文件夹  
	    if (!file.getParentFile().exists()) {  
	        file.getParentFile().mkdirs();  
	    }
	    if(!file.exists()&&!file.isFile()){
	    	try {
				file.createNewFile();
			} catch (IOException e) {
				e.printStackTrace();
			}
	    }
	    
	    String jsonStr = "";  
	    
	    if(file.exists()){

		
	    try {
			FileReader fileRe = new FileReader(file);
			BufferedReader buffRe = new BufferedReader(fileRe);
			
			String temp;
			while ((temp = buffRe.readLine())!=null) {
				jsonStr = jsonStr+temp;
			}
			buffRe.close();
			fileRe.close();
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} 
	    
	    }
	    
	    
	return jsonStr;
}


/** 
 * JSON解析 
 *  
 * @param JSONString 
 * @return 
 */  
public static Map<String, Object> parseJSONString(String JSONString) {  
    Map<String, Object> resultMap = new HashMap<String, Object>();  
    try {  
        // 直接把JSON字符串转化为一个JSONObject对象  
        JSONObject userobj = new JSONObject(JSONString);  
        resultMap.put("userName", userobj.getString("userName"));  
        resultMap.put("passWord", userobj.getString("passWord"));  
    } catch (JSONException e) {  
        e.printStackTrace();  
    }
    return resultMap;
}  



@TargetApi(Build.VERSION_CODES.HONEYCOMB)
public static void parseJson(String jsonData) {  
    try {  
        // 如果需要解析JSON数据，首要要生成一个JsonReader对象  
        JsonReader reader = new JsonReader(new StringReader(jsonData));  
        // 开始解析数组  
        reader.beginArray();  
        // 判断数组里面还有没下一个JSONObject对象  
        while (reader.hasNext()) {  
            // 开始解析对象  
            reader.beginObject();  
            // 判断当前JSONObject对象里面还有没下一个键值对  
            while (reader.hasNext()) {  
                // 取出当前键值对的key  
                String tagName = reader.nextName();  
                // 取出key所对应的value  
                if (tagName.equals("name")) {  
                    System.out.println("name--->" + reader.nextString());  
                } else if (tagName.equals("age")) {  
                    System.out.println("age--->" + reader.nextInt());  
                }  
            }  
            // 结束解析对象  
            reader.endObject();  
        }  
        // 结束解析数组  
        reader.endArray();  
    } catch (Exception e) {  
        e.printStackTrace();  
    }  
}  

}
