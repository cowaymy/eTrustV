package com.coway.trust.api.mobile.sales.orderCostCalc;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderCostCalcForm", description = "공통코드 Form")
public class OrderCostCalcForm {

	@ApiModelProperty(value = "productCode [default : '' 전체] 예) 218 ", example = "218, 298, 319, 538")
	private String productCode;
	
	@ApiModelProperty(value = "promotionCode [default : '' 전체] 예) 31620 ", example = "31620")
	private String promotionCode;

	public static Map<String, Object> createMap(OrderCostCalcForm orderPromotionForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("productCode", orderPromotionForm.getProductCode());
		params.put("promotionCode", orderPromotionForm.getPromotionCode());
		
		return params;
	}

	public String getProductCode() {
		return productCode;
	}

	public void setProductCode(String productCode) {
		this.productCode = productCode;
	}

	public String getPromotionCode() {
		return promotionCode;
	}

	public void setPromotionCode(String promotionCode) {
		this.promotionCode = promotionCode;
	}

}
