package com.coway.trust.api.mobile.services.sales;

import com.coway.trust.util.BeanConverter;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

public class RentalServiceCustomerForm {
	@ApiModelProperty(value = "검색용 사용자 ID") 
	private String userId;
	
	@ApiModelProperty(value = "검색조건  (1 : order no /2 : customer name  )") 
	private String searchType;
	
	@ApiModelProperty(value = "검색내용") 
	private String searchKeyword;
	
	@ApiModelProperty(value = "주문번호") 
	private String salesOrderNo;

	public String getSalesOrderNo() {
		return salesOrderNo;
	}

	public void setSalesOrderNo(String salesOrderNo) {
		this.salesOrderNo = salesOrderNo;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}



	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getSearchKeyword() {
		return searchKeyword;
	}

	public void setSearchKeyword(String searchKeyword) {
		this.searchKeyword = searchKeyword;
	}
}
