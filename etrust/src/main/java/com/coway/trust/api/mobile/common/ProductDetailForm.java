package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "ProductDetailForm", description = "ProductDetailForm")
public class ProductDetailForm {

	public static Map<String, Object> createMap(ProductDetailForm productDetailForm) {
		Map<String, Object> map = BeanConverter.toMap(productDetailForm);
		return map;
	}

}
