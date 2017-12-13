package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class CommDeductionVO {
	private int orderNo;
	private String mCode;
	private double amount;
	private int paidMonth;
	
	public static CommDeductionVO create(CSVRecord CSVRecord) {
		CommDeductionVO vo = new CommDeductionVO();
		vo.setOrderNo(Integer.parseInt(CSVRecord.get(0)));
		vo.setmCode(CSVRecord.get(1));
		vo.setAmount(Double.parseDouble(CSVRecord.get(2)));
		vo.setPaidMonth(Integer.parseInt(CSVRecord.get(3)));
		return vo;
	}
	
	public int getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(int orderNo) {
		this.orderNo = orderNo;
	}
	public String getmCode() {
		return mCode;
	}
	public void setmCode(String mCode) {
		this.mCode = mCode;
	}
	public double getAmount() {
		return amount;
	}
	public void setAmount(double amount) {
		this.amount = amount;
	}
	public int getPaidMonth() {
		return paidMonth;
	}
	public void setPaidMonth(int paidMonth) {
		this.paidMonth = paidMonth;
	}
	
	
}
