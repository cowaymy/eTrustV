package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import javax.persistence.*;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0001D database table.
 * 
 */
public class SalesOrderMVO implements Serializable {
	private static final long serialVersionUID = 1L;

	private long salesOrdId;

	private BigDecimal advBill;

	private BigDecimal aeonStusId;

	private BigDecimal appTypeId;

	private String bindingNo;

	private BigDecimal brnchId;

	private BigDecimal ccPromoId;

	private BigDecimal cnvrSchemeId;

	private String commDt;

	private Date crtDt;

	private BigDecimal crtUserId;

	private BigDecimal custAddId;

	private BigDecimal custBillId;

	private BigDecimal custCareCntId;

	private BigDecimal custCntId;

	private BigDecimal custId;

	private String custPoNo;

	private BigDecimal defRentAmt;

	private String deptCode;

	private String doNo;

	private BigDecimal dscntAmt;

	private BigDecimal editTypeId;

	private String grpCode;

	private BigDecimal instPriod;

	private BigDecimal lok;

	private BigDecimal memId;

	private BigDecimal mthRentAmt;

	private String orgCode;

	private String payComDt;

	private BigDecimal promoId;

	private BigDecimal pvMonth;

	private BigDecimal pvYear;

	private BigDecimal refDocId;

	private String refNo;

	private String rem;

	private BigDecimal renChkId;

	private BigDecimal rentPromoId;

	private Date salesDt;

	private BigDecimal salesGmId;

	private BigDecimal salesHmId;

	private BigDecimal salesOrdIdOld;

	private String salesOrdNo;

	private BigDecimal salesSmId;

	private BigDecimal stusCodeId;

	private BigDecimal syncChk;

	private BigDecimal taxAmt;

	private BigDecimal totAmt;

	private BigDecimal totPv;

	private Date updDt;

	private BigDecimal updUserId;

	public SalesOrderMVO() {
	}

	public long getSalesOrdId() {
		return this.salesOrdId;
	}

