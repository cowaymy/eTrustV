package com.coway.trust.api.mobile.services.as;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ASFailJobRequestDto", description = "ASFailJobRequestDto")
public class ASFailJobRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static ASFailJobRequestDto create(String result) {
		ASFailJobRequestDto dto = new ASFailJobRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
