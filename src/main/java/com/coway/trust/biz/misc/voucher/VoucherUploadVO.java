package com.coway.trust.biz.misc.voucher;

import org.apache.commons.csv.CSVRecord;

import com.coway.trust.biz.payment.payment.service.BatchPaymentVO;
public class VoucherUploadVO {
	private String voucherCode;
	private String customerEmail;
	private String orderId;
	private String customerName;
	private String contact;
	private String productName;
	private String obligation;
	private String freeItem;

	public static VoucherUploadVO create(CSVRecord CSVRecord) {
		VoucherUploadVO vo = new VoucherUploadVO();
		vo.setVoucherCode(CSVRecord.get(0));
		vo.setCustomerEmail(CSVRecord.get(1));
		vo.setOrderId(CSVRecord.get(2));
		vo.setCustomerName(CSVRecord.get(3));
		vo.setContact(CSVRecord.get(4));
		vo.setProductName(CSVRecord.get(5));
		vo.setObligation(CSVRecord.get(6));
		vo.setFreeItem(CSVRecord.get(7));
		return vo;
	}

	public String getVoucherCode() {
		return voucherCode;
	}

	public void setVoucherCode(String voucherCode) {
		this.voucherCode = voucherCode;
	}

	public String getCustomerEmail() {
		return customerEmail;
	}

	public void setCustomerEmail(String customerEmail) {
		this.customerEmail = customerEmail;
	}

	public String getOrderId() {
		return orderId;
	}

	public void setOrderId(String orderId) {
		this.orderId = orderId;
	}

	public String getCustomerName() {
		return customerName;
	}

	public void setCustomerName(String customerName) {
		this.customerName = customerName;
	}

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public String getObligation() {
		return obligation;
	}

	public void setObligation(String obligation) {
		this.obligation = obligation;
	}

	public String getFreeItem() {
		return freeItem;
	}

	public void setFreeItem(String freeItem) {
		this.freeItem = freeItem;
	}

	public String getContact() {
		return contact;
	}

	public void setContact(String contact) {
		this.contact = contact;
	}
}
