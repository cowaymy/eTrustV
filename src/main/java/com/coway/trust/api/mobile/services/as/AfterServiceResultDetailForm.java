package com.coway.trust.api.mobile.services.as;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultDetailForm", description = "AfterServiceResultDetailForm")
public class AfterServiceResultDetailForm {

	
	@ApiModelProperty(value = "필터 코드")
	private String filterCode;

	@ApiModelProperty(value = "foc??")
	private String chargesFoc;

	@ApiModelProperty(value = "chgid??")
	private String exchangeId;

	@ApiModelProperty(value = "filter price")
	private String salesPrice;

	@ApiModelProperty(value = "필터 교체 수량")
	private String filterChangeQty;

	@ApiModelProperty(value = "filter / sparepart / msc(Miscellaneous) 구분")
	private String partsType;

	@ApiModelProperty(value = "교체 필터 바코드")
	private String filterBarcdSerialNo;

	public String getFilterCode() {
		return filterCode;
	}

	public void setFilterCode(String filterCode) {
		this.filterCode = filterCode;
	}

	public String getChargesFoc() {
		return chargesFoc;
	}

	public void setChargesFoc(String chargesFoc) {
		this.chargesFoc = chargesFoc;
	}

	public String getExchangeId() {
		return exchangeId;
	}

	public void setExchangeId(String exchangeId) {
		this.exchangeId = exchangeId;
	}

	public String getSalesPrice() {
		return salesPrice;
	}

	public void setSalesPrice(String salesPrice) {
		this.salesPrice = salesPrice;
	}

	public String getFilterChangeQty() {
		return filterChangeQty;
	}

	public void setFilterChangeQty(String filterChangeQty) {
		this.filterChangeQty = filterChangeQty;
	}

	public String getPartsType() {
		return partsType;
	}

	public void setPartsType(String partsType) {
		this.partsType = partsType;
	}

	public String getFilterBarcdSerialNo() {
		return filterBarcdSerialNo;
	}

	public void setFilterBarcdSerialNo(String filterBarcdSerialNo) {
		this.filterBarcdSerialNo = filterBarcdSerialNo;
	}
	
	
	
	
	
	
}
