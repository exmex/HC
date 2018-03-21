package com.example.gtvsdk;

import java.io.Serializable;
import java.util.HashMap;

import org.json.JSONObject;

public interface GTVRequestInterface extends Serializable{

	public void didFinishLoadingWithResult(HashMap mMap,GTVRequest mGTVRequest);
	public void didFailWithError(String error);
}
