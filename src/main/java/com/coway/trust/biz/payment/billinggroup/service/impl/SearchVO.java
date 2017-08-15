package com.coway.trust.biz.payment.billinggroup.service.impl;

public class SearchVO {
	private String orderNo;
	private String[] appType;
	private String custName;
	
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String[] getAppType() {
		return appType;
	}
	public void setAppType(String[] appType) {
		this.appType = appType;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
}
