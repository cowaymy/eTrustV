package com.coway.trust.web.organization.organization.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.*;

public class CapacityExcelUploaderDataVOEnhance {
	//Enhance version used for HA excel
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
	private String morngSesionAsSt;
	private String morngSesionAsDsk;
	private String morngSesionAsSml;
	private String morngSesionInsSt;
	private String morngSesionInsDsk;
	private String morngSesionInsSml;
	private String morngSesionRtnSt;
	private String morngSesionRtnDsk;
	private String morngSesionRtnSml;
	private String aftnonSesionAsSt;
	private String aftnonSesionAsDsk;
	private String aftnonSesionAsSml;
	private String aftnonSesionInsSt;
	private String aftnonSesionInsDsk;
	private String aftnonSesionInsSml;
	private String aftnonSesionRtnSt;
	private String aftnonSesionRtnDsk;
	private String aftnonSesionRtnSml;
	private String evngSesionAsSt;
	private String evngSesionAsDsk;
	private String evngSesionAsSml;
	private String evngSesionInsSt;
	private String evngSesionInsDsk;
	private String evngSesionInsSml;
	private String evngSesionRtnSt;
	private String evngSesionRtnDsk;
	private String evngSesionRtnSml;
	private String carType;

	public static CapacityExcelUploaderDataVOEnhance create(Row row)
	{
//		try{
    		CapacityExcelUploaderDataVOEnhance vo = new CapacityExcelUploaderDataVOEnhance();

    		vo.setBranch(getValue(row.getCell(1)));
    		vo.setCT(getValue(row.getCell(2)));
    		vo.setBranch1(getValue(row.getCell(3)));
    		vo.setCT1(getValue(row.getCell(4)));

    		if(getValue(row.getCell(5)).isEmpty()){
    			vo.setCarType(getValue(row.getCell(5)));
    		}
    		else{
    			vo.setCarType(getValue(row.getCell(5)).replaceAll("\\s+",""));
    		}

    		vo.setMorngSesionAsSt(getValue(row.getCell(6)));
    		vo.setMorngSesionAsDsk(getValue(row.getCell(7)));
    		vo.setMorngSesionAsSml(getValue(row.getCell(8)));
    		vo.setMorngSesionAs(getValue(row.getCell(9)));

    		vo.setMorngSesionInsSt(getValue(row.getCell(10)));
    		vo.setMorngSesionInsDsk(getValue(row.getCell(11)));
    		vo.setMorngSesionInsSml(getValue(row.getCell(12)));
    		vo.setMorngSesionIns(getValue(row.getCell(13)));

    		vo.setMorngSesionRtnSt(getValue(row.getCell(14)));
    		vo.setMorngSesionRtnDsk(getValue(row.getCell(15)));
    		vo.setMorngSesionRtnSml(getValue(row.getCell(16)));
    		vo.setMorngSesionRtn(getValue(row.getCell(17)));

    		vo.setAftnonSesionAsSt(getValue(row.getCell(18)));
    		vo.setAftnonSesionAsDsk(getValue(row.getCell(19)));
    		vo.setAftnonSesionAsSml(getValue(row.getCell(20)));
    		vo.setAftnonSesionAs(getValue(row.getCell(21)));

    		vo.setAftnonSesionInsSt(getValue(row.getCell(22)));
    		vo.setAftnonSesionInsDsk(getValue(row.getCell(23)));
    		vo.setAftnonSesionInsSml(getValue(row.getCell(24)));
    		vo.setAftnonSesionIns(getValue(row.getCell(25)));

    		vo.setAftnonSesionRtnSt(getValue(row.getCell(26)));
    		vo.setAftnonSesionRtnDsk(getValue(row.getCell(27)));
    		vo.setAftnonSesionRtnSml(getValue(row.getCell(28)));
    		vo.setAftnonSesionRtn(getValue(row.getCell(29)));

    		vo.setEvngSesionAsSt(getValue(row.getCell(30)));
    		vo.setEvngSesionAsDsk(getValue(row.getCell(31)));
    		vo.setEvngSesionAsSml(getValue(row.getCell(32)));
    		vo.setEvngSesionAs(getValue(row.getCell(33)));

    		vo.setEvngSesionInsSt(getValue(row.getCell(34)));
    		vo.setEvngSesionInsDsk(getValue(row.getCell(35)));
    		vo.setEvngSesionInsSml(getValue(row.getCell(36)));
    		vo.setEvngSesionIns(getValue(row.getCell(37)));

    		vo.setEvngSesionRtnSt(getValue(row.getCell(38)));
    		vo.setEvngSesionRtnDsk(getValue(row.getCell(39)));
    		vo.setEvngSesionRtnSml(getValue(row.getCell(40)));
    		vo.setEvngSesionRtn(getValue(row.getCell(41)));

    		return vo;
//		}
//		catch(Exception ex){
//			Row row1 = row;
//			String exceptionMsg = ex.toString();
//			CapacityExcelUploaderDataVOEnhance vo = new CapacityExcelUploaderDataVOEnhance();
//			return vo;
//		}
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

	public String getCarType() {
		return carType;
	}

	public void setCarType(String carType1) {
		carType = carType1;
	}


	public String getMorngSesionAsSt() {
		return morngSesionAsSt;
	}


	public void setMorngSesionAsSt(String morngSesionAsSt) {
		this.morngSesionAsSt = morngSesionAsSt;
	}


	public String getMorngSesionAsDsk() {
		return morngSesionAsDsk;
	}


	public void setMorngSesionAsDsk(String morngSesionAsDsk) {
		this.morngSesionAsDsk = morngSesionAsDsk;
	}


	public String getMorngSesionAsSml() {
		return morngSesionAsSml;
	}


	public void setMorngSesionAsSml(String morngSesionAsSml) {
		this.morngSesionAsSml = morngSesionAsSml;
	}


	public String getMorngSesionInsSt() {
		return morngSesionInsSt;
	}


	public void setMorngSesionInsSt(String morngSesionInsSt) {
		this.morngSesionInsSt = morngSesionInsSt;
	}


	public String getMorngSesionInsDsk() {
		return morngSesionInsDsk;
	}


	public void setMorngSesionInsDsk(String morngSesionInsDsk) {
		this.morngSesionInsDsk = morngSesionInsDsk;
	}


	public String getMorngSesionInsSml() {
		return morngSesionInsSml;
	}


	public void setMorngSesionInsSml(String morngSesionInsSml) {
		this.morngSesionInsSml = morngSesionInsSml;
	}


	public String getMorngSesionRtnSt() {
		return morngSesionRtnSt;
	}


	public void setMorngSesionRtnSt(String morngSesionRtnSt) {
		this.morngSesionRtnSt = morngSesionRtnSt;
	}


	public String getMorngSesionRtnDsk() {
		return morngSesionRtnDsk;
	}


	public void setMorngSesionRtnDsk(String morngSesionRtnDsk) {
		this.morngSesionRtnDsk = morngSesionRtnDsk;
	}


	public String getMorngSesionRtnSml() {
		return morngSesionRtnSml;
	}


	public void setMorngSesionRtnSml(String morngSesionRtnSml) {
		this.morngSesionRtnSml = morngSesionRtnSml;
	}


	public String getAftnonSesionAsSt() {
		return aftnonSesionAsSt;
	}


	public void setAftnonSesionAsSt(String aftnonSesionAsSt) {
		this.aftnonSesionAsSt = aftnonSesionAsSt;
	}


	public String getAftnonSesionAsDsk() {
		return aftnonSesionAsDsk;
	}


	public void setAftnonSesionAsDsk(String aftnonSesionAsDsk) {
		this.aftnonSesionAsDsk = aftnonSesionAsDsk;
	}


	public String getAftnonSesionAsSml() {
		return aftnonSesionAsSml;
	}


	public void setAftnonSesionAsSml(String aftnonSesionAsSml) {
		this.aftnonSesionAsSml = aftnonSesionAsSml;
	}


	public String getAftnonSesionInsSt() {
		return aftnonSesionInsSt;
	}


	public void setAftnonSesionInsSt(String aftnonSesionInsSt) {
		this.aftnonSesionInsSt = aftnonSesionInsSt;
	}


	public String getAftnonSesionInsDsk() {
		return aftnonSesionInsDsk;
	}


	public void setAftnonSesionInsDsk(String aftnonSesionInsDsk) {
		this.aftnonSesionInsDsk = aftnonSesionInsDsk;
	}


	public String getAftnonSesionInsSml() {
		return aftnonSesionInsSml;
	}


	public void setAftnonSesionInsSml(String aftnonSesionInsSml) {
		this.aftnonSesionInsSml = aftnonSesionInsSml;
	}


	public String getAftnonSesionRtnSt() {
		return aftnonSesionRtnSt;
	}


	public void setAftnonSesionRtnSt(String aftnonSesionRtnSt) {
		this.aftnonSesionRtnSt = aftnonSesionRtnSt;
	}


	public String getAftnonSesionRtnDsk() {
		return aftnonSesionRtnDsk;
	}


	public void setAftnonSesionRtnDsk(String aftnonSesionRtnDsk) {
		this.aftnonSesionRtnDsk = aftnonSesionRtnDsk;
	}


	public String getAftnonSesionRtnSml() {
		return aftnonSesionRtnSml;
	}


	public void setAftnonSesionRtnSml(String aftnonSesionRtnSml) {
		this.aftnonSesionRtnSml = aftnonSesionRtnSml;
	}


	public String getEvngSesionAsSt() {
		return evngSesionAsSt;
	}


	public void setEvngSesionAsSt(String evngSesionAsSt) {
		this.evngSesionAsSt = evngSesionAsSt;
	}


	public String getEvngSesionAsDsk() {
		return evngSesionAsDsk;
	}


	public void setEvngSesionAsDsk(String evngSesionAsDsk) {
		this.evngSesionAsDsk = evngSesionAsDsk;
	}


	public String getEvngSesionAsSml() {
		return evngSesionAsSml;
	}


	public void setEvngSesionAsSml(String evngSesionAsSml) {
		this.evngSesionAsSml = evngSesionAsSml;
	}


	public String getEvngSesionInsSt() {
		return evngSesionInsSt;
	}


	public void setEvngSesionInsSt(String evngSesionInsSt) {
		this.evngSesionInsSt = evngSesionInsSt;
	}


	public String getEvngSesionInsDsk() {
		return evngSesionInsDsk;
	}


	public void setEvngSesionInsDsk(String evngSesionInsDsk) {
		this.evngSesionInsDsk = evngSesionInsDsk;
	}


	public String getEvngSesionInsSml() {
		return evngSesionInsSml;
	}


	public void setEvngSesionInsSml(String evngSesionInsSml) {
		this.evngSesionInsSml = evngSesionInsSml;
	}


	public String getEvngSesionRtnSt() {
		return evngSesionRtnSt;
	}


	public void setEvngSesionRtnSt(String evngSesionRtnSt) {
		this.evngSesionRtnSt = evngSesionRtnSt;
	}


	public String getEvngSesionRtnDsk() {
		return evngSesionRtnDsk;
	}


	public void setEvngSesionRtnDsk(String evngSesionRtnDsk) {
		this.evngSesionRtnDsk = evngSesionRtnDsk;
	}


	public String getEvngSesionRtnSml() {
		return evngSesionRtnSml;
	}


	public void setEvngSesionRtnSml(String evngSesionRtnSml) {
		this.evngSesionRtnSml = evngSesionRtnSml;
	}
}
