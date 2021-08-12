package com.coway.trust.web.organization.organization.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.*;

public class CapacityExcelUploaderDataVO {

	// 각 변수는 타입에 맞게 선언해 주세요~~~ ^^

	private String Branch;
	private String CT;
	private String Branch1;
	private String CT1;
	private String morngSesionAs;
	private String morngSesionIns;
	private String morngSesionRtn;
	private String aftnonSesionAs;
	private String aftnonSesionIns;
	private String aftnonSesionRtn;
	private String evngSesionAs;
	private String evngSesionIns;
	private String evngSesionRtn;
	
	public static CapacityExcelUploaderDataVO create(Row row) 
	{
		CapacityExcelUploaderDataVO vo = new CapacityExcelUploaderDataVO();

		vo.setBranch(getValue(row.getCell(1)));
		vo.setCT(getValue(row.getCell(2)));
		vo.setBranch1(getValue(row.getCell(3)));
		vo.setCT1(getValue(row.getCell(4)));
		vo.setMorngSesionAs(getValue(row.getCell(5)));
		vo.setMorngSesionIns(getValue(row.getCell(6)));
		vo.setMorngSesionRtn(getValue(row.getCell(7)));
		vo.setAftnonSesionAs(getValue(row.getCell(8)));
		vo.setAftnonSesionIns(getValue(row.getCell(9)));
		vo.setAftnonSesionRtn(getValue(row.getCell(10)));
		vo.setEvngSesionAs(getValue(row.getCell(11)));
		vo.setEvngSesionIns(getValue(row.getCell(12)));
		vo.setEvngSesionRtn(getValue(row.getCell(13)));
		
		return vo;
	}
	

	public String getBranch() {
		return Branch;
	}

	public void setBranch(String branch) {
		Branch = branch;
	}

	public String getCT() {
		return CT;
	}

	public void setCT(String cT) {
		CT = cT;
	}

	public String getBranch1() {
		return Branch1;
	}

	public void setBranch1(String branch1) {
		Branch1 = branch1;
	}

	public String getCT1() {
		return CT1;
	}

	public void setCT1(String cT1) {
		CT1 = cT1;
	}

	public String getMorngSesionAs() {
		return morngSesionAs;
	}

	public void setMorngSesionAs(String morngSesionAs) {
		this.morngSesionAs = morngSesionAs;
	}

	public String getMorngSesionIns() {
		return morngSesionIns;
	}

	public void setMorngSesionIns(String morngSesionIns) {
		this.morngSesionIns = morngSesionIns;
	}

	public String getMorngSesionRtn() {
		return morngSesionRtn;
	}

	public void setMorngSesionRtn(String morngSesionRtn) {
		this.morngSesionRtn = morngSesionRtn;
	}

	public String getAftnonSesionAs() {
		return aftnonSesionAs;
	}

	public void setAftnonSesionAs(String aftnonSesionAs) {
		this.aftnonSesionAs = aftnonSesionAs;
	}

	public String getAftnonSesionIns() {
		return aftnonSesionIns;
	}

	public void setAftnonSesionIns(String aftnonSesionIns) {
		this.aftnonSesionIns = aftnonSesionIns;
	}

	public String getAftnonSesionRtn() {
		return aftnonSesionRtn;
	}

	public void setAftnonSesionRtn(String aftnonSesionRtn) {
		this.aftnonSesionRtn = aftnonSesionRtn;
	}

	public String getEvngSesionAs() {
		return evngSesionAs;
	}

	public void setEvngSesionAs(String evngSesionAs) {
		this.evngSesionAs = evngSesionAs;
	}

	public String getEvngSesionIns() {
		return evngSesionIns;
	}

	public void setEvngSesionIns(String evngSesionIns) {
		this.evngSesionIns = evngSesionIns;
	}

	public String getEvngSesionRtn() {
		return evngSesionRtn;
	}

	public void setEvngSesionRtn(String evngSesionRtn) {
		this.evngSesionRtn = evngSesionRtn;
	}
	
}
