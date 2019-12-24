package com.coway.trust.api.mobile.services.dtProductRetrun;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "PRReAppointmentRequestDto", description = "PRReAppointmentRequestDto")
public class DtPRReAppointmentRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static DtPRReAppointmentRequestDto create(String result) {
		DtPRReAppointmentRequestDto dto = new DtPRReAppointmentRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
