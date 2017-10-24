package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "DefectDetailForm", description = "DefectDetailForm")
public class DefectDetailForm {

	public static Map<String, Object> createMap(DefectDetailForm defectDetailForm) {
		Map<String, Object> map = BeanConverter.toMap(defectDetailForm);
		return map;
	}

}
