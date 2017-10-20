package com.coway.trust.api.mobile.Service.heartService;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.stockbyholder.StockByHolderQtyForm;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;



@ApiModel(value = "HeartServiceJobForm", description = "공통코드 Form")
public class HeartServiceJobForm {
	
	
	@ApiModelProperty(value = "userId [default : '' 전체] 예) 535736 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201706", example = "1, 2, 3")
	private String requestDate;
	
	
	public static Map<String, Object> createMap(HeartServiceJobForm HeartServiceJobForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", HeartServiceJobForm.getUserId());
		params.put("requestDate", HeartServiceJobForm.getRequestDate());
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
