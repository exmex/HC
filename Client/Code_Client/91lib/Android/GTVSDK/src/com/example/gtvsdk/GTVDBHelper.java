package com.example.gtvsdk;

import android.content.Context;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteDatabase.CursorFactory;
import android.database.sqlite.SQLiteOpenHelper;

public class GTVDBHelper extends SQLiteOpenHelper {

	private static final String DB = "gtvsdk.db";
	public static final String TABLE_NAME = "Login_cache";

	public GTVDBHelper(Context context) {
		super(context, DB, null, 1);
	}


	@Override
	public void onCreate(SQLiteDatabase db) {
		db.execSQL("CREATE TABLE "
				+ TABLE_NAME
				+ "(deviceID TEXT primary key ,userID TEXT,coID TEXT,appKey TEXT,appSecret TEXT,serverID TEXT)");
	}

	@Override
	public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {

	}

}
