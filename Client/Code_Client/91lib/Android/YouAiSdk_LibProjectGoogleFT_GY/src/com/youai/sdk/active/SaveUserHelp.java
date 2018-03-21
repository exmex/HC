package com.youai.sdk.active;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.os.Environment;
import android.util.Log;

import com.youai.sdk.android.api.DatabaseHelper;
import com.youai.sdk.android.entry.YouaiUser;
import com.youai.sdk.android.utils.DES;


/**
 * @保存方式：SQLite 轻量级数据库、
 * @优点： 可以将自己的数据存储到文件系统或者数据库当中， 也可以将自己的数据存
 *         储到SQLite数据库当中，还可以存到SD卡中
 * @注意1：数据库对于一个游戏(一个应用)来说是私有的，并且在一个游戏当中， 
 *         数据库的名字也是唯一的。
 * @注意2 apk中创建的数据库外部的进程是没有权限去读/写的, 
 *         我们需要把数据库文件创建到sdcard上可以解决类似问题.
 * @注意3 当你删除id靠前的数据或者全部删除数据的时候，SQLite不会自动排序，
 *        也就是说再添加数据的时候你不指定id那么SQLite默认还是在原有id最后添加一条新数据
 * @注意4 android 中 的SQLite 语法区分大小写的!!!!!这点要注意！
 *   String UPDATA_DATA = "UPDATE youai SET text='通过SQL语句来修改数据'  WHERE id=1"; 
 *                  千万 不能可以写成小写
 */
public class SaveUserHelp {
	private SQLiteDatabase my_SqlDb ; 
//---------------以下两个成员变量是针对在SD卡中存储数据库文件使用
	private File pathDb =new File( Environment.getExternalStorageDirectory()
			+ File.separator + "youai" + File.separator);
	private File fileDb = new File( Environment.getExternalStorageDirectory()
			+ File.separator + "youai" + File.separator+"youai.db");
	private Context mContext;

	public SaveUserHelp(Context pContext){
		mContext = pContext;
		onCreate();
	}
	
	public void onCreate() {
		 
		//备注1  ----如果你使用的是将数据库的文件创建在SD卡中，那么创建数据库mysql如下操作：
		if (!pathDb.exists()) {// 目录存在返回false
			pathDb.mkdirs();// 创建一个目录
		}
		if (!fileDb.exists()) {// 文件存在返回false
			try {
				fileDb.createNewFile();//创建文件 
			} catch (IOException e) {
				e.printStackTrace();
			}
		} 
		//try{
			my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null);	
			 String tableExist =
					 "SELECT count(*) FROM sqlite_master WHERE type='table' AND name='youai'";
			 Cursor cur = my_SqlDb.rawQuery(tableExist,null);
			 cur.moveToNext();
			 int isExist = cur.getInt(0);
			 cur.close();
			 Log.e("SaveTestHelp", "isExist"+isExist);
			 if(isExist!=1){
				 doDbNewTable();
			 }
			 
