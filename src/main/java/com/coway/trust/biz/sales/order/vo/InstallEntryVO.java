package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0046D database table.
 * 
 */
public class InstallEntryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long installEntryId;

	private BigDecimal allowComm;

	private BigDecimal callEntryId;

	private Date crtDt;

	private BigDecimal crtUserId;

	private String ctGrp;

	private BigDecimal ctId;

	private Date installDt;

	private String installEntryNo;

	private BigDecimal installResultId;

	private BigDecimal installStkId;

	private BigDecimal isTradeIn;

	private BigDecimal revId;

	private BigDecimal salesOrdId;

	private BigDecimal stusCodeId;

	private Date updDt;

	private BigDecimal updUserId;

	public InstallEntryVO() {
	}

	public long getInstallEntryId() {
		return this.installEntryId;
	}

	public void setInstallEntryId(long installEntryId) {
		this.installEntryId = installEntryId;
	}

	public BigDecimal getAllowComm() {
		return this.allowComm;
	}

	public void setAllowComm(BigDecimal allowComm) {
		this.allowComm = allowComm;
	}

	public BigDecimal getCallEntryId() {
		return this.callEntryId;
	}

	public void setCallEntryId(BigDecimal callEntryId) {
		this.callEntryId = callEntryId;
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

	public String getCtGrp() {
		return this.ctGrp;
	}

	public void setCtGrp(String ctGrp) {
		this.ctGrp = ctGrp;
	}

	public BigDecimal getCtId() {
		return this.ctId;
	}

	public void setCtId(BigDecimal ctId) {
		this.ctId = ctId;
	}

	public Date getInstallDt() {
		return this.installDt;
	}

	public void setInstallDt(Date installDt) {
		this.installDt = installDt;
	}

	public String getInstallEntryNo() {
		return this.installEntryNo;
	}

	public void setInstallEntryNo(String installEntryNo) {
		this.installEntryNo = installEntryNo;
	}

	public BigDecimal getInstallResultId() {
		return this.installResultId;
	}

	public void setInstallResultId(BigDecimal installResultId) {
		this.installResultId = installResultId;
	}

	public BigDecimal getInstallStkId() {
		return this.installStkId;
	}

	public void setInstallStkId(BigDecimal installStkId) {
		this.installStkId = installStkId;
	}

	public BigDecimal getIsTradeIn() {
		return this.isTradeIn;
	}

	public void setIsTradeIn(BigDecimal isTradeIn) {
		this.isTradeIn = isTradeIn;
	}

	public BigDecimal getRevId() {
		return this.revId;
	}

	public void setRevId(BigDecimal revId) {
		this.revId = revId;
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