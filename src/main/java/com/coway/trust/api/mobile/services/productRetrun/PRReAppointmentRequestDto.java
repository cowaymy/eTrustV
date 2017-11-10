package com.coway.trust.api.mobile.services.productRetrun;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PRReAppointmentRequestDto", description = "PRReAppointmentRequestDto")
public class PRReAppointmentRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static PRReAppointmentRequestDto create(String result) {
		PRReAppointmentRequestDto dto = new PRReAppointmentRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
