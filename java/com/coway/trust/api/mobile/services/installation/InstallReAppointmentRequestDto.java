package com.coway.trust.api.mobile.services.installation;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallReAppointmentRequestDto", description = "InstallReAppointmentRequestDto")
public class InstallReAppointmentRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static InstallReAppointmentRequestDto create(String result) {
		InstallReAppointmentRequestDto dto = new InstallReAppointmentRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
