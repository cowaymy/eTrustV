package com.coway.trust.api.mobile.services.heartService;

import com.coway.trust.api.mobile.Service.registration.HeartDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServiceResultDto", description = "HeartServiceResultDto")
public class HeartServiceResultDto {

	@ApiModelProperty(value = "결과값")
	private String transactionId;

	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}

	public static HeartServiceResultDto create(String transactionId) {
		HeartServiceResultDto dto = new HeartServiceResultDto();
		dto.setTransactionId(transactionId);

		return dto;
	}

}
