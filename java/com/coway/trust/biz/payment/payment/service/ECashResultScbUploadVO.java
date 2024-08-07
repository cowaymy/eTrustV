package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ECashResultScbUploadVO {
	private String respnsCode;
	private String appvCode;
	private String settleDate;
	private int itmId;
	private int itmCnt;

	public static ECashResultScbUploadVO create(CSVRecord CSVRecord) {

		ECashResultScbUploadVO vo = new ECashResultScbUploadVO();

		vo.setItmId(Integer.parseInt(CSVRecord.get(0).substring(87,102).trim()));
		vo.setAppvCode(CSVRecord.get(0).substring(65,71).trim());
		vo.setRespnsCode(CSVRecord.get(0).substring(71,73).trim());
		vo.setItmCnt((int)CSVRecord.getRecordNumber());

		return vo;

	}

	public int getItmCnt() {
		return itmCnt;
	}

	public void setItmCnt(int itmCnt) {
		this.itmCnt = itmCnt;
	}

	public int getItmId() {
		return itmId;
	}

	public void setItmId(int itmId) {
		this.itmId = itmId;
	}

	public String getAppvCode() {
		return appvCode;
	}

	public void setAppvCode(String appvCode) {
		this.appvCode = appvCode;
	}

	public String getRespnsCode() {
		return respnsCode;
	}

	public void setRespnsCode(String respnsCode) {
		this.respnsCode = respnsCode;
	}

	public String getSettleDate() {
		return settleDate;
	}

	public void setSettleDate(String settleDate) {
		this.settleDate = settleDate;
	}


}
