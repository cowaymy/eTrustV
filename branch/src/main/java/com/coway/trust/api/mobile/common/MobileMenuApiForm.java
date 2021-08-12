package com.coway.trust.api.mobile.common;

import java.util.HashMap;
import java.util.Map;

import com.coway.trust.api.mobile.payment.cashMatching.CashMatchingForm;
import com.coway.trust.util.BeanConverter;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : MobileMenuApiForm.java
 * @Description : MobileMenuApiForm
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 11. 1.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "MobileMenuApiForm", description = "MobileMenuApiForm")
public class MobileMenuApiForm {

	@ApiModelProperty(value = "사용자 ID")
	private String userId;


	public static Map<String, Object> createMap(MobileMenuApiForm mobileMenuApiForm){
		Map<String, Object> params = new HashMap<>();

		params.put("userId",   		mobileMenuApiForm.getUserId());

		return params;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

}
