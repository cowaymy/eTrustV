package com.coway.trust.api.mobile.logistics.stockbyholder;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockByHolderQtyForm", description = "공통코드 Form")
public class StockByHolderQtyForm {

	@ApiModelProperty(value = "locCode [default : '' 전체] 예) CD102120,CD102867 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "partsCode [default : '' 전체] 예) 3300513, 3001499 ,3105547", example = "1, 2, 3")
	private String partsCode;

	public static Map<String, Object> createMap(StockByHolderQtyForm StockByHolderQtyForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", StockByHolderQtyForm.getUserId());
		params.put("partsCode", StockByHolderQtyForm.getPartsCode());
		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

}
