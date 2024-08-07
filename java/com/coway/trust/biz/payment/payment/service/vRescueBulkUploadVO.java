package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class vRescueBulkUploadVO {
	private String ordNo;
	private String remark;

	public static vRescueBulkUploadVO create(CSVRecord CSVRecord) {

		vRescueBulkUploadVO vo = new vRescueBulkUploadVO();

		vo.setOrdNo(CSVRecord.get(0).trim());
		vo.setRemark(CSVRecord.get(1).trim());

		return vo;
	}

	public String getOrdNo() {
		return ordNo;
	}

	public void setOrdNo(String ordNo) {
		this.ordNo = ordNo;
	}

	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

}
