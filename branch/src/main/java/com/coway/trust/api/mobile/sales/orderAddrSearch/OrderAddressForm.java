package com.coway.trust.api.mobile.sales.orderAddrSearch;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderAddressForm", description = "공통코드 Form")
public class OrderAddressForm {
	
	@ApiModelProperty(value = "searchAreaKeyword [default : '' 전체] 예) rusa ", example = "1, 2, 3")
	private String searchAreaKeyword;
	
	@ApiModelProperty(value = "searchPostCode [default : '' 전체] 예) 68100 ", example = "1, 2, 3")
	private String searchPostCode;

	public static Map<String, Object> createMap(OrderAddressForm OrderAddressForm){
		Map<String, Object> params = new HashMap<>();
		params.put("searchAreaKeyword", OrderAddressForm.getSearchAreaKeyword());
		params.put("searchPostCode", OrderAddressForm.getSearchPostCode());
		return params;
	}
	
	public String getSearchAreaKeyword() {
		return searchAreaKeyword;
	}

	public void setSearchAreaKeyword(String searchAreaKeyword) {
		this.searchAreaKeyword = searchAreaKeyword;
	}

	public String getSearchPostCode() {
		return searchPostCode;
	}

	public void setSearchPostCode(String searchPostCode) {
		this.searchPostCode = searchPostCode;
	}
	
}
