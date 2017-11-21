package com.coway.trust.api.mobile.services.cancelSms;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class CanCelSmsForm {

	
	
	
	private String userId;
	private String salesOrderNo;
	private String serviceNo;
	private String senderTelNo;
	private String receiverTelNo;
	
	
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public String getSalesOrderNo() {
		return salesOrderNo;
	}
	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}
	public String getServiceNo() {
		return serviceNo;
	}
	public void setServiceNo(String serviceNo) {
		this.serviceNo = serviceNo;
	}
	public String getSenderTelNo() {
		return senderTelNo;
	}
	public void setSenderTelNo(String senderTelNo) {
		this.senderTelNo = senderTelNo;
	}
	public String getReceiverTelNo() {
		return receiverTelNo;
	}
	public void setReceiverTelNo(String receiverTelNo) {
		this.receiverTelNo = receiverTelNo;
	}
	
	
	
	
	public static Map<String, Object> createMap(CanCelSmsForm canCelSmsForm) {
		
		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map=null;

		map = BeanConverter.toMap(canCelSmsForm);
		
		return map;
	}	
	
	
	
	
}
