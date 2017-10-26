package com.coway.trust.web.scm.excel;

import org.apache.poi.ss.usermodel.Row;

public class BizPlanExcelUploaderDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^

	private String TEAM;
	private double  YYYY;
	private String  Version;
	private double  M01;
	private double  M02;
	private double  M03;
	private double  M04;
	private double  M05;
	private double  M06;
	private double  M07;
	private double  M08;
	private double  M09;
	private double  M10;
	private double  M11;
	private double  M12;
	private double  YearTotal;
	private double  PlanID;
	private String STOCK_CODE;

	public static BizPlanExcelUploaderDataVO create(Row row) 
	{
		BizPlanExcelUploaderDataVO vo = new BizPlanExcelUploaderDataVO();
		
		vo.setTEAM(row.getCell(0).getStringCellValue());
		vo.setYYYY(row.getCell(1).getNumericCellValue());
		vo.setVersion(row.getCell(2).getStringCellValue());
		vo.setM01(row.getCell(3).getNumericCellValue());
		vo.setM02(row.getCell(4).getNumericCellValue());
		vo.setM03(row.getCell(5).getNumericCellValue());
		vo.setM04(row.getCell(6).getNumericCellValue());
		vo.setM05(row.getCell(7).getNumericCellValue());
		vo.setM06(row.getCell(8).getNumericCellValue());
		vo.setM07(row.getCell(9).getNumericCellValue());
		vo.setM08(row.getCell(10).getNumericCellValue());
		vo.setM09(row.getCell(11).getNumericCellValue());
		vo.setM10(row.getCell(12).getNumericCellValue());
		vo.setM11(row.getCell(13).getNumericCellValue());
		vo.setM12(row.getCell(14).getNumericCellValue());
		vo.setYearTotal(row.getCell(15).getNumericCellValue());
		vo.setPlanID(row.getCell(16).getNumericCellValue());
		vo.setSTOCK_CODE(row.getCell(17).getStringCellValue());

		//  나머지 컬럼들을 세팅해 줘야 합니다~~  ^^....

		return vo;
	}

	public String getTEAM() {
		return TEAM;
	}

	public void setTEAM(String tEAM) {
		TEAM = tEAM;
	}

	public double getYYYY() {
		return YYYY;
	}

	public void setYYYY(double yYYY) {
		YYYY = yYYY;
	}

	public String getVersion() {
		return Version;
	}

	public void setVersion(String version) {
		Version = version;
	}

	public double getM01() {
		return M01;
	}

	public void setM01(double m01) {
		M01 = m01;
	}

	public double getM02() {
		return M02;
	}

	public void setM02(double m02) {
		M02 = m02;
	}

	public double getM03() {
		return M03;
	}

	public void setM03(double m03) {
		M03 = m03;
	}

	public double getM04() {
		return M04;
	}

	public void setM04(double m04) {
		M04 = m04;
	}

	public double getM05() {
		return M05;
	}

	public void setM05(double m05) {
		M05 = m05;
	}

	public double getM06() {
		return M06;
	}

	public void setM06(double m06) {
		M06 = m06;
	}

	public double getM07() {
		return M07;
	}

	public void setM07(double m07) {
		M07 = m07;
	}

	public double getM08() {
		return M08;
	}

	public void setM08(double m08) {
		M08 = m08;
	}

	public double getM09() {
		return M09;
	}

	public void setM09(double m09) {
		M09 = m09;
	}

	public double getM10() {
		return M10;
	}

	public void setM10(double m10) {
		M10 = m10;
	}

	public double getM11() {
		return M11;
	}

	public void setM11(double m11) {
		M11 = m11;
	}

	public double getM12() {
		return M12;
	}

	public void setM12(double m12) {
		M12 = m12;
	}

	public double getYearTotal() {
		return YearTotal;
	}

	public void setYearTotal(double yearTotal) {
		YearTotal = yearTotal;
	}

	public double getPlanID() {
		return PlanID;
	}

	public void setPlanID(double planID) {
		PlanID = planID;
	}


	public String getSTOCK_CODE() {
		return STOCK_CODE;
	}

	public void setSTOCK_CODE(String sTOCK_CODE) {
		STOCK_CODE = sTOCK_CODE;
	}	
	
}
