package com.coway.trust.api.mobile.services.asFromCody;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @History
 *
 * This is to capture the AS records from Cody via mobile. The captured records is subject for approval before treat as a Real AS.
 * The objective is to simplified the business flow example, Cody may not require to manual send massage to DSCP or Admin for potential AS.
 * Author : Alex Lau dated on 7/7/2022
 */

@ApiModel(value = "AsFromCodyForm", description = "AsFromCody Form")
public class AsFromCodyForm {

	@ApiModelProperty(value = "userId")
	private String userId;

	@ApiModelProperty(value = "custName")
	private String custName;

	@ApiModelProperty(value = "salesOrderNo")
	private String salesOrderNo;

	@ApiModelProperty(value = "productCode")
	private String productCode;

	@ApiModelProperty(value = "productName")
	private String productName;

	@ApiModelProperty(value = "appType")
	private String appType;

	@ApiModelProperty(value = "salesPromotion")
	private String salesPromotion;

	@ApiModelProperty(value = "contractDuration")
	private String contractDuration;

	@ApiModelProperty(value = "outstanding")
	private String outstanding;

	@ApiModelProperty(value = "sirimNo")
	private String sirimNo;

	@ApiModelProperty(value = "serialNo")
	private String serialNo;

	@ApiModelProperty(value = "membershipContractExpiry")
	private String membershipContractExpiry;

	@ApiModelProperty(value = "dscCode")
	private String dscCode;

	@ApiModelProperty(value = "prodCat")
	private String prodCat;

	@ApiModelProperty(value = "regId")
	private String regId;

	@ApiModelProperty(value = "stus")
	private String stus;

	@ApiModelProperty(value = "defectCode")
	private String defectCode;

	@ApiModelProperty(value = "defectDesc")
	private String defectDesc;

	@ApiModelProperty(value = "handphoneTel")
	private String handphoneTel;

	@ApiModelProperty(value = "homeTel")
	private String homeTel;

	@ApiModelProperty(value = "officeTel")
	private String officeTel;

	@ApiModelProperty(value = "mailAddress")
	private String mailAddress;

	@ApiModelProperty(value = "resulticMobileNo")
	private String resulticMobileNo;

	@ApiModelProperty(value = "customerId")
	private String customerId;

	@ApiModelProperty(value = "customerType")
	private String customerType;

	@ApiModelProperty(value = "corpTypeId")
	private String corpTypeId;

	@ApiModelProperty(value = "customerVaNo")
	private String customerVaNo;

	@ApiModelProperty(value = "fromDate")
	private String fromDate;

	@ApiModelProperty(value = "toDate")
	private String toDate;

	@ApiModelProperty(value = "remark")
	private String remark;



	public String getRemark() {
		return remark;
	}

	public void setRemark(String remark) {
		this.remark = remark;
	}

	public String getHandphoneTel() {
		return handphoneTel;
	}

	public String getHomeTel() {
		return homeTel;
	}

	public String getOfficeTel() {
		return officeTel;
	}

	public String getMailAddress() {
		return mailAddress;
	}

	public String getResulticMobileNo() {
		return resulticMobileNo;
	}

	public String getCustomerId() {
		return customerId;
	}

	public String getCustomerType() {
		return customerType;
	}

	public String getCorpTypeId() {
		return corpTypeId;
	}

	public String getCustomerVaNo() {
		return customerVaNo;
	}

	public void setHandphoneTel(String handphoneTel) {
		this.handphoneTel = handphoneTel;
	}

	public void setHomeTel(String homeTel) {
		this.homeTel = homeTel;
	}

	public void setOfficeTel(String officeTel) {
		this.officeTel = officeTel;
	}

	public void setMailAddress(String mailAddress) {
		this.mailAddress = mailAddress;
	}

	public void setResulticMobileNo(String resulticMobileNo) {
		this.resulticMobileNo = resulticMobileNo;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}

	public void setCorpTypeId(String corpTypeId) {
		this.corpTypeId = corpTypeId;
	}

