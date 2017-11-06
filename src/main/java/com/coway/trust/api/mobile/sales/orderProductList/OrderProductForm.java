package com.coway.trust.api.mobile.sales.orderProductList;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderProductForm", description = "공통코드 Form")
public class OrderProductForm {
	
	@ApiModelProperty(value = "salesType [default : '' 전체] 예) 66 ", example = "66, 67, 68, ")
	private String salesType;
	
	@ApiModelProperty(value = "srvPacId [default : '' 전체] 예) 367 ", example = "367, 368, 369, 370, 371, 372, 373, 374")
	private String srvPacId;
	
	@ApiModelProperty(value = "searchType [default : '' 전체] 예) CODE ", example = "CODE, NAME")
	private String searchType;

	@ApiModelProperty(value = "searchKeyword [default : '' 전체] 예) CHP ", example = "CHP")
	private String searchKeyword;

	public static Map<String, Object> createMap(OrderProductForm OrderAddressForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("salesType", 	OrderAddressForm.getSalesType());
		params.put("srvPacId", 	    OrderAddressForm.getSrvPacId());
		params.put("searchType",    OrderAddressForm.getSearchType());
		params.put("searchKeyword", OrderAddressForm.getSearchKeyword());
		
		return params;
	}

	public String getSalesType() {
		return salesType;
	}

	public void setSalesType(String salesType) {
		this.salesType = salesType;
	}

	public String getSrvPacId() {
		return srvPacId;
	}

	public void setSrvPacId(String srvPacId) {
		this.srvPacId = srvPacId;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}
	
}
