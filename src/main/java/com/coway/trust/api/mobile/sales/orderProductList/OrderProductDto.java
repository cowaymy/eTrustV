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
	
	@ApiModelProperty(value = "productCode")
	private BigDecimal productCode;

	public String getProductName() {
		return productName;
	}

	public void setProductName(String productName) {
		this.productName = productName;
	}

	public BigDecimal getProductCode() {
		return productCode;
	}

	public void setProductCode(BigDecimal productCode) {
		this.productCode = productCode;
	}
	
	public static OrderProductDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, OrderProductDto.class);
	}
}
