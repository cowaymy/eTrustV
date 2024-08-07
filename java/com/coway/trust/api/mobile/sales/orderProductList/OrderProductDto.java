package com.coway.trust.api.mobile.sales.orderProductList;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderProductDto", description = "공통코드 Dto")
public class OrderProductDto {
	
	@ApiModelProperty(value = "productName")
	private String productName;
	
	@ApiModelProperty(value = "productId")
	private int productId;

	@ApiModelProperty(value = "productCode")
	private String productCode;

	@ApiModelProperty(value = "priceId")
	private int priceId;

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
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

	public int getPriceId() {
		return priceId;
	}

	public void setPriceId(int priceId) {
		this.priceId = priceId;
	}

	public static OrderProductDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, OrderProductDto.class);
	}
}
