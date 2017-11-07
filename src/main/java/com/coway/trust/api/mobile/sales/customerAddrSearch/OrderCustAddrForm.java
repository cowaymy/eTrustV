package com.coway.trust.api.mobile.sales.customerAddrSearch;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderCustAddrForm", description = "공통코드 Form")
public class OrderCustAddrForm {

	@ApiModelProperty(value = "customerId [default : '' 전체] 예) 665218 ", example = "1, 2, 3")
	private String customerId;

	public static Map<String, Object> createMap(OrderCustAddrForm orderCustAddrForm){
		Map<String, Object> params = new HashMap<>();
		params.put("customerId", orderCustAddrForm.getCustomerId());
		return params;
	}
	
	public String getCustomerId() {
		return customerId;
	}

	public void setCustomerId(String customerId) {
		this.customerId = customerId;
	}
	
	
}
