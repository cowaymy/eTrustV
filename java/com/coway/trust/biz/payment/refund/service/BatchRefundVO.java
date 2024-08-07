package com.coway.trust.biz.payment.refund.service;

import org.apache.commons.csv.CSVRecord;

public class BatchRefundVO {
	
	private String worNo;
	private String amount;
	private String chqNo;
	private String refNo;
	private String remark;
	
	public static BatchRefundVO create(CSVRecord CSVRecord) {
		BatchRefundVO vo = new BatchRefundVO();
		vo.setWorNo(CSVRecord.get(0));
		vo.setAmount(CSVRecord.get(1));
		vo.setChqNo(CSVRecord.get(2));
		vo.setRefNo(CSVRecord.get(3));
		vo.setRemark(CSVRecord.get(4));
		
		return vo;
	}
	
	public String getWorNo() {
		return worNo;
	}
	public void setWorNo(String worNo) {
		this.worNo = worNo;
	}
	public String getAmount() {
		return amount;
	}
	public void setAmount(String amount) {
		this.amount = amount;
	}
	public String getChqNo() {
		return chqNo;
	}
	public void setChqNo(String chqNo) {
		this.chqNo = chqNo;
	}
	public String getRefNo() {
		return refNo;
	}
	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	
	

}
