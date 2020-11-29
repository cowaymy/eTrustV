package com.coway.trust.api.mobile.sales.royaltyCustomerApi;

import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import java.math.BigDecimal;



@ApiModel(value = "RoyaltyCustomerListApiDto", description = "RoyaltyCustomerListApiDto")
public class RoyaltyCustomerListApiDto {

	@SuppressWarnings("unchecked")
	public static RoyaltyCustomerListApiDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, RoyaltyCustomerListApiDto.class);
	}


	private int loyaltyId;
	private int salesOrdId;
	private int salesOrdNo;
	private int hpCode;
	private int custID;
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
	private double totOutst;
	private int totOrderInUse;
	private int wpInUse;
	private double wpTotOutst;
	private int apInUse;
	private double apTotOutst;
	private int mattressInUse;
	private double mattressTotOutst;
	private int poeInUse;
	private double poeTotOutst;
	private int softenerInUse;
	private double softenerTotOutst;
	private int bidetInUse;
	private double bidetTotOutst;
	private int hpCallReasonCode;
	private String hpCallRemark;
	private int stus;
	private String remark;
	private int crtUserId;
	private String crtDt;
	private int updUserId;
	private String updDt;
	private String hpViewStartDt;
	private String hpViewEndDt;
	private int hpAssgnmtUploadId;

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
	public int getSalesOrdNo() {
		return salesOrdNo;
	}
	public void setSalesOrdNo(int salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}
	public int getHpCode() {
		return hpCode;
	}
	public void setHpCode(int hpCode) {
		this.hpCode = hpCode;
	}
	public int getCustID() {
		return custID;
	}
	public void setCustID(int custID) {
		this.custID = custID;
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
	public double getTotOutst() {
		return totOutst;
	}
	public void setTotOutst(double totOutst) {
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
	public double getWpTotOutst() {
		return wpTotOutst;
	}
	public void setWpTotOutst(double wpTotOutst) {
		this.wpTotOutst = wpTotOutst;
	}
	public int getApInUse() {
		return apInUse;
	}
	public void setApInUse(int apInUse) {
		this.apInUse = apInUse;
	}
	public double getApTotOutst() {
		return apTotOutst;
	}
	public void setApTotOutst(double apTotOutst) {
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
	public void setMattressTotOutst(double mattressTotOutst) {
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
	public void setPoeTotOutst(double poeTotOutst) {
		this.poeTotOutst = poeTotOutst;
	}
	public int getSoftenerInUse() {
		return softenerInUse;
	}
	public void setSoftenerInUse(int softenerInUse) {
		this.softenerInUse = softenerInUse;
	}
	public double getSoftenerTotOutst() {
		return softenerTotOutst;
	}
	public void setSoftenerTotOutst(double softenerTotOutst) {
		this.softenerTotOutst = softenerTotOutst;
	}
	public int getBidetInUse() {
		return bidetInUse;
	}
	public void setBidetInUse(int bidetInUse) {
		this.bidetInUse = bidetInUse;
	}
	public double getBidetTotOutst() {
		return bidetTotOutst;
	}
	public void setBidetTotOutst(double bidetTotOutst) {
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
	public int getStus() {
		return stus;
	}
	public void setStus(int stus) {
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
	public String getHpViewStartDt() {
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
	}
	public int getHpAssgnmtUploadId() {
		return hpAssgnmtUploadId;
	}
	public void setHpAssgnmtUploadId(int hpAssgnmtUploadId) {
		this.hpAssgnmtUploadId = hpAssgnmtUploadId;
	}

}
