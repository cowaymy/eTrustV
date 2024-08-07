package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the PAY0054D database table.
 * 
 */
public class DiscountEntryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int dscntEntryId;
	
	private int ordId;
	
	private int dcType;
	
	private BigDecimal dcAmtPerInstlmt;
	
	private int dcStartInstlmt;
	
	private int dcEndInstlmt;
	
	private String rem;
	
	private String crtDt;
	
	private int crtUserId;
	
	private String updDt;
	
	private int updUserId;
	
	private int dcStusId;
	
	private int cntrctId;

	public int getDscntEntryId() {
		return dscntEntryId;
	}

	public void setDscntEntryId(int dscntEntryId) {
		this.dscntEntryId = dscntEntryId;
	}

	public int getOrdId() {
		return ordId;
	}

	public void setOrdId(int ordId) {
		this.ordId = ordId;
	}

	public int getDcType() {
		return dcType;
	}

	public void setDcType(int dcType) {
		this.dcType = dcType;
	}

	public BigDecimal getDcAmtPerInstlmt() {
		return dcAmtPerInstlmt;
	}

	public void setDcAmtPerInstlmt(BigDecimal dcAmtPerInstlmt) {
		this.dcAmtPerInstlmt = dcAmtPerInstlmt;
	}

	public int getDcStartInstlmt() {
		return dcStartInstlmt;
	}

	public void setDcStartInstlmt(int dcStartInstlmt) {
		this.dcStartInstlmt = dcStartInstlmt;
	}

	public int getDcEndInstlmt() {
		return dcEndInstlmt;
	}

	public void setDcEndInstlmt(int dcEndInstlmt) {
		this.dcEndInstlmt = dcEndInstlmt;
	}

	public String getRem() {
		return rem;
	}

	public void setRem(String rem) {
		this.rem = rem;
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

	public String getUpdDt() {
		return updDt;
	}

	public void setUpdDt(String updDt) {
		this.updDt = updDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

	public int getDcStusId() {
		return dcStusId;
	}

	public void setDcStusId(int dcStusId) {
		this.dcStusId = dcStusId;
	}

	public int getCntrctId() {
		return cntrctId;
	}

	public void setCntrctId(int cntrctId) {
		this.cntrctId = cntrctId;
	}
		
}