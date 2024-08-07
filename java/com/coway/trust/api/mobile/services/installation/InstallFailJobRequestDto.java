package com.coway.trust.api.mobile.services.installation;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallFailJobRequestDto", description = "InstallFailJobRequestDto")
public class InstallFailJobRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static InstallFailJobRequestDto create(String result) {
		InstallFailJobRequestDto dto = new InstallFailJobRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
