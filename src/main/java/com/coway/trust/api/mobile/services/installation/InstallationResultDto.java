package com.coway.trust.api.mobile.services.installation;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationResultDto", description = "InstallationResultDto")
public class InstallationResultDto {

	@ApiModelProperty(value = "결과값")
	private String result;

	@ApiModelProperty(value = "결과값")
	private String transactionId;
	
	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public String getResult() {
		return result;
	}

	public void setResult(String result) {
		this.result = result;
	}
	
	
	
	public static InstallationResultDto create(String transactionId) {
		InstallationResultDto dto = new InstallationResultDto();
		dto.setTransactionId(transactionId);
		
		return dto;
	}
	
	
}
