package com.coway.trust.api.mobile.services.dtAs;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModelProperty;

public class DtAfterServicePartsForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CT100583 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 20170505", example = "1, 2, 3")
	private String requestDate;



	public static Map<String, Object> createMap(DtAfterServicePartsForm afterServicePartsForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", afterServicePartsForm.getUserId());
		params.put("requestDate", afterServicePartsForm.getRequestDate());
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
