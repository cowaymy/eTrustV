package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "ReasonCodeForm", description = "ReasonCodeForm")
public class ReasonCodeForm {

	public static Map<String, Object> createMap(ReasonCodeForm reasonCodeForm) {
		Map<String, Object> map = BeanConverter.toMap(reasonCodeForm);
		return map;
	}

}
