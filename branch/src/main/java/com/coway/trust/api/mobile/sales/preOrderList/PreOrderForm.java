package com.coway.trust.api.mobile.sales.preOrderList;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PreOrderForm", description = "공통코드 Form")
public class PreOrderForm {
	
	@ApiModelProperty(value = "userName [default : '' 전체] 예) IVYLIM ", example = "IVYLIM")
	private String userName;
	
	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201712(YYYYMM) ", example = "201712")
	private String requestDate;

	public static Map<String, Object> createMap(PreOrderForm preOrderForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("userName", preOrderForm.getUserName());
		params.put("requestDate", preOrderForm.getRequestDate());
		
		return params;
	}

	public String getUserName() {
		return userName;
	}

	public void setUserName(String userName) {
		this.userName = userName;
	}

	public String getRequestDate() {
		return requestDate;
	}

	public void setRequestDate(String requestDate) {
		this.requestDate = requestDate;
	}
}
