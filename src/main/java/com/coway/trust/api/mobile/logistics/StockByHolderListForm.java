package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InventoryStockByHolderForm", description = "공통코드 Form")
public class StockByHolderListForm {


	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 3001499 ,3105547, 3300513",  example = "1, 2, 3")
	private String userId;
	
	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 3001499 ,3105547, 3300513",  example = "1, 2, 3")
	private String partsCode;
	
	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 3001499 ,3105547, 3300513",  example = "1, 2, 3")
	private String partsId;
	

	public static Map<String, Object> createMap(StockByHolderListForm InventoryStockByHolderForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", InventoryStockByHolderForm.getUserId());
		params.put("partsCode", InventoryStockByHolderForm.getPartsCode());
		params.put("partsId", InventoryStockByHolderForm.getPartsId());
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


	public String getPartsId() {
		return partsId;
	}


	public void setPartsId(String partsId) {
		this.partsId = partsId;
	}





}
