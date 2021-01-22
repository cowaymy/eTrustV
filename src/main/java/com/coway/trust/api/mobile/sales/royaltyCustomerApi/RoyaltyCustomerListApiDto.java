package com.coway.trust.api.mobile.sales.royaltyCustomerApi;

import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import java.math.BigDecimal;
import java.util.List;



@ApiModel(value = "RoyaltyCustomerListApiDto", description = "RoyaltyCustomerListApiDto")
public class RoyaltyCustomerListApiDto {

	@SuppressWarnings("unchecked")
	public static RoyaltyCustomerListApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, RoyaltyCustomerListApiDto.class);
	}

	private String stkDesc;
	private int stkCtgryId;
	private int unit;
	private int outst;
	private int usageMth;
	private String ctgryDesc;

/*	@ApiModelProperty(value = "waterPurifierResult")
	private List<waterPurifierResult> waterPurifierResult;*/

	private String regId; //666
	private int loyaltyId;
	private int salesOrdId;
	private String salesOrdNo;
	private String hpCode;
	private int custId;
	private String custName;
	private String telM;
	private String telR;
	private String telO;
	private String email;
	private String instAddLine1;
	private String instAddLine2;
	private String instArea;
	private String instPostcode;
	private String instCity;
	private String instState;

	private int totOutst;
	private int totOrderInUse;
	private int wpInUse;
	private int wpTotOutst;
	private int apInUse;
	private int apTotOutst;
	private int mattressInUse;
	private int mattressTotOutst;
	private int poeInUse;
	private int poeTotOutst;
	private int softenerInUse;
	private int softenerTotOutst;
	private int bidetInUse;
	private int bidetTotOutst;

	private int hpCallReasonCode;
	private String hpCallRemark;

	//private int stus;
	private String stus;

	private String remark;
	private int crtUserId;
	//private String crtDt;
	private int updUserId;
	//private String updDt;
	//private String hpViewStartDt;
	//private String hpViewEndDt;
	//private int hpAssgnmtUploadId;

