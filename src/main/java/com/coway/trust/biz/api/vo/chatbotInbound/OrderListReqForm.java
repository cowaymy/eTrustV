package com.coway.trust.biz.api.vo.chatbotInbound;

public class OrderListReqForm {
	private String custNric;
	private int custId;

	public String getCustNric() {
		return custNric;
	}
	public void setCustNric(String custNric) {
		this.custNric = custNric;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}
}