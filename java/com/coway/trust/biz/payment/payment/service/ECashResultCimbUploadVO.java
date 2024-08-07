package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ECashResultCimbUploadVO {
	private String respnsCode;
	private String appvCode;
	private String settleDate;
	private int itmId;
	private int itmCnt;

	public static ECashResultCimbUploadVO create(CSVRecord CSVRecord) {

		ECashResultCimbUploadVO vo = new ECashResultCimbUploadVO();

		vo.setItmId(Integer.parseInt(CSVRecord.get(5).trim()));
		vo.setAppvCode(CSVRecord.get(7).trim());
		vo.setRespnsCode(CSVRecord.get(6).trim());
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
