package com.coway.trust.api.mobile.common;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductDetailDto", description = "ProductDetailDto")
public class ProductDetailDto {

	@ApiModelProperty(value = "Product  아이디")
	private int stockId;
	@ApiModelProperty(value = "Product  코드")
	private String stockCode;
	@ApiModelProperty(value = "Product  설명")
	private String stockDesc;
	@ApiModelProperty(value = "Product 마스터 아이디")
	private int stockCategoryId;

	public static ProductDetailDto create(EgovMap egvoMap) {
		ProductDetailDto dto = new ProductDetailDto();
		dto.setStockId(CommonUtils.getInt(egvoMap.get("stockId")));
		dto.setStockCode((String) egvoMap.get("stockCode"));
		dto.setStockDesc((String) egvoMap.get("stockDesc"));
		dto.setStockCategoryId(CommonUtils.getInt(egvoMap.get("stockCategoryId")));
		return dto;
	}

	public int getStockId() {
		return stockId;
	}

	public void setStockId(int stockId) {
		this.stockId = stockId;
	}

	public String getStockCode() {
		return stockCode;
	}

	public void setStockCode(String stockCode) {
		this.stockCode = stockCode;
	}

	public String getStockDesc() {
		return stockDesc;
	}

	public void setStockDesc(String stockDesc) {
		this.stockDesc = stockDesc;
	}

	public int getStockCategoryId() {
		return stockCategoryId;
	}

	public void setStockCategoryId(int stockCategoryId) {
		this.stockCategoryId = stockCategoryId;
	}

}
