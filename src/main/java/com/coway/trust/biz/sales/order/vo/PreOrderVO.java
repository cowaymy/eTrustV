package com.coway.trust.biz.sales.order.vo;

import java.io.Serializable;
import java.math.BigDecimal;


/**
 * The persistent class for the SAL0213M database table.
 * 
 */
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
    
    private int custCntId;
    
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
    
    private int prcId;
    
    private String memCode;
    
    private int advBill;
    
    private int custCrcId;
    
    private int bankId;
    
    private int custAccId;
    
    private int is3RdParty;
    
    private int rentpayCustId;

    private int modeId;
    
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

	public int getCustCntId() {
		return custCntId;
	}

	public void setCustCntId(int custCntId) {
		this.custCntId = custCntId;
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

	public int getIs3RdParty() {
		return is3RdParty;
	}

	public void setIs3RdParty(int is3RdParty) {
		this.is3RdParty = is3RdParty;
	}

	public int getRentpayCustId() {
		return rentpayCustId;
	}

	public void setRentpayCustId(int rentpayCustId) {
		this.rentpayCustId = rentpayCustId;
	}

	public int getModeId() {
		return modeId;
	}

	public void setModeId(int modeId) {
		this.modeId = modeId;
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

}