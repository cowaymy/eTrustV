package com.coway.trust.web.services.servicePlanning.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.CellType;
import org.apache.poi.ss.usermodel.Row;

import com.ibm.icu.text.SimpleDateFormat;

public class CTSubGroupAreaExcelUploaderDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^

	private String AreaID;
	private String Area;
	private String City;
	private String PostalCode;
	private String State;
	private String LocalType;
	private String ServiceWeek;
	private String SubGroup;
	private String PriodFrom;
	private String PriodTo;

	public static CTSubGroupAreaExcelUploaderDataVO create(Row row) 
	{
		CTSubGroupAreaExcelUploaderDataVO vo = new CTSubGroupAreaExcelUploaderDataVO();

		vo.setAreaID(getValue(row.getCell(1)));
		vo.setArea(getValue(row.getCell(2)));
		vo.setCity(getValue(row.getCell(3)));
		vo.setPostalCode(getValue(row.getCell(4)));
		vo.setState(getValue(row.getCell(5)));
		vo.setLocalType(getValue(row.getCell(6)));
		if (row.getCell(7).getCellTypeEnum() == CellType.NUMERIC)
			vo.setServiceWeek(String.valueOf((int)row.getCell(7).getNumericCellValue()));
		else if (row.getCell(7).getCellTypeEnum() == CellType.STRING)
			vo.setServiceWeek(getValue(row.getCell(7)));
		vo.setSubGroup(getValue(row.getCell(8)));
		SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
		if (row.getCell(9).getCellTypeEnum() == CellType.NUMERIC) {
			vo.setPriodFrom(sdf.format(row.getCell(9).getDateCellValue()));
		} else if (row.getCell(9).getCellTypeEnum() == CellType.STRING) {
			vo.setPriodFrom(getValue(row.getCell(9)));
		}
		if (row.getCell(10).getCellTypeEnum() == CellType.NUMERIC) {
			vo.setPriodTo(sdf.format(row.getCell(10).getDateCellValue()));
		} else if (row.getCell(10).getCellTypeEnum() == CellType.STRING) {
			vo.setPriodTo(getValue(row.getCell(10)));
		}

		return vo;
	}
	
	

	public String getAreaID() {
		return AreaID;
	}

	public void setAreaID(String areaID) {
		AreaID = areaID;
	}

	public String getArea() {
		return Area;
	}

	public void setArea(String area) {
		Area = area;
	}

	public String getCity() {
		return City;
	}

	public void setCity(String city) {
		City = city;
	}

	public String getPostalCode() {
		return PostalCode;
	}

	public void setPostalCode(String postalCode) {
		PostalCode = postalCode;
	}

	public String getState() {
		return State;
	}

	public void setState(String state) {
		State = state;
	}

	public String getLocalType() {
		return LocalType;
	}

	public void setLocalType(String localType) {
		LocalType = localType;
	}

	public String getServiceWeek() {
		return ServiceWeek;
	}

	public void setServiceWeek(String serviceWeek) {
		ServiceWeek = serviceWeek;
	}

	public String getSubGroup() {
		return SubGroup;
	}

	public void setSubGroup(String subGroup) {
		SubGroup = subGroup;
	}

	public String getPriodFrom() {
		return PriodFrom;
	}

	public void setPriodFrom(String priodFrom) {
		PriodFrom = priodFrom;
	}

	public String getPriodTo() {
		return PriodTo;
	}

	public void setPriodTo(String priodTo) {
		PriodTo = priodTo;
	}
	
}
