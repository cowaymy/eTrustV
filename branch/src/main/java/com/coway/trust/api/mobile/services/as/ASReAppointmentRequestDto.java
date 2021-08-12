package com.coway.trust.api.mobile.services.as;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ASReAppointmentRequestDto", description = "ASReAppointmentRequestDto")
public class ASReAppointmentRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static ASReAppointmentRequestDto create(String result) {
		ASReAppointmentRequestDto dto = new ASReAppointmentRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
