package com.coway.trust.api.mobile.services.heartService;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModelProperty;

public class HeartServiceResultDto {

	@ApiModelProperty(value = "결과값")
	private String result;

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}
	
	
	
	public static HeartServiceResultDto create(EgovMap egovMap) {
		return BeanConverter.toBean(egovMap, HeartServiceResultDto.class);
	}
	
}
