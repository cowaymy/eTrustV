package com.coway.trust.api.mobile.logistics.ctcodylist;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DisplayCt_CodyListForm", description = "공통코드 Form")
public class DisplayCt_CodyListForm {

	@ApiModelProperty(value = "사용자 ID 예) C180,CT100069,YUZAIREEN", example = "CT100069,YUZAIREEN")
	private String userId;

	public static Map<String, Object> createMap(DisplayCt_CodyListForm DisplayCt_CodyListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", DisplayCt_CodyListForm.getUserId());
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
