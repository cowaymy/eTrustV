package com.coway.trust.api.mobile.sales.preOrderList;

import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PreOrderDto", description = "Pre-Order Dto")
public class PreOrderDto {
	
	@ApiModelProperty(value = "custName")
	private String custName;
	
	@ApiModelProperty(value = "salesOrderNo")
	private String salesOrderNo;

	@ApiModelProperty(value = "customerType")
	private int customerType;

	@ApiModelProperty(value = "appType")
	private String appType;

	@ApiModelProperty(value = "requestDate")
	private String requestDate;

	@ApiModelProperty(value = "preOrderStatus")
	private String preOrderStatus;

	@ApiModelProperty(value = "sofNo")
	private String sofNo;
	
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

	public int getCustomerType() {
		return customerType;
	}

	public void setCustomerType(int customerType) {
		this.customerType = customerType;
	}

	public String getAppType() {
		return appType;
	}

	public void setAppType(String appType) {
		this.appType = appType;
	}

	public String getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}

	public String getPreOrderStatus() {
		return preOrderStatus;
	}

	public void setPreOrderStatus(String preOrderStatus) {
		this.preOrderStatus = preOrderStatus;
	}

	public String getSofNo() {
		return sofNo;
	}

	public void setSofNo(String sofNo) {
		this.sofNo = sofNo;
	}

	public static PreOrderDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, PreOrderDto.class);
	}
}
