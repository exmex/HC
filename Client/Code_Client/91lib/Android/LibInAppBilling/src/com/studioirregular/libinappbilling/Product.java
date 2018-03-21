package com.studioirregular.libinappbilling;

import java.util.ArrayList;
import java.util.List;

import org.json.JSONException;
import org.json.JSONObject;

import android.os.Bundle;

public class Product {

	public enum Type {
		ONE_TIME_PURCHASE ("inapp"),
		SUBSCRIPTION ("subs");
		
		public static Type parse(String value) {
			
			if (value.equals(ONE_TIME_PURCHASE.value)) {
				return ONE_TIME_PURCHASE;
			} else if (value.equals(SUBSCRIPTION.value)) {
				return SUBSCRIPTION;
			}
			
			throw new IllegalArgumentException("Unexpected value:" + value);
		}
		
		/* package */final String value;
		
		private Type(String value) {
			this.value = value;
		}
	}
	
	@SuppressWarnings("serial")
	public static class ParsingException extends RuntimeException {
		
		public ParsingException(String detail) {
			super(detail);
		}
	}
	
	/**
	 * 
	 * @param apiResult: the result you get from getSkuDetails API.
	 * @return
	 * @throws ParsingException
	 */
	public static List<Product> parse(Bundle apiResult) throws ParsingException {
		
		ArrayList<Product> result = new ArrayList<Product>();
		
		if (!apiResult.containsKey(DETAILS_LIST_KEY)) {
			throw new ParsingException("API result does not contains key:"
					+ DETAILS_LIST_KEY);
		}
		
		ArrayList<String> detailsList = apiResult.getStringArrayList(DETAILS_LIST_KEY);
		
		for (String details : detailsList) {
			
			try {
				Product item = new Product(details);
				result.add(item);
			} catch (JSONException e) {
				e.printStackTrace();
			}
		}
		
		return result;
	}
	
	public Product(String jsonDetails) throws JSONException {
		
		JSONObject json = new JSONObject(jsonDetails);
		
		this.id    = json.optString(JSON_DETAILS_KEY_ID);
		this.type  = Type.parse(json.optString(JSON_DETAILS_KEY_TYPE));
		this.price = json.optString(JSON_DETAILS_KEY_PRICE);
		this.title = json.optString(JSON_DETAILS_KEY_TITLE);
		this.description = json.optString(JSON_DETAILS_KEY_DESCRIPTION);
	}
	
	public final String id;
	
	public final Type   type;
	
	public final String price;
	
	public final String title;
	
	public final String description;
	
	private static final String DETAILS_LIST_KEY = "DETAILS_LIST";
	private static final String JSON_DETAILS_KEY_ID          = "productId";
	private static final String JSON_DETAILS_KEY_TYPE        = "type";
	private static final String JSON_DETAILS_KEY_PRICE       = "price";
	private static final String JSON_DETAILS_KEY_TITLE       = "title";
	private static final String JSON_DETAILS_KEY_DESCRIPTION = "description";
	
	@Override
	public String toString() {
		
		StringBuilder result = new StringBuilder(getClass().getName());
		
		result.append("\n\t").append("id : ").append(id);
		result.append("\n\t").append("type : ").append(type);
		result.append("\n\t").append("price : ").append(price);
		result.append("\n\t").append("title : ").append(title);
		result.append("\n\t").append("description : ").append(description);
		
		return result.toString();
	}
}
