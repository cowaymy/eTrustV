package com.coway.trust.api.mobile.logistics.inventory;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "InventoryOverallStockForm", description = "InventoryOverallStockForm")
public class InventoryOverallStockForm {

	@ApiModelProperty(value = "제품 대그룹(정수기/청정기 등) [default : '' 전체] 예) 54=Water Purifier,55=Air Purifier ", example = "55,54")
	private int productCategoryId;

	@ApiModelProperty(value = "조회할 CT/CODY ID [default : '' 전체] 예) T010,CT100070, ", example = "CD100205,CT100070")
	private String targetUserId;

	public static Map<String, Object> createMap(InventoryOverallStockForm InventoryOverallStockForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("productCategoryId", InventoryOverallStockForm.getProductCategoryId());
		params.put("targetUserId", InventoryOverallStockForm.getTargetUserId());
		return params;
	}

	public int getProductCategoryId() {
		return productCategoryId;
	}

	public void setProductCategoryId(int productCategoryId) {
		this.productCategoryId = productCategoryId;
	}

	public String getTargetUserId() {
		return targetUserId;
	}

	public void setTargetUserId(String targetUserId) {
		this.targetUserId = targetUserId;
	}

}
