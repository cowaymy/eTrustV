package com.coway.trust.biz.payment.autodebit.service;

public class CsvFormatVO {
	private String orderNo;
	private int month;
	private int day;
	private int year;
	private String RejectCode;
	public String getOrderNo() {
		return orderNo;
	}
	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}
	public int getMonth() {
		return month;
	}
	public void setMonth(int month) {
		this.month = month;
	}
	public int getDay() {
		return day;
	}
	public void setDay(int day) {
		this.day = day;
	}
	public int getYear() {
		return year;
	}
	public void setYear(int year) {
		this.year = year;
	}
	public String getRejectCode() {
		return RejectCode;
	}
	public void setRejectCode(String rejectCode) {
		RejectCode = rejectCode;
	}
	public CsvFormatVO(String orderNo, int month, int day, int year, String rejectCode) {
		super();
		this.orderNo = orderNo;
		this.month = month;
		this.day = day;
		this.year = year;
		RejectCode = rejectCode;
	}
	@Override
	public String toString() {
		return "CsvFormatVO [orderNo=" + orderNo + ", month=" + month + ", day=" + day + ", year=" + year
				+ ", RejectCode=" + RejectCode + "]";
	}
	
	
}
