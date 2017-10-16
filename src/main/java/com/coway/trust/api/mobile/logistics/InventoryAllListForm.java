package com.coway.trust.api.mobile.logistics;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InventoryAllListForm", description = "공통코드 Form")
public class InventoryAllListForm {

	@ApiModelProperty(value = "userId [default : '' 전체] 예) T010,C430,CT100591 ", example = "1, 2, 3")
	private String userId;

	@ApiModelProperty(value = "productCode [default : '' 전체] 예) 1100305,110181,1206012", example = "1100305,110181")
	private int productCode;

	@ApiModelProperty(value = "searchType [default : '' 전체] 예) 1=Parts Code ,2=Parts Name, 3= ALL ", example = "1, 2, 3")
	private int searchType;

	@ApiModelProperty(value = "Input Keyword [default : '' 전체] 예) AP,DO,AN", example = "AP")
	private String searchKeyword;

	@ApiModelProperty(value = "제품 id  [default : '' 전체] 323,450,360,248,532,890 예) AP", example = "AP")
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

	public int getProductCode() {
		return productCode;
	}

	public void setProductCode(int productCode) {
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
