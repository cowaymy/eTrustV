package com.coway.trust.biz.common.type;

public enum EmailTemplateType {
	/**
	 * file location : /src/main/resources/template/mail/ .....
	 */
	OVERDUE_PAYMENT_4("/template/mail/overduePayment_4.html"),
	OVERDUE_PAYMENT_5_6("/template/mail/overduePayment_5_6.html"),
	E_TEMPORARY_RECEIPT("/template/mail/eTemporaryReceipt.html");

	private String fileName = "";

	EmailTemplateType(String fileName) {
		this.fileName = fileName;
	}

	public String getFileName() {
		return this.fileName;
	}
}
