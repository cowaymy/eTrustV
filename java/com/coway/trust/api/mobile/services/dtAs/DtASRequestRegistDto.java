package com.coway.trust.api.mobile.services.dtAs;

import io.swagger.annotations.ApiModelProperty;

public class DtASRequestRegistDto {


	@ApiModelProperty(value = "결과값")
	private String result;

	public String getResult() {
		return result;
	}


	public void setResult(String result) {
		this.result = result;
	}

	public static DtASRequestRegistDto create(String result) {
		DtASRequestRegistDto dto = new DtASRequestRegistDto();
		dto.setResult(result);

		return dto;
	}

}
