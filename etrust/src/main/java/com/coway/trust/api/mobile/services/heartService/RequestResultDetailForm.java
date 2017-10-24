package com.coway.trust.api.mobile.services.heartService;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "RequestResultDetailForm", description = "RequestResultDetailForm")
public class RequestResultDetailForm {

	@ApiModelProperty(value = "필터 코드 [default : '' 전체] 예) T010", example = "CT100337")
	private int filterCode;

	@ApiModelProperty(value = "chgid예) 20170820", example = "28092017")
	private String exChgid;

	@ApiModelProperty(value = "필터 교체 수량 예) 20170827", example = "29092017")
	private int filterChangeQty;

	
	public static Map<String, Object> createMap(RequestResultDetailForm requestResultDetailForm) {
		Map<String, Object> map = BeanConverter.toMap(requestResultDetailForm);
		return map;

	}

	public int getFilterCode() {
		return filterCode;
	}



	public void setFilterCode(int filterCode) {
		this.filterCode = filterCode;
	}



	public String getExChgid() {
		return exChgid;
	}



	public void setExChgid(String exChgid) {
		this.exChgid = exChgid;
	}



	public int getFilterChangeQty() {
		return filterChangeQty;
	}



	public void setFilterChangeQty(int filterChangeQty) {
		this.filterChangeQty = filterChangeQty;
	}






}
