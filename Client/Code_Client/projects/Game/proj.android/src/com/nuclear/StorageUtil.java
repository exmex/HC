package com.nuclear;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStreamReader;
import java.util.HashSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import android.os.Environment;
import android.util.Log;




public class StorageUtil {
	
	private static final String TAG = StorageUtil.class.getSimpleName();
	
	public static void removeFileDirectory(File file)
	{
		if (file.exists() == false)
			return;
		if (file.isDirectory())
		{
			File[] files = file.listFiles();
			for(File of : files)
			{
				removeFileDirectory(of);
			}
			file.delete();
		}
		else if (file.isFile())
		{
			file.delete();
		}
		else
		{
			file.delete();
		}
	}
	
	public static String getSecondStorageWithFreeSize(long freebytes) {
		
		HashSet<String> storageSet = getSecondStorageSet();
		if (storageSet != null && !storageSet.isEmpty()) {
			
			for (String storage : storageSet) {
				File tempDir = new File(storage);
				if (tempDir.exists() && tempDir.isDirectory() && 
						tempDir.canWrite() && tempDir.canRead() && 
						tempDir.getUsableSpace() > freebytes)
				{
					tempDir = null;
					return storage;
				}
				tempDir = null;
			}
			
		}
		//
		File externalStorageDir = Environment
					.getExternalStorageDirectory();
		if (externalStorageDir != null)
		{
			if (!externalStorageDir.getAbsolutePath().equalsIgnoreCase("/mnt/sdcard1"))
			{
				File dir1 =  new File("/mnt/sdcard1");
				if (dir1.exists() && dir1.isDirectory() && dir1.getUsableSpace() > freebytes)
					return "/mnt/sdcard1";
			}
			//
			if (!externalStorageDir.getAbsolutePath().equalsIgnoreCase("/storage/sdcard1"))
			{
				File dir1 =  new File("/storage/sdcard1");
				if (dir1.exists() && dir1.isDirectory() && dir1.getUsableSpace() > freebytes)
					return "/storage/sdcard1";
			}
		}
		//
		{
			File dir1 =  new File("/mnt/sdcard2");
			if (dir1.exists() && dir1.isDirectory() && dir1.getUsableSpace() > freebytes)
				return "/mnt/sdcard2";
		}
		{
			File dir1 =  new File("/storage/sdcard2");
			if (dir1.exists() && dir1.isDirectory() && dir1.getUsableSpace() > freebytes)
				return "/storage/sdcard2";
		}
		//
		return null;
	}
	
	public static HashSet<String> getSecondStorageSet(){
		HashSet<String> storageSet = getStorageSet(new File("/system/etc/vold.fstab"), true);
        if (storageSet != null) {
        	storageSet.addAll(getStorageSet(new File("/proc/mounts"), false));
        }
        //              
        if (storageSet == null || storageSet.isEmpty()) {
        	//
        }
        return storageSet;
	}
	
	public static HashSet<String> getStorageSet(){
        HashSet<String> storageSet = getStorageSet(new File("/system/etc/vold.fstab"), true);
        if (storageSet != null) {
        	storageSet.addAll(getStorageSet(new File("/proc/mounts"), false));
        	//add default external storage
        	storageSet.add(Environment.getExternalStorageDirectory().getAbsolutePath());
        }
        //              
        if (storageSet == null || storageSet.isEmpty()) {
            storageSet = new HashSet<String>();
            storageSet.add(Environment.getExternalStorageDirectory().getAbsolutePath());
        }
        return storageSet;
    }

    public static HashSet<String> getStorageSet(File file, boolean is_fstab_file) {
        HashSet<String> storageSet = new HashSet<String>();
        BufferedReader reader = null;
        try {
            reader = new BufferedReader(new InputStreamReader(new FileInputStream(file)));
            String line;
        while ((line = reader.readLine()) != null) {
            HashSet<String> _storage = null;
            if (is_fstab_file) {
                _storage = parseVoldFile(line);
            } else {
                _storage = parseMountsFile(line);
            }
            if (_storage == null)
                continue;
            storageSet.addAll(_storage);
        }
        } catch (Exception e) {
            e.printStackTrace();
        }finally{
            try {
                reader.close();
            } catch (Exception e) {
                e.printStackTrace();
            }   
            reader = null;
        }
        //
        return storageSet;
    }

    private static HashSet<String> parseMountsFile(String str) {
        if (str == null)
            return null;
        if (str.length()==0)
            return null;
        if (str.startsWith("#"))
            return null;
        HashSet<String> storageSet = new HashSet<String>();
        /*
         * /dev/block/vold/179:19 /mnt/sdcard2 vfat rw,dirsync,nosuid,nodev,noexec,relatime,uid=1000,gid=1015,fmask=0002,dmask=0002,allow_utime=0020,codepage=cp437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro 0 0
         * /dev/block/vold/179:33 /mnt/sdcard vfat rw,dirsync,nosuid,nodev,noexec,relatime,uid=1000,gid=1015,fmask=0002,dmask=0002,allow_utime=0020,codepage=cp437,iocharset=iso8859-1,shortname=mixed,utf8,errors=remount-ro 0 0
         */
        Pattern patter = Pattern.compile("/dev/block/vold.*?(/mnt|storage/.+?) vfat .*");
        Matcher matcher = patter.matcher(str);
        boolean b = matcher.find();
        if (b) {
            String _group = matcher.group(1);
            if (!_group.startsWith("/"))
            	_group = "/" + _group;
            storageSet.add(_group);
            Log.d(TAG, "parseMountsFile: "+_group);
        }

        return storageSet;
    }

    private static HashSet<String> parseVoldFile(String str) {
        if (str == null)
            return null;
        if (str.length()==0)
            return null;
        if (str.startsWith("#"))
            return null;
        HashSet<String> storageSet = new HashSet<String>();
        /*
         * dev_mount sdcard /mnt/sdcard auto /devices/platform/msm_sdcc.1/mmc_host
         * dev_mount SdCard /mnt/sdcard/extStorages /mnt/sdcard/extStorages/SdCard auto sd /devices/platform/s3c-sdhci.2/mmc_host/mmc1
         */
        Pattern patter1 = Pattern.compile("(/mnt|storage/[^ ]+?)((?=[ ]+auto[ ]+)|(?=[ ]+(\\d*[ ]+)))");
        /*
         * dev_mount ins /mnt/emmc emmc /devices/platform/msm_sdcc.3/mmc_host
         */
        Pattern patter2 = Pattern.compile("(/mnt|storage/.+?)[ ]+");
        Matcher matcher1 = patter1.matcher(str);
        boolean b1 = matcher1.find();
        if (b1) {
            String _group = matcher1.group(1);
            if (!_group.startsWith("/"))
            	_group = "/" + _group;
            storageSet.add(_group);
            Log.d(TAG, "parseVoldFile: "+_group);
        }

        Matcher matcher2 = patter2.matcher(str);
        boolean b2 = matcher2.find();
        if (!b1 && b2) {
            String _group = matcher2.group(1);
            if (!_group.startsWith("/"))
            	_group = "/" + _group;
            storageSet.add(_group);
            Log.d(TAG, "parseVoldFile: "+_group);
        }
        return storageSet;
    }
	
}

