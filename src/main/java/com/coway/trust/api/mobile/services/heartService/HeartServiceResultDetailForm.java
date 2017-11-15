package com.coway.trust.api.mobile.services.heartService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.coway.trust.api.mobile.services.as.AfterServiceResultDetailForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "HeartServiceResultDetailForm", description = "HeartServiceResultDetailForm")
public class HeartServiceResultDetailForm {

	@ApiModelProperty(value = "필터 코드 [default : '' 전체] 예) T010", example = "CT100337")
	private String filterCode;

	@ApiModelProperty(value = "chgid예) 20170820", example = "28092017")
	private int exchangeId;

	@ApiModelProperty(value = "필터 교체 수량 예) 20170827", example = "29092017")
	private int filterChangeQty;

	
	@ApiModelProperty(value = "대체 필터 코드(123456)", example = "")
	private int alternativeFilterCode;

	@ApiModelProperty(value = "교체 필터 바코드", example = "")
	private String filterBarcdSerialNo;
	
	public int getAlternativeFilterCode() {
		return alternativeFilterCode;
	}

	public void setAlternativeFilterCode(int alternativeFilterCode) {
		this.alternativeFilterCode = alternativeFilterCode;
	}

	public String getFilterBarcdSerialNo() {
		return filterBarcdSerialNo;
	}

	public void setFilterBarcdSerialNo(String filterBarcdSerialNo) {
		this.filterBarcdSerialNo = filterBarcdSerialNo;
	}

	public String getFilterCode() {
		return filterCode;
	}

	public void setFilterCode(String filterCode) {
		this.filterCode = filterCode;
	}


	public int getExchangeId() {
		return exchangeId;
	}

	public void setExchangeId(int exchangeId) {
		this.exchangeId = exchangeId;
	}

	public int getFilterChangeQty() {
		return filterChangeQty;
	}

	public void setFilterChangeQty(int filterChangeQty) {
		this.filterChangeQty = filterChangeQty;
	}

	
	public static List<Map<String, Object>>  createMaps(List<HeartServiceResultDetailForm> heartServiceResultDetailForm) {

		List<Map<String, Object>> list = new ArrayList<>();
		Map<String, Object> map;
	
		for(HeartServiceResultDetailForm form : heartServiceResultDetailForm){
			map = BeanConverter.toMap(form);
			list.add(map);
		}
		return list;
	}
	

}
