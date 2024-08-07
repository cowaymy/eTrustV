package com.coway.trust.api.mobile.Service.registration;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartDtailForm", description = "HeartDtailForm")
public class HeartDtailForm {

	@ApiModelProperty(value = "filterCode")
	private String filterCode;
	@ApiModelProperty(value = "exchangeId")
	private int exchangeId;
	@ApiModelProperty(value = "filterChangeQty")
	private int filterChangeQty;

	public String getFilterCode() {
		return filterCode;
	}

	public void setFilterCode(String filterCode) {
		this.filterCode = filterCode;
	}

	public int getExchangeId() {
		return exchangeId;
	}

	public void setExchangeId(int exchangeId) {
		this.exchangeId = exchangeId;
	}

	public int getFilterChangeQty() {
		return filterChangeQty;
	}

	public void setFilterChangeQty(int filterChangeQty) {
		this.filterChangeQty = filterChangeQty;
	}

}
