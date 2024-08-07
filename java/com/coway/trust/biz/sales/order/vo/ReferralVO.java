package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0074D database table.
 * 
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class ReferralVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int ordRefId;
	
	private int salesOrdId;
	
	private String salesOrdNo;
	
	private String refName;
	
	private String refCntc;
	
	private int refStateId;
	
	private String refRem;
	
	private String crtDt;
	
	private int crtUserId;
	
	private int stusCode;
	
	private Date nwKeyinDt;
	
	private String currOrdNo;
	
	private int pvMonth;
	
	private int pvYear;

	public int getOrdRefId() {
		return ordRefId;
	}

	public void setOrdRefId(int ordRefId) {
		this.ordRefId = ordRefId;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getRefName() {
		return refName;
	}

	public void setRefName(String refName) {
		this.refName = refName;
	}

	public String getRefCntc() {
		return refCntc;
	}

	public void setRefCntc(String refCntc) {
		this.refCntc = refCntc;
	}

	public int getRefStateId() {
		return refStateId;
	}

	public void setRefStateId(int refStateId) {
		this.refStateId = refStateId;
	}

	public String getRefRem() {
		return refRem;
	}

	public void setRefRem(String refRem) {
		this.refRem = refRem;
	}

	public String getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(String crtDt) {
		this.crtDt = crtDt;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public int getStusCode() {
		return stusCode;
	}

	public void setStusCode(int stusCode) {
		this.stusCode = stusCode;
	}

	public Date getNwKeyinDt() {
		return nwKeyinDt;
	}

	public void setNwKeyinDt(Date nwKeyinDt) {
		this.nwKeyinDt = nwKeyinDt;
	}

	public String getCurrOrdNo() {
		return currOrdNo;
	}

	public void setCurrOrdNo(String currOrdNo) {
		this.currOrdNo = currOrdNo;
	}

	public int getPvMonth() {
		return pvMonth;
	}

	public void setPvMonth(int pvMonth) {
		this.pvMonth = pvMonth;
	}

	public int getPvYear() {
		return pvYear;
	}

	public void setPvYear(int pvYear) {
		this.pvYear = pvYear;
	}
	
}