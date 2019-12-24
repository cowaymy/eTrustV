package com.coway.trust.api.mobile.services.dtAs;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ASReAppointmentRequestDto", description = "ASReAppointmentRequestDto")
public class DtASReAppointmentRequestDto {

	@ApiModelProperty(value = "결과값")
	private String result;

	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}

	public static DtASReAppointmentRequestDto create(String result) {
		DtASReAppointmentRequestDto dto = new DtASReAppointmentRequestDto();
		dto.setResult(result);

		return dto;
	}




}
