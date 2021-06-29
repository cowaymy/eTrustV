package com.coway.trust.web.organization.organization.excel;

import org.apache.commons.csv.CSVRecord;

public class MemberHospitalizeDataVO {
	private String memberCode;


	public static MemberHospitalizeDataVO create(CSVRecord CSVRecord) {
	  MemberHospitalizeDataVO vo = new MemberHospitalizeDataVO();
		vo.setMemberCode(CSVRecord.get(0));
		return vo;
	}


	public String getMemberCode() {
		return memberCode;
	}


	public void setMemberCode(String memberCode) {
		this.memberCode = memberCode;
	}

}
