package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0042D database table.
 * 
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class GSTEURCertificateVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int eurcId;

	private Date eurcCrtDt;

	private int eurcCrtUserId;

	private int eurcCustId;

	private String eurcCustRgsNo;

	private String eurcFilePathName;

	private String eurcRefDt;

	private String eurcRefNo;

	private String eurcRem;

	private int eurcRliefAppTypeId;

	private int eurcRliefTypeId;

	private int eurcSalesOrdId;

	private int eurcStusCodeId;

	private Date eurcUpdDt;

	private int eurcUpdUserId;
	
	private int atchFileGrpId;
	
	private String existData;

	public GSTEURCertificateVO() {
	}

	public int getEurcId() {
		return eurcId;
	}

	public void setEurcId(int eurcId) {
		this.eurcId = eurcId;
	}

	public Date getEurcCrtDt() {
		return eurcCrtDt;
	}

	public void setEurcCrtDt(Date eurcCrtDt) {
		this.eurcCrtDt = eurcCrtDt;
	}

	public int getEurcCrtUserId() {
		return eurcCrtUserId;
	}

	public void setEurcCrtUserId(int eurcCrtUserId) {
		this.eurcCrtUserId = eurcCrtUserId;
	}

	public int getEurcCustId() {
		return eurcCustId;
	}

	public void setEurcCustId(int eurcCustId) {
		this.eurcCustId = eurcCustId;
	}

	public String getEurcCustRgsNo() {
		return eurcCustRgsNo;
	}

	public void setEurcCustRgsNo(String eurcCustRgsNo) {
		this.eurcCustRgsNo = eurcCustRgsNo;
	}

	public String getEurcFilePathName() {
		return eurcFilePathName;
	}

	public void setEurcFilePathName(String eurcFilePathName) {
		this.eurcFilePathName = eurcFilePathName;
	}

	public String getEurcRefDt() {
		return eurcRefDt;
	}

	public void setEurcRefDt(String eurcRefDt) {
		this.eurcRefDt = eurcRefDt;
	}

	public String getEurcRefNo() {
		return eurcRefNo;
	}

	public void setEurcRefNo(String eurcRefNo) {
		this.eurcRefNo = eurcRefNo;
	}

	public String getEurcRem() {
		return eurcRem;
	}

	public void setEurcRem(String eurcRem) {
		this.eurcRem = eurcRem;
	}

	public int getEurcRliefAppTypeId() {
		return eurcRliefAppTypeId;
	}

	public void setEurcRliefAppTypeId(int eurcRliefAppTypeId) {
		this.eurcRliefAppTypeId = eurcRliefAppTypeId;
	}

	public int getEurcRliefTypeId() {
		return eurcRliefTypeId;
	}

	public void setEurcRliefTypeId(int eurcRliefTypeId) {
		this.eurcRliefTypeId = eurcRliefTypeId;
	}

	public int getEurcSalesOrdId() {
		return eurcSalesOrdId;
	}

	public void setEurcSalesOrdId(int eurcSalesOrdId) {
		this.eurcSalesOrdId = eurcSalesOrdId;
	}

	public int getEurcStusCodeId() {
		return eurcStusCodeId;
	}

	public void setEurcStusCodeId(int eurcStusCodeId) {
		this.eurcStusCodeId = eurcStusCodeId;
	}

	public Date getEurcUpdDt() {
		return eurcUpdDt;
	}

	public void setEurcUpdDt(Date eurcUpdDt) {
		this.eurcUpdDt = eurcUpdDt;
	}

	public int getEurcUpdUserId() {
		return eurcUpdUserId;
	}

	public void setEurcUpdUserId(int eurcUpdUserId) {
		this.eurcUpdUserId = eurcUpdUserId;
	}

	public int getAtchFileGrpId() {
		return atchFileGrpId;
	}

	public void setAtchFileGrpId(int atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}

	public String getExistData() {
		return existData;
	}

	public void setExistData(String existData) {
		this.existData = existData;
	}

}