package com.coway.trust.api.mobile.services.asFromCody;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.common.userProfileApi.UserProfileApiDto;
import com.coway.trust.util.BeanConverter;

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

@ApiModel(value = "AsFromCodyDto", description = "AsFromCody Dto")
public class AsFromCodyDto {

		@SuppressWarnings("unchecked")
		public static AsFromCodyDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, AsFromCodyDto.class);
	}

		public static Map<String, Object> createMap(AsFromCodyDto asFromCodyForm){
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

		    return params;
		  }


	private String userId;
	private String custName;
	private String salesOrderNo;
	private String productCode;
	private String productName;
	private String appType;
	private String salesPromotion;
	private String contractDuration;
	private String outstanding;
	private String sirimNo;
	private String serialNo;
	private String membershipContractExpiry;
	private String dscCode;
	private String prodCat;
	private String regId;
	private String stus;
	private String defectCode;
	private String defectDesc;


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

}