		/*}catch (Exception e){
			 doDbNewTable();
		}finally {// 如果try中异常，也要对数据库进行关闭
			my_SqlDb.close();
		}*/
	
		
	}

	//添加数据
	public void doDbInsert(YouaiUser pUser) {
		String password = "";
		try {
			if(!"".equals(pUser.getPassword()))
			password = DES.encryptDES("com4love", pUser.getPassword());
		} catch (Exception e1) {
			return;
		}
		try { 
			my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null); 
			
			//备注2----如果你使用的是将数据库的文件创建在SD卡中，那么创建数据库mysql如下操作：
							// ---------------------- SQL语句插入--------------
			String INSERT_DATA =
			"INSERT INTO youai (username,password,email,userType,uidStr,isLocalLogout,isFirstThird,lastLoginTime) values ('"+pUser.getUsername()
			+"','"+password
			+"','"+pUser.getEmail()
			+"','"+pUser.getUserType()
			+"','"+pUser.getUidStr()
			+"','"+pUser.getIsLocalLogout()
			+"','"+pUser.getIsFirstThird()
			+"',datetime('now'))";
			my_SqlDb.execSQL(INSERT_DATA);
			
			
		}catch (Exception e) {
			Log.e("SaveTestHelp", e.toString());
		} finally {// 如果try中异常，也要对数据库进行关闭
			my_SqlDb.close();
		}
	}
	
	public ArrayList<YouaiUser> doDbSelectAll(){
		ArrayList<YouaiUser> users = new ArrayList<YouaiUser>();
		try{
			my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null); 
			Cursor cur = my_SqlDb.rawQuery("SELECT * FROM youai ORDER BY lastLoginTime DESC", null);
			if (cur != null) {
				while (cur.moveToNext()) {//直到返回false说明表中到了数据末尾
					YouaiUser _user = new YouaiUser();
					_user.setUsername(cur.getString(1));
					_user.setPassword(cur.getString(2));
					
					String password = "";
					try {
						if(!"".equals(_user.getPassword()))
						password = DES.decryptDES("com4love", _user.getPassword());
					} catch (Exception e1) {
					}
					_user.setPassword(password);
					_user.setEmail(cur.getString(3));
					_user.setUserType(cur.getString(4));
					_user.setUidStr(cur.getString(5));
					_user.setIsLocalLogout(cur.getString(6));
					_user.setIsFirstThird(cur.getString(7));
					_user.setLastlogintime(cur.getString(8));
					users.add(_user);
				}
				cur.close();
			}
	} catch (Exception e) {
		Log.e("SaveTestHelp", e.toString());
	} finally {// 如果try中异常，也要对数据库进行关闭
		my_SqlDb.close();
		
	}
		return users;
	}
	
	public void doDbDelete(YouaiUser pUser){
		try { 
		 my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null); 
				// ---------------------- 读写句柄来删除
				my_SqlDb.delete("youai", DatabaseHelper.uidStr + "= '"+pUser.getUidStr()+"'", null);
				// 第一个参数 需要操作的表名
				// 第二个参数为 id+操作的下标 如果这里我们传入null，表示全部删除
				// 第三个参数默认传null即可
				// ----------------------- SQL语句来删除
				// String DELETE_DATA = "DELETE FROM youai WHERE id=1";
				// db.execSQL(DELETE_DATA);
		} catch (Exception e) {
			Log.e("SaveTestHelp", e.toString());
		} finally {// 如果try中异常，也要对数据库进行关闭
			my_SqlDb.close();
		}
	}
	
	public void doDbUpdate(YouaiUser pUser){
		
		String password = "";
		try {
			if(!"".equals(pUser.getPassword()))
			password = DES.encryptDES("com4love", pUser.getPassword());
		} catch (Exception e1) {
			return;
		}
		
		try { 
			my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null); 
				// ------------------------SQL语句来修改 -------------
				 String UPDATA_DATA =
				 "UPDATE youai SET lastLoginTime= datetime('now') ,userType='"+pUser.getUserType()+"', password='"+password
				 +"', username='"+pUser.getUsername()+"', email='"+pUser.getEmail()+"', isLocalLogout='"+pUser.getIsLocalLogout()+"', isFirstThird='"+pUser.getIsFirstThird()
				 +"'  WHERE uidStr='"+pUser.getUidStr()+"'";
				 my_SqlDb.execSQL(UPDATA_DATA);
	} catch (Exception e) {
		Log.e("SaveTestHelp", e.toString());
	} finally {// 如果try中异常，也要对数据库进行关闭
		my_SqlDb.close();
	}
  }
	
	public void doDbUpdateOrInsert(YouaiUser pUser){
		
		String password = "";
		try {
			if(!"".equals(pUser.getPassword()))
			password = DES.encryptDES("com4love", pUser.getPassword());
		} catch (Exception e1) {
			return;
		}
		
		
		try { 
			my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null); 
				// ------------------------SQL语句来修改 -------------
			Cursor cur = my_SqlDb.rawQuery("SELECT * FROM youai  WHERE uidStr='"+pUser.getUidStr()+"'", null);
			if (cur != null&cur.moveToNext()) {
				String UPDATA_DATA ;
				if(password.equals("")){

					UPDATA_DATA  =
							 "UPDATE youai SET lastLoginTime= datetime('now') ,userType='"+pUser.getUserType()+"', username='"+pUser.getUsername()+"', email='"+pUser.getEmail()+"', isLocalLogout='"+pUser.getIsLocalLogout()
							 +"', isFirstThird='"+pUser.getIsFirstThird()+"'  WHERE uidStr='"+pUser.getUidStr()+"'";
							 my_SqlDb.execSQL(UPDATA_DATA);
				}else{

					UPDATA_DATA =
							 "UPDATE youai SET lastLoginTime= datetime('now') ,userType='"+pUser.getUserType()+"', password='"+password
							 +"', username='"+pUser.getUsername()+"', email='"+pUser.getEmail()+"', isLocalLogout='"+pUser.getIsLocalLogout()
							 +"', isFirstThird='"+pUser.getIsFirstThird()+"'  WHERE uidStr='"+pUser.getUidStr()+"'";
							 my_SqlDb.execSQL(UPDATA_DATA);
				}
				 
			}else {
				 String INSERT_DATA =
			"INSERT INTO youai (username,password,email,userType,uidStr,isLocalLogout,isFirstThird,lastLoginTime) values ('"+pUser.getUsername()
			+"','"+password
			+"','"+pUser.getEmail()
			+"','"+pUser.getUserType()
			+"','"+pUser.getUidStr()
			+"','"+pUser.getIsLocalLogout()
			+"','"+pUser.getIsFirstThird()
			+"',datetime('now'))";
			my_SqlDb.execSQL(INSERT_DATA);
			}
			cur.close();	
	} catch (Exception e) {
		Log.e("SaveTestHelp", e.toString());
	} finally {// 如果try中异常，也要对数据库进行关闭
		my_SqlDb.close();
	}
  }
	
	public void doDbDelTable(){
		try { 
		my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null); 
				my_SqlDb.execSQL("DROP TABLE youai");
		} catch (Exception e) {
			Log.e("SaveTestHelp", e.toString());
		} finally {// 如果try中异常，也要对数据库进行关闭
			my_SqlDb.close();
		}
	}
	
	public void doDbNewTable(){
		try {   my_SqlDb = SQLiteDatabase.openOrCreateDatabase(fileDb, null); 
				
			String str_newtable_sql = "CREATE TABLE "
					+ DatabaseHelper.TABLE_NAME + "(" + DatabaseHelper.ID
					+ " INTEGER PRIMARY KEY AUTOINCREMENT,"
					+ DatabaseHelper.username
					+ " text NOT NULL ON CONFLICT ABORT,"
					+ DatabaseHelper.password + " text ,"
					+ DatabaseHelper.email + " text ,"
					+ DatabaseHelper.userType + " text ,"
					+ DatabaseHelper.uidStr + " text ,"
					+ DatabaseHelper.isLocalLogout + " text ,"
					+ DatabaseHelper.isFirstThird + " text ,"
					+ DatabaseHelper.lastLoginTime + " TimeStamp NOT NULL"
					+ ");";

				my_SqlDb.execSQL(str_newtable_sql);
		} catch (Exception e) {
			Log.e("SaveTestHelp", e.toString());
			//操作失败
		} finally {// 如果try中异常，也要对数据库进行关闭
			my_SqlDb.close();
		}
	}
	 
}

