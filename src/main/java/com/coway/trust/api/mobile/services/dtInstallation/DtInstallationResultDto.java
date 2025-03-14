package com.coway.trust.api.mobile.services.dtInstallation;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InstallationResultDto", description = "InstallationResultDto")
public class DtInstallationResultDto {


	@ApiModelProperty(value = "결과값")
	private String transactionId;
	
	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	
	
	
	public static DtInstallationResultDto create(String transactionId) {
		DtInstallationResultDto dto = new DtInstallationResultDto();
		dto.setTransactionId(transactionId);
		
		return dto;
	}
	
	
}
