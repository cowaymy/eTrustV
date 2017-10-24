package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "MalfunctionReasonForm", description = "MalfunctionReasonForm")
public class MalfunctionReasonForm {

	public static Map<String, Object> createMap(MalfunctionReasonForm malfunctionReasonForm) {
		Map<String, Object> map = BeanConverter.toMap(malfunctionReasonForm);
		return map;
	}

}
