package com.coway.trust.web.services.servicePlanning.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.Row;
import org.apache.velocity.runtime.directive.Parse;

public class CTSubGroupExcelUploaderDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^

	private String DSC;
	private String CTM;
	private String CT;
	private String memId;
	private String CTSubGroup;
	private String ACSubGroup;

	public static CTSubGroupExcelUploaderDataVO create(Row row)
	{
		CTSubGroupExcelUploaderDataVO vo = new CTSubGroupExcelUploaderDataVO();

		vo.setDSC(getValue(row.getCell(1)));
		vo.setCTM(getValue(row.getCell(2)));
		vo.setCT(getValue(row.getCell(3)));
		vo.setMemId(getValue(row.getCell(4)));
		vo.setCTSubGroup(getValue(row.getCell(5)));
		vo.setACSubGroup(getValue(row.getCell(7)));

		return vo;
	}

	public String getDSC() {
		return DSC;
	}

	public void setDSC(String dSC) {
		DSC = dSC;
	}

	public String getCTM() {
		return CTM;
	}

	public void setCTM(String cTM) {
		CTM = cTM;
	}

	public String getCT() {
		return CT;
	}

	public void setCT(String cT) {
		CT = cT;
	}

	public String getCTSubGroup() {
		return CTSubGroup;
	}

	public void setCTSubGroup(String cTSubGroup) {
		CTSubGroup = cTSubGroup;
	}

	public String getACSubGroup() {
		return ACSubGroup;
	}

	public void setACSubGroup(String aCSubGroup) {
		ACSubGroup = aCSubGroup;
	}

	public String getMemId() {
		return memId;
	}

	public void setMemId(String memId) {
		this.memId = memId;
	}


}
