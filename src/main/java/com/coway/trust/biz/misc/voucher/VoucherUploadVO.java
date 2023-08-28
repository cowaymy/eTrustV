package com.coway.trust.biz.misc.voucher;

import org.apache.commons.csv.CSVRecord;

import com.coway.trust.biz.payment.payment.service.BatchPaymentVO;
public class VoucherUploadVO {
	private String voucherCode;
	private String customerEmail;
	private String orderId;

	public static VoucherUploadVO create(CSVRecord CSVRecord) {
		VoucherUploadVO vo = new VoucherUploadVO();
		vo.setVoucherCode(CSVRecord.get(0));
		vo.setCustomerEmail(CSVRecord.get(1));
		vo.setOrderId(CSVRecord.get(2));
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
}
