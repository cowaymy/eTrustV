package com.coway.trust.biz.api.vo.chatbotInbound;

import java.io.Serializable;

public class JompayVO implements Serializable{
	private String billerCode;
	private String ref1;
	private String ref2;

	public String getBillerCode() {
		return billerCode;
	}
	public void setBillerCode(String billerCode) {
		this.billerCode = billerCode;
	}

	public String getRef1() {
		return ref1;
	}
	public void setRef1(String ref1) {
		this.ref1 = ref1;
	}

	public String getRef2() {
		return ref2;
	}
	public void setRef2(String ref2) {
		this.ref2 = ref2;
	}
}
