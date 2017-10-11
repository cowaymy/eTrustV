package com.coway.trust.api.callcenter.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "CommonCodeForm", description = "공통코드 Form")
public class CommonCodeAllForm {

	public static Map<String, Object> createMap(CommonCodeAllForm commonCodeForm) {
		return BeanConverter.toMap(commonCodeForm);
	}

}
