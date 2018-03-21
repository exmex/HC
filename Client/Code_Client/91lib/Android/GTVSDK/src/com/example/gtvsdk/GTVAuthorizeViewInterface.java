package com.example.gtvsdk;

import java.io.Serializable;



public interface GTVAuthorizeViewInterface extends Serializable{

	public void authorizeViewdidRecieveAuthorizationID(
			GTVAuthorizeView authView, String IDStr, String timeStr,
			String signStr);

	public void authorizeViewdidRecieveRegisterID(GTVAuthorizeView authView,
			String IDStr, String timeStr, String signStr);
	
	public void authorizeViewdidRecieveRechargeSumbitMoneyStr(GTVAuthorizeView authView,String moneyStr);
	public void authorizeViewdidLoginFail(GTVAuthorizeView authView);
	public void authorizeViewdidFailWithErrorInfo(GTVAuthorizeView authView,String errorInfo);
	public void authorizeViewDidCancel(GTVAuthorizeView authView);
}
