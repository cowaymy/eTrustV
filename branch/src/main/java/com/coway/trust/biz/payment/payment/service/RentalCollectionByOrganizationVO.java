package com.coway.trust.biz.payment.payment.service;


public class RentalCollectionByOrganizationVO {
	private String orgCode;
	private String grpCode;
	private String deptCode;
	private String memCode;
	private String cmbInstallStatus;
	private String cmbCustTypeId;
	private String cmbAppType;


	public String getOrgCode() {
		return orgCode;
	}
	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}
	public String getGrpCode() {
		return grpCode;
	}
	public void setGrpCode(String grpCode) {
		this.grpCode = grpCode;
	}
	public String getDeptCode() {
		return deptCode;
	}
	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}
	public String getMemCode() {
		return memCode;
	}
	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}
	public String getCmbAppType() {
		return cmbAppType;
	}
	public void setCmbAppType(String cmbAppType) {
		this.cmbAppType = cmbAppType;
	}
	public String getCmbCustTypeId() {
		return cmbCustTypeId;
	}
	public void setCmbCustTypeId(String cmbCustTypeId) {
		this.cmbCustTypeId = cmbCustTypeId;
	}
	public String getCmbInstallStatus() {
		return cmbInstallStatus;
	}
	public void setCmbInstallStatus(String cmbInstallStatus) {
		this.cmbInstallStatus = cmbInstallStatus;
	}



}
