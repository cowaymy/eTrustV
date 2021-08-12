package com.coway.trust.api.mobile.services.productRetrun;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PRFailJobRequestDto", description = "PRFailJobRequestDto")
public class PRFailJobRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static PRFailJobRequestDto create(String result) {
		PRFailJobRequestDto dto = new PRFailJobRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
