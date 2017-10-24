package com.coway.trust.api.mobile.logistics.mystock;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MyStockListForm", description = "공통코드 Form")
public class MyStockListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) T120", example = "T120")
	private String userId;


	public static Map<String, Object> createMap(MyStockListForm MyStockListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", MyStockListForm.getUserId());
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
