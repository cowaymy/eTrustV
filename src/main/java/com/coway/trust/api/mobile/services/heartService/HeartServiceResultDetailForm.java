package com.coway.trust.api.mobile.services.heartService;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServiceResultDetailForm", description = "HeartServiceResultDetailForm")
public class HeartServiceResultDetailForm {

	@ApiModelProperty(value = "필터 코드 [default : '' 전체] 예) T010", example = "CT100337")
	private int filterCode;

	@ApiModelProperty(value = "chgid예) 20170820", example = "28092017")
	private String exchangeId;

	@ApiModelProperty(value = "필터 교체 수량 예) 20170827", example = "29092017")
	private int filterChangeQty;

	
	@ApiModelProperty(value = "대체 필터 코드(123456)", example = "")
	private int alternativeFilterCode;

	@ApiModelProperty(value = "교체 필터 바코드", example = "")
	private int filterBarcdSerialNo;
	
	public int getAlternativeFilterCode() {
		return alternativeFilterCode;
	}

	public void setAlternativeFilterCode(int alternativeFilterCode) {
		this.alternativeFilterCode = alternativeFilterCode;
	}

	public int getFilterBarcdSerialNo() {
		return filterBarcdSerialNo;
	}

	public void setFilterBarcdSerialNo(int filterBarcdSerialNo) {
		this.filterBarcdSerialNo = filterBarcdSerialNo;
	}

	public int getFilterCode() {
		return filterCode;
	}

	public void setFilterCode(int filterCode) {
		this.filterCode = filterCode;
	}


	public String getExchangeId() {
		return exchangeId;
	}

	public void setExchangeId(String exchangeId) {
		this.exchangeId = exchangeId;
	}

	public int getFilterChangeQty() {
		return filterChangeQty;
	}

	public void setFilterChangeQty(int filterChangeQty) {
		this.filterChangeQty = filterChangeQty;
	}

	

}
