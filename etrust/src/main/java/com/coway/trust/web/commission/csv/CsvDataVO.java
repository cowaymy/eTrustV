package com.coway.trust.web.commission.csv;

import org.apache.commons.csv.CSVRecord;

public class CsvDataVO {

	//  TODO : 각 변수는 타입에 맞게 다시 선언해 주세요~~~ ^^..  타입에 맞게 선언 처리 되었으면, 이 주석은 삭제해 주세요.
	private String hpCode;
	private String joinYear;
	private String joinMonth;
	private String joinDays;
	private String isNew;

	public static CsvDataVO create(CSVRecord CSVRecord) {
		CsvDataVO vo = new CsvDataVO();
		vo.setHpCode(CSVRecord.get(0));
		vo.setJoinYear(CSVRecord.get(1));
		vo.setJoinMonth(CSVRecord.get(2));
		vo.setJoinDays(CSVRecord.get(3));
		vo.setIsNew(CSVRecord.get(4));
		return vo;
	}

	public String getHpCode() {
		return hpCode;
	}

	public void setHpCode(String hpCode) {
		this.hpCode = hpCode;
	}

	public String getJoinYear() {
		return joinYear;
	}

	public void setJoinYear(String joinYear) {
		this.joinYear = joinYear;
	}

	public String getJoinMonth() {
		return joinMonth;
	}

	public void setJoinMonth(String joinMonth) {
		this.joinMonth = joinMonth;
	}

	public String getJoinDays() {
		return joinDays;
	}

	public void setJoinDays(String joinDays) {
		this.joinDays = joinDays;
	}

	public String getIsNew() {
		return isNew;
	}

	public void setIsNew(String isNew) {
		this.isNew = isNew;
	}
}
