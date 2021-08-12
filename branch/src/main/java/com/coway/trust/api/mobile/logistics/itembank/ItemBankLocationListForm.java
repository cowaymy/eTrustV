package com.coway.trust.api.mobile.logistics.itembank;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ItemBankLocationListForm", description = "ItemBankLocationListForm")
public class ItemBankLocationListForm {

	@ApiModelProperty(value = "사용자 ID 예) C180,CT100337,YUZAIREEN", example = "CT100337,YUZAIREEN")
	private String userId;

	public static Map<String, Object> createMap(ItemBankLocationListForm ItemBankLocationListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", ItemBankLocationListForm.getUserId());
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
