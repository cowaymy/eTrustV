package com.coway.trust.api.mobile.services.as;

import io.swagger.annotations.ApiModelProperty;

public class ASRequestRegistDto {

	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}
	
	
	public void setResult(String result) {
		this.result = result;
	}
	
	public static ASRequestRegistDto create(String result) {
		ASRequestRegistDto dto = new ASRequestRegistDto();
		dto.setResult(result);
		
		return dto;
	}
	
}
