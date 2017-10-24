package com.coway.trust.biz.common.type;

public enum FileType {
	WEB("W"), MOBILE("M"), CALL_CENTER("C");

	private String code = "";

	FileType(String code) {
		this.code = code;
	}

	public String getCode() {
		return this.code;
	}
}
