package com.coway.trust.biz.api.vo.chatbotInbound;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "GetOtdReqForm", description = "GetOtdReqForm")
public class GetOtdReqForm {
	private String orderNo;
	private int orderId;

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
}
