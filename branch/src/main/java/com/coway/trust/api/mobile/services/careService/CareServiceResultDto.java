package com.coway.trust.api.mobile.services.careService;

import com.coway.trust.api.mobile.Service.registration.HeartDto;
import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServiceResultDto", description = "HeartServiceResultDto")
public class CareServiceResultDto {

	@ApiModelProperty(value = "결과값")
	private String transactionId;

	
	public String getTransactionId() {
		return transactionId;
	}

	public void setTransactionId(String transactionId) {
		this.transactionId = transactionId;
	}


	public static CareServiceResultDto create(String transactionId) {
		CareServiceResultDto dto = new CareServiceResultDto();
		dto.setTransactionId(transactionId);
		
		return dto;
	}
	
}
