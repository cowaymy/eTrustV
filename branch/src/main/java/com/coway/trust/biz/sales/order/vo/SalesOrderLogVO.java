package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0009D database table.
 * 
 */
public class SalesOrderLogVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int logId;

	private int isLok;

	private Date logCrtDt;

	private int logCrtUserId;

	private Date logDt;

	private int prgrsId;

	private int refId;

	private int salesOrdId;

	public SalesOrderLogVO() {
	}

	public int getLogId() {
		return logId;
	}

	public void setLogId(int logId) {
		this.logId = logId;
	}

	public int getIsLok() {
		return isLok;
	}

	public void setIsLok(int isLok) {
		this.isLok = isLok;
	}

	public Date getLogCrtDt() {
		return logCrtDt;
	}

	public void setLogCrtDt(Date logCrtDt) {
		this.logCrtDt = logCrtDt;
	}

	public int getLogCrtUserId() {
		return logCrtUserId;
	}

	public void setLogCrtUserId(int logCrtUserId) {
		this.logCrtUserId = logCrtUserId;
	}

	public Date getLogDt() {
		return logDt;
	}

	public void setLogDt(Date logDt) {
		this.logDt = logDt;
	}

	public int getPrgrsId() {
		return prgrsId;
	}

	public void setPrgrsId(int prgrsId) {
		this.prgrsId = prgrsId;
	}

	public int getRefId() {
		return refId;
	}

	public void setRefId(int refId) {
		this.refId = refId;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

}