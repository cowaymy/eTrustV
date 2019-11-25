package com.coway.trust.api.mobile.payment.unpaidCustomer;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;


@ApiModel(value = "UnpaidCustomerForm", description = "UnpaidCustomer Form")
public class UnpaidCustomerForm {

	@ApiModelProperty(value = "userId 예)1 ", example = "1")
	private String userId;

	@ApiModelProperty(value = "searchType 예)1 ", example = "1")
	private String searchType;

	@ApiModelProperty(value = "searchKeyword 예)0030784", example = "0030784")
	private String searchKeyword;

	@ApiModelProperty(value = "salesOrdNo 예)2276627", example = "2276627")
	private String salesOrdNo;

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

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public static Map<String, Object> createMap(UnpaidCustomerForm paymentForm){
		Map<String, Object> params = new HashMap<>();

		params.put("userId",   				paymentForm.getUserId());
		params.put("searchType",   		paymentForm.getSearchType());
		params.put("searchKeyword",   	paymentForm.getSearchKeyword());
		params.put("salesOrdNo",   		paymentForm.getSalesOrdNo());

		return params;
	}

}
