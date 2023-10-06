package com.coway.trust.biz.api.vo;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "CBTApiRespForm", description = "CBTApiRespForm")
public class CBTApiRespForm {
	private boolean success;
	private int statusCode;

	public boolean isSuccess() {
		return success;
	}
	public void setSuccess(boolean success) {
		this.success = success;
	}

	public int getStatusCode() {
		return statusCode;
	}
	public void setStatusCode(int statusCode) {
		this.statusCode = statusCode;
	}
}
