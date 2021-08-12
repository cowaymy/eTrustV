package com.coway.trust.biz.common.type;

public enum FileType {
	WEB("W"), WEB_DIRECT_RESOURCE("D"), MOBILE("M"), CALL_CENTER("C");

	private String code = "";

	FileType(String code) {
		this.code = code;
	}

	public String getCode() {
		return this.code;
	}
}
