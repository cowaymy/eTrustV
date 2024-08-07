package com.coway.trust.api.mobile.logistics.hiCare;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HiCareInventoryForm", description = "Hi Care Inventory Form")
public class HiCareInventoryForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CD101707", example = "CD101707")
	private String userNm;

	public static Map<String, Object> createMap(HiCareInventoryForm hiCareInventoryForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userNm", hiCareInventoryForm.getUserNm());
		return params;
	}

	public String getUserNm() {
		return userNm;
	}

	public void setUserNm(String userNm) {
		this.userNm = userNm;
	}
}
