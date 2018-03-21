package com.nearme.gamecenter.open.api;

import org.json.JSONObject;

import android.app.Activity;
import android.content.ActivityNotFoundException;
import android.content.Intent;
import android.graphics.Bitmap;
import android.provider.MediaStore;

public class UserInfo {
	public String id, username, profilePictureUrl, nickname;
	public double gameBalance;
	public boolean sex;
	public Bitmap profilePictureBitmap;
	public JSONObject jsonObject;
	public String jsonString;
	private static int pic_width = 72;
	public UserInfo(String json) {
		try {
			this.jsonString = json;
			JSONObject jsonObject = new JSONObject(json);
			JSONObject user = jsonObject.getJSONObject("BriefUser");
			UserInfo.this.jsonObject = user;
			id = user.getString("id");
			sex = user.getBoolean("sex");
			profilePictureUrl = user.getString("profilePictureUrl");
			username = user.getString("userName");
			nickname = user.getString("name");
			gameBalance = Double.valueOf(user.getString("gameBalance"));
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
	
	public UserInfo(String nickname, boolean sex, Bitmap pic) {
		this.nickname = nickname;
		this.sex = sex;
		this.profilePictureBitmap = pic;
	}
	
	/**
	 * Launches Camera to take a picture and store it in a file.
	 */
	public static void doTakePhoto(Activity ac, int requestCode) {
		Intent intent = new Intent(MediaStore.ACTION_IMAGE_CAPTURE, null);
		intent.putExtra("crop", "true");
//		intent.putExtra("aspectX", 1);
//		intent.putExtra("aspectY", 1);
		intent.putExtra("outputX", pic_width);
		intent.putExtra("outputY", pic_width);
		intent.putExtra("return-data", true);
//		intent.putExtra("hideCameraButton", true);
		ac.startActivityForResult(intent, requestCode);
	}
	
	/**
	 * Launches Gallery to pick a photo.
	 */
	public static void doPickPhotoFromGallery(Activity ac, int requestCode) {
		try {
			// Launch picker to choose photo for selected contact
			final Intent intent = getPhotoPickIntent();
			intent.setPackage("com.oppo.cooliris.media");
			ac.startActivityForResult(intent, requestCode);
		} catch (ActivityNotFoundException e) {
			try {
				Intent intent = getPhotoPickIntent();
				ac.startActivityForResult(intent, requestCode);
			} catch (Exception e2) {
			}
		}
	}
	
	public static Intent getPhotoPickIntent() {
		Intent intent = new Intent(Intent.ACTION_GET_CONTENT, null);
		intent.setType("image/*");
		intent.putExtra("crop", "true");
//		intent.putExtra("aspectX", 1);
//		intent.putExtra("aspectY", 1);
		intent.putExtra("outputX", pic_width);
		intent.putExtra("outputY", pic_width);
		intent.putExtra("return-data", true);
		return intent;
	}
}
