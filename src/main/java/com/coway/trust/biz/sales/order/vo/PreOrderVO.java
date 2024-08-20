package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;

import com.coway.trust.biz.homecare.sales.order.vo.HcOrderVO;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;


/**
 * The persistent class for the SAL0213M database table.
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class PreOrderVO implements Serializable {
	private static final long serialVersionUID = 1L;

    private int preOrdId;

    private String reqstDt;

    private int chnnl;

    private int stusId;

    private String sofNo;

    private String custPoNo;

    private int appTypeId;

    private int srvPacId;

    private int instPriod;

    private int custId;

    private int empChk;

    private int gstChk;

    private String eurcCustRgsNo;

    private int atchFileGrpId;

    private int custCntcId;

    private int keyinBrnchId;

    private int instAddId;

    private int dscBrnchId;

    private String preDt;

    private String preTm;

    private String instct;

    private int exTrade;

    private int itmStkId;

    private int promoId;

    private BigDecimal mthRentAmt;

    private int promoDiscPeriodTp;

    private BigDecimal promoDiscPeriod;

    private BigDecimal totAmt;

    private BigDecimal norAmt;

    private BigDecimal norRntFee;

    private BigDecimal discRntFee;

    private BigDecimal totPv;

    private BigDecimal totPvGst;

    private int prcId;

    private String memCode;

    private int advBill;

    private int custCrcId;

    private int bankId;

    private int custAccId;

    private int is3rdParty;

    private int rentPayCustId;

    private int rentPayModeId;

    private int custBillId;

    private int custBillCustId;

    private int custBillCntId;

    private int custBillAddId;

    private String custBillRem;

    private String custBillEmail;

    private int custBillIsSms;

    private int custBillIsPost;

    private String custBillEmailAdd;

    private int custBillIsWebPortal;

    private String custBillWebPortalUrl;

    private int custBillIsSms2;

    private int custBillCustCareCntId;

    private int crtUserId;

    private String crtDt;

    private int updUserId;

    private String updDt;

    private String rem1;

    private String rem2;

    private int salesOrdId;

    private int itmCompId;

    private int corpCustType;

    private int agreementType;

    private int salesOrdIdOld;

    private String relatedNo;

    private int receivingMarketingMsgStatus;

    private String isExtradePR;

    private String busType;

    private String voucherCode;

    private String srvType;

    // 20191210 - KR-SH 추가
    private int preOrdId1;
    private int preOrdId2;
    private int ordSeqNo;
    private int itmStkId1;
    private int itmCompId1;
    private int promoId1;
    private BigDecimal mthRentAmt1;
    private BigDecimal totAmt1;
    private BigDecimal norAmt1;
    private BigDecimal discRntFee1;
    private BigDecimal totPv1;
    private BigDecimal totPvGst1;
    private int prcId1;
    private int itmStkId2;
    private int itmCompId2;
    private int promoId2;
    private BigDecimal mthRentAmt2;
    private BigDecimal totAmt2;
    private BigDecimal norAmt2;
	private BigDecimal discRntFee2;
    private BigDecimal totPv2;
    private BigDecimal totPvGst2;
    private int prcId2;
    private int matPreOrdNo;
    private int fraPreOrdNo;
    private HcOrderVO hcOrderVO;  // Homecare Order
    private String rcdTms1;
    private String rcdTms2;
    private Integer bndlId;

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

	public String getReqstDt() {
		return reqstDt;
	}

	public void setReqstDt(String reqstDt) {
		this.reqstDt = reqstDt;
	}

	public int getChnnl() {
		return chnnl;
	}

	public void setChnnl(int chnnl) {
		this.chnnl = chnnl;
	}

	public int getStusId() {
		return stusId;
	}

	public void setStusId(int stusId) {
		this.stusId = stusId;
	}

	public String getSofNo() {
		return sofNo;
	}

	public void setSofNo(String sofNo) {
		this.sofNo = sofNo;
	}

	public String getCustPoNo() {
		return custPoNo;
	}

	public void setCustPoNo(String custPoNo) {
		this.custPoNo = custPoNo;
	}

	public int getAppTypeId() {
		return appTypeId;
	}

	public void setAppTypeId(int appTypeId) {
		this.appTypeId = appTypeId;
	}

	public int getSrvPacId() {
		return srvPacId;
	}

	public void setSrvPacId(int srvPacId) {
		this.srvPacId = srvPacId;
	}

	public int getInstPriod() {
		return instPriod;
	}

	public void setInstPriod(int instPriod) {
		this.instPriod = instPriod;
	}

	public int getCustId() {
		return custId;
	}

	public void setCustId(int custId) {
		this.custId = custId;
	}

	public int getEmpChk() {
		return empChk;
	}

	public void setEmpChk(int empChk) {
		this.empChk = empChk;
	}

	public int getGstChk() {
		return gstChk;
	}

	public void setGstChk(int gstChk) {
		this.gstChk = gstChk;
	}

	public String getEurcCustRgsNo() {
		return eurcCustRgsNo;
	}

	public void setEurcCustRgsNo(String eurcCustRgsNo) {
		this.eurcCustRgsNo = eurcCustRgsNo;
	}

	public int getAtchFileGrpId() {
		return atchFileGrpId;
	}

	public void setAtchFileGrpId(int atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}

	public int getCustCntcId() {
		return custCntcId;
	}

	public void setCustCntcId(int custCntId) {
		this.custCntcId = custCntId;
	}

	public int getKeyinBrnchId() {
		return keyinBrnchId;
	}

	public void setKeyinBrnchId(int keyinBrnchId) {
		this.keyinBrnchId = keyinBrnchId;
	}

	public int getInstAddId() {
		return instAddId;
	}

	public void setInstAddId(int instAddId) {
		this.instAddId = instAddId;
	}

	public int getDscBrnchId() {
		return dscBrnchId;
	}

	public void setDscBrnchId(int dscBrnchId) {
		this.dscBrnchId = dscBrnchId;
	}

	public String getPreDt() {
		return preDt;
	}

	public void setPreDt(String preDt) {
		this.preDt = preDt;
	}

	public String getPreTm() {
		return preTm;
	}

	public void setPreTm(String preTm) {
		this.preTm = preTm;
	}

	public String getInstct() {
		return instct;
	}

	public void setInstct(String instct) {
		this.instct = instct;
	}

	public int getExTrade() {
		return exTrade;
	}

	public void setExTrade(int exTrade) {
		this.exTrade = exTrade;
	}

	public int getItmStkId() {
		return itmStkId;
	}

	public void setItmStkId(int itmStkId) {
		this.itmStkId = itmStkId;
	}

	public int getPromoId() {
		return promoId;
	}

	public void setPromoId(int promoId) {
		this.promoId = promoId;
	}

	public BigDecimal getMthRentAmt() {
		return mthRentAmt;
	}

	public void setMthRentAmt(BigDecimal mthRentAmt) {
		this.mthRentAmt = mthRentAmt;
	}

	public int getPromoDiscPeriodTp() {
		return promoDiscPeriodTp;
	}

	public void setPromoDiscPeriodTp(int promoDiscPeriodTp) {
		this.promoDiscPeriodTp = promoDiscPeriodTp;
	}

	public BigDecimal getPromoDiscPeriod() {
		return promoDiscPeriod;
	}

	public void setPromoDiscPeriod(BigDecimal promoDiscPeriod) {
		this.promoDiscPeriod = promoDiscPeriod;
	}

	public BigDecimal getTotAmt() {
		return totAmt;
	}

	public void setTotAmt(BigDecimal totAmt) {
		this.totAmt = totAmt;
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

	public BigDecimal getTotPv() {
		return totPv;
	}

	public void setTotPv(BigDecimal totPv) {
		this.totPv = totPv;
	}

	public int getPrcId() {
		return prcId;
	}

	public void setPrcId(int prcId) {
		this.prcId = prcId;
	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public int getAdvBill() {
		return advBill;
	}

	public void setAdvBill(int advBill) {
		this.advBill = advBill;
	}

	public int getCustCrcId() {
		return custCrcId;
	}

	public void setCustCrcId(int custCrcId) {
		this.custCrcId = custCrcId;
	}

	public int getBankId() {
		return bankId;
	}

	public void setBankId(int bankId) {
		this.bankId = bankId;
	}

	public int getCustAccId() {
		return custAccId;
	}

	public void setCustAccId(int custAccId) {
		this.custAccId = custAccId;
	}

	public int getIs3rdParty() {
		return is3rdParty;
	}

	public void setIs3rdParty(int is3rdParty) {
		this.is3rdParty = is3rdParty;
	}

	public int getRentPayCustId() {
		return rentPayCustId;
	}

	public void setRentPayCustId(int rentPayCustId) {
		this.rentPayCustId = rentPayCustId;
	}

	public int getRentPayModeId() {
		return rentPayModeId;
	}

	public void setRentPayModeId(int rentPayModeId) {
		this.rentPayModeId = rentPayModeId;
	}

	public int getCustBillCustId() {
		return custBillCustId;
	}

	public void setCustBillCustId(int custBillCustId) {
		this.custBillCustId = custBillCustId;
	}

	public int getCustBillCntId() {
		return custBillCntId;
	}

	public void setCustBillCntId(int custBillCntId) {
		this.custBillCntId = custBillCntId;
	}

	public int getCustBillAddId() {
		return custBillAddId;
	}

	public void setCustBillAddId(int custBillAddId) {
		this.custBillAddId = custBillAddId;
	}

	public String getCustBillRem() {
		return custBillRem;
	}

	public void setCustBillRem(String custBillRem) {
		this.custBillRem = custBillRem;
	}

	public String getCustBillEmail() {
		return custBillEmail;
	}

	public void setCustBillEmail(String custBillEmail) {
		this.custBillEmail = custBillEmail;
	}

	public int getCustBillIsSms() {
		return custBillIsSms;
	}

	public void setCustBillIsSms(int custBillIsSms) {
		this.custBillIsSms = custBillIsSms;
	}

	public int getCustBillIsPost() {
		return custBillIsPost;
	}

	public void setCustBillIsPost(int custBillIsPost) {
		this.custBillIsPost = custBillIsPost;
	}

	public String getCustBillEmailAdd() {
		return custBillEmailAdd;
	}

	public void setCustBillEmailAdd(String custBillEmailAdd) {
		this.custBillEmailAdd = custBillEmailAdd;
	}

	public int getCustBillIsWebPortal() {
		return custBillIsWebPortal;
	}

	public void setCustBillIsWebPortal(int custBillIsWebPortal) {
		this.custBillIsWebPortal = custBillIsWebPortal;
	}

	public String getCustBillWebPortalUrl() {
		return custBillWebPortalUrl;
	}

	public void setCustBillWebPortalUrl(String custBillWebPortalUrl) {
		this.custBillWebPortalUrl = custBillWebPortalUrl;
	}

	public int getCustBillIsSms2() {
		return custBillIsSms2;
	}

	public void setCustBillIsSms2(int custBillIsSms2) {
		this.custBillIsSms2 = custBillIsSms2;
	}

	public int getCustBillCustCareCntId() {
		return custBillCustCareCntId;
	}

	public void setCustBillCustCareCntId(int custBillCustCareCntId) {
		this.custBillCustCareCntId = custBillCustCareCntId;
	}

	public int getCrtUserId() {
		return crtUserId;
	}

	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}

	public String getCrtDt() {
		return crtDt;
	}

	public void setCrtDt(String crtDt) {
		this.crtDt = crtDt;
	}

	public int getUpdUserId() {
		return updUserId;
	}

	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}

	public String getUpdDt() {
		return updDt;
	}

	public void setUpdDt(String updDt) {
		this.updDt = updDt;
	}

	public String getRem1() {
		return rem1;
	}

	public void setRem1(String rem1) {
		this.rem1 = rem1;
	}

	public String getRem2() {
		return rem2;
	}

	public void setRem2(String rem2) {
		this.rem2 = rem2;
	}

	public BigDecimal getTotPvGst() {
		return totPvGst;
	}

	public void setTotPvGst(BigDecimal totPvGst) {
		this.totPvGst = totPvGst;
	}

	public int getCustBillId() {
		return custBillId;
	}

	public void setCustBillId(int custBillId) {
		this.custBillId = custBillId;
	}

	public int getSalesOrdId() {
		return salesOrdId;
	}

	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}

	public int getItmCompId() {
		return itmCompId;
	}

	public void setItmCompId(int itmCompId) {
		this.itmCompId = itmCompId;
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

	public int getPreOrdId1() {
		return preOrdId1;
	}

	public void setPreOrdId1(int preOrdId1) {
		this.preOrdId1 = preOrdId1;
	}

	public int getPreOrdId2() {
		return preOrdId2;
	}

	public void setPreOrdId2(int preOrdId2) {
		this.preOrdId2 = preOrdId2;
	}

	public int getOrdSeqNo() {
		return ordSeqNo;
	}

	public void setOrdSeqNo(int ordSeqNo) {
		this.ordSeqNo = ordSeqNo;
	}

	public int getItmStkId1() {
		return itmStkId1;
	}

	public void setItmStkId1(int itmStkId1) {
		this.itmStkId1 = itmStkId1;
	}

	public int getItmCompId1() {
		return itmCompId1;
	}

	public void setItmCompId1(int itmCompId1) {
		this.itmCompId1 = itmCompId1;
	}

	public int getPromoId1() {
		return promoId1;
	}

	public void setPromoId1(int promoId1) {
		this.promoId1 = promoId1;
	}

	public BigDecimal getMthRentAmt1() {
		return mthRentAmt1;
	}

	public void setMthRentAmt1(BigDecimal mthRentAmt1) {
		this.mthRentAmt1 = mthRentAmt1;
	}

	public BigDecimal getTotAmt1() {
		return totAmt1;
	}

	public void setTotAmt1(BigDecimal totAmt1) {
		this.totAmt1 = totAmt1;
	}

	public BigDecimal getNorAmt1() {
		return norAmt1;
	}

	public void setNorAmt1(BigDecimal norAmt1) {
		this.norAmt1 = norAmt1;
	}

	public BigDecimal getDiscRntFee1() {
		return discRntFee1;
	}

	public void setDiscRntFee1(BigDecimal discRntFee1) {
		this.discRntFee1 = discRntFee1;
	}

	public BigDecimal getTotPv1() {
		return totPv1;
	}

	public void setTotPv1(BigDecimal totPv1) {
		this.totPv1 = totPv1;
	}

	public BigDecimal getTotPvGst1() {
		return totPvGst1;
	}

	public void setTotPvGst1(BigDecimal totPvGst1) {
		this.totPvGst1 = totPvGst1;
	}

	public int getPrcId1() {
		return prcId1;
	}

	public void setPrcId1(int prcId1) {
		this.prcId1 = prcId1;
	}

	public int getItmStkId2() {
		return itmStkId2;
	}

	public void setItmStkId2(int itmStkId2) {
		this.itmStkId2 = itmStkId2;
	}

	public int getItmCompId2() {
		return itmCompId2;
	}

	public void setItmCompId2(int itmCompId2) {
		this.itmCompId2 = itmCompId2;
	}

	public int getPromoId2() {
		return promoId2;
	}

	public void setPromoId2(int promoId2) {
		this.promoId2 = promoId2;
	}

	public BigDecimal getMthRentAmt2() {
		return mthRentAmt2;
	}

	public void setMthRentAmt2(BigDecimal mthRentAmt2) {
		this.mthRentAmt2 = mthRentAmt2;
	}

	public BigDecimal getTotAmt2() {
		return totAmt2;
	}

	public void setTotAmt2(BigDecimal totAmt2) {
		this.totAmt2 = totAmt2;
	}

	public BigDecimal getNorAmt2() {
		return norAmt2;
	}

	public void setNorAmt2(BigDecimal norAmt2) {
		this.norAmt2 = norAmt2;
	}

	public BigDecimal getDiscRntFee2() {
		return discRntFee2;
	}

	public void setDiscRntFee2(BigDecimal discRntFee2) {
		this.discRntFee2 = discRntFee2;
	}

	public BigDecimal getTotPv2() {
		return totPv2;
	}

	public void setTotPv2(BigDecimal totPv2) {
		this.totPv2 = totPv2;
	}

	public BigDecimal getTotPvGst2() {
		return totPvGst2;
	}

	public void setTotPvGst2(BigDecimal totPvGst2) {
		this.totPvGst2 = totPvGst2;
	}

	public int getPrcId2() {
		return prcId2;
	}

	public void setPrcId2(int prcId2) {
		this.prcId2 = prcId2;
	}

	public int getMatPreOrdNo() {
		return matPreOrdNo;
	}

	public void setMatPreOrdNo(int matPreOrdNo) {
		this.matPreOrdNo = matPreOrdNo;
	}

	public int getFraPreOrdNo() {
		return fraPreOrdNo;
	}

	public void setFraPreOrdNo(int fraPreOrdNo) {
		this.fraPreOrdNo = fraPreOrdNo;
	}

	public HcOrderVO getHcOrderVO() {
		return hcOrderVO;
	}

	public void setHcOrderVO(HcOrderVO hcOrderVO) {
		this.hcOrderVO = hcOrderVO;
	}

	public String getRcdTms1() {
		return rcdTms1;
	}

	public void setRcdTms1(String rcdTms1) {
		this.rcdTms1 = rcdTms1;
	}

	public String getRcdTms2() {
		return rcdTms2;
	}

	public void setRcdTms2(String rcdTms2) {
		this.rcdTms2 = rcdTms2;
	}

	public static long getSerialversionuid() {
		return serialVersionUID;
	}

	public int getSalesOrdIdOld() {
		return salesOrdIdOld;
	}

	public void setSalesOrdIdOld(int salesOrdIdOld) {
		this.salesOrdIdOld = salesOrdIdOld;
	}

	public String getRelatedNo() {
		return relatedNo;
	}

	public void setRelatedNo(String relatedNo) {
		this.relatedNo = relatedNo;
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

  public String getSrvType() {
    return srvType;
  }

  public void setSrvType(String srvType) {
    this.srvType = srvType;
  }
}