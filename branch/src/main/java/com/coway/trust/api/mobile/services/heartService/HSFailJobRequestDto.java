package com.coway.trust.api.mobile.services.heartService;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HSFailJobRequestDto", description = "HSFailJobRequestDto")
public class HSFailJobRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static HSFailJobRequestDto create(String result) {
		HSFailJobRequestDto dto = new HSFailJobRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
