package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the CCR0006D database table.
 * 
 */
public class CallEntryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long callEntryId;

	private Date callDt;

	private Date crtDt;

	private BigDecimal crtUserId;

	private BigDecimal docId;

	private BigDecimal hapyCallerId;

	private BigDecimal isWaitForCancl;

	private String oriCallDt;

	private BigDecimal resultId;

	private BigDecimal salesOrdId;

	private BigDecimal stusCodeId;

	private BigDecimal typeId;

	private Date updDt;

	private BigDecimal updUserId;

	public CallEntryVO() {
	}

	public long getCallEntryId() {
		return this.callEntryId;
	}

	public void setCallEntryId(long callEntryId) {
		this.callEntryId = callEntryId;
	}

	public Date getCallDt() {
		return this.callDt;
	}

	public void setCallDt(Date callDt) {
		this.callDt = callDt;
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

	public BigDecimal getDocId() {
		return this.docId;
	}

	public void setDocId(BigDecimal docId) {
		this.docId = docId;
	}

	public BigDecimal getHapyCallerId() {
		return this.hapyCallerId;
	}

	public void setHapyCallerId(BigDecimal hapyCallerId) {
		this.hapyCallerId = hapyCallerId;
	}

	public BigDecimal getIsWaitForCancl() {
		return this.isWaitForCancl;
	}

	public void setIsWaitForCancl(BigDecimal isWaitForCancl) {
		this.isWaitForCancl = isWaitForCancl;
	}

	public String getOriCallDt() {
		return this.oriCallDt;
	}

	public void setOriCallDt(String oriCallDt) {
		this.oriCallDt = oriCallDt;
	}

	public BigDecimal getResultId() {
		return this.resultId;
	}

	public void setResultId(BigDecimal resultId) {
		this.resultId = resultId;
	}

	public BigDecimal getSalesOrdId() {
		return this.salesOrdId;
	}

	public void setSalesOrdId(BigDecimal salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public BigDecimal getStusCodeId() {
		return this.stusCodeId;
	}

	public void setStusCodeId(BigDecimal stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public BigDecimal getTypeId() {
		return this.typeId;
	}

	public void setTypeId(BigDecimal typeId) {
		this.typeId = typeId;
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