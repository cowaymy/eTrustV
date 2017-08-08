package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the CCR0007D database table.
 * 
 */
public class CallResultVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long callResultId;

	private Date callActnDt;

	private Date callCrtDt;

	private BigDecimal callCrtUserId;

	private BigDecimal callCrtUserIdDept;

	private BigDecimal callCtId;

	private Date callDt;

	private BigDecimal callEntryId;

	private BigDecimal callFdbckId;

	private BigDecimal callHcId;

	private String callRem;

	private BigDecimal callRosAmt;

	private BigDecimal callSms;

	private String callSmsRem;

	private BigDecimal callStusId;

	public CallResultVO() {
	}

	public long getCallResultId() {
		return this.callResultId;
	}

	public void setCallResultId(long callResultId) {
		this.callResultId = callResultId;
	}

	public Date getCallActnDt() {
		return this.callActnDt;
	}

	public void setCallActnDt(Date callActnDt) {
		this.callActnDt = callActnDt;
	}

	public Date getCallCrtDt() {
		return this.callCrtDt;
	}

	public void setCallCrtDt(Date callCrtDt) {
		this.callCrtDt = callCrtDt;
	}

	public BigDecimal getCallCrtUserId() {
		return this.callCrtUserId;
	}

	public void setCallCrtUserId(BigDecimal callCrtUserId) {
		this.callCrtUserId = callCrtUserId;
	}

	public BigDecimal getCallCrtUserIdDept() {
		return this.callCrtUserIdDept;
	}

	public void setCallCrtUserIdDept(BigDecimal callCrtUserIdDept) {
		this.callCrtUserIdDept = callCrtUserIdDept;
	}

	public BigDecimal getCallCtId() {
		return this.callCtId;
	}

	public void setCallCtId(BigDecimal callCtId) {
		this.callCtId = callCtId;
	}

	public Date getCallDt() {
		return this.callDt;
	}

	public void setCallDt(Date callDt) {
		this.callDt = callDt;
	}

	public BigDecimal getCallEntryId() {
		return this.callEntryId;
	}

	public void setCallEntryId(BigDecimal callEntryId) {
		this.callEntryId = callEntryId;
	}

	public BigDecimal getCallFdbckId() {
		return this.callFdbckId;
	}

	public void setCallFdbckId(BigDecimal callFdbckId) {
		this.callFdbckId = callFdbckId;
	}

	public BigDecimal getCallHcId() {
		return this.callHcId;
	}

	public void setCallHcId(BigDecimal callHcId) {
		this.callHcId = callHcId;
	}

	public String getCallRem() {
		return this.callRem;
	}

	public void setCallRem(String callRem) {
		this.callRem = callRem;
	}

	public BigDecimal getCallRosAmt() {
		return this.callRosAmt;
	}

	public void setCallRosAmt(BigDecimal callRosAmt) {
		this.callRosAmt = callRosAmt;
	}

	public BigDecimal getCallSms() {
		return this.callSms;
	}

	public void setCallSms(BigDecimal callSms) {
		this.callSms = callSms;
	}

	public String getCallSmsRem() {
		return this.callSmsRem;
	}

	public void setCallSmsRem(String callSmsRem) {
		this.callSmsRem = callSmsRem;
	}

	public BigDecimal getCallStusId() {
		return this.callStusId;
	}

	public void setCallStusId(BigDecimal callStusId) {
		this.callStusId = callStusId;
	}

}