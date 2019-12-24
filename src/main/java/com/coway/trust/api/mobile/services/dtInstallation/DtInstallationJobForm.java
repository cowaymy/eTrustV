package com.coway.trust.api.mobile.services.dtInstallation;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationJobForm", description = "공통코드 Form")
public class DtInstallationJobForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CT100559 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201706", example = "1, 2, 3")
	private String requestDate;
	
	
	
	public static Map<String, Object> createMap(DtInstallationJobForm InstallationJobForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", InstallationJobForm.getUserId());
		params.put("requestDate", InstallationJobForm.getRequestDate());
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
