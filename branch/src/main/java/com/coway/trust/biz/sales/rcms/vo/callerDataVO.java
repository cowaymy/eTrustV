package com.coway.trust.biz.sales.rcms.vo;

import org.apache.commons.csv.CSVRecord;

public class callerDataVO {

	private String orderNo;
	private String caller;
	
	public static callerDataVO create(CSVRecord CSVRecord){
		
		callerDataVO vo = new callerDataVO();
		
		vo.setOrderNo(CSVRecord.get(0));
		vo.setCaller(CSVRecord.get(1));
		
		return vo;
	}
	
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public String getCaller() {
		return caller;
	}
	public void setCaller(String caller) {
		this.caller = caller;
	}
}
