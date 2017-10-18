package com.coway.trust.api.mobile.logistics.salesprice;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModelProperty;

public class StockPriceForm {
	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) 1100305", example = "1100305")
	private String productCode;
	@ApiModelProperty(value = "사용자 ID [default : '' 전체] 예) 312", example = "312")
	private int productId;
	@ApiModelProperty(value = "검색 type (all / partCode / partName)", example = "all / partCode / partName")
	private String searchType;
	@ApiModelProperty(value = "검색어 AC", example = "AC")
	private String searchKeyword;
	@ApiModelProperty(value = "Filter=62 / Part=63 구분", example = "62,63")
	private int searchKinds;

	public static Map<String, Object> createMap(StockPriceForm stockpriceForm) {
		Map<String, Object> map = BeanConverter.toMap(stockpriceForm);
		return map;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
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

	public int getSearchKinds() {
		return searchKinds;
	}

	public void setSearchKinds(int searchKinds) {
		this.searchKinds = searchKinds;
	}

}
