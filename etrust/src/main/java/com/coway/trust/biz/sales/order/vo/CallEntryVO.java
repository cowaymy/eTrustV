package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the CCR0006D database table.
 * 
 */
public class CallEntryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int callEntryId;

	private String callDt;

	private Date crtDt;

	private int crtUserId;

	private int docId;

	private int hapyCallerId;

	private int isWaitForCancl;

	private String oriCallDt;

	private int resultId;

	private int salesOrdId;

	private int stusCodeId;

	private int typeId;

	private Date updDt;

	private int updUserId;

	public CallEntryVO() {
	}

	public int getCallEntryId() {
		return callEntryId;
	}

	public void setCallEntryId(int callEntryId) {
		this.callEntryId = callEntryId;
	}

	public String getCallDt() {
		return callDt;
	}

	public void setCallDt(String callDt) {
		this.callDt = callDt;
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

	public int getDocId() {
		return docId;
	}

	public void setDocId(int docId) {
		this.docId = docId;
	}

	public int getHapyCallerId() {
		return hapyCallerId;
	}

	public void setHapyCallerId(int hapyCallerId) {
		this.hapyCallerId = hapyCallerId;
	}

	public int getIsWaitForCancl() {
		return isWaitForCancl;
	}

	public void setIsWaitForCancl(int isWaitForCancl) {
		this.isWaitForCancl = isWaitForCancl;
	}

	public String getOriCallDt() {
		return oriCallDt;
	}

	public void setOriCallDt(String oriCallDt) {
		this.oriCallDt = oriCallDt;
	}

	public int getResultId() {
		return resultId;
	}

	public void setResultId(int resultId) {
		this.resultId = resultId;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public int getTypeId() {
		return typeId;
	}

	public void setTypeId(int typeId) {
		this.typeId = typeId;
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