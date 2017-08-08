package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0074D database table.
 * 
 */
public class RentPaySetVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long rentPayId;

	private BigDecimal aeonCnvr;

	private BigDecimal bankId;

	private BigDecimal custAccId;

	private BigDecimal custCrcId;

	private BigDecimal custId;

	private Date ddApplyDt;

	private Date ddRejctDt;

	private Date ddStartDt;

	private Date ddSubmitDt;

	private BigDecimal editTypeId;

	private BigDecimal failResnId;

	private BigDecimal is3rdParty;

	private String issuNric;

	private BigDecimal lastApplyUser;

	private BigDecimal modeId;

	private String nricOld;

	private BigDecimal payTrm;

	private String rem;

	private BigDecimal salesOrdId;

	private BigDecimal stusCodeId;

	private BigDecimal svcCntrctId;

	private Date updDt;

	private BigDecimal updUserId;

	public RentPaySetVO() {
	}

	public long getRentPayId() {
		return this.rentPayId;
	}

	public void setRentPayId(long rentPayId) {
		this.rentPayId = rentPayId;
	}

	public BigDecimal getAeonCnvr() {
		return this.aeonCnvr;
	}

	public void setAeonCnvr(BigDecimal aeonCnvr) {
		this.aeonCnvr = aeonCnvr;
	}

	public BigDecimal getBankId() {
		return this.bankId;
	}

	public void setBankId(BigDecimal bankId) {
		this.bankId = bankId;
	}

	public BigDecimal getCustAccId() {
		return this.custAccId;
	}

	public void setCustAccId(BigDecimal custAccId) {
		this.custAccId = custAccId;
	}

	public BigDecimal getCustCrcId() {
		return this.custCrcId;
	}

	public void setCustCrcId(BigDecimal custCrcId) {
		this.custCrcId = custCrcId;
	}

	public BigDecimal getCustId() {
		return this.custId;
	}

	public void setCustId(BigDecimal custId) {
		this.custId = custId;
	}

	public Date getDdApplyDt() {
		return this.ddApplyDt;
	}

	public void setDdApplyDt(Date ddApplyDt) {
		this.ddApplyDt = ddApplyDt;
	}

	public Date getDdRejctDt() {
		return this.ddRejctDt;
	}

	public void setDdRejctDt(Date ddRejctDt) {
		this.ddRejctDt = ddRejctDt;
	}

	public Date getDdStartDt() {
		return this.ddStartDt;
	}

	public void setDdStartDt(Date ddStartDt) {
		this.ddStartDt = ddStartDt;
	}

	public Date getDdSubmitDt() {
		return this.ddSubmitDt;
	}

	public void setDdSubmitDt(Date ddSubmitDt) {
		this.ddSubmitDt = ddSubmitDt;
	}

	public BigDecimal getEditTypeId() {
		return this.editTypeId;
	}

	public void setEditTypeId(BigDecimal editTypeId) {
		this.editTypeId = editTypeId;
	}

	public BigDecimal getFailResnId() {
		return this.failResnId;
	}

	public void setFailResnId(BigDecimal failResnId) {
		this.failResnId = failResnId;
	}

	public BigDecimal getIs3rdParty() {
		return this.is3rdParty;
	}

	public void setIs3rdParty(BigDecimal is3rdParty) {
		this.is3rdParty = is3rdParty;
	}

	public String getIssuNric() {
		return this.issuNric;
	}

	public void setIssuNric(String issuNric) {
		this.issuNric = issuNric;
	}

	public BigDecimal getLastApplyUser() {
		return this.lastApplyUser;
	}

	public void setLastApplyUser(BigDecimal lastApplyUser) {
		this.lastApplyUser = lastApplyUser;
	}

	public BigDecimal getModeId() {
		return this.modeId;
	}

	public void setModeId(BigDecimal modeId) {
		this.modeId = modeId;
	}

	public String getNricOld() {
		return this.nricOld;
	}

	public void setNricOld(String nricOld) {
		this.nricOld = nricOld;
	}

	public BigDecimal getPayTrm() {
		return this.payTrm;
	}

	public void setPayTrm(BigDecimal payTrm) {
		this.payTrm = payTrm;
	}

	public String getRem() {
		return this.rem;
	}

	public void setRem(String rem) {
		this.rem = rem;
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

	public BigDecimal getSvcCntrctId() {
		return this.svcCntrctId;
	}

	public void setSvcCntrctId(BigDecimal svcCntrctId) {
		this.svcCntrctId = svcCntrctId;
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