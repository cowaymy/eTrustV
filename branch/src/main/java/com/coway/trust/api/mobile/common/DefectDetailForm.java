package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DefectDetailForm", description = "DefectDetailForm")
public class DefectDetailForm {
	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) T120", example = "T120")
	private String userId;

	public static Map<String, Object> createMap(DefectDetailForm defectDetailForm) {
		Map<String, Object> map = BeanConverter.toMap(defectDetailForm);
		return map;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