	public void setSalesOrdId(long salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public BigDecimal getAdvBill() {
		return this.advBill;
	}

	public void setAdvBill(BigDecimal advBill) {
		this.advBill = advBill;
	}

	public BigDecimal getAeonStusId() {
		return this.aeonStusId;
	}

	public void setAeonStusId(BigDecimal aeonStusId) {
		this.aeonStusId = aeonStusId;
	}

	public BigDecimal getAppTypeId() {
		return this.appTypeId;
	}

	public void setAppTypeId(BigDecimal appTypeId) {
		this.appTypeId = appTypeId;
	}

	public String getBindingNo() {
		return this.bindingNo;
	}

	public void setBindingNo(String bindingNo) {
		this.bindingNo = bindingNo;
	}

	public BigDecimal getBrnchId() {
		return this.brnchId;
	}

	public void setBrnchId(BigDecimal brnchId) {
		this.brnchId = brnchId;
	}

	public BigDecimal getCcPromoId() {
		return this.ccPromoId;
	}

	public void setCcPromoId(BigDecimal ccPromoId) {
		this.ccPromoId = ccPromoId;
	}

	public BigDecimal getCnvrSchemeId() {
		return this.cnvrSchemeId;
	}

	public void setCnvrSchemeId(BigDecimal cnvrSchemeId) {
		this.cnvrSchemeId = cnvrSchemeId;
	}

	public String getCommDt() {
		return this.commDt;
	}

	public void setCommDt(String commDt) {
		this.commDt = commDt;
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

	public BigDecimal getCustAddId() {
		return this.custAddId;
	}

	public void setCustAddId(BigDecimal custAddId) {
		this.custAddId = custAddId;
	}

	public BigDecimal getCustBillId() {
		return this.custBillId;
	}

	public void setCustBillId(BigDecimal custBillId) {
		this.custBillId = custBillId;
	}

	public BigDecimal getCustCareCntId() {
		return this.custCareCntId;
	}

	public void setCustCareCntId(BigDecimal custCareCntId) {
		this.custCareCntId = custCareCntId;
	}

	public BigDecimal getCustCntId() {
		return this.custCntId;
	}

	public void setCustCntId(BigDecimal custCntId) {
		this.custCntId = custCntId;
	}

	public BigDecimal getCustId() {
		return this.custId;
	}

	public void setCustId(BigDecimal custId) {
		this.custId = custId;
	}

	public String getCustPoNo() {
		return this.custPoNo;
	}

	public void setCustPoNo(String custPoNo) {
		this.custPoNo = custPoNo;
	}

	public BigDecimal getDefRentAmt() {
		return this.defRentAmt;
	}

	public void setDefRentAmt(BigDecimal defRentAmt) {
		this.defRentAmt = defRentAmt;
	}

	public String getDeptCode() {
		return this.deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getDoNo() {
		return this.doNo;
	}

	public void setDoNo(String doNo) {
		this.doNo = doNo;
	}

	public BigDecimal getDscntAmt() {
		return this.dscntAmt;
	}

	public void setDscntAmt(BigDecimal dscntAmt) {
		this.dscntAmt = dscntAmt;
	}

	public BigDecimal getEditTypeId() {
		return this.editTypeId;
	}

	public void setEditTypeId(BigDecimal editTypeId) {
		this.editTypeId = editTypeId;
	}

	public String getGrpCode() {
		return this.grpCode;
	}

	public void setGrpCode(String grpCode) {
		this.grpCode = grpCode;
	}

	public BigDecimal getInstPriod() {
		return this.instPriod;
	}

	public void setInstPriod(BigDecimal instPriod) {
		this.instPriod = instPriod;
	}

	public BigDecimal getLok() {
		return this.lok;
	}

	public void setLok(BigDecimal lok) {
		this.lok = lok;
	}

	public BigDecimal getMemId() {
		return this.memId;
	}

	public void setMemId(BigDecimal memId) {
		this.memId = memId;
	}

	public BigDecimal getMthRentAmt() {
		return this.mthRentAmt;
	}

	public void setMthRentAmt(BigDecimal mthRentAmt) {
		this.mthRentAmt = mthRentAmt;
	}

	public String getOrgCode() {
		return this.orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getPayComDt() {
		return this.payComDt;
	}

	public void setPayComDt(String payComDt) {
		this.payComDt = payComDt;
	}

	public BigDecimal getPromoId() {
		return this.promoId;
	}

	public void setPromoId(BigDecimal promoId) {
		this.promoId = promoId;
	}

	public BigDecimal getPvMonth() {
		return this.pvMonth;
	}

	public void setPvMonth(BigDecimal pvMonth) {
		this.pvMonth = pvMonth;
	}

	public BigDecimal getPvYear() {
		return this.pvYear;
	}

	public void setPvYear(BigDecimal pvYear) {
		this.pvYear = pvYear;
	}

	public BigDecimal getRefDocId() {
		return this.refDocId;
	}

	public void setRefDocId(BigDecimal refDocId) {
		this.refDocId = refDocId;
	}

	public String getRefNo() {
		return this.refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public String getRem() {
		return this.rem;
	}

	public void setRem(String rem) {
		this.rem = rem;
	}

	public BigDecimal getRenChkId() {
		return this.renChkId;
	}

	public void setRenChkId(BigDecimal renChkId) {
		this.renChkId = renChkId;
	}

	public BigDecimal getRentPromoId() {
		return this.rentPromoId;
	}

	public void setRentPromoId(BigDecimal rentPromoId) {
		this.rentPromoId = rentPromoId;
	}

	public Date getSalesDt() {
		return this.salesDt;
	}

	public void setSalesDt(Date salesDt) {
		this.salesDt = salesDt;
	}

	public BigDecimal getSalesGmId() {
		return this.salesGmId;
	}

	public void setSalesGmId(BigDecimal salesGmId) {
		this.salesGmId = salesGmId;
	}

	public BigDecimal getSalesHmId() {
		return this.salesHmId;
	}

	public void setSalesHmId(BigDecimal salesHmId) {
		this.salesHmId = salesHmId;
	}

	public BigDecimal getSalesOrdIdOld() {
		return this.salesOrdIdOld;
	}

	public void setSalesOrdIdOld(BigDecimal salesOrdIdOld) {
		this.salesOrdIdOld = salesOrdIdOld;
	}

	public String getSalesOrdNo() {
		return this.salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public BigDecimal getSalesSmId() {
		return this.salesSmId;
	}

	public void setSalesSmId(BigDecimal salesSmId) {
		this.salesSmId = salesSmId;
	}

	public BigDecimal getStusCodeId() {
		return this.stusCodeId;
	}

	public void setStusCodeId(BigDecimal stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public BigDecimal getSyncChk() {
		return this.syncChk;
	}

	public void setSyncChk(BigDecimal syncChk) {
		this.syncChk = syncChk;
	}

	public BigDecimal getTaxAmt() {
		return this.taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	public BigDecimal getTotAmt() {
		return this.totAmt;
	}

	public void setTotAmt(BigDecimal totAmt) {
		this.totAmt = totAmt;
	}

	public BigDecimal getTotPv() {
		return this.totPv;
	}

	public void setTotPv(BigDecimal totPv) {
		this.totPv = totPv;
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