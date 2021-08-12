package com.coway.trust.api.mobile.sales.customerSearch;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderCustomerForm", description = "공통코드 Form")
public class OrderCustomerForm {
	
	@ApiModelProperty(value = "nricCompanyNo [default : '' 전체] 예) 1234567890 ", example = "1, 2, 3")
	private String nricCompanyNo;
	
	@ApiModelProperty(value = "customerType [default : '' 전체] 예) 964 ", example = "1, 2, 3")
	private String customerType;
	
	public static Map<String, Object> createMap(OrderCustomerForm OrderCustomerForm){
		Map<String, Object> params = new HashMap<>();
		params.put("nricCompanyNo", OrderCustomerForm.getNricCompanyNo());
		params.put("customerType", OrderCustomerForm.getCustomerType());
		return params;
	}

	public String getNricCompanyNo() {
		return nricCompanyNo;
	}

	public void setNricCompanyNo(String nricCompanyNo) {
		this.nricCompanyNo = nricCompanyNo;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	
	

}
