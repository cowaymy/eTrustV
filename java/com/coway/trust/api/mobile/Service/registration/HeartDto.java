package com.coway.trust.api.mobile.Service.registration;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartDto", description = "HeartDto")
public class HeartDto {

	@ApiModelProperty(value = "transactionId")
	private String transactionId;

	public static HeartDto create(String transactionId) {
		HeartDto dto = new HeartDto();
		dto.setTransactionId(transactionId);
		return dto;
	}

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}
}
