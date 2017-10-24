package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "DefectMasterForm", description = "DefectMasterForm")
public class DefectMasterForm {

	public static Map<String, Object> createMap(DefectMasterForm defectMasterForm) {
		Map<String, Object> map = BeanConverter.toMap(defectMasterForm);
		return map;
	}

}
