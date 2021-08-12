package com.coway.trust.api.mobile.common;

import com.coway.trust.util.CommonUtils;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "ProductMasterDto", description = "ProductMasterDto")
public class ProductMasterDto {

	@ApiModelProperty(value = "Product 마스터 아이디")
	private int stockCategoryId;
	@ApiModelProperty(value = "Product 마스터 코드")
	private String stockCategoryCode;
	@ApiModelProperty(value = "Product 마스터 코드 명")
	private String stockCategoryDesc;

	public static ProductMasterDto create(EgovMap egvoMap) {
		ProductMasterDto dto = new ProductMasterDto();
		dto.setStockCategoryId(CommonUtils.getInt(egvoMap.get("stockCategoryId")));
		dto.setStockCategoryCode((String) egvoMap.get("stockCategoryCode"));
		dto.setStockCategoryDesc((String) egvoMap.get("stockCategoryDesc"));
		return dto;
	}

	public int getStockCategoryId() {
		return stockCategoryId;
	}

	public void setStockCategoryId(int stockCategoryId) {
		this.stockCategoryId = stockCategoryId;
	}

	public String getStockCategoryCode() {
		return stockCategoryCode;
	}

	public void setStockCategoryCode(String stockCategoryCode) {
		this.stockCategoryCode = stockCategoryCode;
	}

	public String getStockCategoryDesc() {
		return stockCategoryDesc;
	}

	public void setStockCategoryDesc(String stockCategoryDesc) {
		this.stockCategoryDesc = stockCategoryDesc;
	}

}
