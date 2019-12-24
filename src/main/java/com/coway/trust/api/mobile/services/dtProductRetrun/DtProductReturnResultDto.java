package com.coway.trust.api.mobile.services.dtProductRetrun;

import com.coway.trust.api.mobile.services.installation.InstallationResultDto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductReturnResultDto", description = "ProductReturnResultDto")
public class DtProductReturnResultDto {

	@ApiModelProperty(value = "결과값")
	private String result;

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}
	
	
	public static DtProductReturnResultDto create(String result) {
		DtProductReturnResultDto dto = new DtProductReturnResultDto();
		dto.setResult(result);
		
		return dto;
	}
	
	
}
