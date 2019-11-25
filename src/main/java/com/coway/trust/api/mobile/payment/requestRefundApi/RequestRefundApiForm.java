package com.coway.trust.api.mobile.payment.requestRefundApi;

import java.util.HashMap;
import java.util.Map;

import io.swagger.annotations.ApiModel;


/**
 * @ClassName : RequestRefundApiForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author          Description
 * -------------   -----------     -------------
 * 2019. 10. 21.   KR-JAEMJAEM:)   First creation
 * </pre>
 */
@ApiModel(value = "RequestRefundApiForm", description = "RequestRefundApiForm")
public class RequestRefundApiForm {
	public static Map<String, Object> createMap(RequestRefundApiForm vo){
		Map<String, Object> params = new HashMap<>();
		return params;
	}
}
