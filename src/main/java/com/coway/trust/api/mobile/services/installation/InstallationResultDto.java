package com.coway.trust.api.mobile.services.installation;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationResultDto", description = "InstallationResultDto")
public class InstallationResultDto {

	@ApiModelProperty(value = "결과값")
	private String result;

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}
	
	
	public static InstallationResultDto create(String result) {
		InstallationResultDto dto = new InstallationResultDto();
		dto.setResult(result);
		
		return dto;
	}
	
	
}
