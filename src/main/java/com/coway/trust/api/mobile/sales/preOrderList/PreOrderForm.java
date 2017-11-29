package com.coway.trust.api.mobile.sales.preOrderList;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PreOrderForm", description = "공통코드 Form")
public class PreOrderForm {
	
	@ApiModelProperty(value = "userId [default : '' 전체] 예) 359 ", example = "359")
	private String userId;
	
	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 29/11/2017(DD/MM/YYYY) ", example = "29/11/2017")
	private String requestDate;

	public static Map<String, Object> createMap(PreOrderForm preOrderForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("userId", preOrderForm.getUserId());
		params.put("requestDate", preOrderForm.getRequestDate());
		
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}
}
