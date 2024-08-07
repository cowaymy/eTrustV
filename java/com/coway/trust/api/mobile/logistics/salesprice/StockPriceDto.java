package com.coway.trust.api.mobile.logistics.salesprice;

import java.text.DecimalFormat;

import com.coway.trust.util.BeanConverter;
import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockPriceDto", description = "StockPriceDto")
public class StockPriceDto {

	@ApiModelProperty(value = "부품코드")
	String partsCode;

	@ApiModelProperty(value = "부품 id")
	int partsId;

	@ApiModelProperty(value = "부품명")
	String partsName;

	@ApiModelProperty(value = "부품가격")
	int partsPrice;

	@ApiModelProperty(value = "가격단위")
	int priceUnit; // no standard data

	@ApiModelProperty(value = "통화")
	String currency; // no standard data

	public static StockPriceDto create(EgovMap egvoMap) {
		return BeanConverter.toBean(egvoMap, StockPriceDto.class);
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

	public String getPartsName() {
		return partsName;
	}

	public void setPartsName(String partsName) {
		this.partsName = partsName;
	}

	public int getPartsPrice() {
		return partsPrice;
	}

	public void setPartsPrice(int partsPrice) {
		this.partsPrice = partsPrice;
	}

	public int getPriceUnit() {
		return priceUnit;
	}

	public void setPriceUnit(int priceUnit) {
		this.priceUnit = priceUnit;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

}
