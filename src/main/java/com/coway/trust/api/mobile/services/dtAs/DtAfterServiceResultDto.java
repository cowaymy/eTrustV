package com.coway.trust.api.mobile.services.dtAs;

import com.coway.trust.api.mobile.services.heartService.HeartServiceResultDto;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultDto", description = "AfterServiceResultDto")
public class DtAfterServiceResultDto {


	@ApiModelProperty(value = "결과값")
	private String transactionId;

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}


	public static DtAfterServiceResultDto create(String transactionId) {
		DtAfterServiceResultDto dto = new DtAfterServiceResultDto();
		dto.setTransactionId(transactionId);

		return dto;
	}

}
