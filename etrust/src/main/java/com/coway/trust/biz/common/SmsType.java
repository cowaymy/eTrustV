package com.coway.trust.biz.common;

public enum SmsType {
	SMALL("GenSuite"), BULK("MVGate");

	private String productName = "";

	SmsType(String productName) {
		this.productName = productName;
	}

	public String getProductName() {
		return this.productName;
	}
}
