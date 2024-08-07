package com.coway.trust.web.organization.organization;

import org.apache.commons.csv.CSVRecord;

public class LoyaltyHPUploadDataVO {

	private String lotyMemberStatusCode;
	private String lotyMemberCode;
	private String lotyStartDate;
	private String lotyEndDate;
	private String lotyPeriod;
	private String lotyYear;
	private String lotyUploadId;
	private String userId;


	public static LoyaltyHPUploadDataVO create(CSVRecord CSVRecord) {
		LoyaltyHPUploadDataVO vo = new LoyaltyHPUploadDataVO();
		vo.setLotyMemberStatusCode(CSVRecord.get(0));
		vo.setLotyMemberCode(CSVRecord.get(1));
		vo.setLotyStartDate(CSVRecord.get(2));
		vo.setLotyEndDate(CSVRecord.get(3));
		vo.setLotyPeriod(CSVRecord.get(4));
		vo.setLotyYear(CSVRecord.get(5));
		return vo;
	}




	public String getLotyUploadId() {
		return lotyUploadId;
	}



	public void setLotyUploadId(String lotyUploadId) {
		this.lotyUploadId = lotyUploadId;
	}



	public String getLotyMemberStatusCode() {
		return lotyMemberStatusCode;
	}




	public void setLotyMemberStatusCode(String lotyMemberStatusCode) {
		this.lotyMemberStatusCode = lotyMemberStatusCode;
	}




	public String getLotyMemberCode() {
		return lotyMemberCode;
	}




	public void setLotyMemberCode(String lotyMemberCode) {
		this.lotyMemberCode = lotyMemberCode;
	}




	public String getLotyStartDate() {
		return lotyStartDate;
	}




	public void setLotyStartDate(String lotyStartDate) {
		this.lotyStartDate = lotyStartDate;
	}




	public String getLotyEndDate() {
		return lotyEndDate;
	}




	public void setLotyEndDate(String lotyEndDate) {
		this.lotyEndDate = lotyEndDate;
	}




	public String getLotyPeriod() {
		return lotyPeriod;
	}




	public void setLotyPeriod(String lotyPeriod) {
		this.lotyPeriod = lotyPeriod;
	}




	public String getLotyYear() {
		return lotyYear;
	}




	public void setLotyYear(String lotyYear) {
		this.lotyYear = lotyYear;
	}




	public String getUserId() {
		return userId;
	}




	public void setUserId(String userId) {
		this.userId = userId;
	}


}
