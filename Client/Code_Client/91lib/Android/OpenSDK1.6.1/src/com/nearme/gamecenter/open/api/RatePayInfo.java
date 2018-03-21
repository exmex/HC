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
 * 固定比例可币消耗参数
 * 
 * @Author	lailong
 * @Since	2013-10-25
 */
public class RatePayInfo extends PayInfo implements Parcelable {
	
	/**
	 * 商品
	 */
	private int rate = 0;
	
	/**
	 * 默认显示充值商品的数量
	 */
	private int defaultShowCount;

	/**
	 * @param order
	 * @param attach
	 * @param amount
	 */
	public RatePayInfo(String order, String attach) {
		// amount will be useless
		super(order, attach, 1);
	}

	public int getRate() {
		return rate;
	}

	public void setRate(int rate) {
		this.rate = rate;
	}

	public int getDefaultShowCount() {
		return defaultShowCount;
	}

	public void setDefaultShowCount(int defaultShowCount) {
		this.defaultShowCount = defaultShowCount;
	}

	/* (non-Javadoc)
	 * @see android.os.Parcelable#describeContents()
	 */
	@Override
	public int describeContents() {
		// TODO Auto-generated method stub
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
		dest.writeInt(rate);
		dest.writeInt(defaultShowCount);
		
	}
	
	public static final Parcelable.Creator<RatePayInfo> CREATOR = new Creator<RatePayInfo>() {

		@Override
		public RatePayInfo createFromParcel(Parcel source) {
			final RatePayInfo ratePayInfo = new RatePayInfo(source.readString(), source.readString());
			ratePayInfo.setAmount(source.readInt());
			ratePayInfo.setCallbackUrl(source.readString());
			ratePayInfo.setProductName(source.readString());
			ratePayInfo.setProductDesc(source.readString());
			ratePayInfo.setRate(source.readInt());
			ratePayInfo.setDefaultShowCount(source.readInt());
			return ratePayInfo;
		}

		@Override
		public RatePayInfo[] newArray(int size) {
			return new RatePayInfo[size];
		}

	};

}
