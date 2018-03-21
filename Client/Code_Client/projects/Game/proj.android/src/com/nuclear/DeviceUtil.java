

package com.nuclear;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileFilter;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.text.DecimalFormat;
import java.util.Properties;
import java.util.UUID;
import java.util.regex.Pattern;

import android.content.Context;
import android.os.Build;
import android.os.Environment;
import android.provider.Settings.Secure;
import android.telephony.TelephonyManager;
import android.text.TextUtils;
import android.text.format.Formatter;
import android.util.Log;


public class DeviceUtil
{
	
	public static String getDeviceId(Context context) {
		TelephonyManager telephonyManager = (TelephonyManager) context
				.getSystemService(Context.TELEPHONY_SERVICE);
		String imei = telephonyManager.getDeviceId();
		if (!TextUtils.isEmpty(imei)) {
			return imei;
		} else {
			String androidId = Secure.getString(context.getContentResolver(),
					Secure.ANDROID_ID);
			return androidId;
		}
	}
	
	/*
	 * 
	 * */
	public static String generateUUID()
	{
		return UUID.randomUUID().toString();//字符串带横杠字符-
	}
	/*
	 * 
	 * */
	public static String getDeviceProductName(Context context)
	{
		
		String temp = Build.MODEL.replaceAll(" ", "-");
		return Build.MANUFACTURER+"_"+temp;
		
		//String productName = "DeviceProductName";
	}
	/*
	 * 
	 * */
	public static String getDeviceUUID(Context context)
	{
		//Environment.getExternalStoragePublicDirectory(type)
		String uuid = "";//getExternalFilesDir(null)//不能用这个，在没有外部存储的设备会有问题！Android的外部存储不狭隘的指SD卡，设备厂商可内置部分存储时即为默认外部存储
		File uFile = new File(/*context.getFilesDir().getAbsolutePath()*/Environment.getExternalStorageDirectory().getAbsoluteFile()
				+ "/youai/uuid.properties");
		if (uFile.exists()) {
			Properties cfgIni = new Properties();
			try {
				cfgIni.load(new FileInputStream(uFile));
				uuid = cfgIni.getProperty("uuid", null);
			} catch (FileNotFoundException e) {
				
			} catch (IOException e) {
				
			}
			cfgIni = null;
			if(uuid!=null && !("".equals(uuid)))
			{
				uFile = null;
				Log.w("getDeviceUUID", uuid);
				return uuid;
			}
		}
		else
		{
			Properties cfgIni = new Properties();
			cfgIni.setProperty("uuid", "");
			try {
				cfgIni.store(new FileOutputStream(uFile), "auto save, default none str");
			} catch (FileNotFoundException e) {
				
			} catch (IOException e) {
				
			}
			//
			cfgIni = null;
		}
		try
		{
			TelephonyManager tmsvc = (TelephonyManager)context.getSystemService(Context.TELEPHONY_SERVICE);
			if (tmsvc != null)
			{
				uuid = tmsvc.getDeviceId();
				if (uuid == null)
					uuid = tmsvc.getSubscriberId();
				if (uuid == null)
					//uuid = DeviceUtil.getDeviceProductName(context);
					uuid = null;
			}
		}
		catch(Exception e)
		{
			
		}
		if(uuid==null||"".equals(uuid)||"0".equals(uuid))
		{
			uuid = "uuid_"+generateUUID();
		}
		Properties cfgIni = new Properties();
		cfgIni.setProperty("uuid", uuid);
		try {
			cfgIni.store(new FileOutputStream(uFile), "auto save, generateUUID");
		} catch (FileNotFoundException e) {
			
		} catch (IOException e) {
			
		}
		uFile = null;
		cfgIni = null;
		Log.w("getDeviceUUID", uuid);
		return uuid;
	}
	
	/**
     * 获取RAM内存大小
     * 
     * @return
     */
    public static String getTotalMemory(Context context) {
    	String str1 = "/proc/meminfo";// 系统内存信息文件 
    	String str2;
    	String[] arrayOfString;
    	double initial_memory = 0;
    	DecimalFormat df = null;
    	try {
	    	FileReader localFileReader = new FileReader(str1);
	    	BufferedReader localBufferedReader = new BufferedReader(
	    	localFileReader, 8192);
	    	str2 = localBufferedReader.readLine();// 读取meminfo第一行，系统总内存大小 
	    	if(str2==null)
	    	{
	    		localBufferedReader.close();
	    		return "";
	    	}
	    	arrayOfString = str2.split("\\s+");
	    	for (String num : arrayOfString) {
	    		Log.i(str2, num + "\t");
	    	}

	    	initial_memory = Integer.valueOf(arrayOfString[1]).intValue() / 1024;// * 1024;// 获得系统总内存，单位是KB，乘以1024转换为Byte
	    	initial_memory = initial_memory / 1024;
	    	df = new DecimalFormat("##.##");
	    	
	    	localBufferedReader.close();

    	} catch (Exception e) {
    		return "";
    	}
    	return df.format(initial_memory);//String.valueOf(initial_memory);//Formatter.formatFileSize(getBaseContext(), initial_memory);// Byte转换为KB或者MB，内存大小规格化 
//    	return Formatter.formatFileSize(getBaseContext(), initial_memory);
    }
    
    /**
     * 获取手机CPU个数
     * 
     * @return
     */
    public static int getNumCores() {
        //Private Class to display only CPU devices in the directory listing
        class CpuFilter implements FileFilter {
            @Override
            public boolean accept(File pathname) {
                //Check if filename is "cpu", followed by a single digit number
                if(Pattern.matches("cpu[0-9]", pathname.getName())) {
                    return true;
                }
                return false;
            }      
        }

        try {
            //Get directory containing CPU info
            File dir = new File("/sys/devices/system/cpu/");
            if(dir.exists()) {
	            //Filter to only list the devices we care about
	            File[] files = dir.listFiles(new CpuFilter());
	            Log.d("MainActivity", "CPU Count: "+files.length);
	            //Return the number of cores (virtual CPU devices)
	            return files.length;
            }
            else
            {
            	return 1;
            }
        } catch(Exception e) {
            //Print exception
            Log.d("MainActivity", "CPU Count: Failed.");
            e.printStackTrace();
            //Default to return 1 core
            return 1;
        }
    }
    
    /*
     * 
     * 获取CPU最大频率（单位KHZ）
     */
    
 // "/system/bin/cat" 命令行

    // "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq" 存储最大频率的文件的路径

       public static String getMaxCpuFreq() {
               String result = "";
               ProcessBuilder cmd;
               try {
                       String[] args = { "/system/bin/cat",
                                       "/sys/devices/system/cpu/cpu0/cpufreq/cpuinfo_max_freq" };
                       cmd = new ProcessBuilder(args);
                       Process process = cmd.start();
                       InputStream in = process.getInputStream();
                       byte[] re = new byte[24];
                       while (in.read(re) != -1) {
                               result = result + new String(re);
                       }
                       in.close();
               } catch (Exception ex) {
                       ex.printStackTrace();
                       result = ""; //1.5   1572864
               }
               return result.trim();
       }
}

