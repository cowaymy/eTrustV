package com.coway.trust.api.mobile.services.dtProductRetrun;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PRFailJobRequestDto", description = "PRFailJobRequestDto")
public class DtPRFailJobRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static DtPRFailJobRequestDto create(String result) {
		DtPRFailJobRequestDto dto = new DtPRFailJobRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
