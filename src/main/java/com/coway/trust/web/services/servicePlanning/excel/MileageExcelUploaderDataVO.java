package com.coway.trust.web.services.servicePlanning.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.*;

public class MileageExcelUploaderDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^

	private String MemberType;
	private String Branch;
	private String CityFrom;
	private String DCPFrom;
	private String DCPFromID;
	private String CityTo;
	private String DCPTo;
	private String DCPToID;
	private String Distance;

	public static MileageExcelUploaderDataVO create(Row row) 
	{
		MileageExcelUploaderDataVO vo = new MileageExcelUploaderDataVO();

		vo.setMemberType(getValue(row.getCell(1)));
		vo.setBranch(getValue(row.getCell(2)));
		vo.setCityFrom(getValue(row.getCell(3)));
		vo.setDCPFrom(getValue(row.getCell(4)));
		vo.setDCPFromID(getValue(row.getCell(5)));
		vo.setCityTo(getValue(row.getCell(6)));
		vo.setDCPTo(getValue(row.getCell(7)));
		vo.setDCPToID(getValue(row.getCell(8)));
		vo.setDistance(getValue(row.getCell(9)));
		
		return vo;
	}
	

	public String getMemberType() {
		return MemberType;
	}

	public void setMemberType(String memberType) {
		MemberType = memberType;
	}

	public String getBranch() {
		return Branch;
	}

	public void setBranch(String branch) {
		Branch = branch;
	}

	public String getDCPFrom() {
		return DCPFrom;
	}

	public void setDCPFrom(String dCPFrom) {
		DCPFrom = dCPFrom;
	}

	public String getDCPTo() {
		return DCPTo;
	}

	public void setDCPTo(String dCPTo) {
		DCPTo = dCPTo;
	}

	public String getDistance() {
		return Distance;
	}

	public void setDistance(String distance) {
		Distance = distance;
	}

	public String getCityFrom() {
		return CityFrom;
	}

	public void setCityFrom(String cityFrom) {
		CityFrom = cityFrom;
	}

	public String getDCPFromID() {
		return DCPFromID;
	}

	public void setDCPFromID(String dCPFromID) {
		DCPFromID = dCPFromID;
	}

	public String getCityTo() {
		return CityTo;
	}

	public void setCityTo(String cityTo) {
		CityTo = cityTo;
	}

	public String getDCPToID() {
		return DCPToID;
	}

	public void setDCPToID(String dCPToID) {
		DCPToID = dCPToID;
	}

}
