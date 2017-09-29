package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "DisplayCt_CodyListForm", description = "공통코드 Form")
public class DisplayCt_CodyListForm {

	@ApiModelProperty(value = "마스터 코드 IDs [default : '' 전체] 예) 1,2",  example = "1, 2")
	private String materialCode;

	public static Map<String, Object> createMap(DisplayCt_CodyListForm DisplayCt_CodyListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("MaterialCode", DisplayCt_CodyListForm.getMaterialCode());
		return params;
	}

	public String getMaterialCode() {
		return materialCode;
	}

	public void setMaterialCode(String materialCode) {
		this.materialCode = materialCode;
	}


	
	
}
