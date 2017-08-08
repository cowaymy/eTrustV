package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0060D database table.
 * 
 */
public class EStatementReqVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long reqId;

	private String cnfmCode;

	private Date cnfmDt;

	private Date crtDt;

	private BigDecimal crtUserId;

	private BigDecimal custBillId;

	private String email;

	private String emailAdd;

	private String emailFailDesc;

	private BigDecimal emailFailInd;

	private String refNo;

	private BigDecimal stusCodeId;

	private Date updDt;

	private BigDecimal updUserId;

	public EStatementReqVO() {
	}

	public long getReqId() {
		return this.reqId;
	}

	public void setReqId(long reqId) {
		this.reqId = reqId;
	}

	public String getCnfmCode() {
		return this.cnfmCode;
	}

	public void setCnfmCode(String cnfmCode) {
		this.cnfmCode = cnfmCode;
	}

	public Date getCnfmDt() {
		return this.cnfmDt;
	}

	public void setCnfmDt(Date cnfmDt) {
		this.cnfmDt = cnfmDt;
	}

	public Date getCrtDt() {
		return this.crtDt;
	}

	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}

	public BigDecimal getCrtUserId() {
		return this.crtUserId;
	}

	public void setCrtUserId(BigDecimal crtUserId) {
		this.crtUserId = crtUserId;
	}

	public BigDecimal getCustBillId() {
		return this.custBillId;
	}

	public void setCustBillId(BigDecimal custBillId) {
		this.custBillId = custBillId;
	}

	public String getEmail() {
		return this.email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEmailAdd() {
		return this.emailAdd;
	}

	public void setEmailAdd(String emailAdd) {
		this.emailAdd = emailAdd;
	}

	public String getEmailFailDesc() {
		return this.emailFailDesc;
	}

	public void setEmailFailDesc(String emailFailDesc) {
		this.emailFailDesc = emailFailDesc;
	}

	public BigDecimal getEmailFailInd() {
		return this.emailFailInd;
	}

	public void setEmailFailInd(BigDecimal emailFailInd) {
		this.emailFailInd = emailFailInd;
	}

	public String getRefNo() {
		return this.refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public BigDecimal getStusCodeId() {
		return this.stusCodeId;
	}

	public void setStusCodeId(BigDecimal stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public Date getUpdDt() {
		return this.updDt;
	}

	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}

	public BigDecimal getUpdUserId() {
		return this.updUserId;
	}

	public void setUpdUserId(BigDecimal updUserId) {
		this.updUserId = updUserId;
	}

}