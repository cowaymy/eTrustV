package com.coway.trust.biz.common.type;

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
