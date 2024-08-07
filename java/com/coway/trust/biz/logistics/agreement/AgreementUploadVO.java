package com.coway.trust.biz.logistics.agreement;

import org.apache.commons.csv.CSVRecord;

public class AgreementUploadVO {
	private String memCode;

	public static AgreementUploadVO create(CSVRecord CSVRecord) {
		AgreementUploadVO vo = new AgreementUploadVO();
		vo.setMemCode(CSVRecord.get(0));
		return vo;
	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}
}
