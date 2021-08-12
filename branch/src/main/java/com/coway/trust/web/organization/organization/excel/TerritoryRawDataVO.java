package com.coway.trust.web.organization.organization.excel;

import static com.coway.trust.config.excel.ExcelReadComponent.getValue;

import org.apache.poi.ss.usermodel.Row;

public class TerritoryRawDataVO {

	private String branchType;
	private String areaId;
	private String branch;
	private String extBranch;
	
	
	public static TerritoryRawDataVO create(Row row) {
		
		TerritoryRawDataVO vo = new TerritoryRawDataVO();
		vo.setAreaId(getValue(row.getCell(1)));
		vo.setBranch(getValue(row.getCell(2)));
		vo.setExtBranch(getValue(row.getCell(3)));

		return vo;
	}


	@Override
	public String toString() {
		return "TerritoryRawDataVO [branchType=" + branchType + ", areaId=" + areaId + ", branch=" + branch
				+ ", extBranch=" + extBranch + "]";
	}


	public String getBranchType() {
		return branchType;
	}


	public void setBranchType(String branchType) {
		this.branchType = branchType;
	}


	public String getAreaId() {
		return areaId;
	}


	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}


	public String getBranch() {
		return branch;
	}


	public void setBranch(String branch) {
		this.branch = branch;
	}


	public String getExtBranch() {
		return extBranch;
	}


	public void setExtBranch(String extBranch) {
		this.extBranch = extBranch;
	}
}
