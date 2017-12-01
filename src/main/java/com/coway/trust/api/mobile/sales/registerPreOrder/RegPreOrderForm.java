package com.coway.trust.api.mobile.sales.registerPreOrder;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PreOrderForm", description = "공통코드 Form")
public class RegPreOrderForm {
	
	@ApiModelProperty(value = "userId [default : '' 전체] 예) 359 ", example = "359")
	private int customerId;
	
	@ApiModelProperty(value = "productId [default : '' 전체] 예) 5 ", example = "5")
	private int productId;
	
	@ApiModelProperty(value = "salesType [default : '' 전체] 예) 66 ", example = "66")
	private int salesType;
	
	@ApiModelProperty(value = "servicePeriod [default : '' 전체] 예) 60 ", example = "60")
	private int servicePeriod;
	
	@ApiModelProperty(value = "promotionCode [default : '' 전체] 예) 31620 ", example = "31620")
	private String promotionCode;
	
	@ApiModelProperty(value = "reOrderYN [default : '' 전체] 예) 0 ", example = "0")
	private int reOrderYN;
	
	@ApiModelProperty(value = "gstYN [default : '' 전체] 예) 0 ", example = "0")
	private int gstYN;
	
	@ApiModelProperty(value = "advPaymentYN [default : '' 전체] 예) 0 ", example = "0")
	private int advPaymentYN;
	
	@ApiModelProperty(value = "normalPriceRpfAmt [default : 0 전체] 예) 200 ", example = "200")
	private BigDecimal normalPriceRpfAmt;
	
	@ApiModelProperty(value = "finalPriceRpfAmt [default : 0 전체] 예) 60 ", example = "60")
	private BigDecimal finalPriceRpfAmt;
	
	@ApiModelProperty(value = "normalRentalFeeAmt [default : 0전체] 예) 100 ", example = "100")
	private BigDecimal normalRentalFeeAmt;
	
	@ApiModelProperty(value = "finalRentalFeeAmt [default : 0 전체] 예) 60 ", example = "60")
	private BigDecimal finalRentalFeeAmt;
	
	@ApiModelProperty(value = "totalPv [default : 0 전체] 예) 2340 ", example = "2340")
	private BigDecimal totalPv;
	
	@ApiModelProperty(value = "totalPvGst [default : 0 전체] 예) 2344 ", example = "2344")
	private BigDecimal totalPvGst;
	
	@ApiModelProperty(value = "priceId [default : 0 전체] 예) 106 ", example = "106")
	private int priceId;
	
	@ApiModelProperty(value = "memCode [default : '' 전체] 예) 100005 ", example = "100005")
	private String memCode;
	
	@ApiModelProperty(value = "sofNo [default : '' 전체] 예) AAA2825399 ", example = "AAA2825399")
	private String sofNo;
	
	@ApiModelProperty(value = "installDate [default : '' 전체] 예) 20171202 ", example = "20171202")
	private String installDate;
	
	@ApiModelProperty(value = "installTime [default : '' 전체] 예) 12:01:01 ", example = "12:01:01")
	private String installTime;
	
	@ApiModelProperty(value = "etcMemo [default : '' 전체] 예) test ", example = "test")
	private String etcMemo;
	
	@ApiModelProperty(value = "custAddrId [default : 0 전체] 예) 75417 ", example = "75417")
	private int custAddrId;

	@ApiModelProperty(value = "areaId [default : '' 전체] 예) 80350-0097 ", example = "80350-0097")
	private String areaId;
	
	@ApiModelProperty(value = "street [default : '' 전체] 예) Street ", example = "Street")
	private String street;
	
	@ApiModelProperty(value = "addDetail [default : '' 전체] 예) addDetail ", example = "addDetail")
	private String addDetail;
	
	@ApiModelProperty(value = "salesSubType [default : '' 전체] 예) 2 ", example = "2")
	private int salesSubType;
	
	@ApiModelProperty(value = "atchFileGrpId [default : '' 전체] 예) 111 ", example = "111")
	private int atchFileGrpId;

	@ApiModelProperty(value = "loginUserName [default : '' 전체] 예) IVYLIM ", example = "IVYLIM")
	private String loginUserName;

	public static Map<String, Object> createMap(RegPreOrderForm preOrderForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("customerId", preOrderForm.getCustomerId());
		params.put("productId", preOrderForm.getProductId());
		params.put("salesType", preOrderForm.getSalesType());
		params.put("servicePeriod", preOrderForm.getServicePeriod());
		params.put("promotionCode", preOrderForm.getPromotionCode());
		params.put("reOrderYN", preOrderForm.getReOrderYN());
		params.put("gstYN", preOrderForm.getGstYN());
		params.put("advPaymentYN", preOrderForm.getAdvPaymentYN());
		params.put("normalPriceRpfAmt", preOrderForm.getNormalPriceRpfAmt());
		params.put("finalPriceRpfAmt", preOrderForm.getFinalPriceRpfAmt());
		params.put("normalRentalFeeAmt", preOrderForm.getNormalRentalFeeAmt());
		params.put("finalRentalFeeAmt", preOrderForm.getFinalRentalFeeAmt());
		params.put("totalPv", preOrderForm.getTotalPv());
		params.put("totalPvGst", preOrderForm.getTotalPvGst());
		params.put("priceId", preOrderForm.getPriceId());
		params.put("memCode", preOrderForm.getMemCode());
		params.put("sofNo", preOrderForm.getSofNo());
		params.put("installDate", preOrderForm.getInstallDate());
		params.put("installTime", preOrderForm.getInstallTime());
		params.put("etcMemo", preOrderForm.getEtcMemo());
		params.put("custAddrId", preOrderForm.getCustAddrId());
		params.put("areaId", preOrderForm.getAreaId());
		params.put("street", preOrderForm.getStreet());
		params.put("addDetail", preOrderForm.getAddDetail());
		params.put("salesSubType", preOrderForm.getSalesSubType());
		params.put("atchFileGrpId", preOrderForm.getAtchFileGrpId());
		params.put("loginUserName", preOrderForm.getLoginUserName());
		
		return params;
	}

