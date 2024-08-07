package com.coway.trust.api.mobile.services.careService;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HSFailJobRequestDto", description = "HSFailJobRequestDto")
public class CSFailJobRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static CSFailJobRequestDto create(String result) {
		CSFailJobRequestDto dto = new CSFailJobRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
