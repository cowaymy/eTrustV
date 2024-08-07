package com.coway.trust.api.mobile.services.dtRc;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DtRentalCollectionListForm", description = "공통코드 Form")
public class DtRentalCollectionListForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CT100559 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "requestDate [default : '' 전체] 예) 201706", example = "1, 2, 3")
	private String requestDate;


	public static Map<String, Object> createMap(DtRentalCollectionListForm DtRentalCollectionListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", DtRentalCollectionListForm.getUserId());
		params.put("requestDate", DtRentalCollectionListForm.getRequestDate());
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
