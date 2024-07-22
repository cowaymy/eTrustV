package com.coway.trust.biz.supplement.payment.service;

import org.apache.commons.csv.CSVRecord;

public class SupplementBatchRefundVO {

	private String borNo;
	private String amount;
	private String chqNo;
	private String refNo;
	private String remark;

	public static SupplementBatchRefundVO create(CSVRecord CSVRecord) {
		SupplementBatchRefundVO vo = new SupplementBatchRefundVO();
		vo.setBorNo(CSVRecord.get(0));
		vo.setAmount(CSVRecord.get(1));
		vo.setChqNo(CSVRecord.get(2));
		vo.setRefNo(CSVRecord.get(3));
		vo.setRemark(CSVRecord.get(4));

		return vo;
	}

	public String getBorNo() {
		return borNo;
	}
	public void setBorNo(String borNo) {
		this.borNo = borNo;
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
