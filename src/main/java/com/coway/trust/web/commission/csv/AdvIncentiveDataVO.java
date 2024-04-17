package com.coway.trust.web.commission.csv;

import org.apache.commons.csv.CSVRecord;

public class AdvIncentiveDataVO {

	//  TODO : 각 변수는 타입에 맞게 다시 선언해 주세요~~~ ^^..  타입에 맞게 선언 처리 되었으면, 이 주석은 삭제해 주세요.
	private String day;
	private String month;
	private String year;
	private String memberCode;
	private String targetAmt;
	private String refCode;
	private String level;


	public static AdvIncentiveDataVO create(CSVRecord CSVRecord) {
		AdvIncentiveDataVO vo = new AdvIncentiveDataVO();
		vo.setDay(CSVRecord.get(0));
		vo.setMonth(CSVRecord.get(1));
		vo.setYear(CSVRecord.get(2));
		vo.setMemberCode(CSVRecord.get(3));
		vo.setTargetAmt(CSVRecord.get(4));
		vo.setRefCode(CSVRecord.get(5));
		vo.setLevel(CSVRecord.get(6));
		return vo;
	}


	public String getDay() {
		return day;
	}


	public void setDay(String day) {
		this.day = day;
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
}
