package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0042D database table.
 * 
 */
public class GSTEURCertificateVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long eurcId;

	private Date eurcCrtDt;

	private BigDecimal eurcCrtUserId;

	private BigDecimal eurcCustId;

	private String eurcCustRgsNo;

	private String eurcFilePathName;

	private String eurcRefDt;

	private String eurcRefNo;

	private String eurcRem;

	private BigDecimal eurcRliefAppTypeId;

	private BigDecimal eurcRliefTypeId;

	private BigDecimal eurcSalesOrdId;

	private BigDecimal eurcStusCodeId;

	private Date eurcUpdDt;

	private BigDecimal eurcUpdUserId;

	public GSTEURCertificateVO() {
	}

	public long getEurcId() {
		return this.eurcId;
	}

	public void setEurcId(long eurcId) {
		this.eurcId = eurcId;
	}

	public Date getEurcCrtDt() {
		return this.eurcCrtDt;
	}

	public void setEurcCrtDt(Date eurcCrtDt) {
		this.eurcCrtDt = eurcCrtDt;
	}

	public BigDecimal getEurcCrtUserId() {
		return this.eurcCrtUserId;
	}

	public void setEurcCrtUserId(BigDecimal eurcCrtUserId) {
		this.eurcCrtUserId = eurcCrtUserId;
	}

	public BigDecimal getEurcCustId() {
		return this.eurcCustId;
	}

	public void setEurcCustId(BigDecimal eurcCustId) {
		this.eurcCustId = eurcCustId;
	}

	public String getEurcCustRgsNo() {
		return this.eurcCustRgsNo;
	}

	public void setEurcCustRgsNo(String eurcCustRgsNo) {
		this.eurcCustRgsNo = eurcCustRgsNo;
	}

	public String getEurcFilePathName() {
		return this.eurcFilePathName;
	}

	public void setEurcFilePathName(String eurcFilePathName) {
		this.eurcFilePathName = eurcFilePathName;
	}

	public String getEurcRefDt() {
		return this.eurcRefDt;
	}

	public void setEurcRefDt(String eurcRefDt) {
		this.eurcRefDt = eurcRefDt;
	}

	public String getEurcRefNo() {
		return this.eurcRefNo;
	}

	public void setEurcRefNo(String eurcRefNo) {
		this.eurcRefNo = eurcRefNo;
	}

	public String getEurcRem() {
		return this.eurcRem;
	}

	public void setEurcRem(String eurcRem) {
		this.eurcRem = eurcRem;
	}

	public BigDecimal getEurcRliefAppTypeId() {
		return this.eurcRliefAppTypeId;
	}

	public void setEurcRliefAppTypeId(BigDecimal eurcRliefAppTypeId) {
		this.eurcRliefAppTypeId = eurcRliefAppTypeId;
	}

	public BigDecimal getEurcRliefTypeId() {
		return this.eurcRliefTypeId;
	}

	public void setEurcRliefTypeId(BigDecimal eurcRliefTypeId) {
		this.eurcRliefTypeId = eurcRliefTypeId;
	}

	public BigDecimal getEurcSalesOrdId() {
		return this.eurcSalesOrdId;
	}

	public void setEurcSalesOrdId(BigDecimal eurcSalesOrdId) {
		this.eurcSalesOrdId = eurcSalesOrdId;
	}

	public BigDecimal getEurcStusCodeId() {
		return this.eurcStusCodeId;
	}

	public void setEurcStusCodeId(BigDecimal eurcStusCodeId) {
		this.eurcStusCodeId = eurcStusCodeId;
	}

	public Date getEurcUpdDt() {
		return this.eurcUpdDt;
	}

	public void setEurcUpdDt(Date eurcUpdDt) {
		this.eurcUpdDt = eurcUpdDt;
	}

	public BigDecimal getEurcUpdUserId() {
		return this.eurcUpdUserId;
	}

	public void setEurcUpdUserId(BigDecimal eurcUpdUserId) {
		this.eurcUpdUserId = eurcUpdUserId;
	}

}