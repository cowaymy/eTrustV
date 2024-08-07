package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "MalfunctionCodeForm", description = "MalfunctionCodeForm")
public class MalfunctionCodeForm {

	public static Map<String, Object> createMap(MalfunctionCodeForm malfunctionCodeForm) {
		Map<String, Object> map = BeanConverter.toMap(malfunctionCodeForm);
		return map;
	}

}
