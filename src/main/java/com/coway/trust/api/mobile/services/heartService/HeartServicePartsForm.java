package com.coway.trust.api.mobile.services.heartService;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServicePartsForm", description = "공통코드 Form")
public class HeartServicePartsForm {

	
	@ApiModelProperty(value = "userId [default : '' 전체] 예) CD100975 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201706", example = "1, 2, 3")
	private String requestDate;

	
	
	public static Map<String, Object> createMap(HeartServicePartsForm HeartServicePartsForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", HeartServicePartsForm.getUserId());
		params.put("requestDate", HeartServicePartsForm.getRequestDate());
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
