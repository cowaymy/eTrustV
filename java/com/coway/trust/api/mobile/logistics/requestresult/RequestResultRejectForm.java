package com.coway.trust.api.mobile.logistics.requestresult;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RequestResultRejectForm", description = "RequestResultRejectForm")
public class RequestResultRejectForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) T120", example = "T120")
	private String userId;

	@ApiModelProperty(value = "요청일(YYYYMMDD) 20171031", example = "20171031")
	private String requestDate;

	@ApiModelProperty(value = "SMO no", example = "SMO.....")
	private String smoNo;

	public static Map<String, Object> createMap(RequestResultRejectForm requestResultRejectForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", requestResultRejectForm.getUserId());
		params.put("requestDate", requestResultRejectForm.getRequestDate());
		params.put("smoNo", requestResultRejectForm.getSmoNo());
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

	public String getSmoNo() {
		return smoNo;
	}

	public void setSmoNo(String smoNo) {
		this.smoNo = smoNo;
	}

}
