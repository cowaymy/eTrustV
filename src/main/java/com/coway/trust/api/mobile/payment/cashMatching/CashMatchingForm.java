package com.coway.trust.api.mobile.payment.cashMatching;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;

/**
 * @ClassName : CashMatchingForm.java
 * @Description : TO-DO Class Description
 *
 * @History
 * <pre>
 * Date            Author       Description
 * -------------  -----------  -------------
 * 2019. 10. 19.   KR-HAN        First creation
 * </pre>
 */
@ApiModel(value = "CashMatchingForm", description = "CashMatching Form")
public class CashMatchingForm {

	@ApiModelProperty(value = "fromDate", example = "1")
	private String fromDate;

	@ApiModelProperty(value = "toDate", example = "1")
	private String toDate;

	@ApiModelProperty(value = "userId", example = "1")
	private String userId;

	@ApiModelProperty(value = "mobPayNo", example = "1")
	private String mobPayNo;

	@ApiModelProperty(value = "salesOrdNo", example = "1")
	private String salesOrdNo;

	@ApiModelProperty(value = "slipNo", example = "1")
	private String slipNo;

	@ApiModelProperty(value = "salesOrdNo", example = "1")
	private String uploadImg;

	public String getUserId() {
		return userId;
	}

	public void setUserId(String userId) {
		this.userId = userId;
	}

	public String getFromDate() {
		return fromDate;
	}

	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}

	public String getToDate() {
		return toDate;
	}

	public void setToDate(String toDate) {
		this.toDate = toDate;
	}


	public String getMobPayNo() {
		return mobPayNo;
	}

	public void setMobPayNo(String mobPayNo) {
		this.mobPayNo = mobPayNo;
	}

	public String getSalesOrdNo() {
		return salesOrdNo;
	}

	public void setSalesOrdNo(String salesOrdNo) {
		this.salesOrdNo = salesOrdNo;
	}

	public String getSlipNo() {
		return slipNo;
	}

	public void setSlipNo(String slipNo) {
		this.slipNo = slipNo;
	}

	public String getUploadImg() {
		return uploadImg;
	}

	public void setUploadImg(String uploadImg) {
		this.uploadImg = uploadImg;
	}

	public static Map<String, Object> createMap(CashMatchingForm cashMatchingForm){
		Map<String, Object> params = new HashMap<>();

		params.put("fromDate",   		cashMatchingForm.getFromDate());
		params.put("toDate",   			cashMatchingForm.getToDate());
		params.put("userId",   			cashMatchingForm.getUserId());
		params.put("mobPayNo",   			cashMatchingForm.getMobPayNo());
		params.put("salesOrdNo",   			cashMatchingForm.getSalesOrdNo());
		params.put("slipNo",   			cashMatchingForm.getSlipNo());
		params.put("uploadImg",   			cashMatchingForm.getUploadImg());

		return params;
	}

}
