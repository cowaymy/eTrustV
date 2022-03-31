package com.coway.trust.biz.payment.autodebit.service;

import org.apache.commons.csv.CSVRecord;

public class M2UploadVO {
	private String orderNo;

	public String getOrderNo() {
		return orderNo;
	}

	public void setOrderNo(String orderNo) {
		this.orderNo = orderNo;
	}

	public static M2UploadVO create(CSVRecord CSVRecord) {
		M2UploadVO vo = new M2UploadVO();
		vo.setOrderNo(CSVRecord.get(0));

		return vo;
	}


}
