package com.coway.trust.biz.api.vo.chatbotInbound;

public class StatementReqForm {
	private String orderNo;
	private int orderId;
	private String custEmailAdd;
	private int statementType;
	private int month;

	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public int getOrderId() {
		return orderId;
	}
	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}
	public String getCustEmailAdd() {
		return custEmailAdd;
	}
	public void setCustEmailAdd(String custEmailAdd) {
		this.custEmailAdd = custEmailAdd;
	}
	public int getStatementType() {
		return statementType;
	}
	public void setStatementType(int statementType) {
		this.statementType = statementType;
	}
	public int getMonth() {
		return month;
	}
	public void setMonth(int month) {
		this.month = month;
	}
}