/*	public List<waterPurifierResult> getWaterPurifierResult() {
		return waterPurifierResult;
	}
	public void setWaterPurifierResult(List<waterPurifierResult> waterPurifierResult) {
		this.waterPurifierResult = waterPurifierResult;
	}*/

	public String getRegId() {
		return regId;
	}
	public void setRegId(String regId) {
		this.regId = regId;
	}
	public int getLoyaltyId() {
		return loyaltyId;
	}
	public void setLoyaltyId(int loyaltyId) {
		this.loyaltyId = loyaltyId;
	}
	public int getSalesOrdId() {
		return salesOrdId;
	}
	public void setSalesOrdId(int salesOrdId) {
		this.salesOrdId = salesOrdId;
	}
	public String getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}
	public String getHpCode() {
		return hpCode;
	}
	public void setHpCode(String hpCode) {
		this.hpCode = hpCode;
	}
	public int getCustId() {
		return custId;
	}
	public void setCustId(int custId) {
		this.custId = custId;
	}
	public String getCustName() {
		return custName;
	}
	public void setCustName(String custName) {
		this.custName = custName;
	}
	public String getTelM() {
		return telM;
	}
	public void setTelM(String telM) {
		this.telM = telM;
	}
	public String getTelR() {
		return telR;
	}
	public void setTelR(String telR) {
		this.telR = telR;
	}
	public String getTelO() {
		return telO;
	}
	public void setTelO(String telO) {
		this.telO = telO;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getInstAddLine1() {
		return instAddLine1;
	}
	public void setInstAddLine1(String instAddLine1) {
		this.instAddLine1 = instAddLine1;
	}
	public String getInstAddLine2() {
		return instAddLine2;
	}
	public void setInstAddLine2(String instAddLine2) {
		this.instAddLine2 = instAddLine2;
	}
	public String getInstArea() {
		return instArea;
	}
	public void setInstArea(String instArea) {
		this.instArea = instArea;
	}
	public String getInstPostcode() {
		return instPostcode;
	}
	public void setInstPostcode(String instPostcode) {
		this.instPostcode = instPostcode;
	}
	public String getInstCity() {
		return instCity;
	}
	public void setInstCity(String instCity) {
		this.instCity = instCity;
	}
	public String getInstState() {
		return instState;
	}
	public void setInstState(String instState) {
		this.instState = instState;
	}
	public int getTotOutst() {
		return totOutst;
	}
	public void setTotOutst(int totOutst) {
		this.totOutst = totOutst;
	}
	public int getTotOrderInUse() {
		return totOrderInUse;
	}
	public void setTotOrderInUse(int totOrderInUse) {
		this.totOrderInUse = totOrderInUse;
	}
	public int getWpInUse() {
		return wpInUse;
	}
	public void setWpInUse(int wpInUse) {
		this.wpInUse = wpInUse;
	}
	public int getWpTotOutst() {
		return wpTotOutst;
	}
	public void setWpTotOutst(int wpTotOutst) {
		this.wpTotOutst = wpTotOutst;
	}
	public int getApInUse() {
		return apInUse;
	}
	public void setApInUse(int apInUse) {
		this.apInUse = apInUse;
	}
	public int getApTotOutst() {
		return apTotOutst;
	}
	public void setApTotOutst(int apTotOutst) {
		this.apTotOutst = apTotOutst;
	}
	public int getMattressInUse() {
		return mattressInUse;
	}
	public void setMattressInUse(int mattressInUse) {
		this.mattressInUse = mattressInUse;
	}
	public double getMattressTotOutst() {
		return mattressTotOutst;
	}
	public void setMattressTotOutst(int mattressTotOutst) {
		this.mattressTotOutst = mattressTotOutst;
	}
	public int getPoeInUse() {
		return poeInUse;
	}
	public void setPoeInUse(int poeInUse) {
		this.poeInUse = poeInUse;
	}
	public double getPoeTotOutst() {
		return poeTotOutst;
	}
	public void setPoeTotOutst(int poeTotOutst) {
		this.poeTotOutst = poeTotOutst;
	}
	public int getSoftenerInUse() {
		return softenerInUse;
	}
	public void setSoftenerInUse(int softenerInUse) {
		this.softenerInUse = softenerInUse;
	}
	public int getSoftenerTotOutst() {
		return softenerTotOutst;
	}
	public void setSoftenerTotOutst(int softenerTotOutst) {
		this.softenerTotOutst = softenerTotOutst;
	}
	public int getBidetInUse() {
		return bidetInUse;
	}
	public void setBidetInUse(int bidetInUse) {
		this.bidetInUse = bidetInUse;
	}
	public int getBidetTotOutst() {
		return bidetTotOutst;
	}
	public void setBidetTotOutst(int bidetTotOutst) {
		this.bidetTotOutst = bidetTotOutst;
	}
	public int getHpCallReasonCode() {
		return hpCallReasonCode;
	}
	public void setHpCallReasonCode(int hpCallReasonCode) {
		this.hpCallReasonCode = hpCallReasonCode;
	}
	public String getHpCallRemark() {
		return hpCallRemark;
	}
	public void setHpCallRemark(String hpCallRemark) {
		this.hpCallRemark = hpCallRemark;
	}
	public String getStus() {
		return stus;
	}
	public void setStus(String stus) {
		this.stus = stus;
	}
	public String getRemark() {
		return remark;
	}
	public void setRemark(String remark) {
		this.remark = remark;
	}
	public int getCrtUserId() {
		return crtUserId;
	}
	public void setCrtUserId(int crtUserId) {
		this.crtUserId = crtUserId;
	}
	/*public String getCrtDt() {
		return crtDt;
	}
	public void setCrtDt(String crtDt) {
		this.crtDt = crtDt;
	}*/
	public int getUpdUserId() {
		return updUserId;
	}
	public void setUpdUserId(int updUserId) {
		this.updUserId = updUserId;
	}
	/*public String getUpdDt() {
		return updDt;
	}
	public void setUpdDt(String updDt) {
		this.updDt = updDt;
	}*/
  /*public String getHpViewStartDt() {
		return hpViewStartDt;
	}
	public void setHpViewStartDt(String hpViewStartDt) {
		this.hpViewStartDt = hpViewStartDt;
	}
	public String getHpViewEndDt() {
		return hpViewEndDt;
	}
	public void setHpViewEndDt(String hpViewEndDt) {
		this.hpViewEndDt = hpViewEndDt;
	}*/
	/*public int getHpAssgnmtUploadId() {
		return hpAssgnmtUploadId;
	}
	public void setHpAssgnmtUploadId(int hpAssgnmtUploadId) {
		this.hpAssgnmtUploadId = hpAssgnmtUploadId;
	}*/

	public String getStkDesc() {
		return stkDesc;
	}
	public void setStkDesc(String stkDesc) {
		this.stkDesc = stkDesc;
	}
	public int getStkCtgryId() {
		return stkCtgryId;
	}
	public void setStkCtgryId(int stkCtgryId) {
		this.stkCtgryId = stkCtgryId;
	}
	public int getUnit() {
		return unit;
	}
	public void setUnit(int unit) {
		this.unit = unit;
	}
	public int getOutst() {
		return outst;
	}
	public void setOutst(int outst) {
		this.outst = outst;
	}
	public int getUsageMth() {
		return usageMth;
	}
	public void setUsageMth(int usageMth) {
		this.usageMth = usageMth;
	}
	public String getCtgryDesc() {
		return ctgryDesc;
	}
	public void setCtgryDesc(String ctgryDesc) {
		this.ctgryDesc = ctgryDesc;
	}



}
