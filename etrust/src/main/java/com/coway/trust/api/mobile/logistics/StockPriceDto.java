package com.coway.trust.api.mobile.logistics;

import java.text.DecimalFormat;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;

@ApiModel(value = "StockPriceDto", description = "StockPriceDto")
public class StockPriceDto {

	String partsCode;
	String partsName;
	String partsPrice;
	String priceUnit; // no standard data
	String currency; // no standard data

	public static StockPriceDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		StockPriceDto dto = new StockPriceDto();
		DecimalFormat df = new DecimalFormat(".00");
		int tmp = CommonUtils.getInt(egvoMap.get("amt"));

		dto.setPartsCode((String) egvoMap.get("stkCode"));
		dto.setPartsName((String) egvoMap.get("stkDesc"));
		dto.setPartsPrice(df.format(tmp));
		// no standard data
		// dto.setPriceUnit((String) egvoMap.get(""));
		// dto.setCurrency((String) egvoMap.get(""));
		return dto;
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

	public String getPartsPrice() {
		return partsPrice;
	}

	public void setPartsPrice(String partsPrice) {
		this.partsPrice = partsPrice;
	}

	public String getPriceUnit() {
		return priceUnit;
	}

	public void setPriceUnit(String priceUnit) {
		this.priceUnit = priceUnit;
	}

	public String getCurrency() {
		return currency;
	}

	public void setCurrency(String currency) {
		this.currency = currency;
	}

}
