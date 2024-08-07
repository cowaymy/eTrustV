package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;


public class BatchPaymentOutVO {
	private String orderNo;
	private String amount;
	
	public static BatchPaymentOutVO create(CSVRecord CSVRecord) {
		BatchPaymentOutVO vo = new BatchPaymentOutVO();
		vo.setOrderNo(CSVRecord.get(0));
		vo.setAmount(CSVRecord.get(1));
		
		return vo;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public String getAmount() {
		return amount;
	}

	public void setAmount(String amount) {
		this.amount = amount;
	}
	
	
}
