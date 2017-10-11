package com.coway.trust.api.mobile.logistics;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

public class StockPriceForm {

	int productCode;
	String searchType;
	// String partCode;
	// String partName;
	String searchKeyword;

	public static Map<String, Object> createMap(StockPriceForm stockpriceForm) {
		Map<String, Object> map = BeanConverter.toMap(stockpriceForm);
		return map;
	}

	public int getProductCode() {
		return productCode;
	}

	public void setProductCode(int productCode) {
		this.productCode = productCode;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	// public String getPartCode() {
	// return partCode;
	// }
	//
	// public void setPartCode(String partCode) {
	// this.partCode = partCode;
	// }
	//
	// public String getPartName() {
	// return partName;
	// }
	//
	// public void setPartName(String partName) {
	// this.partName = partName;
	// }

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

}
