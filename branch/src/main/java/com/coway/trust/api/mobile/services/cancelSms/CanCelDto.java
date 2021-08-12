package com.coway.trust.api.mobile.services.cancelSms;

import io.swagger.annotations.ApiModelProperty;

public class CanCelDto {

	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static CanCelDto create(String result) {
		CanCelDto dto = new CanCelDto();
		dto.setResult(result);
		
		return dto;
	}
}
