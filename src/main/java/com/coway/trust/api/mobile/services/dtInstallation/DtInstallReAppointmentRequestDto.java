package com.coway.trust.api.mobile.services.dtInstallation;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallReAppointmentRequestDto", description = "InstallReAppointmentRequestDto")
public class DtInstallReAppointmentRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static DtInstallReAppointmentRequestDto create(String result) {
		DtInstallReAppointmentRequestDto dto = new DtInstallReAppointmentRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
