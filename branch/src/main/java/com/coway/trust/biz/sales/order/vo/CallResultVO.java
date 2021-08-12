package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the CCR0007D database table.
 * 
 */
public class CallResultVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int callResultId;

	private String callActnDt;

	private Date callCrtDt;

	private int callCrtUserId;

	private int callCrtUserIdDept;

	private int callCtId;

	private String callDt;

	private int callEntryId;

	private int callFdbckId;

	private int callHcId;

	private String callRem;

	private BigDecimal callRosAmt;

	private int callSms;

	private String callSmsRem;

	private int callStusId;

	public CallResultVO() {
	}

	public int getCallResultId() {
		return callResultId;
	}

	public void setCallResultId(int callResultId) {
		this.callResultId = callResultId;
	}

	public String getCallActnDt() {
		return callActnDt;
	}

	public void setCallActnDt(String callActnDt) {
		this.callActnDt = callActnDt;
	}

	public Date getCallCrtDt() {
		return callCrtDt;
	}

	public void setCallCrtDt(Date callCrtDt) {
		this.callCrtDt = callCrtDt;
	}

	public int getCallCrtUserId() {
		return callCrtUserId;
	}

	public void setCallCrtUserId(int callCrtUserId) {
		this.callCrtUserId = callCrtUserId;
	}

	public int getCallCrtUserIdDept() {
		return callCrtUserIdDept;
	}

	public void setCallCrtUserIdDept(int callCrtUserIdDept) {
		this.callCrtUserIdDept = callCrtUserIdDept;
	}

	public int getCallCtId() {
		return callCtId;
	}

	public void setCallCtId(int callCtId) {
		this.callCtId = callCtId;
	}

	public String getCallDt() {
		return callDt;
	}

	public void setCallDt(String callDt) {
		this.callDt = callDt;
	}

	public int getCallEntryId() {
		return callEntryId;
	}

	public void setCallEntryId(int callEntryId) {
		this.callEntryId = callEntryId;
	}

	public int getCallFdbckId() {
		return callFdbckId;
	}

	public void setCallFdbckId(int callFdbckId) {
		this.callFdbckId = callFdbckId;
	}

	public int getCallHcId() {
		return callHcId;
	}

	public void setCallHcId(int callHcId) {
		this.callHcId = callHcId;
	}

	public String getCallRem() {
		return callRem;
	}

	public void setCallRem(String callRem) {
		this.callRem = callRem;
	}

	public BigDecimal getCallRosAmt() {
		return callRosAmt;
	}

	public void setCallRosAmt(BigDecimal callRosAmt) {
		this.callRosAmt = callRosAmt;
	}

	public int getCallSms() {
		return callSms;
	}

	public void setCallSms(int callSms) {
		this.callSms = callSms;
	}

	public String getCallSmsRem() {
		return callSmsRem;
	}

	public void setCallSmsRem(String callSmsRem) {
		this.callSmsRem = callSmsRem;
	}

	public int getCallStusId() {
		return callStusId;
	}

	public void setCallStusId(int callStusId) {
		this.callStusId = callStusId;
	}

}