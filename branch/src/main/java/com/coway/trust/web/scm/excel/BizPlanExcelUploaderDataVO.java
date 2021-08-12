package com.coway.trust.web.scm.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.Row;

public class BizPlanExcelUploaderDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^

	private String TEAM;
	private String YYYY;
	private String Version;
	private String M01;
	private String M02;
	private String M03;
	private String M04;
	private String M05;
	private String M06;
	private String M07;
	private String M08;
	private String M09;
	private String M10;
	private String M11;
	private String M12;
	private String YearTotal;
	private String PlanID;
	private String STOCK_CODE;

	public static BizPlanExcelUploaderDataVO create(Row row) 
	{
		BizPlanExcelUploaderDataVO vo = new BizPlanExcelUploaderDataVO();

		vo.setTEAM(getValue(row.getCell(0)));
		vo.setYYYY(getValue(row.getCell(1)));
		vo.setVersion(getValue(row.getCell(2)));
		vo.setM01(getValue(row.getCell(3)));
		vo.setM02(getValue(row.getCell(4)));
		vo.setM03(getValue(row.getCell(5)));
		vo.setM04(getValue(row.getCell(6)));
		vo.setM05(getValue(row.getCell(7)));
		vo.setM06(getValue(row.getCell(8)));
		vo.setM07(getValue(row.getCell(9)));
		vo.setM08(getValue(row.getCell(10)));
		vo.setM09(getValue(row.getCell(11)));
		vo.setM10(getValue(row.getCell(12)));
		vo.setM11(getValue(row.getCell(13)));
		vo.setM12(getValue(row.getCell(14)));
		vo.setYearTotal(getValue(row.getCell(15)));
		vo.setPlanID(getValue(row.getCell(16)));
		vo.setSTOCK_CODE(getValue(row.getCell(17)));

		return vo;
	}
	
	

	public String getTEAM() {
		return TEAM;
	}

	public void setTEAM(String tEAM) {
		TEAM = tEAM;
	}

	public String getYYYY() {
		return YYYY;
	}

	public void setYYYY(String yYYY) {
		YYYY = yYYY;
	}

	public String getVersion() {
		return Version;
	}

	public void setVersion(String version) {
		Version = version;
	}

	public String getM01() {
		return M01;
	}

	public void setM01(String m01) {
		M01 = m01;
	}

	public String getM02() {
		return M02;
	}

	public void setM02(String m02) {
		M02 = m02;
	}

	public String getM03() {
		return M03;
	}

	public void setM03(String m03) {
		M03 = m03;
	}

	public String getM04() {
		return M04;
	}

	public void setM04(String m04) {
		M04 = m04;
	}

	public String getM05() {
		return M05;
	}

	public void setM05(String m05) {
		M05 = m05;
	}

	public String getM06() {
		return M06;
	}

	public void setM06(String m06) {
		M06 = m06;
	}

	public String getM07() {
		return M07;
	}

	public void setM07(String m07) {
		M07 = m07;
	}

	public String getM08() {
		return M08;
	}

	public void setM08(String m08) {
		M08 = m08;
	}

	public String getM09() {
		return M09;
	}

	public void setM09(String m09) {
		M09 = m09;
	}

	public String getM10() {
		return M10;
	}

	public void setM10(String m10) {
		M10 = m10;
	}

	public String getM11() {
		return M11;
	}

	public void setM11(String m11) {
		M11 = m11;
	}

	public String getM12() {
		return M12;
	}

	public void setM12(String m12) {
		M12 = m12;
	}

	public String getYearTotal() {
		return YearTotal;
	}

	public void setYearTotal(String yearTotal) {
		YearTotal = yearTotal;
	}

	public String getPlanID() {
		return PlanID;
	}

	public void setPlanID(String planID) {
		PlanID = planID;
	}

	public String getSTOCK_CODE() {
		return STOCK_CODE;
	}

	public void setSTOCK_CODE(String sTOCK_CODE) {
		STOCK_CODE = sTOCK_CODE;
	}

}
