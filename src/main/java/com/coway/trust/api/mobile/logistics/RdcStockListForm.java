package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RdcStockListForm", description = "공통코드 Form")
public class RdcStockListForm {
	
	@ApiModelProperty(value = "마스터 코드 IDs [default : '' 전체] 예) CT100374",  example = "1, 2")
	private String userId;
	
	@ApiModelProperty(value = "materialCode IDs [default : '' 전체] 예) 110544,3112234,110544",  example = "1, 2")
	private String materialCode;

	public static Map<String, Object> createMap(RdcStockListForm RdcStockListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("MaterialCode", RdcStockListForm.getMaterialCode());
		params.put("userId", RdcStockListForm.getUserId());
		return params;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}


	
	
}
