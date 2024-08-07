package com.coway.trust.api.mobile.services.as;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class ASRequestResultDto {

	
	private String custName;
	private String salesOrderNo;
	private String customerId;
	private String asRequestNo;
	private String asRequestDate;
	private String asRequestStatus;
	private String productCode;
	private String productName;
	
	

	
	public String getCustName() {
		return custName;
	}




	public void setCustName(String custName) {
		this.custName = custName;
	}




	public String getSalesOrderNo() {
		return salesOrderNo;
	}




	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}




	public String getCustomerId() {
		return customerId;
	}




	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}




	public String getAsRequestNo() {
		return asRequestNo;
	}




	public void setAsRequestNo(String asRequestNo) {
		this.asRequestNo = asRequestNo;
	}




	public String getAsRequestDate() {
		return asRequestDate;
	}




	public void setAsRequestDate(String asRequestDate) {
		this.asRequestDate = asRequestDate;
	}




	public String getAsRequestStatus() {
		return asRequestStatus;
	}




	public void setAsRequestStatus(String asRequestStatus) {
		this.asRequestStatus = asRequestStatus;
	}




	public String getProductCode() {
		return productCode;
	}




	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}




	public String getProductName() {
		return productName;
	}




	public void setProductName(String productName) {
		this.productName = productName;
	}




	public static ASRequestResultDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ASRequestResultDto.class);
	}
	
	

	
}
