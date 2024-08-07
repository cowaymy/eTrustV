package com.coway.trust.biz.payment.billing.service;

import org.apache.commons.csv.CSVRecord;

public class AdvBillingBatchVO {
	private String orderNo;
	private int taxInvoiceFr;
	private int taxInvoiceTo;
	private double discount;
	
	public static AdvBillingBatchVO create(CSVRecord CSVRecord) {
		AdvBillingBatchVO vo = new AdvBillingBatchVO();
		vo.setOrderNo(String.valueOf((CSVRecord.get(0))));
		vo.setTaxInvoiceFr(Integer.parseInt(CSVRecord.get(1)));
		vo.setTaxInvoiceTo(Integer.parseInt(CSVRecord.get(2)));
		vo.setDiscount(Double.parseDouble(CSVRecord.get(3)));
		return vo;
	}

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public int getTaxInvoiceFr() {
		return taxInvoiceFr;
	}

	public void setTaxInvoiceFr(int taxInvoiceFr) {
		this.taxInvoiceFr = taxInvoiceFr;
	}

	public int getTaxInvoiceTo() {
		return taxInvoiceTo;
	}

	public void setTaxInvoiceTo(int taxInvoiceTo) {
		this.taxInvoiceTo = taxInvoiceTo;
	}

	public double getDiscount() {
		return discount;
	}

	public void setDiscount(double discount) {
		this.discount = discount;
	}
	
	
}
