package com.coway.trust.biz.common.type;

public enum SMSTemplateType {
	/**
	 * file location : /src/main/resources/template/sms/ .....
	 */
	RENTAL_BILL("/template/sms/rentalBill");

	private String fileName = "";

	SMSTemplateType(String fileName) {
		this.fileName = fileName;
	}

	public String getFileName() {
		return this.fileName;
	}
}
