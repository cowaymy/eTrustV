package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "StockReceiveListForm", description = "공통코드 Form")
public class LogStockReceiveForm {


	@ApiModelProperty(value = "GI Date [default : '' 전체] 예) 2017",  example = "1100305,110181")
	private int searchFromDate;
	
	@ApiModelProperty(value = "GR Date [default : '' 전체] 예) 1=Parts Code ,2=Parts Name, 3= ALL ",  example = "1, 2, 3")
	private int searchToDate;
	
	
	public static Map<String, Object> createMap(LogStockReceiveForm StockReceiveListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("productCode", StockReceiveListForm.getSearchFromDate());
		params.put("searchType", StockReceiveListForm.getSearchToDate());

		return params;
	}


	public int getSearchFromDate() {
		return searchFromDate;
	}


	public void setSearchFromDate(int searchFromDate) {
		this.searchFromDate = searchFromDate;
	}


	public int getSearchToDate() {
		return searchToDate;
	}


	public void setSearchToDate(int searchToDate) {
		this.searchToDate = searchToDate;
	}


}
