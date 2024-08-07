package com.coway.trust.api.mobile.services.history;

import java.util.HashMap;	
import java.util.Map;



import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;



@ApiModel(value = "ServiceHistoryForm", description = "공통코드 Form")
public class ServiceHistoryForm {
	
	@ApiModelProperty(value = "userId [default : '' 전체] 예)  ", example = "1, 2, 3")
	private String userId;
	
//	@ApiModelProperty(value = "userId [default : '' 전체] 예)  ", example = "1, 2, 3")
//	private String userId;

	@ApiModelProperty(value = "salesOrderNo [default : '' 전체] 예) 1209382", example = "1, 2, 3")
	private String salesOrderNo;
	
	
	public static Map<String, Object> createMaps(ServiceHistoryForm ServiceHistoryForm) {
		Map<String, Object> params = new HashMap<>();
		params.put("userId", ServiceHistoryForm.getUserId());
		params.put("salesOrderNo", ServiceHistoryForm.getSalesOrderNo());
		return params;
	} 
	
	


	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}




	public String getSalesOrderNo() {
		return salesOrderNo;
	}




	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}	
	


	
	
	
}