	public void setCustomerVaNo(String customerVaNo) {
		this.customerVaNo = customerVaNo;
	}

	public String getDefectCode() {
		return defectCode;
	}

	public String getDefectDesc() {
		return defectDesc;
	}

	public void setDefectCode(String defectCode) {
		this.defectCode = defectCode;
	}

	public void setDefectDesc(String defectDesc) {
		this.defectDesc = defectDesc;
	}

	public String getUserId() {
		return userId;
	}

	public String getCustName() {
		return custName;
	}

	public String getSalesOrderNo() {
		return salesOrderNo;
	}

	public String getProductCode() {
		return productCode;
	}

	public String getProductName() {
		return productName;
	}

	public String getAppType() {
		return appType;
	}

	public String getSalesPromotion() {
		return salesPromotion;
	}

	public String getContractDuration() {
		return contractDuration;
	}

	public String getOutstanding() {
		return outstanding;
	}

	public String getSirimNo() {
		return sirimNo;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public String getMembershipContractExpiry() {
		return membershipContractExpiry;
	}

	public String getDscCode() {
		return dscCode;
	}

	public String getProdCat() {
		return prodCat;
	}

	public String getRegId() {
		return regId;
	}

	public String getStus() {
		return stus;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public void setCustName(String custName) {
		this.custName = custName;
	}

	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public void setAppType(String appType) {
		this.appType = appType;
	}

	public void setSalesPromotion(String salesPromotion) {
		this.salesPromotion = salesPromotion;
	}

	public void setContractDuration(String contractDuration) {
		this.contractDuration = contractDuration;
	}

	public void setOutstanding(String outstanding) {
		this.outstanding = outstanding;
	}

	public void setSirimNo(String sirimNo) {
		this.sirimNo = sirimNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

	public void setMembershipContractExpiry(String membershipContractExpiry) {
		this.membershipContractExpiry = membershipContractExpiry;
	}

	public void setDscCode(String dscCode) {
		this.dscCode = dscCode;
	}

	public void setProdCat(String prodCat) {
		this.prodCat = prodCat;
	}


	public void setRegId(String regId) {
		this.regId = regId;
	}

	public void setStus(String stus) {
		this.stus = stus;
	}

	public String getFromDate() {
		return fromDate;
	}

	public String getToDate() {
		return toDate;
	}

	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}

	public void setToDate(String toDate) {
		this.toDate = toDate;
	}

public static Map<String, Object> createMap(AsFromCodyForm asFromCodyForm){
    Map<String, Object> params = new HashMap<>();

    params.put("userId", asFromCodyForm.getUserId());
    params.put("custName", asFromCodyForm.getCustName());
    params.put("salesOrderNo", 	asFromCodyForm.getSalesOrderNo());
    params.put("productCode", asFromCodyForm.getProductCode());
    params.put("productName", asFromCodyForm.getProductName());
    params.put("appType", asFromCodyForm.getAppType());
    params.put("salesPromotion", asFromCodyForm.getSalesPromotion());
    params.put("contractDuration", asFromCodyForm.getContractDuration());
    params.put("outstanding", asFromCodyForm.getOutstanding());
    params.put("sirimNo", asFromCodyForm.getSirimNo());
    params.put("serialNo", asFromCodyForm.getSerialNo());
    params.put("membershipContractExpiry", asFromCodyForm.getMembershipContractExpiry());
    params.put("dscCode", asFromCodyForm.getDscCode());
    params.put("prodCat", asFromCodyForm.getProdCat());
    params.put("regId", asFromCodyForm.getRegId());
    params.put("stus", asFromCodyForm.getStus());
    params.put("defectCode", asFromCodyForm.getDefectCode());
    params.put("defectDesc", asFromCodyForm.getDefectDesc());
    params.put("fromDate", asFromCodyForm.getFromDate());
    params.put("toDate", asFromCodyForm.getToDate());
    params.put("remark", asFromCodyForm.getRemark());

    return params;
  }


}
