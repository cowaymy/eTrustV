package com.coway.trust.web.services.servicePlanning.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.*;

public class MileageExcelUploaderDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^

	private String MemberType;
	private String Branch;
	private String DCPFrom;
	private String DCPTo;
	private String Distance;
	private String memType1;
	private String brnchCode1;
	private String dcpFrom1;
	private String dcpTo1;
	private String distance1;

	public static MileageExcelUploaderDataVO create(Row row) 
	{
		MileageExcelUploaderDataVO vo = new MileageExcelUploaderDataVO();

		vo.setMemberType(getValue(row.getCell(1)));
		vo.setBranch(getValue(row.getCell(2)));
		vo.setDCPFrom(getValue(row.getCell(3)));
		vo.setDCPTo(getValue(row.getCell(4)));
		if (row.getCell(5).getCellTypeEnum() == CellType.NUMERIC)
			vo.setDistance(String.valueOf((int)row.getCell(5).getNumericCellValue()));
		else if (row.getCell(5).getCellTypeEnum() == CellType.STRING)
			vo.setDistance(getValue(row.getCell(5)));
		
		// 숨겨진 셀 (입력값 없을 수 있음)
		if (row.getCell(6) == null || row.getCell(6).getCellType() == Cell.CELL_TYPE_BLANK)	// This cell is empty
			vo.setMemType1(null);
		else {
			if (row.getCell(6).getCellTypeEnum() == CellType.NUMERIC)
				vo.setMemType1(String.valueOf((int)row.getCell(6).getNumericCellValue()));
			else if (row.getCell(6).getCellTypeEnum() == CellType.STRING)
				vo.setMemType1(getValue(row.getCell(6)));
		}
		
		if (row.getCell(7) == null || row.getCell(7).getCellType() == Cell.CELL_TYPE_BLANK)	// This cell is empty
			vo.setBrnchCode1(null);
		else {
			vo.setBrnchCode1(getValue(row.getCell(7)));
		}
		
		if (row.getCell(8) == null || row.getCell(8).getCellType() == Cell.CELL_TYPE_BLANK)	// This cell is empty
			vo.setDcpFrom1(null);
		else {
			vo.setDcpFrom1(getValue(row.getCell(8)));
		}
		
		if (row.getCell(9) == null || row.getCell(9).getCellType() == Cell.CELL_TYPE_BLANK)	// This cell is empty
			vo.setDcpTo1(null);
		else {
			vo.setDcpTo1(getValue(row.getCell(9)));
		}
		
		if (row.getCell(10) == null || row.getCell(10).getCellType() == Cell.CELL_TYPE_BLANK)	// This cell is empty
			vo.setDistance1(null);
		else {
			if (row.getCell(10).getCellTypeEnum() == CellType.NUMERIC)
				vo.setDistance1(String.valueOf((int)row.getCell(10).getNumericCellValue()));
			else if (row.getCell(10).getCellTypeEnum() == CellType.STRING)
				vo.setDistance1(getValue(row.getCell(10)));
		}

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


	public String getMemType1() {
		return memType1;
	}


	public void setMemType1(String memType1) {
		this.memType1 = memType1;
	}


	public String getBrnchCode1() {
		return brnchCode1;
	}


	public void setBrnchCode1(String brnchCode1) {
		this.brnchCode1 = brnchCode1;
	}


	public String getDcpFrom1() {
		return dcpFrom1;
	}


	public void setDcpFrom1(String dcpFrom1) {
		this.dcpFrom1 = dcpFrom1;
	}


	public String getDcpTo1() {
		return dcpTo1;
	}


	public void setDcpTo1(String dcpTo1) {
		this.dcpTo1 = dcpTo1;
	}


	public String getDistance1() {
		return distance1;
	}


	public void setDistance1(String distance1) {
		this.distance1 = distance1;
	}

}
