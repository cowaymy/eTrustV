package com.coway.trust.cmmn.model;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "WhatappsApiRespForm", description = "WhatappsApiRespForm")
public class WhatappsApiRespForm {
	private boolean success;
	private int statusCode;
	private String error;

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

	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
}
