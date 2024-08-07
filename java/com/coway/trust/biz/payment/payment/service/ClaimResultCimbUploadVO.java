package com.coway.trust.biz.payment.payment.service;

import org.apache.commons.csv.CSVRecord;

public class ClaimResultCimbUploadVO {
	private String refNo;
	private String refCode;
	private int itemId;
	private String apprCode;

	public static ClaimResultCimbUploadVO create(CSVRecord CSVRecord) {

		ClaimResultCimbUploadVO vo = new ClaimResultCimbUploadVO();

		vo.setRefCode(CSVRecord.get(6).trim());
		vo.setItemId(Integer.parseInt(CSVRecord.get(5).trim()));
		vo.setApprCode(CSVRecord.get(7).trim());


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
