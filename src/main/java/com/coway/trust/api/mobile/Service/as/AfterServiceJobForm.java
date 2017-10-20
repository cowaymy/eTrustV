package com.coway.trust.api.mobile.Service.as;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceJobForm", description = "공통코드 Form")
public class AfterServiceJobForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) 215682 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 20170124", example = "1, 2, 3")
	private String requestDate;

	
	
	public static Map<String, Object> createMap(AfterServiceJobForm afterServiceJobForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", afterServiceJobForm.getUserId());
		params.put("requestDate", afterServiceJobForm.getRequestDate());
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
