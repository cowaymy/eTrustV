package com.coway.trust.biz.logistics.sms;

import org.apache.commons.csv.CSVRecord;

public class SmsUploadVO {
	private String msisdn;
	private String ordNo;
	private String msg;

	public static SmsUploadVO create(CSVRecord CSVRecord) {

		SmsUploadVO vo = new SmsUploadVO();

		vo.setMsisdn(CSVRecord.get(0).trim());
		vo.setOrdNo(CSVRecord.get(1).trim());
		vo.setMsg(CSVRecord.get(2).trim());

		return vo;
	}

	public String getMsisdn() {
		return msisdn;
	}

	public void setMsisdn(String msisdn) {
		this.msisdn = msisdn;
	}

	public String getOrdNo() {
		return ordNo;
	}

	public void setOrdNo(String ordNo) {
		this.ordNo = ordNo;
	}

	public String getMsg() {
		return msg;
	}

	public void setMsg(String msg) {
		this.msg = msg;
	}

}
