package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;


/**
 * The persistent class for the SAL0001D database table.
 * 
 */
public class SalesOrderMVO implements Serializable {
	
	private static final long serialVersionUID = 1L;

	private long salesOrdId;

	private int advBill;

	private int aeonStusId;

	private int appTypeId;

	private String bindingNo;

	private int brnchId;

	private int ccPromoId;

	private int cnvrSchemeId;

	private String commDt;

	private Date crtDt;

	private int crtUserId;

	private int custAddId;

	private int custBillId;

	private int custCareCntId;

	private int custCntId;

	private int custId;

	private String custPoNo;

	private BigDecimal defRentAmt;

	private String deptCode;

	private String doNo;

	private BigDecimal dscntAmt;

	private int editTypeId;

	private String grpCode;

	private int instPriod;

	private int lok;

	private int memId;

	private BigDecimal mthRentAmt;

	private String orgCode;

	private String payComDt;

	private int promoId;

	private int pvMonth;

	private int pvYear;

	private int refDocId;

	private String refNo;

	private String rem;

	private int renChkId;

	private int rentPromoId;

	private Date salesDt;

	private int salesGmId;

	private int salesHmId;

	private int salesOrdIdOld;

	private String salesOrdNo;

	private int salesSmId;

	private int stusCodeId;

	private int syncChk;

	private BigDecimal taxAmt;

	private BigDecimal totAmt;

	private BigDecimal totPv;

	private Date updDt;

	private int updUserId;
	
	private String billGroup;

	public long getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(long salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getAdvBill() {
		return advBill;
	}

	public void setAdvBill(int advBill) {
		this.advBill = advBill;
	}

	public int getAeonStusId() {
		return aeonStusId;
	}

	public void setAeonStusId(int aeonStusId) {
		this.aeonStusId = aeonStusId;
	}

	public int getAppTypeId() {
		return appTypeId;
	}

	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}

	public String getBindingNo() {
		return bindingNo;
	}

	public void setBindingNo(String bindingNo) {
		this.bindingNo = bindingNo;
	}

	public int getBrnchId() {
		return brnchId;
	}

	public void setBrnchId(int brnchId) {
		this.brnchId = brnchId;
	}

	public int getCcPromoId() {
		return ccPromoId;
	}

	public void setCcPromoId(int ccPromoId) {
		this.ccPromoId = ccPromoId;
	}

	public int getCnvrSchemeId() {
		return cnvrSchemeId;
	}

	public void setCnvrSchemeId(int cnvrSchemeId) {
		this.cnvrSchemeId = cnvrSchemeId;
	}

	public String getCommDt() {
		return commDt;
	}

