package com.coway.trust.biz.payment.otherpayment.service;

import org.apache.commons.csv.CSVRecord;


public class CustVaExcludeVO {
	private String custVaNo;


	public static CustVaExcludeVO create(CSVRecord CSVRecord) {
		CustVaExcludeVO vo = new CustVaExcludeVO();
		vo.setCustVaNo(CSVRecord.get(0));

		return vo;
	}

	public String getCustVaNo() {
		return custVaNo;
	}

	public void setCustVaNo(String custVaNo) {
		this.custVaNo = custVaNo;
	}

}
