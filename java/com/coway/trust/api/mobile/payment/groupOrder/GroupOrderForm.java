package com.coway.trust.api.mobile.payment.groupOrder;

import java.util.HashMap;
import java.util.Map;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : GroupOrderForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 9. 19.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "GroupOrderForm", description = "GroupOrder Form")
public class GroupOrderForm {

	@ApiModelProperty(value = "userId 예)1 ", example = "1")
	private String userId;

	@ApiModelProperty(value = "searchType 예)1 ", example = "1")
	private String searchType;

	@ApiModelProperty(value = "keywordInp 예)0030784", example = "0030784")
	private String keywordInp;

	@ApiModelProperty(value = "custId 예)18216", example = "18216")
	private String custId;

	@ApiModelProperty(value = "custBillGrpNo 예)18216", example = "18216")
	private String custBillGrpNo;

	@ApiModelProperty(value = "custBillId 예)2276627", example = "2276627")
	private String custBillId;

	@ApiModelProperty(value = "salesOrdNo 예)2276627", example = "2276627")
	private String salesOrdNo;

	@ApiModelProperty(value = "mobticketno 예)2276627", example = "2276627")
	private int mobTicketNo;


	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getSearchType() {
		return searchType;
	}

	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getKeywordInp() {
		return keywordInp;
	}

	public void setKeywordInp(String keywordInp) {
		this.keywordInp = keywordInp;
	}

	public String getCustId() {
		return custId;
	}

	public void setCustId(String custId) {
		this.custId = custId;
	}

	public String getCustBillGrpNo() {
		return custBillGrpNo;
	}

	public void setCustBillGrpNo(String custBillGrpNo) {
		this.custBillGrpNo = custBillGrpNo;
	}

	public String getCustBillId() {
		return custBillId;
	}

	public void setCustBillId(String custBillId) {
		this.custBillId = custBillId;
	}

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public int getMobTicketNo() {
		return mobTicketNo;
	}

	public void setMobTicketNo(int mobTicketNo) {
		this.mobTicketNo = mobTicketNo;
	}

	public static Map<String, Object> createMap(GroupOrderForm groupOrderForm){
		Map<String, Object> params = new HashMap<>();

		params.put("userId",   			groupOrderForm.getUserId());
		params.put("searchType",   	groupOrderForm.getSearchType());
		params.put("keywordInp",   	groupOrderForm.getKeywordInp());
		params.put("custId",   			groupOrderForm.getCustId());
		params.put("custBillGrpNo",   	groupOrderForm.getCustBillGrpNo());
		params.put("custBillId",   		groupOrderForm.getCustBillId());
		params.put("salesOrdNo",    	groupOrderForm.getSalesOrdNo());
		params.put("mobTicketNo",    groupOrderForm.getMobTicketNo());


		return params;
	}

}
