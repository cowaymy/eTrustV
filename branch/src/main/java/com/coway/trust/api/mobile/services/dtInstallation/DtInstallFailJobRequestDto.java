package com.coway.trust.api.mobile.services.dtInstallation;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallFailJobRequestDto", description = "InstallFailJobRequestDto")
public class DtInstallFailJobRequestDto {
	
	@ApiModelProperty(value = "결과값")
	private String result;
	
	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}
	
	public static DtInstallFailJobRequestDto create(String result) {
		DtInstallFailJobRequestDto dto = new DtInstallFailJobRequestDto();
		dto.setResult(result);
		
		return dto;
	}



	
}
