package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ClaimResultScbUploadVO {
	private String refNo;
	private String refCode;
	private int itemId;
	private String apprCode;


	public static ClaimResultScbUploadVO create(CSVRecord CSVRecord) {

		ClaimResultScbUploadVO vo = new ClaimResultScbUploadVO();

		vo.setRefNo(CSVRecord.get(0).substring(14,50).trim());
		vo.setRefCode(CSVRecord.get(0).substring(71,73).trim());
		vo.setItemId(Integer.parseInt(CSVRecord.get(0).substring(87,102).trim()));
		vo.setApprCode(CSVRecord.get(0).substring(65,71).trim());

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
