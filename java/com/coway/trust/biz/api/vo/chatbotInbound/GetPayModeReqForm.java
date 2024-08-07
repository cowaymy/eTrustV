package com.coway.trust.biz.api.vo.chatbotInbound;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "GetPayModeReqForm", description = "GetPayModeReqForm")
public class GetPayModeReqForm {
	private String orderNo;
	private int orderId;
	private int payMtdType;

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

	public int getPayMtdType() {
		return payMtdType;
	}
	public void setPayMtdType(int payMtdType) {
		this.payMtdType = payMtdType;
	}
}
