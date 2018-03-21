package com.youai.sdk.android.api;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.util.Log;

//DatabaseHelper作为一个访问SQLite的助手类，提供两个方面的功能，
//第一，getReadableDatabase(),getWritableDatabase()可以获得SQLiteDatabse对象，通过该对象可以对数据库进行操作
//第二，提供了onCreate()和onUpgrade()两个回调函数，允许我们在创建和升级数据库时，进行自己的操作

public class DatabaseHelper extends SQLiteOpenHelper {

	public final static int VERSION = 1;// 版本号
	public final static String TABLE_NAME = "youai";// 表名
	public final static String ID = "id";// 后面ContentProvider使用
	public final static String lastLoginTime = "lastlogintime";
	public static final String DATABASE_NAME = "youai.db";
	public final static String username = "username";
	public final static String password = "password";
	public final static String email = "email";
	public final static String userType = "userType";
	public final static String uidStr = "uidStr";
	public final static String isLocalLogout = "isLocalLogout";
	public final static String isFirstThird = "isFirstThird";
	
	public DatabaseHelper(Context context) {
		// 在Android 中创建和打开一个数据库都可以使用openOrCreateDatabase 方法来实现，
		// 因为它会自动去检测是否存在这个数据库，如果存在则打开，不过不存在则创建一个数据库；
		// 创建成功则返回一个 SQLiteDatabase对象，否则抛出异常FileNotFoundException。
		// 下面是来创建一个名为"DATABASE_NAME"的数据库，并返回一个SQLiteDatabase对象 
		
		super(context, DATABASE_NAME, null, VERSION); 
	} 
	@Override
	// 在数据库第一次生成的时候会调用这个方法，一般我们在这个方法里边生成数据库表;
	public void onCreate(SQLiteDatabase db) { 
		
		String str_newtable_sql =  
		"CREATE TABLE " + DatabaseHelper.TABLE_NAME + "(" + DatabaseHelper.ID
		 + " INTEGER PRIMARY KEY AUTOINCREMENT," + DatabaseHelper.username
		 + " text NOT NULL ON CONFLICT ABORT,"+DatabaseHelper.password+" text ,"+DatabaseHelper.email+" text ,"+DatabaseHelper.userType+" text ,"+DatabaseHelper.uidStr+" text ,"+DatabaseHelper.isLocalLogout+" text ,"+DatabaseHelper.lastLoginTime+" TimeStamp NOT NULL" +");";
			
		// CREATE TABLE 创建一张表 然后后面是我们的表名
		// 然后表的列，第一个是id 方便操作数据,int类型
		// PRIMARY KEY 是指主键 这是一个int型,用于唯一的标识一行;
		// AUTOINCREMENT 表示数据库会为每条记录的key加一，确保记录的唯一性;
		// 最后我加入一列文本 String类型
		// ----------注意：这里str_sql是sql语句，类似dos命令，要注意空格！
		db.execSQL(str_newtable_sql);
		// execSQL()方法是执行一句sql语句
		// 虽然此句我们生成了一张数据库表和包含该表的sql.himi文件,
		// 但是要注意 不是方法是创建，是传入的一句str_sql这句sql语句表示创建！！
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
		// 一般默认情况下，当我们插入 数据库就立即更新
		// 当数据库需要升级的时候，Android 系统会主动的调用这个方法。
		// 一般我们在这个方法里边删除数据表，并建立新的数据表，
		// 当然是否还需要做其他的操作，完全取决于游戏需求。
		Log.v("Youai", "onUpgrade");
	} 

}
