package com.coway.trust.web.services.csv;

import org.apache.commons.csv.CSVRecord;

public class HiCareDataVO {

	//  TODO : 각 변수는 타입에 맞게 다시 선언해 주세요~~~ ^^..  타입에 맞게 선언 처리 되었으면, 이 주석은 삭제해 주세요.
	private String serialNo;
	private String model;


	public static HiCareDataVO create(CSVRecord CSVRecord) {
		HiCareDataVO vo = new HiCareDataVO();
		vo.setSerialNo(CSVRecord.get(0));
		vo.setModel(CSVRecord.get(1));
		return vo;
	}


	public String getSerialNo() {
		return serialNo;
	}


	public String getModel() {
		return model;
	}


	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}


	public void setModel(String model) {
		this.model = model;
	}


}
