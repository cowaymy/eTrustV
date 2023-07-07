package com.coway.trust.web.eAccounting.csv;

import org.apache.commons.csv.CSVRecord;

public class SmGmEntitlementVO {

	//  TODO : 각 변수는 타입에 맞게 다시 선언해 주세요~~~ ^^..  타입에 맞게 선언 처리 되었으면, 이 주석은 삭제해 주세요.
	private String hpCode;
	private String level;
	private String month;
	private String entitlement;


	public static SmGmEntitlementVO create(CSVRecord CSVRecord) {
		SmGmEntitlementVO vo = new SmGmEntitlementVO();
		vo.setHpCode(CSVRecord.get(0));
		vo.setLevel(CSVRecord.get(1));
		vo.setMonth(CSVRecord.get(2));
		vo.setEntitlement(CSVRecord.get(3));
		return vo;
	}


	public String getHpCode() {
		return hpCode;
	}


	public void setHpCode(String hpCode) {
		this.hpCode = hpCode;
	}

	public String getLevel() {
		return level;
	}


	public void setLevel(String level) {
		this.level = level;
	}


	public String getMonth() {
		return month;
	}


	public void setMonth(String month) {
		this.month = month;
	}


	public String getEntitlement() {
		return entitlement;
	}


	public void setEntitlement(String entitlement) {
		this.entitlement = entitlement;
	}



}
