package com.coway.trust.api.mobile.services.heartService;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HSReAppointmtRequestDto", description = "HSReAppointmtRequestDto")
public class HSReAppointmtRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static HSReAppointmtRequestDto create(String result) {
		HSReAppointmtRequestDto dto = new HSReAppointmtRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
