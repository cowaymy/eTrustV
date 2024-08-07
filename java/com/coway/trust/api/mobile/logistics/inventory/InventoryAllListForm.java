package com.coway.trust.api.mobile.logistics.inventory;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InventoryAllListForm", description = "공통코드 Form")
public class InventoryAllListForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) CD101049,CT100591 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "productCode [default : '' 전체] 예) 110181,112098", example = "1100305,110181")
	private String productCode;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) PartsCode=1,PartsName=2,All=3 ", example = " 1,2, 3")
	private int searchType;

	@ApiModelProperty(value = "Input Keyword [default : '' 전체] 예) AN,DO,AP/3300513,3300514,3302950", example = "AP")
	private String searchKeyword;

	@ApiModelProperty(value = "제품 id  [default : '' 전체] 10,802 예) AP", example = "AP")
	private int productId;

	public static Map<String, Object> createMap(InventoryAllListForm InventoryAllListForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", InventoryAllListForm.getUserId());
		params.put("productCode", InventoryAllListForm.getProductCode());
		params.put("searchType", InventoryAllListForm.getSearchType());
		params.put("searchKeyword", InventoryAllListForm.getSearchKeyword());
		params.put("productId", InventoryAllListForm.getProductId());
		return params;
	}

	public int getProductId() {
		return productId;
	}

	public void setProductId(int productId) {
		this.productId = productId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public int getSearchType() {
		return searchType;
	}

	public void setSearchType(int searchType) {
		this.searchType = searchType;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}

}
