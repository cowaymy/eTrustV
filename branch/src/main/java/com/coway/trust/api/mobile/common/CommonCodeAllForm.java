package com.coway.trust.api.mobile.common;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "CommonCodeForm", description = "공통코드 Form")
public class CommonCodeAllForm {

	@ApiModelProperty(value = "마스터 코드 IDs [default : '' 전체] 예) 1,2",  example = "1, 2")
	private String codeList;

	public static Map<String, Object> createMap(CommonCodeAllForm commonCodeForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("codeMasterIds", commonCodeForm.getCodeList());
		return params;
	}

	public String getCodeList() {
		return codeList;
	}

	public void setCodeList(String codeList) {
		this.codeList = codeList;
	}

}
