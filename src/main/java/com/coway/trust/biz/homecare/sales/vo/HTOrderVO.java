package com.coway.trust.biz.homecare.sales.vo;

import java.io.Serializable;
import java.math.BigDecimal;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import com.coway.trust.biz.sales.order.vo.DocSubmissionVO;
import com.coway.trust.biz.sales.order.vo.InstallationVO;
import com.coway.trust.biz.sales.order.vo.SalesOrderLogVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigPeriodVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigSettingVO;
import com.coway.trust.biz.sales.order.vo.SrvConfigurationVO;
import com.coway.trust.biz.sales.order.vo.SrvMembershipSalesVO;
import com.coway.trust.cmmn.model.GridDataSet;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;

/**
 *
 *
 */
@JsonIgnoreProperties(ignoreUnknown = true)
public class HTOrderVO implements Serializable {

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

	private String prodSize;

	private String prodBrand;

	private String serviceType;

	private String unitType;

	private String cntId;

	private String instct;

	private String preDt;

	private String preTm;

	private int custTypeId;

	private int raceId;

	private int orderAppType;

	private String sInstallDate;

	private int itmStkId;

	private String dInstallDate;

	private int orderQuantity;

	private InstallationVO installationVO; //INSTALLATION MASTER

	private GridDataSet<DocSubmissionVO> docSubmissionVOList;

	private List<DocSubmissionVO> docSubVOList;

	private SrvMembershipSalesVO srvMembershipSalesVO;

	private SrvConfigurationVO srvConfigurationVO;

	private List<SrvConfigSettingVO> srvConfigSettingVOList;

	private SrvConfigPeriodVO srvConfigPeriodVO;

	private List<SalesOrderLogVO> salesOrderLogVOList;

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

	public String getProdSize() {
		return prodSize;
	}

	public void setProdSize(String prodSize) {
		this.prodSize = prodSize;
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

	public String getProdBrand() {
		return prodBrand;
	}

	public void setProdBrand(String prodBrand) {
		this.prodBrand = prodBrand;
	}

	public String getCntId() {
		return cntId;
	}

	public void setCntId(String cntId) {
		this.cntId = cntId;
	}

	public String getInstct() {
		return instct;
	}

	public void setInstct(String instct) {
		this.instct = instct;
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

	public GridDataSet<DocSubmissionVO> getDocSubmissionVOList() {
		return docSubmissionVOList;
	}

	public void setDocSubmissionVOList(GridDataSet<DocSubmissionVO> docSubmissionVOList) {
		this.docSubmissionVOList = docSubmissionVOList;
	}

	public List<DocSubmissionVO> getDocSubVOList() {
		return docSubVOList;
	}

	public void setDocSubVOList(List<DocSubmissionVO> docSubVOList) {
		this.docSubVOList = docSubVOList;
	}

	public SrvMembershipSalesVO getSrvMembershipSalesVO() {
		return srvMembershipSalesVO;
	}

	public void setSrvMembershipSalesVO(SrvMembershipSalesVO srvMembershipSalesVO) {
		this.srvMembershipSalesVO = srvMembershipSalesVO;
	}

	public SrvConfigurationVO getSrvConfigurationVO() {
		return srvConfigurationVO;
	}

	public void setSrvConfigurationVO(SrvConfigurationVO srvConfigurationVO) {
		this.srvConfigurationVO = srvConfigurationVO;
	}

	public List<SrvConfigSettingVO> getSrvConfigSettingVOList() {
		return srvConfigSettingVOList;
	}

	public void setSrvConfigSettingVOList(List<SrvConfigSettingVO> srvConfigSettingVOList) {
		this.srvConfigSettingVOList = srvConfigSettingVOList;
	}

	public SrvConfigPeriodVO getSrvConfigPeriodVO() {
		return srvConfigPeriodVO;
	}

	public void setSrvConfigPeriodVO(SrvConfigPeriodVO srvConfigPeriodVO) {
		this.srvConfigPeriodVO = srvConfigPeriodVO;
	}

	public List<SalesOrderLogVO> getSalesOrderLogVOList() {
		return salesOrderLogVOList;
	}

	public void setSalesOrderLogVOList(List<SalesOrderLogVO> salesOrderLogVOList) {
		this.salesOrderLogVOList = salesOrderLogVOList;
	}

	public InstallationVO getInstallationVO() {
		return installationVO;
	}

	public void setInstallationVO(InstallationVO installationVO) {
		this.installationVO = installationVO;
	}

	public int getCustTypeId() {
		return custTypeId;
	}

	public void setCustTypeId(int custTypeId) {
		this.custTypeId = custTypeId;
	}

	public int getRaceId() {
		return raceId;
	}

	public void setRaceId(int raceId) {
		this.raceId = raceId;
	}

	public int getOrderAppType() {
		return orderAppType;
	}

	public void setOrderAppType(int orderAppType) {
		this.orderAppType = orderAppType;
	}

	public String getsInstallDate() {
		return sInstallDate;
	}

	public void setsInstallDate(String sInstallDate) {
		this.sInstallDate = sInstallDate;
	}

	public int getItmStkId() {
		return itmStkId;
	}

	public void setItmStkId(int itmStkId) {
		this.itmStkId = itmStkId;
	}

	public String getdInstallDate() {
		return dInstallDate;
	}

	public void setdInstallDate(String dInstallDate) {
		this.dInstallDate = dInstallDate;
	}

	public int getOrderQuantity() {
		return orderQuantity;
	}

	public void setOrderQuantity(int orderQuantity) {
		this.orderQuantity = orderQuantity;
	}







}