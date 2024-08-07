package com.coway.trust.api.mobile.services.careService;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HSReAppointmtRequestDto", description = "HSReAppointmtRequestDto")
public class CSReAppointmtRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static CSReAppointmtRequestDto create(String result) {
		CSReAppointmtRequestDto dto = new CSReAppointmtRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
