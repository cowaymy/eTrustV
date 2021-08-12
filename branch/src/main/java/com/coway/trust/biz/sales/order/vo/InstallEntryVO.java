package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0046D database table.
 * 
 */
public class InstallEntryVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private int installEntryId;

	private int allowComm;

	private int callEntryId;

	private Date crtDt;

	private int crtUserId;

	private String ctGrp;

	private int ctId;

	private String installDt;

	private String installEntryNo;

	private int installResultId;

	private int installStkId;

	private int isTradeIn;

	private int revId;

	private int salesOrdId;

	private int stusCodeId;

	private Date updDt;

	private int updUserId;

	public InstallEntryVO() {
	}

	public int getInstallEntryId() {
		return installEntryId;
	}

	public void setInstallEntryId(int installEntryId) {
		this.installEntryId = installEntryId;
	}

	public int getAllowComm() {
		return allowComm;
	}

	public void setAllowComm(int allowComm) {
		this.allowComm = allowComm;
	}

	public int getCallEntryId() {
		return callEntryId;
	}

	public void setCallEntryId(int callEntryId) {
		this.callEntryId = callEntryId;
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

	public String getCtGrp() {
		return ctGrp;
	}

	public void setCtGrp(String ctGrp) {
		this.ctGrp = ctGrp;
	}

	public int getCtId() {
		return ctId;
	}

	public void setCtId(int ctId) {
		this.ctId = ctId;
	}

	public String getInstallDt() {
		return installDt;
	}

	public void setInstallDt(String installDt) {
		this.installDt = installDt;
	}

	public String getInstallEntryNo() {
		return installEntryNo;
	}

	public void setInstallEntryNo(String installEntryNo) {
		this.installEntryNo = installEntryNo;
	}

	public int getInstallResultId() {
		return installResultId;
	}

	public void setInstallResultId(int installResultId) {
		this.installResultId = installResultId;
	}

	public int getInstallStkId() {
		return installStkId;
	}

	public void setInstallStkId(int installStkId) {
		this.installStkId = installStkId;
	}

	public int getIsTradeIn() {
		return isTradeIn;
	}

	public void setIsTradeIn(int isTradeIn) {
		this.isTradeIn = isTradeIn;
	}

	public int getRevId() {
		return revId;
	}

	public void setRevId(int revId) {
		this.revId = revId;
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