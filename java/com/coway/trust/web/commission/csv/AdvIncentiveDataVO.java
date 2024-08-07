package com.coway.trust.web.commission.csv;

import org.apache.commons.csv.CSVRecord;

public class AdvIncentiveDataVO {

	private String month;
	private String year;
	private String memberCode;
	private String targetAmt;
	private String refCode;
	private String level;
	private String advDt;

	public static AdvIncentiveDataVO create(CSVRecord CSVRecord) {
		AdvIncentiveDataVO vo = new AdvIncentiveDataVO();
		vo.setMonth(CSVRecord.get(0));
		vo.setYear(CSVRecord.get(1));
		vo.setMemberCode(CSVRecord.get(2));
		vo.setTargetAmt(CSVRecord.get(3));
		vo.setRefCode(CSVRecord.get(4));
		vo.setLevel(CSVRecord.get(5));
		vo.setAdvDt(CSVRecord.get(6));
		return vo;
	}

	public String getMonth() {
		return month;
	}


	public void setMonth(String month) {
		this.month = month;
	}


	public String getYear() {
		return year;
	}


	public void setYear(String year) {
		this.year = year;
	}


	public String getMemberCode() {
		return memberCode;
	}


	public void setMemberCode(String memberCode) {
		this.memberCode = memberCode;
	}


	public String getTargetAmt() {
		return targetAmt;
	}


	public void setTargetAmt(String targetAmt) {
		this.targetAmt = targetAmt;
	}


	public String getRefCode() {
		return refCode;
	}


	public void setRefCode(String refCode) {
		this.refCode = refCode;
	}


	public String getLevel() {
		return level;
	}


	public void setLevel(String level) {
		this.level = level;
	}


	public String getAdvDt() {
		return advDt;
	}


	public void setAdvDt(String advDt) {
		this.advDt = advDt;
	}
}
