package com.coway.trust.api.mobile.services.as;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;

public class ASRequestCustDto {

	private String custName;
	private String salesOrderNo;
	private String customerId;
	private String productCode;
	private String productName;
	private String serialNo;
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
	public String getSerialNo() {
		return serialNo;
	}
	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	
	
	public static ASRequestCustDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, ASRequestCustDto.class);
	}
	
	
}
