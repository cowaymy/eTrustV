package com.coway.trust.api.mobile.logistics.stockbyholder;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockByHolderListForm", description = "공통코드 Form")
public class StockByHolderListForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CD100087 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "partsCode [default : '' 전체] 예) 100750, 3001499 ,3105547, 3300513", example = "1, 2, 3")
	private String partsCode;

	@ApiModelProperty(value = "partsId [default : '' 전체] 예) 125", example = "1, 2, 3")
	private int partsId;

	public static Map<String, Object> createMap(StockByHolderListForm StockByHolderListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", StockByHolderListForm.getUserId());
		params.put("partsCode", StockByHolderListForm.getPartsCode());
		params.put("partsId", StockByHolderListForm.getPartsId());
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

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

}
