package com.coway.trust.api.mobile.sales.orderPromotionList;

import java.math.BigDecimal;

import com.coway.trust.util.BeanConverter;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

@ApiModel(value = "OrderProductDto", description = "공통코드 Dto")
public class OrderPromotionDto {
	
	@ApiModelProperty(value = "promotionCode")
	private BigDecimal promotionCode;
	
	@ApiModelProperty(value = "promotionName")
	private String promotionName;
	
	public BigDecimal getPromotionCode() {
		return promotionCode;
	}

	public void setPromotionCode(BigDecimal promotionCode) {
		this.promotionCode = promotionCode;
	}

	public String getPromotionName() {
		return promotionName;
	}

	public void setPromotionName(String promotionName) {
		this.promotionName = promotionName;
	}

	public static OrderPromotionDto create(EgovMap egvoMap) {
		// TODO Auto-generated method stub
		return BeanConverter.toBean(egvoMap, OrderPromotionDto.class);
	}
}
