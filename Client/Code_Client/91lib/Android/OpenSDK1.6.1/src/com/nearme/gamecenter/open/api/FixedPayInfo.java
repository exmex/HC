/**
 * Copyright (C) 2013, all rights reserved.
 * Company	SHENZHEN YUNZHONGFEI TECHNOLOGY CORP., LTD. 
 * Author	lailong
 * Since	2013-10-25
 */
package com.nearme.gamecenter.open.api;

import android.os.Parcel;
import android.os.Parcelable;

/**
 * 消耗固定金额的可币参数
 * 
 * @Author	lailong
 * @Since	2013-10-25
 */
public class FixedPayInfo extends PayInfo implements Parcelable {
	
	/**
	 * 消耗商品的数量
	 */
	private int goodsCount;

	/**
	 * @param order
	 * @param attach
	 * @param amount
	 */
	public FixedPayInfo(String order, String attach, int amount) {
		super(order, attach, amount);
	}

	public int getGoodsCount() {
		return goodsCount;
	}

	public void setGoodsCount(int goodsCount) {
		this.goodsCount = goodsCount;
	}

	/* (non-Javadoc)
	 * @see android.os.Parcelable#describeContents()
	 */
	@Override
	public int describeContents() {
		return 0;
	}

	/* (non-Javadoc)
	 * @see android.os.Parcelable#writeToParcel(android.os.Parcel, int)
	 */
	@Override
	public void writeToParcel(Parcel dest, int flags) {
		// for payinfo
		dest.writeString(getOrder());
		dest.writeString(getAttach());
		
		dest.writeInt(getAmount());
		dest.writeString(getCallbackUrl());
		dest.writeString(getProductName());
		dest.writeString(getProductDesc());
		
		// for RatePayInfo
		dest.writeInt(goodsCount);
		
	}
	
	public static final Parcelable.Creator<FixedPayInfo> CREATOR = new Creator<FixedPayInfo>() {

		@Override
		public FixedPayInfo createFromParcel(Parcel source) {
			final FixedPayInfo ratePayInfo = new FixedPayInfo(source.readString(), source.readString(), source.readInt());
			ratePayInfo.setCallbackUrl(source.readString());
			ratePayInfo.setProductName(source.readString());
			ratePayInfo.setProductDesc(source.readString());
			ratePayInfo.setGoodsCount(source.readInt());
			return ratePayInfo;
		}

		@Override
		public FixedPayInfo[] newArray(int size) {
			return new FixedPayInfo[size];
		}

	};

}
