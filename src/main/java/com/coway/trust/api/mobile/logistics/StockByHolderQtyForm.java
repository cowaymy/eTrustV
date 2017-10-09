package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockByHolderQtyForm", description = "공통코드 Form")
public class StockByHolderQtyForm {

	@ApiModelProperty(value = "locCode [default : '' 전체] 예) CD100615 ", example = "1, 2, 3")
	private String locCode;

	@ApiModelProperty(value = "partsCode [default : '' 전체] 예) 100750, 3001499 ,3105547, 3300513", example = "1, 2, 3")
	private String partsCode;

	@ApiModelProperty(value = "partsId [default : '' 전체] 예) Water Purifier=54, Air Purifier=55, Bidet=56", example = "1, 2, 3")
	private String partsId;

	public static Map<String, Object> createMap(StockByHolderQtyForm StockByHolderQtyForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("locCode", StockByHolderQtyForm.getLocCode());
		params.put("partsCode", StockByHolderQtyForm.getPartsCode());
		params.put("partsId", StockByHolderQtyForm.getPartsId());
		return params;
	}

	public String getLocCode() {
		return locCode;
	}

	public void setLocCode(String locCode) {
		this.locCode = locCode;
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
