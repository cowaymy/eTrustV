package com.coway.trust.api.mobile.logistics.filterinventorydisplay;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class UserFilterListForm {

	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) CD100876", example = "CD100876")
	private String userId;

	@ApiModelProperty(value = "     예)    ", example = "")
	private String partsCode;

	@ApiModelProperty(value = "     예)     ", example = "")
	private int partsId;

	public static Map<String, Object> createMap(UserFilterListForm filterNotChangeListForm) {
		Map<String, Object> map = BeanConverter.toMap(filterNotChangeListForm);
		return map;
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

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

}
