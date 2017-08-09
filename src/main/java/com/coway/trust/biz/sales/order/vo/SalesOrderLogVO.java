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

	private long logId;

	private BigDecimal isLok;

	private Date logCrtDt;

	private BigDecimal logCrtUserId;

	private Date logDt;

	private BigDecimal prgrsId;

	private BigDecimal refId;

	private BigDecimal salesOrdId;

	public SalesOrderLogVO() {
	}

	public long getLogId() {
		return this.logId;
	}

	public void setLogId(long logId) {
		this.logId = logId;
	}

	public BigDecimal getIsLok() {
		return this.isLok;
	}

	public void setIsLok(BigDecimal isLok) {
		this.isLok = isLok;
	}

	public Date getLogCrtDt() {
		return this.logCrtDt;
	}

	public void setLogCrtDt(Date logCrtDt) {
		this.logCrtDt = logCrtDt;
	}

	public BigDecimal getLogCrtUserId() {
		return this.logCrtUserId;
	}

	public void setLogCrtUserId(BigDecimal logCrtUserId) {
		this.logCrtUserId = logCrtUserId;
	}

	public Date getLogDt() {
		return this.logDt;
	}

	public void setLogDt(Date logDt) {
		this.logDt = logDt;
	}

	public BigDecimal getPrgrsId() {
		return this.prgrsId;
	}

	public void setPrgrsId(BigDecimal prgrsId) {
		this.prgrsId = prgrsId;
	}

	public BigDecimal getRefId() {
		return this.refId;
	}

	public void setRefId(BigDecimal refId) {
		this.refId = refId;
	}

	public BigDecimal getSalesOrdId() {
		return this.salesOrdId;
	}

	public void setSalesOrdId(BigDecimal salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

}