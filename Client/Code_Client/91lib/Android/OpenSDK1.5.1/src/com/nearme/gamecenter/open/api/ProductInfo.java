package com.nearme.gamecenter.open.api;

import android.os.Parcel;
import android.os.Parcelable;

public class ProductInfo implements Parcelable {

	private double amount;
	private String payCallbackUrl;
	private String chargeCallbackUrl;
	private String partnerOrder;
	private String productDesc;
	private String productName;
	private int type;
	private int count;

	public ProductInfo(double amount, String payCallbackUrl, String chargeCallbackUrl,String partnerOrder,
			String productDesc, String productName, int type, int count) {
		super();
		this.amount = amount;
		this.payCallbackUrl = payCallbackUrl;
		this.chargeCallbackUrl = chargeCallbackUrl;
		this.partnerOrder = partnerOrder;
		this.productDesc = productDesc;
		this.productName = productName;
		this.count = count;
		this.type = type;
	}

	public double getAmount() {
		return amount;
	}

	public String getPayCallBackUrl() {
		return payCallbackUrl;
	}

	public String getChargeCallbackUrl() {
		return chargeCallbackUrl;
	}

	public String getPartnerOrder() {
		return partnerOrder;
	}

	public String getProductDesc() {
		return productDesc;
	}

	public String getProductName() {
		return productName;
	}

	public int getType() {
		return type;
	}

	public void setCallBackUrl(String callBackUrl) {
		this.payCallbackUrl = callBackUrl;
	}

	public int getCount() {
		return count;
	}
	
	

	public void setAmount(double amount) {
		this.amount = amount;
	}

	public void setPayCallbackUrl(String payCallbackUrl) {
		this.payCallbackUrl = payCallbackUrl;
	}

	public void setChargeCallbackUrl(String chargeCallbackUrl) {
		this.chargeCallbackUrl = chargeCallbackUrl;
	}

	public void setPartnerOrder(String partnerOrder) {
		this.partnerOrder = partnerOrder;
	}

	public void setProductDesc(String productDesc) {
		this.productDesc = productDesc;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public void setType(int type) {
		this.type = type;
	}

	public void setCount(int count) {
		this.count = count;
	}

	@Override
	public int describeContents() {
		return 0;
	}

	@Override
	public void writeToParcel(Parcel dest, int flags) {
		dest.writeDouble(amount);
		dest.writeString(payCallbackUrl);
		dest.writeString(chargeCallbackUrl);
		dest.writeString(partnerOrder);
		dest.writeString(productDesc);
		dest.writeString(productName);
		dest.writeInt(type);
		dest.writeInt(count);
	}

	public static final Parcelable.Creator<ProductInfo> CREATOR = new Creator<ProductInfo>() {

		@Override
		public ProductInfo createFromParcel(Parcel source) {
			return new ProductInfo(source.readDouble(), source.readString(),
					source.readString(), source.readString(), source.readString(),
					source.readString(), source.readInt(), source.readInt());
		}

		@Override
		public ProductInfo[] newArray(int size) {
			return new ProductInfo[size];
		}

	};
}
