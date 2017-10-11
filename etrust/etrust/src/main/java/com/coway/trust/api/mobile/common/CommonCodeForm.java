package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "CommonCodeForm", description = "공통코드 Form")
public class CommonCodeForm {
	private static final int ALL = 99;

	@ApiModelProperty(value = "코드 Disable 여부(default : 99) [ 0 : enable, 1 : disable, " + ALL + " : all ]")
	private int codeDisab = ALL;

	public static Map<String, Object> createMap(CommonCodeForm commonCodeForm, int codeMasterId) {
		Map<String, Object> map = BeanConverter.toMap(commonCodeForm);
		map.put("codeMasterId", codeMasterId);
		return map;
	}

	public int getCodeDisab() {
		return codeDisab;
	}

	public void setCodeDisab(int codeDisab) {
		this.codeDisab = codeDisab;
	}

}
