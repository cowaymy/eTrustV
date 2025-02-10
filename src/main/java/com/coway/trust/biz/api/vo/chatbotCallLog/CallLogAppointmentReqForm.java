package com.coway.trust.biz.api.vo.chatbotCallLog;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "CallLogAppointmentReqForm", description = "CallLogAppointmentReqForm")
public class CallLogAppointmentReqForm {
	private String requestId;
	private String orderNo;
	private String aptDate;
	private int tncFlag;
	private int statusCode;

	public String getRequestId() {
		return requestId;
	}
	public void setRequestId(String requestId) {
		this.requestId = requestId;
	}
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public int getTncFlag() {
		return tncFlag;
	}
	public void setTncFlag(int tncFlag) {
		this.tncFlag = tncFlag;
	}
	public String getAptDate() {
		return aptDate;
	}
	public void setAptDate(String aptDate) {
		this.aptDate = aptDate;
	}
	public int getStatusCode() {
		return statusCode;
	}
	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}
}
