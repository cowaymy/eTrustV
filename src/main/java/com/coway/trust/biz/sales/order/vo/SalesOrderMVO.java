package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 * The persistent class for the SAL0001D database table.
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class SalesOrderMVO implements Serializable {

  private static final long serialVersionUID = 1L;

  private long salesOrdId;

  private int advBill;

  private int aeonStusId;

  private int appTypeId;

  private int srvPacId;

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

  private int empChk;

  private int exTrade;

  private int ecash;

  private int promoDiscPeriodTp;

  private int promoDiscPeriod;

  private BigDecimal norAmt;

  private BigDecimal norRntFee;

  private BigDecimal discRntFee;

  private int gstChk;

  private int corpCustType;

  private int agreementType;

  private int comboOrdBind;

  private Integer bndlId;

  private String salesProdSz;

  private int preOrdId;

  private int ecommOrdId;

  private String eCommBndlId;

  private String serviceType;

  private String unitType;

  private int receivingMarketingMsgStatus;

  private String busType;

  private String isExtradePR;

  private String voucherCode;

  private String tnbAccNo;

  public String getSalesProdSz() {
	return salesProdSz;
}

public void setSalesProdSz(String salesProdSz) {
	this.salesProdSz = salesProdSz;
}

public static long getSerialversionuid() {
	return serialVersionUID;
}

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

  public int getEmpChk() {
    return empChk;
  }

  public void setEmpChk(int empChk) {
    this.empChk = empChk;
  }

  public int getExTrade() {
    return exTrade;
  }

  public void setExTrade(int exTrade) {
    this.exTrade = exTrade;
  }

  public int getEcash() {
    return ecash;
  }

  public void setEcash(int ecash) {
    this.ecash = ecash;
  }

  public int getPromoDiscPeriodTp() {
    return promoDiscPeriodTp;
  }

  public void setPromoDiscPeriodTp(int promoDiscPeriodTp) {
    this.promoDiscPeriodTp = promoDiscPeriodTp;
  }

  public int getPromoDiscPeriod() {
    return promoDiscPeriod;
  }

  public void setPromoDiscPeriod(int promoDiscPeriod) {
    this.promoDiscPeriod = promoDiscPeriod;
  }

  public BigDecimal getNorAmt() {
    return norAmt;
  }

  public void setNorAmt(BigDecimal norAmt) {
    this.norAmt = norAmt;
  }

  public BigDecimal getNorRntFee() {
    return norRntFee;
  }

  public void setNorRntFee(BigDecimal norRntFee) {
    this.norRntFee = norRntFee;
  }

  public BigDecimal getDiscRntFee() {
    return discRntFee;
  }

  public void setDiscRntFee(BigDecimal discRntFee) {
    this.discRntFee = discRntFee;
  }

  public int getGstChk() {
    return gstChk;
  }

  public void setGstChk(int gstChk) {
    this.gstChk = gstChk;
  }

  public int getSrvPacId() {
    return srvPacId;
  }

  public void setSrvPacId(int srvPacId) {
    this.srvPacId = srvPacId;
  }

  public int getCorpCustType() {
    return corpCustType;
  }

  public void setCorpCustType(int corpCustType) {
    this.corpCustType = corpCustType;
  }

  public int getAgreementType() {
    return agreementType;
  }

  public void setAgreementType(int agreementType) {
    this.agreementType = agreementType;
  }

  public int getComboOrdBind() {
    return comboOrdBind;
  }

  public void setComboOrdBind(int comboOrdBind) {
    this.comboOrdBind = comboOrdBind;
  }

public Integer getBndlId() {
	return bndlId;
}

public void setBndlId(Integer bndlId) {
	this.bndlId = bndlId;
}

public int getPreOrdId() {
  return preOrdId;
}

public void setPreOrdId(int preOrdId) {
  this.preOrdId = preOrdId;
}

public int getEcommOrdId() {
  return ecommOrdId;
}

public void setEcommOrdId(int ecommOrdId) {
  this.ecommOrdId = ecommOrdId;
}

public String geteCommBndlId() {
	return eCommBndlId;
}

public void seteCommBndlId(String eCommBndlId) {
	this.eCommBndlId = eCommBndlId;
}

public String getUnitType() {
    return unitType;
  }

  public void setUnitType(String unitType) {
    this.unitType = unitType;
  }

  public String getServiceType() {
    return serviceType;
  }

  public void setServiceType(String serviceType) {
    this.serviceType = serviceType;
  }

public int getReceivingMarketingMsgStatus() {
	return receivingMarketingMsgStatus;
}

public void setReceivingMarketingMsgStatus(int receivingMarketingMsgStatus) {
	this.receivingMarketingMsgStatus = receivingMarketingMsgStatus;
}

public String getBusType() {
	return busType;
}

public void setBusType(String bustype) {
	this.busType = bustype;
}

public String getIsExtradePR() {
	return isExtradePR;
}

public void setIsExtradePR(String isExtradePR) {
	this.isExtradePR = isExtradePR;
}

public String getVoucherCode() {
	return voucherCode;
}

public void setVoucherCode(String voucherCode) {
	this.voucherCode = voucherCode;
}

public String getTnbAccNo() {
	return tnbAccNo;
}

public void setTnbAccNo(String tnbAccNo) {
	this.tnbAccNo = tnbAccNo;
}
}