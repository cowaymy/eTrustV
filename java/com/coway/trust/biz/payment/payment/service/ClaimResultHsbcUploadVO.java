package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ClaimResultHsbcUploadVO {
	private String refNo;
	private String refCode;
	private int itemId;
	private String apprCode;


	public static ClaimResultHsbcUploadVO create(CSVRecord CSVRecord) {

		ClaimResultHsbcUploadVO vo = new ClaimResultHsbcUploadVO();

		if(CSVRecord.get(0).substring(0,1).trim().equals("D")){
    		vo.setRefCode(CSVRecord.get(0).substring(120,123).trim());
    		vo.setItemId(Integer.parseInt(CSVRecord.get(0).substring(43,52).trim()));
    		vo.setApprCode(CSVRecord.get(0).substring(39,43).trim());
		}else{
			vo.setRefCode(CSVRecord.get(0).substring(99,102).trim());
			vo.setItemId(Integer.parseInt(CSVRecord.get(0).substring(48,57).trim()));
			vo.setApprCode(CSVRecord.get(0).substring(41,47).trim());
		}

		return vo;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public String getRefCode() {
		return refCode;
	}

	public void setRefCode(String refCode) {
		this.refCode = refCode;
	}

	public int getItemId() {
		return itemId;
	}

	public void setItemId(int itemId) {
		this.itemId = itemId;
	}

	public String getApprCode() {
	    return apprCode;
	}

	public void setApprCode(String apprCode) {
	  this.apprCode = apprCode;
	}

}
