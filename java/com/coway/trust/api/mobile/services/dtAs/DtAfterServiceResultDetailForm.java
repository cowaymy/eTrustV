package com.coway.trust.api.mobile.services.dtAs;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.codec.binary.Base64;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "AfterServiceResultDetailForm", description = "AfterServiceResultDetailForm")
public class DtAfterServiceResultDetailForm {


	@ApiModelProperty(value = "필터 코드")
	private String filterCode;

	@ApiModelProperty(value = "foc??")
	private int chargesFoc;

	@ApiModelProperty(value = "chgid??")
	private int exchangeId;

	@ApiModelProperty(value = "filter price")
	private int salesPrice;

	@ApiModelProperty(value = "필터 교체 수량")
	private int filterChangeQty;

	@ApiModelProperty(value = "filter / sparepart / msc(Miscellaneous) 구분")
	private int partsType;

	@ApiModelProperty(value = "교체 필터 바코드")
	private String filterBarcdSerialNo;

	public String getFilterCode() {
		return filterCode;
	}

	public void setFilterCode(String filterCode) {
		this.filterCode = filterCode;
	}

	public int getChargesFoc() {
		return chargesFoc;
	}

	public void setChargesFoc(int chargesFoc) {
		this.chargesFoc = chargesFoc;
	}

	public int getExchangeId() {
		return exchangeId;
	}

	public void setExchangeId(int exchangeId) {
		this.exchangeId = exchangeId;
	}

	public int getSalesPrice() {
		return salesPrice;
	}

	public void setSalesPrice(int salesPrice) {
		this.salesPrice = salesPrice;
	}

	public int getFilterChangeQty() {
		return filterChangeQty;
	}

	public void setFilterChangeQty(int filterChangeQty) {
		this.filterChangeQty = filterChangeQty;
	}

	public int getPartsType() {
		return partsType;
	}

	public void setPartsType(int partsType) {
		this.partsType = partsType;
	}

	public String getFilterBarcdSerialNo() {
		return filterBarcdSerialNo;
	}

	public void setFilterBarcdSerialNo(String filterBarcdSerialNo) {
		this.filterBarcdSerialNo = filterBarcdSerialNo;
	}



	public static List<Map<String, Object>>  createMaps(List<DtAfterServiceResultDetailForm> afterServiceResultDetailForms) {

		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;

//		map = BeanConverter.toMap(afterServiceResultForm, "partList");

		for(DtAfterServiceResultDetailForm form : afterServiceResultDetailForms){
			map = BeanConverter.toMap(form);
			list.add(map);
		}

		return list;
	}










}
