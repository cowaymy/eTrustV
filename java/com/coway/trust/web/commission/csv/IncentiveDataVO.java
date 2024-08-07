package com.coway.trust.web.commission.csv;

import org.apache.commons.csv.CSVRecord;

public class IncentiveDataVO {

	//  TODO : 각 변수는 타입에 맞게 다시 선언해 주세요~~~ ^^..  타입에 맞게 선언 처리 되었으면, 이 주석은 삭제해 주세요.
	private String memberCode;
	private String targetAmt;
	private String refCode;
	private String level;
				

	public static IncentiveDataVO create(CSVRecord CSVRecord) {
		IncentiveDataVO vo = new IncentiveDataVO();
		vo.setMemberCode(CSVRecord.get(0));
		vo.setTargetAmt(CSVRecord.get(1));
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
