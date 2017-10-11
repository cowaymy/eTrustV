package com.coway.trust.api.mobile.common;

import java.util.Map;

import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;

@ApiModel(value = "ProductMasterForm", description = "ProductMasterForm")
public class ProductMasterForm {

	public static Map<String, Object> createMap(ProductMasterForm productMasterForm) {
		Map<String, Object> map = BeanConverter.toMap(productMasterForm);
		return map;
	}

}