	public int getCustomerId() {
		return customerId;
	}

	public void setCustomerId(int customerId) {
		this.customerId = customerId;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public int getSalesType() {
		return salesType;
	}

	public void setSalesType(int salesType) {
		this.salesType = salesType;
	}

	public int getServicePeriod() {
		return servicePeriod;
	}

	public void setServicePeriod(int servicePeriod) {
		this.servicePeriod = servicePeriod;
	}

	public String getPromotionCode() {
		return promotionCode;
	}

	public void setPromotionCode(String promotionCode) {
		this.promotionCode = promotionCode;
	}

	public int getReOrderYN() {
		return reOrderYN;
	}

	public void setReOrderYN(int reOrderYN) {
		this.reOrderYN = reOrderYN;
	}

	public int getGstYN() {
		return gstYN;
	}

	public void setGstYN(int gstYN) {
		this.gstYN = gstYN;
	}

	public int getAdvPaymentYN() {
		return advPaymentYN;
	}

	public void setAdvPaymentYN(int advPaymentYN) {
		this.advPaymentYN = advPaymentYN;
	}

	public BigDecimal getNormalPriceRpfAmt() {
		return normalPriceRpfAmt;
	}

	public void setNormalPriceRpfAmt(BigDecimal normalPriceRpfAmt) {
		this.normalPriceRpfAmt = normalPriceRpfAmt;
	}

	public BigDecimal getFinalPriceRpfAmt() {
		return finalPriceRpfAmt;
	}

	public void setFinalPriceRpfAmt(BigDecimal finalPriceRpfAmt) {
		this.finalPriceRpfAmt = finalPriceRpfAmt;
	}

	public BigDecimal getNormalRentalFeeAmt() {
		return normalRentalFeeAmt;
	}

	public void setNormalRentalFeeAmt(BigDecimal normalRentalFeeAmt) {
		this.normalRentalFeeAmt = normalRentalFeeAmt;
	}

	public BigDecimal getFinalRentalFeeAmt() {
		return finalRentalFeeAmt;
	}

	public void setFinalRentalFeeAmt(BigDecimal finalRentalFeeAmt) {
		this.finalRentalFeeAmt = finalRentalFeeAmt;
	}

	public BigDecimal getTotalPv() {
		return totalPv;
	}

	public void setTotalPv(BigDecimal totalPv) {
		this.totalPv = totalPv;
	}

	public BigDecimal getTotalPvGst() {
		return totalPvGst;
	}

	public void setTotalPvGst(BigDecimal totalPvGst) {
		this.totalPvGst = totalPvGst;
	}

	public int getPriceId() {
		return priceId;
	}

	public void setPriceId(int priceId) {
		this.priceId = priceId;
	}

	public String getMemCode() {
		return memCode;
	}

	public void setMemCode(String memCode) {
		this.memCode = memCode;
	}

	public String getSofNo() {
		return sofNo;
	}

	public void setSofNo(String sofNo) {
		this.sofNo = sofNo;
	}

	public String getInstallDate() {
		return installDate;
	}

	public void setInstallDate(String installDate) {
		this.installDate = installDate;
	}

	public String getInstallTime() {
		return installTime;
	}

	public void setInstallTime(String installTime) {
		this.installTime = installTime;
	}

	public String getEtcMemo() {
		return etcMemo;
	}

	public void setEtcMemo(String etcMemo) {
		this.etcMemo = etcMemo;
	}

	public int getCustAddrId() {
		return custAddrId;
	}

	public void setCustAddrId(int custAddrId) {
		this.custAddrId = custAddrId;
	}

	public String getAreaId() {
		return areaId;
	}

	public void setAreaId(String areaId) {
		this.areaId = areaId;
	}

	public String getStreet() {
		return street;
	}

	public void setStreet(String street) {
		this.street = street;
	}

	public String getAddDetail() {
		return addDetail;
	}

	public void setAddDetail(String addDetail) {
		this.addDetail = addDetail;
	}

	public int getSalesSubType() {
		return salesSubType;
	}

	public void setSalesSubType(int salesSubType) {
		this.salesSubType = salesSubType;
	}

	public int getAtchFileGrpId() {
		return atchFileGrpId;
	}

	public void setAtchFileGrpId(int atchFileGrpId) {
		this.atchFileGrpId = atchFileGrpId;
	}

	public String getLoginUserName() {
		return loginUserName;
	}

	public void setLoginUserName(String loginUserName) {
		this.loginUserName = loginUserName;
	}

}
