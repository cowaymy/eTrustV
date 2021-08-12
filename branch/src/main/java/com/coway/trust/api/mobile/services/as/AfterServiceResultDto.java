package com.coway.trust.api.mobile.services.as;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultDto", description = "AfterServiceResultDto")
public class AfterServiceResultDto {
	
	
	@ApiModelProperty(value = "결과값")
	private String transactionId;

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
	

	public static AfterServiceResultDto create(String transactionId) {
		AfterServiceResultDto dto = new AfterServiceResultDto();
		dto.setTransactionId(transactionId);
		
		return dto;
	}
	
}