	public void setCommDt(String commDt) {
		this.commDt = commDt;
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

	public int getCustAddId() {
		return custAddId;
	}

	public void setCustAddId(int custAddId) {
		this.custAddId = custAddId;
	}

	public int getCustBillId() {
		return custBillId;
	}

	public void setCustBillId(int custBillId) {
		this.custBillId = custBillId;
	}

	public int getCustCareCntId() {
		return custCareCntId;
	}

	public void setCustCareCntId(int custCareCntId) {
		this.custCareCntId = custCareCntId;
	}

	public int getCustCntId() {
		return custCntId;
	}

	public void setCustCntId(int custCntId) {
		this.custCntId = custCntId;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public String getCustPoNo() {
		return custPoNo;
	}

	public void setCustPoNo(String custPoNo) {
		this.custPoNo = custPoNo;
	}

	public BigDecimal getDefRentAmt() {
		return defRentAmt;
	}

	public void setDefRentAmt(BigDecimal defRentAmt) {
		this.defRentAmt = defRentAmt;
	}

	public String getDeptCode() {
		return deptCode;
	}

	public void setDeptCode(String deptCode) {
		this.deptCode = deptCode;
	}

	public String getDoNo() {
		return doNo;
	}

	public void setDoNo(String doNo) {
		this.doNo = doNo;
	}

	public BigDecimal getDscntAmt() {
		return dscntAmt;
	}

	public void setDscntAmt(BigDecimal dscntAmt) {
		this.dscntAmt = dscntAmt;
	}

	public int getEditTypeId() {
		return editTypeId;
	}

	public void setEditTypeId(int editTypeId) {
		this.editTypeId = editTypeId;
	}

	public String getGrpCode() {
		return grpCode;
	}

	public void setGrpCode(String grpCode) {
		this.grpCode = grpCode;
	}

	public int getInstPriod() {
		return instPriod;
	}

	public void setInstPriod(int instPriod) {
		this.instPriod = instPriod;
	}

	public int getLok() {
		return lok;
	}

	public void setLok(int lok) {
		this.lok = lok;
	}

	public int getMemId() {
		return memId;
	}

	public void setMemId(int memId) {
		this.memId = memId;
	}

	public BigDecimal getMthRentAmt() {
		return mthRentAmt;
	}

	public void setMthRentAmt(BigDecimal mthRentAmt) {
		this.mthRentAmt = mthRentAmt;
	}

	public String getOrgCode() {
		return orgCode;
	}

	public void setOrgCode(String orgCode) {
		this.orgCode = orgCode;
	}

	public String getPayComDt() {
		return payComDt;
	}

	public void setPayComDt(String payComDt) {
		this.payComDt = payComDt;
	}

	public int getPromoId() {
		return promoId;
	}

	public void setPromoId(int promoId) {
		this.promoId = promoId;
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

	public int getRefDocId() {
		return refDocId;
	}

	public void setRefDocId(int refDocId) {
		this.refDocId = refDocId;
	}

	public String getRefNo() {
		return refNo;
	}

	public void setRefNo(String refNo) {
		this.refNo = refNo;
	}

	public String getRem() {
		return rem;
	}

	public void setRem(String rem) {
		this.rem = rem;
	}

	public int getRenChkId() {
		return renChkId;
	}

	public void setRenChkId(int renChkId) {
		this.renChkId = renChkId;
	}

	public int getRentPromoId() {
		return rentPromoId;
	}

	public void setRentPromoId(int rentPromoId) {
		this.rentPromoId = rentPromoId;
	}

	public Date getSalesDt() {
		return salesDt;
	}

	public void setSalesDt(Date salesDt) {
		this.salesDt = salesDt;
	}

	public int getSalesGmId() {
		return salesGmId;
	}

	public void setSalesGmId(int salesGmId) {
		this.salesGmId = salesGmId;
	}

	public int getSalesHmId() {
		return salesHmId;
	}

	public void setSalesHmId(int salesHmId) {
		this.salesHmId = salesHmId;
	}

	public int getSalesOrdIdOld() {
		return salesOrdIdOld;
	}

	public void setSalesOrdIdOld(int salesOrdIdOld) {
		this.salesOrdIdOld = salesOrdIdOld;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public int getSalesSmId() {
		return salesSmId;
	}

	public void setSalesSmId(int salesSmId) {
		this.salesSmId = salesSmId;
	}

	public int getStusCodeId() {
		return stusCodeId;
	}

	public void setStusCodeId(int stusCodeId) {
		this.stusCodeId = stusCodeId;
	}

	public int getSyncChk() {
		return syncChk;
	}

	public void setSyncChk(int syncChk) {
		this.syncChk = syncChk;
	}

	public BigDecimal getTaxAmt() {
		return taxAmt;
	}

	public void setTaxAmt(BigDecimal taxAmt) {
		this.taxAmt = taxAmt;
	}

	public BigDecimal getTotAmt() {
		return totAmt;
	}

	public void setTotAmt(BigDecimal totAmt) {
		this.totAmt = totAmt;
	}

	public BigDecimal getTotPv() {
		return totPv;
	}

	public void setTotPv(BigDecimal totPv) {
		this.totPv = totPv;
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

	public String getBillGroup() {
		return billGroup;
	}

	public void setBillGroup(String billGroup) {
		this.billGroup = billGroup;
	}
}