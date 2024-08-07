package com.coway.trust.api.mobile.sales.orderPromotionList;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderProductForm", description = "공통코드 Form")
public class OrderPromotionForm {
	
	@ApiModelProperty(value = "salesType [default : '' 전체] 예) 66 ", example = "66, 67, 68, ")
	private String salesType;
	
	@ApiModelProperty(value = "salesSubType [default : '' 전체] 예) 2 ", example = "2")
	private String salesSubType;
	
	@ApiModelProperty(value = "productId [default : '' 전체] 예) 4 ", example = "4, 298, 319, 538")
	private String productId;
	
	@ApiModelProperty(value = "reOrderYN [default : '' 전체] 예) 0 ", example = "0, 1")
	private String reOrderYN;

	@ApiModelProperty(value = "customerType [default : '' 전체] 예) 964 ", example = "964, 965")
	private String customerType;

	public static Map<String, Object> createMap(OrderPromotionForm orderPromotionForm){
		Map<String, Object> params = new HashMap<>();
		
		params.put("salesType",   orderPromotionForm.getSalesType());
		params.put("salesSubType",   orderPromotionForm.getSalesSubType());
		params.put("productId", orderPromotionForm.getProductId());
		params.put("reOrderYN",   orderPromotionForm.getReOrderYN());
		params.put("customerType",   orderPromotionForm.getCustomerType());
		
		return params;
	}

	public String getSalesType() {
		return salesType;
	}

	public void setSalesType(String salesType) {
		this.salesType = salesType;
	}

	public String getSalesSubType() {
		return salesSubType;
	}

	public void setSalesSubType(String salesSubType) {
		this.salesSubType = salesSubType;
	}

	public String getProductId() {
		return productId;
	}

	public void setProductId(String productId) {
		this.productId = productId;
	}

	public String getReOrderYN() {
		return reOrderYN;
	}

	public void setReOrderYN(String reOrderYN) {
		this.reOrderYN = reOrderYN;
	}

	public String getCustomerType() {
		return customerType;
	}

	public void setCustomerType(String customerType) {
		this.customerType = customerType;
	}
	
}
