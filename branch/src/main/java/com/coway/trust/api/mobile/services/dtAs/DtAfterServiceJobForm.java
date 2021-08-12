package com.coway.trust.api.mobile.services.dtAs;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceJobForm", description = "공통코드 Form")
public class DtAfterServiceJobForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CT100583 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201705", example = "1, 2, 3")
	private String requestDate;



	public static Map<String, Object> createMap(DtAfterServiceJobForm afterServiceJobForm) {
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
