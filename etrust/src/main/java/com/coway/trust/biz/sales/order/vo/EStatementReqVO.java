package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0060D database table.
 * 
 */
public class EStatementReqVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int reqId;

	private String cnfmCode;

	private Date cnfmDt;

	private Date crtDt;

	private int crtUserId;

	private int custBillId;

	private String email;

	private String emailAdd;

	private String emailFailDesc;

	private int emailFailInd;

	private String refNo;

	private int stusCodeId;

	private Date updDt;

	private int updUserId;

	public EStatementReqVO() {
	}

	public int getReqId() {
		return reqId;
	}

	public void setReqId(int reqId) {
		this.reqId = reqId;
	}

	public String getCnfmCode() {
		return cnfmCode;
	}

	public void setCnfmCode(String cnfmCode) {
		this.cnfmCode = cnfmCode;
	}

	public Date getCnfmDt() {
		return cnfmDt;
	}

	public void setCnfmDt(Date cnfmDt) {
		this.cnfmDt = cnfmDt;
	}

	public Date getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(Date crtDt) {
		this.crtDt = crtDt;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public int getCustBillId() {
		return custBillId;
	}

	public void setCustBillId(int custBillId) {
		this.custBillId = custBillId;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getEmailAdd() {
		return emailAdd;
	}

	public void setEmailAdd(String emailAdd) {
		this.emailAdd = emailAdd;
	}

	public String getEmailFailDesc() {
		return emailFailDesc;
	}

	public void setEmailFailDesc(String emailFailDesc) {
		this.emailFailDesc = emailFailDesc;
	}

	public int getEmailFailInd() {
		return emailFailInd;
	}

	public void setEmailFailInd(int emailFailInd) {
		this.emailFailInd = emailFailInd;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public Date getUpdDt() {
		return updDt;
	}

	public void setUpdDt(Date updDt) {
		this.updDt = updDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

}