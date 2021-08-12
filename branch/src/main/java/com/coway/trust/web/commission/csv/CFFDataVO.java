package com.coway.trust.web.commission.csv;

import org.apache.commons.csv.CSVRecord;

public class CFFDataVO {

	//  TODO : 각 변수는 타입에 맞게 다시 선언해 주세요~~~ ^^..  타입에 맞게 선언 처리 되었으면, 이 주석은 삭제해 주세요.
	private String memberCode;
	private String mark;


	public static CFFDataVO create(CSVRecord CSVRecord) {
		CFFDataVO vo = new CFFDataVO();
		vo.setMemberCode(CSVRecord.get(0));
		vo.setMark(CSVRecord.get(1));
		return vo;
	}


	public String getMemberCode() {
		return memberCode;
	}


	public void setMemberCode(String memberCode) {
		this.memberCode = memberCode;
	}


	public String getMark() {
		return mark;
	}


	public void setMark(String mark) {
		this.mark = mark;
	}
}
