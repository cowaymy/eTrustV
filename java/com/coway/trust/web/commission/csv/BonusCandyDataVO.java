package com.coway.trust.web.commission.csv;

import org.apache.commons.csv.CSVRecord;

public class BonusCandyDataVO {

	//  TODO : 각 변수는 타입에 맞게 다시 선언해 주세요~~~ ^^..  타입에 맞게 선언 처리 되었으면, 이 주석은 삭제해 주세요.
	private String memberCode;
	private String bonusCandyRate;
	private String refCode;
	private String level;


	public static BonusCandyDataVO create(CSVRecord CSVRecord) {
		BonusCandyDataVO vo = new BonusCandyDataVO();
		vo.setMemberCode(CSVRecord.get(0));
		vo.setBonusCandyRate(CSVRecord.get(1));
		vo.setRefCode(CSVRecord.get(2));
		vo.setLevel(CSVRecord.get(3));
		return vo;
	}


	public String getMemberCode() {
		return memberCode;
	}


	public void setMemberCode(String memberCode) {
		this.memberCode = memberCode;
	}


	public String getBonusCandyRate() {
		return bonusCandyRate;
	}


	public void setBonusCandyRate(String bonusCandyRate) {
		this.bonusCandyRate = bonusCandyRate;
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
