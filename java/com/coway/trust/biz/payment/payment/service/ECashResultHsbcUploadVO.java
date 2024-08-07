package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ECashResultHsbcUploadVO {
	private String respnsCode;
	private String appvCode;
	private String settleDate;
	private int itmId;
	private int itmCnt;

	public static ECashResultHsbcUploadVO create(CSVRecord CSVRecord) {

		ECashResultHsbcUploadVO vo = new ECashResultHsbcUploadVO();

		if(CSVRecord.get(0).substring(0,1).trim().equals("D")){
    		vo.setRespnsCode(CSVRecord.get(0).substring(120,123).trim());
    		vo.setItmId(Integer.parseInt(CSVRecord.get(0).substring(43,52).trim()));
    		vo.setAppvCode(CSVRecord.get(0).substring(39,43).trim());
    		vo.setItmCnt((int)CSVRecord.getRecordNumber());
		}else{
			vo.setRespnsCode(CSVRecord.get(0).substring(99,102).trim());
			vo.setItmId(Integer.parseInt(CSVRecord.get(0).substring(48,57).trim()));
			vo.setAppvCode(CSVRecord.get(0).substring(41,47).trim());
			vo.setItmCnt((int)CSVRecord.getRecordNumber());
		}

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
