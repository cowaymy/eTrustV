package com.coway.trust.api.mobile.logistics.rdcstock;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RdcStockListForm", description = "공통코드 Form")
public class RdcStockListForm {

	@ApiModelProperty(value = "마스터 코드 IDs [default : '' 전체] 예) CT100374", example = "1, 2")
	private String userId;

	@ApiModelProperty(value = "materialCode IDs [default : '' 전체] 예) 110544,3112234,110544", example = "1, 2")
	private String partsCode;

	@ApiModelProperty(value = "부품 id IDs [default : '' 전체] 예) 407", example = "1, 2")
	private int partsId;

	public static Map<String, Object> createMap(RdcStockListForm RdcStockListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("partsCode", RdcStockListForm.getPartsCode());
		params.put("userId", RdcStockListForm.getUserId());
		params.put("partsId", RdcStockListForm.getPartsId());
		return params;
	}

	public String getPartsCode() {
		return partsCode;
	}

	public void setPartsCode(String partsCode) {
		this.partsCode = partsCode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getPartsId() {
		return partsId;
	}

	public void setPartsId(int partsId) {
		this.partsId = partsId;
	}

}
