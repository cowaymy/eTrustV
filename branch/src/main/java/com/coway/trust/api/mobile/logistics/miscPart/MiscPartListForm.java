package com.coway.trust.api.mobile.logistics.miscPart;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.logistics.itembank.ItemBankItemListForm;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "MiscPartListForm", description = "공통코드 Form")
public class MiscPartListForm {
	
	public static Map<String, Object> createMap(MiscPartListForm miscPartListForm) {
		Map<String, Object> params = new HashMap<>();
		return params;
	}	

}
