package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DisplayCt_CodyListForm", description = "공통코드 Form")
public class DisplayCt_CodyListForm {

	@ApiModelProperty(value = "사용자 ID 예) CT100069,YUZAIREEN",  example = "CT100069,YUZAIREEN")
	private String userId;
	
	@ApiModelProperty(value = "부품코드 예) 100750,3002284,100752,3300516",  example = "100750,3002284,100752,3300516")
	private String partsCode;

	
	public static Map<String, Object> createMap(DisplayCt_CodyListForm DisplayCt_CodyListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", DisplayCt_CodyListForm.getUserId());
		params.put("partsCode", DisplayCt_CodyListForm.getPartsCode());
		return params;
	}


	public String getUserId() {
		return userId;
	}


	public void setUserId(String userId) {
		this.userId = userId;
	}


	public String getPartsCode() {
		return partsCode;
	}


	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

	

	
	
}
