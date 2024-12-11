package com.coway.trust.biz.payment.payment.service;


public class RentalCollectionByBSSearchVO {
	private String orgCode;
	private String grpCode;
	private String deptCode;
	private String memCode;
	//Added by Kit - 2018
	private String cmbOutstandMonth;
	private String cmbCustTypeId;
	private String cmbIsPaid;
	private String cmbPaymode;
	private String cmbBsMonth;
	private String cmbDeductStus;
	//Added by LaiKW - 20200427
	private String memType;
	private String cmbSrvType;

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
	public String getCmbOutstandMonth() {
		return cmbOutstandMonth;
	}
	public void setCmbOutstandMonth(String cmbOutstandMonth) {
		this.cmbOutstandMonth = cmbOutstandMonth;
	}
	public String getCmbCustTypeId() {
		return cmbCustTypeId;
	}
	public void setCmbCustTypeId(String cmbCustTypeId) {
		this.cmbCustTypeId = cmbCustTypeId;
	}
	public String getCmbIsPaid() {
		return cmbIsPaid;
	}
	public void setCmbIsPaid(String cmbIsPaid) {
		this.cmbIsPaid = cmbIsPaid;
	}
	public String getCmbPaymode() {
		return cmbPaymode;
	}
	public void setCmbPaymode(String cmbPaymode) {
		this.cmbPaymode = cmbPaymode;
	}
	public String getCmbBsMonth() {
		return cmbBsMonth;
	}
	public void setCmbBsMonth(String cmbBsMonth) {
		this.cmbBsMonth = cmbBsMonth;
	}
	public String getCmbDeductStus() {
		return cmbDeductStus;
	}
	public void setCmbDeductStus(String cmbDeductStus) {
		this.cmbDeductStus = cmbDeductStus;
	}
	public String getMemType() {
        return memType;
    }
    public void setMemType(String memType) {
        this.memType = memType;
    }
    public String getCmbSrvType(){
    	return cmbSrvType;
    }
    public void setCmbSrvType(String cmbSrvType){
    	this.cmbSrvType = cmbSrvType;
    }
}
